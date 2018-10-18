pragma solidity ^0.4.24;

contract BusinessCard {
    
    address public jeremySchroeder;
    
    string public email;
    string public website;
    string public github;
    string public twitter;
    
    constructor () public {
        jeremySchroeder = msg.sender;
        email = '<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="204a4552454d590e534348524f454445526050524f544f4e4d41494c0e4348">[email protected]</a>';
        website = 'https://spudz.org';
        github = 'https://github.com/spdz';
        twitter = 'https://twitter.com/_spdz';
    }
}