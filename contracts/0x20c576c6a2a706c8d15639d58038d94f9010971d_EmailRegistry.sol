pragma solidity ^0.4.18; // solhint-disable-line



contract EmailRegistry {
    mapping (address => string) public emails;
    function registerEmail(string email){
        emails[msg.sender]=email;    
    }
}