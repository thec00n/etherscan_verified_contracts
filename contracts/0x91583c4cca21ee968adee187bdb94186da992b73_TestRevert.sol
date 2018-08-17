pragma solidity ^0.4.0;

contract TestRevert {
    function test_require() public {
        require(now &lt; 1000);
    }

    function test_assert() public {
        assert(now &lt; 1000);
    }
}