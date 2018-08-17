pragma solidity ^0.4.2;
contract Token {
    address public issuer;
    mapping (address =&gt; uint) public balances;

    function Token() {
        issuer = tx.origin;
        balances[issuer] = 10000000;
    }

    function transfer(address _to, uint _amount) {
        if (balances[msg.sender] &lt; _amount) {
            throw;
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}