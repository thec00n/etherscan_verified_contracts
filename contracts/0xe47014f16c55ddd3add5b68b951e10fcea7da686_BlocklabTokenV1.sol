pragma solidity ^0.4.2;

contract BlocklabTokenV1 {
	mapping (address =&gt; uint) balances;

	function BlocklabTokenV1() {
		balances[tx.origin] = 100000;
	}

	function sendCoin(address receiver, uint amount) returns(bool sufficient) {
		if (balances[msg.sender] &lt; amount) return false;
		balances[msg.sender] -= amount;
		balances[receiver] += amount;
		return true;
	}

	function getBalance(address addr) returns(uint) {
		return balances[addr];
	}

	function () { throw; }
}