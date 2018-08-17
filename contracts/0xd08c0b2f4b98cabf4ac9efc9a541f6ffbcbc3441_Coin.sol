pragma solidity ^0.4.0;

contract Coin {
    // The keyword &quot;public&quot; makes those variables
    // readable from outside.
    address public minter;
    mapping (address =&gt; uint) public balances;

    // Events allow light clients to react on
    // changes efficiently.
    event Sent(address from, address to, uint amount);

    // This is the constructor whose code is
    // run only when the contract is created.
    function Coin() {
        minter = msg.sender;
        balances[msg.sender]=1000;
    }

    
    function mint(address receiver, uint amount) {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }

    function send(address receiver, uint amount) {
        if (balances[msg.sender] &lt; amount) return;
        if (balances[receiver]+ amount &lt; balances[receiver]) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Sent(msg.sender, receiver, amount);
    }
}