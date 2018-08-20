// Token Shredder
//
// Written by Alexandre Naverniouk
// twitter @AlexNa

//*** Attention !!!

//*** All tokens sent to this contract will become inaccessible forever. 
//*** There is no technical way to withdraw the tokens out of this contract. 
//*** Intention for creating this contract was to implement a token destroyer
//*** that is public and guaranteed to be final and irreversible.

//*** Notice, that the creator of the contract (me) does not have any power
//*** to move tokens or delete the contract and claim the balance. The contract will stay as it is
//*** forever and it will hold the tokens forever. 

pragma solidity ^0.4.0;
// The Solidity version 0.4+ prevents the contract to receive Ethers with 
// no fallback function implemented. 
// It means that this contract is safe to send Ethers to, meaning the 
// EVM will throw an exception and the Ethers will not be destroyed. 

contract TokenShredder {

}