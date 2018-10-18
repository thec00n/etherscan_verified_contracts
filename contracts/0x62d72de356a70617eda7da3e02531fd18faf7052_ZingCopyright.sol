pragma solidity ^0.4.16;


contract owned {

    address public owner;
    address[] public admins;
    mapping (address => bool) public isAdmin;

    function owned() public {
        owner = msg.sender;
        isAdmin[msg.sender] = true;
        admins.push(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin {
        require(isAdmin[msg.sender]);
        _;
    }

    function addAdmin(address user) onlyOwner public {
        require(!isAdmin[user]);
        isAdmin[user] = true;
        admins.push(user);
    }

    function removeAdmin(address user) onlyOwner public {
        require(isAdmin[user]);
        isAdmin[user] = false;
        for (uint i = 0; i < admins.length - 1; i++)
            if (admins[i] == user) {
                admins[i] = admins[admins.length - 1];
                break;
            }
        admins.length -= 1;
    }

    function replaceAdmin(address oldAdmin, address newAdmin) onlyOwner public {
        require(isAdmin[oldAdmin]);
        require(!isAdmin[newAdmin]);
        for (uint i = 0; i < admins.length; i++)
            if (admins[i] == oldAdmin) {
                admins[i] = newAdmin;
                break;
            }
        isAdmin[oldAdmin] = false;
        isAdmin[newAdmin] = true;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    function getAdmins() public view returns (address[]) {
        return admins;
    }

}

contract ZingCopyright is owned {

    struct Copyright {
        string fingerprint;
        string owner;
        bool exist;
    }

    mapping (string => Copyright) copyrights;

    function setCopyright(string uid, string copyrightId, string fingerprint) onlyAdmin public {
        require(!copyrights[copyrightId].exist);
        copyrights[copyrightId] = Copyright({
            fingerprint: fingerprint,
            owner: uid,
            exist: true
        });
    }

    function revokeCopyright(string copyrightId) onlyAdmin public {
        require(copyrights[copyrightId].exist);
        delete copyrights[copyrightId];
    }

    function getCopyright(string copyrightId) public view returns (string _owner, string _fingerprint) {
        _owner = copyrights[copyrightId].owner;
        _fingerprint = copyrights[copyrightId].fingerprint;
    }

}