pragma solidity ^0.4.19;

contract PureLoop
{
    function execute() public pure returns (uint output) {
        uint num;
        while(true) {
            num++;
        }
        return num;
    }
}