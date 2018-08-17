pragma solidity ^0.4.0;
contract Test {

    function send(address to) public{
        if (to.call(&quot;0xabcdef&quot;)) {
            return;
        } else {
            revert();
        }
    }
}