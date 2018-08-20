pragma solidity ^0.4.10;

contract FunGame 
{
    address owner;
    struct user
    {
        address parent;
        uint8 level;
    }
    mapping(address=>user) public map;
    function FunGame()
    {
        owner = msg.sender;
        map[msg.sender].level = 8; 
    }
}