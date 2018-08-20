pragma solidity ^0.4.17;

contract GetsBurned {

    function () payable {
    }

    function BurnMe () {
        // Selfdestruct and send eth to self, 
        selfdestruct(address(this));
    }
}