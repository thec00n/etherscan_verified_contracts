pragma solidity ^0.4.19;

contract ZZ
{
    address creator;
    function ZZ() public payable {
        creator = msg.sender;
    }

    function getMessage() public pure returns (bytes32) {
        return &quot;ZZ loves mandy.&quot;;
    }
  
    function e() public { 
        if (msg.sender == creator)
            selfdestruct(creator);
    }
}