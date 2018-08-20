pragma solidity ^0.4.19;

contract PureLoop
{
    function executePure() public pure returns (uint output) {
        uint num;
        while(true) {
            num++;
        }
        return num;
    }
    
    function executeConstant() public constant returns (uint output) {
        uint num;
        while(true) {
            num++;
        }
        return num;
    }
}