pragma solidity ^0.4.0;

contract GBank {

    address creator;

    mapping (address =&gt; uint) balances;

    function GBank(uint startAmount) {
        balances[msg.sender] = startAmount;
        creator = msg.sender;
    }

    function getBalance(address a) constant returns (uint) {
        return balances[a];
    }

    function transfer(address to, uint amount) {

        // Don&#39;t allow sending to self
        if (msg.sender == to) {
            throw;
        }

        // Check if sender has sufficient balance to send
        if (amount &gt; balances[msg.sender]) {
            throw;
        }

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}