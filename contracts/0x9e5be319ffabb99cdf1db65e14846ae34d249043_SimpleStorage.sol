pragma solidity ^0.4.23;

contract SimpleStorage {
    string public welcomeMsg = "Hello block chain from InfPro IT Solutions!";
    string[] public myStorage;
    
    function add(string _store) public {
        myStorage.push(_store);
    }
}