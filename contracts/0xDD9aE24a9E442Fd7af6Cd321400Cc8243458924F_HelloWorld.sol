pragma solidity ^0.4.13;

contract HelloWorld {
    
    string wellcomeString = "Hello, world!";
    
    function getData() public constant returns (string) {
        return wellcomeString;
    }
    
    function setData(string newData) public {
        wellcomeString = newData;
    }
    
}