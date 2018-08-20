pragma solidity ^0.4.23;

contract DAppsDevs {
    address public owner;

    string public constant companyName = "DApps Devs LLC";
    string public constant companySite = "dappsdevs.io, dappsdevs.com";
    string public constant phoneNumber  = "+1-302-481-9195";
    string public constant email = "<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="ea83848c85aa8e8b9a9a998e8f9c99c4898587">[email protected]</a>";

    mapping(bytes32 => string) public additionalInfo;

    constructor() public {
        owner = msg.sender;
    }

    function () payable fromOwner() {
    }

    function setCompanyInfo(bytes32 key, string value) fromOwner() public {
        additionalInfo[key] = value;
    }

    function getCompanyInfo(bytes32 key) constant public returns (string) {
        return additionalInfo[key];
    }

    function kill() fromOwner() public {
        selfdestruct(owner);
    }

    modifier fromOwner() {
        require(owner == msg.sender);
        _;
    }
}