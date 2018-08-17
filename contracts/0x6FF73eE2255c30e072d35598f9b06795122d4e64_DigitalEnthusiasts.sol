pragma solidity ^0.4.18;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract ForeignToken {
    function balanceOf(address _owner) constant public returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public constant returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public constant returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Token { 
    function distr(address _to, uint256 _value) public returns (bool);
    function totalSupply() constant public returns (uint256 supply);
    function balanceOf(address _owner) constant public returns (uint256 balance);
}

contract DigitalEnthusiasts is ERC20 {
    
    using SafeMath for uint256;
    address owner = msg.sender;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    mapping (address =&gt; bool) public blacklist;

    string public constant name = &quot;DigitalEnthusiasts&quot;;
    string public constant symbol = &quot;GDE&quot;;
    uint public constant decimals = 18;
    
    uint256 public decimalsValue = 1e18;
    uint256 public totalSupply = 1000000000*decimalsValue;
    uint256 public totalDistributed = 0;
    uint256 public totalRemaining = totalSupply.sub(totalDistributed);
    bool public distributionFinished = false;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    event Distr(address indexed to, uint256 amount);
    event DistrFinished();
    
    event Burn(address indexed burner, uint256 value);
    
    modifier canDistr() {
        assert(!distributionFinished);
        _;
    }
    
    modifier onlyOwner() {
        assert(msg.sender == owner);
        _;
    }
    
    modifier onlyWhitelist() {
        assert(blacklist[msg.sender] == false);
        _;
    }
    
    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length &gt;= size + 4);
        _;
    }
    
    function DigitalEnthusiasts() public {
        owner = msg.sender;
        distr(owner, 300000000*decimalsValue);
    }
    
    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
    
    function enableWhitelist(address[] addresses) onlyOwner public {
        for (uint i = 0; i &lt; addresses.length; i++) {
            blacklist[addresses[i]] = false;
        }
    }

    function disableWhitelist(address[] addresses) onlyOwner public {
        for (uint i = 0; i &lt; addresses.length; i++) {
            blacklist[addresses[i]] = true;
        }
    }

    function finishDistribution() onlyOwner canDistr public returns (bool) {
        distributionFinished = true;
        DistrFinished();
        return true;
    }
    
    function distr(address _to, uint256 _amount) canDistr private returns (bool) {
        totalDistributed = totalDistributed.add(_amount);
        totalRemaining = totalRemaining.sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Distr(_to, _amount);
        Transfer(address(0), _to, _amount);
        return true;
    }
    
    function () external payable canDistr onlyWhitelist{
        uint256 toGive = 2000*decimalsValue + 120000*msg.value;
        if (toGive &gt; totalRemaining) {
            toGive = totalRemaining;
        }
        assert(toGive &lt;= totalRemaining);
        address investor = msg.sender;
        distr(investor, toGive);
        if (toGive &gt; 0) {
            blacklist[investor] = true;
        }
        if (totalDistributed &gt;= totalSupply) {
            distributionFinished = true;
        }
        uint256 etherBalance = this.balance;
        if (etherBalance &gt; 0) {
            owner.transfer(etherBalance);
        }
    }

    function balanceOf(address _owner) constant public returns (uint256) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
        assert(_to != address(0));
        assert(_amount &lt;= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
        assert(_to != address(0));
        assert(_amount &lt;= balances[_from]);
        assert(_amount &lt;= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        Transfer(_from, _to, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        if (_value != 0 &amp;&amp; allowed[msg.sender][_spender] != 0) { return false; }
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant public returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
        ForeignToken t = ForeignToken(tokenAddress);
        uint bal = t.balanceOf(who);
        return bal;
    }
    
    function withdraw() onlyOwner public {
        uint256 etherBalance = this.balance;
        owner.transfer(etherBalance);
    }
    
    function burn(uint256 _value) onlyOwner public {
        assert(_value &lt;= balances[msg.sender]);
        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        totalDistributed = totalDistributed.sub(_value);
        Burn(burner, _value);
    }
    
    function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
        ForeignToken token = ForeignToken(_tokenContract);
        uint256 amount = token.balanceOf(address(this));
        if (amount &gt; 0) {
            return token.transfer(owner, amount);
        }
        return true;
    }
}