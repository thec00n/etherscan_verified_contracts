pragma solidity ^0.4.13;

contract jvCoin {
    mapping (address =&gt; uint) balances;

    function jvCoin() { 
        balances[msg.sender] = 10000;
    }

    function sendCoin(address receiver, uint amount) returns (bool sufficient) {
        if (balances[msg.sender] &lt; amount) return false;

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        return true;
    }
}