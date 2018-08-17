pragma solidity ^0.4.11;

contract ERC20Interface {
	function totalSupply() constant returns (uint supply);
	function balanceOf(address _owner) constant returns (uint balance);
	function transfer(address _to, uint _value) returns (bool success);
	function transferFrom(address _from, address _to, uint _value) returns (bool success);
	function approve(address _spender, uint _value) returns (bool success);
	function allowance(address _owner, address _spender) constant returns (uint remaining);
	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
}
contract DDAContract is ERC20Interface {
	string public constant symbol = &quot;DDA&quot;;
	string public constant name = &quot;DeDeAnchor&quot;;
	uint8 public constant decimals = 18;
	uint256 public _totalSupply = 10**26;//smallest unit is 10**-18, and total dda is 10**8

	mapping (address =&gt; uint) public balances;
	mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;

	address dedeAddress;

// ERC20 FUNCTIONS
	function totalSupply() constant returns (uint totalSupply){
		return _totalSupply;
	}
	function balanceOf(address _owner) constant returns (uint balance){
		return balances[_owner];
	}
	function transfer(address _to, uint _value) returns (bool success){
		if(balances[msg.sender] &gt;= _value
			&amp;&amp; _value &gt; 0
			&amp;&amp; balances[_to] + _value &gt; balances[_to]){
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		}
		else{
			return false;
		}
	}
	function transferFrom(address _from, address _to, uint _value) returns (bool success){
		if(balances[_from] &gt;= _value
			&amp;&amp; allowed[_from][msg.sender] &gt;= _value
			&amp;&amp; _value &gt;= 0
			&amp;&amp; balances[_to] + _value &gt; balances[_to]){
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(_from, _to, _value);
			return true;
		}
		else{
			return false;
		}
	}
	function approve(address _spender, uint _value) returns (bool success){
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}
	function allowance(address _owner, address _spender) constant returns (uint remaining){
		return allowed[_owner][_spender];
	}


	function DDAContract(address _dedeAddress){
		dedeAddress = _dedeAddress;
		balances[_dedeAddress] = _totalSupply;
		Transfer(0, _dedeAddress, _totalSupply);
	}
	function changeDedeAddress(address newDedeAddress){
		require(msg.sender == dedeAddress);
		dedeAddress = newDedeAddress;
	}
	function mint(uint256 value){
		require(msg.sender == dedeAddress);
		_totalSupply += value;
		balances[msg.sender] += value;
		Transfer(0, msg.sender, value);
	}
}