pragma solidity ^0.4.13;
contract HelloWorld {
    
    function getData() public constant returns (string) {
        return &quot;Hello, world!&quot;;
    }
   
}