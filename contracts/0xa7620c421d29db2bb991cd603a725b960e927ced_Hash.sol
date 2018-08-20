pragma solidity ^0.4.18;

contract Hash {
    // storage vars
    address owner;

    // constructor
    function Hash() public {
        owner = msg.sender;
    }

    // fallback: unmatched transactions will be returned
    function() internal {
        revert();
    }

    function hash(string dataString) public pure returns(bytes32){
        return(keccak256(dataString));
    }

    function selfDestruct() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}