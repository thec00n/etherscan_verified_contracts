pragma solidity ^0.4.18;

library SafeMath {

    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }
}

contract Owned {
    address public owner;

    address public newOwner;

    function Owned() public payable {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address _owner) onlyOwner public {
        require(_owner != 0);
        newOwner = _owner;
    }

    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

contract Blocked {
    uint public blockedUntil;

    modifier unblocked {
        require(now &gt; blockedUntil);
        _;
    }
}

contract ERC20Basic {
    uint256 public totalSupply;

    function balanceOf(address who) constant public returns (uint256);

    function transfer(address to, uint256 value) public returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) constant public returns (uint256);

    function transferFrom(address from, address to, uint256 value) public returns (bool);

    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract PayloadSize {
    // Fix for the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length &gt;= size + 4);
        _;
    }
}

contract BasicToken is ERC20Basic, Blocked, PayloadSize {

    using SafeMath for uint256;

    mapping (address =&gt; uint256) balances;

    function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balances[_owner];
    }

}

contract StandardToken is ERC20, BasicToken {

    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) unblocked public returns (bool) {
        var _allowance = allowed[_from][msg.sender];

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) onlyPayloadSize(2 * 32) unblocked public returns (bool) {

        require((_value == 0) || (allowed[msg.sender][_spender] == 0));

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) onlyPayloadSize(2 * 32) unblocked constant public returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}

contract BurnableToken is StandardToken {

    event Burn(address indexed burner, uint256 value);

    function burn(uint256 _value) unblocked public {
        require(_value &gt; 0);
        require(_value &lt;= balances[msg.sender]);
        // no need to require value &lt;= totalSupply, since that would imply the
        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        Burn(burner, _value);
    }
}

contract PreNTFToken is BurnableToken, Owned {

    string public constant name = &quot;PreNTF Token&quot;;

    string public constant symbol = &quot;PreNTF&quot;;

    uint32 public constant decimals = 18;

    function PreNTFToken(uint256 initialSupply, uint unblockTime) public {
        totalSupply = initialSupply;
        balances[owner] = initialSupply;
        blockedUntil = unblockTime;
    }

    function manualTransfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) onlyOwner public returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
}

contract Crowdsale is Owned, PayloadSize {

    using SafeMath for uint256;

    struct AmountData {
        bool exists;
        uint256 value;
    }

    // Date of start pre-ICO
    uint public constant preICOstartTime =    1512597600; // start at Thursday, December 7, 2017 12:00:00 AM EET
    uint public constant preICOendTime =      1517436000; // end at   Thursday, February 1, 2018 12:00:00 AM EET
    uint public constant blockUntil =         1525122000; // tokens are blocked until Tuesday, May 1, 2018 12:00:00 AM EET

    uint256 public constant maxTokenAmount = 3375000 * 10**18; // max tokens amount

    uint256 public constant bountyTokenAmount = 375000 * 10**18;
    uint256 public givenBountyTokens = 0;

    PreNTFToken public token;

    uint256 public leftTokens = 0;

    uint256 public totalAmount = 0;
    uint public transactionCounter = 0;

    uint256 public constant tokenPrice = 3 * 10**15; // token price in ether

    uint256 public minAmountForDeal = 9 ether;

    mapping (uint =&gt; AmountData) public amountsByCurrency;

    mapping (address =&gt; uint256) public bountyTokensToAddress;

    modifier canBuy() {
        require(!isFinished());
        require(now &gt;= preICOstartTime);
        _;
    }

    modifier minPayment() {
        require(msg.value &gt;= minAmountForDeal);
        _;
    }

    // Fix for the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length &gt;= size + 4);
        _;
    }

    function Crowdsale() public {
        token = new PreNTFToken(maxTokenAmount, blockUntil);
        leftTokens = maxTokenAmount - bountyTokenAmount;
        // init currency in Crowdsale.
        AmountData storage btcAmountData = amountsByCurrency[0];
        btcAmountData.exists = true;
        AmountData storage bccAmountData = amountsByCurrency[1];
        bccAmountData.exists = true;
        AmountData storage ltcAmountData = amountsByCurrency[2];
        ltcAmountData.exists = true;
        AmountData storage dashAmountData = amountsByCurrency[3];
        dashAmountData.exists = true;
    }

    function isFinished() public constant returns (bool) {
        return now &gt; preICOendTime || leftTokens == 0;
    }

    function() external canBuy minPayment payable {
        uint256 amount = msg.value;
        uint256 givenTokens = amount.mul(1 ether).div(tokenPrice);
        uint256 providedTokens = transferTokensTo(msg.sender, givenTokens);
        transactionCounter = transactionCounter + 1;

        if (givenTokens &gt; providedTokens) {
            uint256 needAmount = providedTokens.mul(tokenPrice).div(1 ether);
            require(amount &gt; needAmount);
            require(msg.sender.call.gas(3000000).value(amount - needAmount)());
            amount = needAmount;
        }
        totalAmount = totalAmount.add(amount);
    }

    function manualTransferTokensTo(address to, uint256 givenTokens, uint currency, uint256 amount) external canBuy onlyOwner returns (uint256) {
        AmountData memory tempAmountData = amountsByCurrency[currency];
        require(tempAmountData.exists);
        AmountData storage amountData = amountsByCurrency[currency];
        amountData.value = amountData.value.add(amount);
        uint256 value = transferTokensTo(to, givenTokens);
        transactionCounter = transactionCounter + 1;
        return value;
    }

    function addCurrency(uint currency) external onlyOwner {
        AmountData storage amountData = amountsByCurrency[currency];
        amountData.exists = true;
    }

    function transferTokensTo(address to, uint256 givenTokens) private returns (uint256) {
        var providedTokens = givenTokens;
        if (givenTokens &gt; leftTokens) {
            providedTokens = leftTokens;
        }
        leftTokens = leftTokens.sub(providedTokens);
        require(token.manualTransfer(to, providedTokens));
        return providedTokens;
    }

    function finishCrowdsale() external {
        require(isFinished());
        if (leftTokens &gt; 0) {
            token.burn(leftTokens);
            leftTokens = 0;
        }
    }

    function takeBountyTokens() external returns (bool){
        require(isFinished());
        uint256 allowance = bountyTokensToAddress[msg.sender];
        require(allowance &gt; 0);
        bountyTokensToAddress[msg.sender] = 0;
        require(token.manualTransfer(msg.sender, allowance));
        return true;
    }

    function giveTokensTo(address holder, uint256 amount) external onlyPayloadSize(2 * 32) onlyOwner returns (bool) {
        require(bountyTokenAmount &gt;= givenBountyTokens.add(amount));
        bountyTokensToAddress[holder] = bountyTokensToAddress[holder].add(amount);
        givenBountyTokens = givenBountyTokens.add(amount);
        return true;
    }

    function getAmountByCurrency(uint index) external returns (uint256) {
        AmountData memory tempAmountData = amountsByCurrency[index];
        return tempAmountData.value;
    }

    function withdraw() external onlyOwner {
        require(msg.sender.call.gas(3000000).value(this.balance)());
    }

    function setAmountForDeal(uint256 value) external onlyOwner {
        minAmountForDeal = value;
    }

    function withdrawAmount(uint256 amount) external onlyOwner {
        uint256 givenAmount = amount;
        if (this.balance &lt; amount) {
            givenAmount = this.balance;
        }
        require(msg.sender.call.gas(3000000).value(givenAmount)());
    }
}