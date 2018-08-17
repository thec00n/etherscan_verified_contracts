pragma solidity ^0.4.8;

contract testingToken {
	mapping (address =&gt; uint256) public balanceOf;
	address public owner;
	function testingToken() {
		owner = msg.sender;
		balanceOf[msg.sender] = 1000;
	}
	function send(address _to, uint256 _value) {
		if (balanceOf[msg.sender]&lt;_value) throw;
		if (balanceOf[_to]+_value&lt;balanceOf[_to]) throw;
		if (_value&lt;0) throw;
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += _value;
	}
}