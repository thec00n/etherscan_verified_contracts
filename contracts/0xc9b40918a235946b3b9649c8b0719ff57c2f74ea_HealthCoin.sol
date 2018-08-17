pragma solidity ^0.4.11;

library safeMath {
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

contract ERC20 {
    function totalSupply() constant returns (uint supply);
    function balanceOf(address who) constant returns (uint value);
    function allowance(address owner, address spender) constant returns (uint _allowance);

    function transfer(address to, uint value) returns (bool ok);
    function transferFrom(address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract HealthCoin is ERC20{
	uint initialSupply = 500000;
	string public constant name = &quot;HealthCoin&quot;;
	string public constant symbol = &quot;HLC&quot;;
	uint USDExchangeRate = 300;
	uint price = 30;
	address HealthCoinAddress;

	mapping (address =&gt; uint256) balances;
	mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
	
	modifier onlyOwner{
    if (msg.sender == HealthCoinAddress) {
		  _;
		}
	}

	function totalSupply() constant returns (uint256) {
		return initialSupply;
    }

	function balanceOf(address _owner) constant returns (uint256 balance) {
		return balances[_owner];
    }

  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  function transfer(address _to, uint256 _value) returns (bool success) {
    if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      Transfer(msg.sender, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      Transfer(_from, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function approve(address _spender, uint256 _value) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

	function HealthCoin() {
        HealthCoinAddress = msg.sender;
        balances[HealthCoinAddress] = initialSupply;
    }

	function setUSDExchangeRate (uint rate) onlyOwner{
		USDExchangeRate = rate;
	}

	function () payable{
	    uint amountInUSDollars = safeMath.div(safeMath.mul(msg.value, USDExchangeRate),10**18);
	    uint valueToPass = safeMath.div(amountInUSDollars, price);
    	if (balances[HealthCoinAddress] &gt;= valueToPass &amp;&amp; valueToPass &gt; 0) {
          balances[msg.sender] = safeMath.add(balances[msg.sender],valueToPass);
          balances[HealthCoinAddress] = safeMath.sub(balances[HealthCoinAddress],valueToPass);
          Transfer(HealthCoinAddress, msg.sender, valueToPass);
        } 
	}

	function withdraw(uint amount) onlyOwner{
        HealthCoinAddress.transfer(amount);
	}
}