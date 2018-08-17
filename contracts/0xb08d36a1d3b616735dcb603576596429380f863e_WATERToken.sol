pragma solidity ^0.4.18;

contract ERC20Interface {
	function totalSupply() public constant returns (uint256);
	function balanceOf(address tokenOwner) public constant returns (uint256 balance);
	function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
	function transfer(address to, uint256 tokens) public returns (bool success);
	function approve(address spender, uint256 tokens) public returns (bool success);
	function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

contract ApproveAndCallFallBack {
	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract WATERToken is ERC20Interface {

	function () public payable {
		revert();
	}

	string public name;
	uint8 public decimals;
	string public symbol;
	string public version = &#39;H1.0&#39;;
	uint256 public _totalSupply;

	mapping (address =&gt; uint256) balances;
	mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

	function WATERToken() public {
		decimals = 8;
		_totalSupply = 21000000 * 10 ** uint256(decimals);
		balances[msg.sender] = _totalSupply;
		//Transfer(address(0), msg.sender, _totalSupply);
		name = &quot;WATER TOKEN&quot;;
		symbol = &quot;WAT&quot;;
	}

	function totalSupply() public view returns (uint256) {
		return _totalSupply;
	}

	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
		//if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		//} else { return false; }
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
		//if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
			balances[_to] += _value;
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			Transfer(_from, _to, _value);
			return true;
		//} else { return false; }
	}

	function balanceOf(address _owner) public view returns (uint256 balance) {
		return balances[_owner];
	}

	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
	  return allowed[_owner][_spender];
	}

	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);

		ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, _extraData);
		return true;
	}
}