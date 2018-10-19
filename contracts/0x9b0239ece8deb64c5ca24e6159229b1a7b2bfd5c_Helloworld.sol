pragma solidity ^0.4.24;

contract Helloworld {
    string content;
    
    constructor()
    public
    {
        content = 'aaa';
    }
    
    function getContent() constant public returns (string){
        return content;
    }
}