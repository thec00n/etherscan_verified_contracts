pragma solidity ^0.4.19;

contract PureLoop
{
    function execute() public pure returns (uint output) {
        uint num;
        num +=execute();
        return num++;
    }
}