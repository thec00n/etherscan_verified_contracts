pragma solidity ^0.4.11;

// By contributing you agree to our terms &amp; conditions.
// https://harbour.tokenate.io/HarbourTermsOfSale.pdf

library SafeMath {
    function mul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal returns (uint) {
        assert(b &gt; 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function sub(uint a, uint b) internal returns (uint) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c &gt;= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a &gt;= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal constant returns (uint64) {
        return a &lt; b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a &gt;= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal constant returns (uint256) {
        return a &lt; b ? a : b;
    }

    function assert(bool assertion) internal {
        if (!assertion) {
            throw;
        }
    }
}

contract ownable {

    address public owner;

    modifier onlyOwner {
        if (!isOwner(msg.sender)) throw;
        _;
    }

    function ownable() {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        owner = _newOwner;
    }

    function isOwner(address _address) returns (bool) {
        return owner == _address;
    }
}

contract Burnable {

    event Burn(address indexed owner, uint amount);
    function burn(address _owner, uint _amount) public;

}

contract ERC20 {
    uint public totalSupply;
    
    function totalSupply() constant returns (uint);
    function balanceOf(address _owner) constant returns (uint);
    function allowance(address _owner, address _spender) constant returns (uint);
    function transfer(address _to, uint _value) returns (bool);
    function transferFrom(address _from, address _to, uint _value) returns (bool);
    function approve(address _spender, uint _value) returns (bool);
    
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
}

contract Mintable {

    event Mint(address indexed to, uint value);
    function mint(address _to, uint _amount) public;
}

contract Token is ERC20, Mintable, Burnable, ownable {
    using SafeMath for uint;

    string public name;
    string public symbol;

    uint public decimals = 18;
    uint public maxSupply;
    uint public totalSupply;
    uint public freezeMintUntil;

    mapping (address =&gt; mapping (address =&gt; uint)) allowed;
    mapping (address =&gt; uint) balances;

    modifier canMint {
        require(totalSupply &lt; maxSupply);
        _;
    }

    modifier mintIsNotFrozen {
        require(freezeMintUntil &lt; now);
        _;
    }

    function Token(string _name, string _symbol, uint _maxSupply) {
        name = _name;
        symbol = _symbol;
        maxSupply = _maxSupply;
        totalSupply = 0;
        freezeMintUntil = 0;
    }

    function totalSupply() constant returns (uint) {
        return totalSupply;
    }

    function balanceOf(address _owner) constant returns (uint) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) constant returns (uint) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _value) returns (bool) {
        if (_value &lt;= 0) {
            return false;
        }

        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool) {
        if (_value &lt;= 0) {
            return false;
        }

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function mint(address _to, uint _amount) public canMint mintIsNotFrozen onlyOwner {
        if (maxSupply &lt; totalSupply.add(_amount)) throw;

        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);

        Mint(_to, _amount);
    }

    function burn(address _owner, uint _amount) public onlyOwner {
        totalSupply = totalSupply.sub(_amount);
        balances[_owner] = balances[_owner].sub(_amount);

        Burn(_owner, _amount);
    }

    function freezeMintingFor(uint _weeks) public onlyOwner {
        freezeMintUntil = now + _weeks * 1 weeks;
    }
}

contract TokenSale is ownable {
    using SafeMath for uint;

    uint256 public constant MINT_LOCK_DURATION_IN_WEEKS = 26;

    Token public token;

    address public beneficiary;

    uint public cap;
    uint public collected;
    uint public price;
    uint public purchaseLimit;

    uint public whitelistStartBlock;
    uint public startBlock;
    uint public endBlock;

    bool public capReached = false;
    bool public isFinalized = false;

    mapping (address =&gt; uint) contributed;
    mapping (address =&gt; bool) whitelisted;

    event GoalReached(uint amountRaised);
    event NewContribution(address indexed holder, uint256 tokens, uint256 contributed);
    event Refunded(address indexed beneficiary, uint amount);

    modifier onlyAfterSale { require(block.number &gt; endBlock); _; }

    modifier onlyWhenFinalized { require(isFinalized); _; }

    modifier onlyDuringSale {
        require(block.number &gt;= startBlock(msg.sender));
        require(block.number &lt;= endBlock);
        _;
    }

    modifier onlyWhenEnded {
        if (block.number &lt; endBlock &amp;&amp; !capReached) throw;
        _;
    }

    function TokenSale(
        uint _cap,
        uint _whitelistStartBlock,
        uint _startBlock,
        uint _endBlock,
        address _token,
        uint _price,
        uint _purchaseLimit,
        address _beneficiary
    )
    {
        cap = _cap * 1 ether;
        price = _price;
        purchaseLimit = (_purchaseLimit * 1 ether) * price;
        token = Token(_token);
        beneficiary = _beneficiary;

        whitelistStartBlock = _whitelistStartBlock;
        startBlock = _startBlock;
        endBlock = _endBlock;
    }

    function () payable {
        doPurchase(msg.sender);
    }

    function refund() public onlyWhenFinalized {
        if (capReached) throw;

        uint balance = token.balanceOf(msg.sender);
        if (balance == 0) throw;

        uint refund = balance.div(price);
        if (refund &gt; this.balance) {
            refund = this.balance;
        }

        token.burn(msg.sender, balance);
        contributed[msg.sender] = 0;

        msg.sender.transfer(refund);
        Refunded(msg.sender, refund);
    }

    function finalize() public onlyWhenEnded onlyOwner {
        require(!isFinalized);
        isFinalized = true;

        if (!capReached) {
            return;
        }

        if (!beneficiary.send(collected)) throw;
        token.freezeMintingFor(MINT_LOCK_DURATION_IN_WEEKS);
    }

    function doPurchase(address _owner) internal onlyDuringSale {
        if (msg.value &lt;= 0) throw;
        if (collected &gt;= cap) throw;

        uint value = msg.value;
        if (collected.add(value) &gt; cap) {
            uint difference = cap.sub(collected);
            msg.sender.transfer(value.sub(difference));
            value = difference;
        }

        uint tokens = value.mul(price);
        if (token.balanceOf(msg.sender) + tokens &gt; purchaseLimit) throw;

        collected = collected.add(value);
        token.mint(msg.sender, tokens);
        NewContribution(_owner, tokens, value);

        if (collected != cap) {
            return;
        }

        GoalReached(collected);
        capReached = true;
    }

    function addToWhitelist(address _address) public onlyOwner {
        whitelisted[_address] = true;
    }

    function startBlock(address contributor) constant returns (uint) {
        if (whitelisted[contributor]) {
            return whitelistStartBlock;
        }

        return startBlock;
    }

    function tokenTransferOwnership(address _newOwner) public onlyWhenFinalized {
        if (!capReached) throw; // only transfer if cap reached, otherwise we need burning for refund
        token.transferOwnership(_newOwner);
    }
}