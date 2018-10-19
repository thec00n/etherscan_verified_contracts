pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a5cbccc6cee5c8cacec0cbd68bccca">[email protected]</a>
* Mokens
* Copyright (c) 2018
/******************************************************************************/
///////////////////////////////////////////////////////////////////////////////////
//Storage contracts
////////////
//Some delegate contracts are listed with storage contracts they inherit.
///////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
//Mokens
///////////////////////////////////////////////////////////////////////////////////
contract Storage0 {
    // funcId => delegate contract
    mapping(bytes4 => address) internal delegates;
}
///////////////////////////////////////////////////////////////////////////////////
//MokenUpdates
//MokenOwner
//QueryMokenDelegates
///////////////////////////////////////////////////////////////////////////////////
contract Storage1 is Storage0 {
    address internal contractOwner;
    bytes[] internal funcSignatures;
    // signature => index+1
    mapping(bytes => uint256) internal funcSignatureToIndex;
}

contract MokenOwner is Storage1 {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() external view returns (address) {
        return contractOwner;
    }

    function transferOwnership(address _newOwner) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_newOwner != address(0), "_newOwner cannot be 0 address.");
        emit OwnershipTransferred(contractOwner, _newOwner);
        contractOwner = _newOwner;
    }

    function withdraw(address _sendTo, uint256 _amount) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        address mokensContract = address(this);
        require(_amount <= mokensContract.balance, "Amount is greater than balance.");
        _sendTo.transfer(_amount);
    }
}