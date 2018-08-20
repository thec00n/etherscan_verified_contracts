pragma solidity ^0.4.18;

// This is the HST token purgatory, where Horizon State
// Transferrs tokens that are locked forever.
contract HSTPurgatory {
    
    function() public payable {
        revert();
    }

}