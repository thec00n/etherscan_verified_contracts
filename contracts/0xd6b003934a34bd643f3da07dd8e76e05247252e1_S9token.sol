pragma solidity ^0.4.15;
contract S9token {
	
	address owner;
	string public name=&quot;S9token&quot;;
	uint8 public constant decimals = 0;
	string public constant version = &quot;1&quot;;
	uint256 _totalSupply;
	mapping (address =&gt; uint256) public balances;

	function S9token() {
		owner=msg.sender;
		_totalSupply=200;
		balances[msg.sender]=200;
	}

	event Transfer( address indexed from, address indexed to, uint value);

	function totalSupply() public constant returns (uint supply){
		return _totalSupply;
	}

    function balanceOf(address _owner) constant returns(uint256 balanceof){
		return balances[_owner];
	}

    function transfer(address _to, uint256 _amount) returns (bool success){
    	require(msg.sender==owner);
		if (balances[msg.sender] &gt;= _amount 
			&amp;&amp; _amount &gt; 0 
			&amp;&amp; balances[_to] + _amount &gt; balances[_to]){
			balances[msg.sender] -= _amount;
			balances[_to] += _amount;
			return true;
			Transfer(msg.sender,_to,_amount);
		}
		else{
			return false;
		}
	}
    

}