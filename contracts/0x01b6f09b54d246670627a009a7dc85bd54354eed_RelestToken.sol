pragma solidity ^0.4.11;

library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a / b;
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

contract Ownable {
    address public owner;
    function Ownable() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);  
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

/**
 * Ethereum Request for comments #20
 * Интерфейс стандарта токенов
 * https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
    uint256 public totalSupply;

    // Возвращает баланс адреса
    function balanceOf(address _owner) constant returns (uint balance);
    
    // Отправляет токены _value на адрес _to
    function transfer(address _to, uint _value) returns (bool success);
    
    // Отправляет токены _value с адреса _from на адрес _to
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    
    // Позволяет адресу _spender снимать &lt;= _value с вашего аккаунта
    function approve(address _spender, uint _value) returns (bool success);
    
    // Возвращает сколько _spender может снимать с вашего аккаунта
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
contract RelestToken is ERC20, Ownable {
    using SafeMath for uint256;
    string public name = &quot;Relest&quot;;
    string public symbol = &quot;REST&quot;;
    uint256 public decimals = 8;
    uint public ethRaised = 0;
    address wallet = 0xC487f60b6fA6d7CC1e51908b383385CbfC6c30B5;

    uint256 public minEth = 1 ether / 10;
    uint256 public priceRate = 1000; // 1 ETH = 1000 RST
    uint256 step1Price = 1500;
    uint256 step2Price = 1300;
    uint256 step3Price = 1150;
    
    uint256 minPriceRate = 1000;
    uint256 public ethGoal = 1000 ether;

    uint256 public startPreICOTimestamp = 1502287200; // 09.08.2017 14:00 (GMT)
    uint256 public endPreICOTimestamp = 1502632800; // 13.08.2017 14:00 (GMT)

    uint256 public startICOTimestamp = 1505743200; // 18.09.2017 14:00 (GMT)
    uint256 step1End = 1505750400; // 18.09.2017 16:00 (GMT)
    uint256 step2End = 1505829600; // 19.09.2017 14:00 (GMT)
    uint256 step3End = 1506348000; // 25.09.2017 14:00 (GMT)
    uint256 public endICOTimestamp = 1506952800; // 02.10.2017 14:00 (GMT)

    bool public preSaleGoalReached = false; // true if ethGoal is reached
    bool public preSaleStarted = false;
    bool public preSaleEnded = false;
    bool public SaleStarted = false;
    bool public SaleEnded = false;
    bool public isFinalized = false;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    event TokenPurchase(address indexed sender, address indexed beneficiary, uint ethAmount, uint tokenAmount);
    event Mint(address indexed to, uint256 amount);
    event Bounty(address indexed to, uint256 amount);

    // MODIFIERS
    
    modifier validPurchase() {
        assert(msg.value &gt;= minEth &amp;&amp; msg.sender != 0x0);
        _;
    }
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length &gt;= size + 4);
        _;
    }

    function RelestToken() {
        owner = msg.sender;
    }

    function balanceOf(address _owner) constant returns (uint balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
        require(preSaleEnded &amp;&amp; SaleEnded);
        require(_to != 0x0 &amp;&amp; _value &gt; 0 &amp;&amp; balances[msg.sender] &gt;= _value &amp;&amp; 
            balances[_to] + _value &gt; balances[_to]);
        balances[_to] += _value;
        balances[msg.sender] -= _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
        require(preSaleEnded &amp;&amp; SaleEnded);
        require(_to != 0x0 &amp;&amp; _value &gt; 0 &amp;&amp; balances[msg.sender] &gt;= _value &amp;&amp; 
            balances[_to] + _value &gt; balances[_to] &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint _value) returns (bool success) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    function () payable {
        buyTokens(msg.sender);
    }
    function checkPeriod() returns (bool) {
    	bool within = false;
        if(now &gt; startPreICOTimestamp &amp;&amp; now &lt; endPreICOTimestamp &amp;&amp; !preSaleGoalReached) { // pre-ICO
            preSaleStarted = true;
            preSaleEnded = false;
            SaleStarted = false;
            SaleEnded = false;
            within = true;
        } else if(now &gt; startICOTimestamp &amp;&amp; now &lt; endICOTimestamp) { // ICO
            SaleStarted = true;
            SaleEnded = false;
            preSaleEnded = true;
            within = true;
        } else if(now &gt; endICOTimestamp) { // after ICO
            preSaleEnded = true;
            SaleEnded = true;
        } else if(now &lt; startPreICOTimestamp) { // before pre-ICO
            preSaleStarted = false;
            preSaleEnded = false;
            SaleStarted = false;
            SaleEnded = false;
        }else { // between pre-ICO and ICO
        	preSaleStarted = true;
        	preSaleEnded = true;
        	SaleStarted = false;
        	SaleEnded = false;
        }
        return within;
    }
    function buyTokens(address beneficiary) payable validPurchase {
    	assert(checkPeriod());
        uint256 ethAmount = msg.value;
        if(preSaleStarted &amp;&amp; !preSaleEnded) {
            priceRate = 2000;
        }
        if(SaleStarted &amp;&amp; !SaleEnded) {
            if(now &gt;= startICOTimestamp &amp;&amp; now &lt;= step1End) {
                priceRate = step1Price;
            }
            else if(now &gt; step1End &amp;&amp; now &lt;= step2End) {
                priceRate = step2Price;
            }
            else if(now &gt; step2End &amp;&amp; now &lt;= step3End) {
                priceRate = step3Price;
            }
            else {
                priceRate = minPriceRate;
            }
        }
        uint256 tokenAmount = ethAmount.mul(priceRate);
        tokenAmount = tokenAmount.div(1e10);
        ethRaised = ethRaised.add(ethAmount);
        mint(beneficiary, tokenAmount);
        TokenPurchase(msg.sender, beneficiary, ethAmount, tokenAmount);
        wallet.transfer(msg.value);
        if(preSaleStarted &amp;&amp; !preSaleEnded &amp;&amp; ethRaised &gt;= ethGoal) {
            preSaleEnded = true;
            preSaleGoalReached = true;
        }
    }

    function finalize() onlyOwner {
        require(now &gt; endICOTimestamp &amp;&amp; SaleEnded &amp;&amp; !isFinalized);
        uint256 tokensLeft = (totalSupply * 30) / 70; // rest 30% of tokens
        Bounty(wallet, tokensLeft);
        mint(wallet, tokensLeft);
        isFinalized = true;
    }

    function mint(address receiver, uint256 _amount) returns (bool success){
        totalSupply = totalSupply.add(_amount);
        balances[receiver] = balances[receiver].add(_amount);
        Mint(receiver, _amount);
        return true;
    }
}
// &#175;\_(ツ)_/&#175;