pragma solidity ^0.4.10;

contract Callee {
    event ReceivedCall();
    
    function () {
        ReceivedCall();
    }
}