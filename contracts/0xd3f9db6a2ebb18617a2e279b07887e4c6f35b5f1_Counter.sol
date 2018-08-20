pragma solidity ^0.4.0;
contract Counter {
    
    uint total;
  
    function add(uint num) public {
        total = total + num;
    }
    
    function subtract(uint num) public {
        total = total - num;
    }
    
    function double() public {
        total = total * 2;
    }
  
}