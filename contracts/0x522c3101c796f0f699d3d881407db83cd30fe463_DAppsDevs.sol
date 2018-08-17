pragma solidity ^0.4.23;

contract DAppsDevs {
    address public owner;

    string public constant companyName = &quot;DApps Devs LLC&quot;;
    string public constant companySite = &quot;dappsdevs.io, dappsdevs.com&quot;;
    string public constant phoneNumber  = &quot;+1-302-481-9195&quot;;
    string public constant email = &quot;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="ea83848c85aa8e8b9a9a998e8f9c99c4898587">[email&#160;protected]</a>&quot;;

    mapping(bytes32 =&gt; string) public additionalInfo;

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