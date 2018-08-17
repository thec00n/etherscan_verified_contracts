pragma solidity ^0.4.13;
 
contract HelloWorld {
    
    string wellcomeString = &quot;Hello, world!&quot;;
    
    function getData() constant returns (string) {
        return wellcomeString;
    }
    
    function setData(string newData) {
        wellcomeString = newData;
    }
    
}