pragma solidity ^0.4.0;

contract TSQ {

    address public jak;
    bool public is_open = true;

    function TSQ() {
        jak = msg.sender;
    }

    function open() {
        if (msg.sender != jak) return;
        is_open = true;
    }

    function close() {
        if (msg.sender != jak) return;
        is_open = false;
    }
}