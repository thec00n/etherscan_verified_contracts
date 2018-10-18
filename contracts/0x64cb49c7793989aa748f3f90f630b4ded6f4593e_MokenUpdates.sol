pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="bad4d3d9d1fad7d5d1dfd4c994d3d5">[email protected]</a>
* Copyright (c) 2018
*
* The MokenUpdates contract adds/updates/removes functions.
*
* Function changes emit the ContractUpdated event.
* Monitor changes to the Mokens contract by watching/querying the
* ContractUpdated event
*
* Functions and delegate contracts can be queried by using functions from the
* QueryMokenDelegates contract.
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
    string[] internal functionSignatures;
    // signature => index+1
    mapping(string => uint256) internal functionSignatureToIndex;
}

contract MokenUpdates is Storage1 {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractUpdated(bytes4 indexed functionId, address indexed delegate, bytes32 indexed updateType, string functionSignature);

    function initializeMokensContract(address mokenUpdates) external {
        require(contractOwner == address(0), "Contract owner has been set.");
        contractOwner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
        /////////////////////////////////////////
        //adding functions to Mokens contract
        /////////////////////////////////////////
        string memory signature;
        bytes4 funcId;
        string[] memory signatures = new string[](3);
        signatures[0] = "addFunctions(address,string)";
        signatures[1] = "updateFunctions(address,string)";
        signatures[2] = "removeFunctions(string)";
        for(uint256 i = 0; i < signatures.length; i++) {
            signature = signatures[i];
            funcId = bytes4(keccak256(bytes(signature)));
            delegates[funcId] = mokenUpdates;
            functionSignatures.push(signature);
            functionSignatureToIndex[signature] = functionSignatures.length;
            emit ContractUpdated(funcId, mokenUpdates, "new", signature);
        }
    }

    function addFunctions(address _delegate, string signatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signaturesBytes = bytes(signatures);
        bytes memory signatureBytes;
        string memory signature;
        bytes4 funcId;
        uint256 length = signaturesBytes.length;
        uint256 pos = 2;
        uint256 start = 0;
        uint256 num;
        for (; pos < length; pos++) {
            // 0x29 == )
            if (signaturesBytes[pos] == 0x29) {
                num = (pos - start) + 1;
                signatureBytes = new bytes(num);
                for (uint i = 0; i < num; i++) {
                    signatureBytes[i] = signaturesBytes[start + i];
                }
                start = pos + 1;
                signature = string(signatureBytes);
                funcId = bytes4(keccak256(signatureBytes));
                require(functionSignatureToIndex[signature] == 0, "Function already exists.");
                require(delegates[funcId] == address(0), "FuncId clash.");
                delegates[funcId] = _delegate;
                functionSignatures.push(signature);
                functionSignatureToIndex[signature] = functionSignatures.length;
                emit ContractUpdated(funcId, _delegate, "new", signature);
            }
        }
    }

    function updateFunctions(address _delegate, string signatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signaturesBytes = bytes(signatures);
        bytes memory signatureBytes;
        string memory signature;
        bytes4 funcId;
        uint256 length = signaturesBytes.length;
        uint256 pos = 2;
        uint256 start = 0;
        uint256 num;
        uint256 index;
        for (; pos < length; pos++) {
            // 0x29 == )
            if (signaturesBytes[pos] == 0x29) {
                num = (pos - start) + 1;
                signatureBytes = new bytes(num);
                for (uint i = 0; i < num; i++) {
                    signatureBytes[i] = signaturesBytes[start + i];
                }
                start = pos + 1;
                signature = string(signatureBytes);
                funcId = bytes4(keccak256(signatureBytes));
                index = functionSignatureToIndex[signature];
                if (index == 0) {
                    require(delegates[funcId] == address(0), "FuncId clash.");
                    delegates[funcId] = _delegate;
                    functionSignatures.push(signature);
                    functionSignatureToIndex[signature] = functionSignatures.length;
                    emit ContractUpdated(funcId, _delegate, "new", signature);
                }
                else if (delegates[funcId] != _delegate) {
                    delegates[funcId] = _delegate;
                    emit ContractUpdated(funcId, _delegate, "updated", signature);
                }
            }
        }
    }

    function removeFunctions(string signatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        address delegate;
        bytes memory signaturesBytes = bytes(signatures);
        bytes memory signatureBytes;
        string memory signature;
        bytes4 funcId;
        uint256 length = signaturesBytes.length;
        uint256 pos = 2;
        uint256 start = 0;
        uint256 num;
        uint256 index;
        uint256 lastIndex;
        for (; pos < length; pos++) {
            // 0x29 == )
            if (signaturesBytes[pos] == 0x29) {
                num = (pos - start) + 1;
                signatureBytes = new bytes(num);
                for (uint i = 0; i < num; i++) {
                    signatureBytes[i] = signaturesBytes[start + i];
                }
                start = pos + 1;
                signature = string(signatureBytes);
                funcId = bytes4(keccak256(signatureBytes));
                index = functionSignatureToIndex[signature];
                require(index != 0, "Function does not exist.");
                index--;
                lastIndex = functionSignatures.length - 1;
                if (index != lastIndex) {
                    functionSignatures[index] = functionSignatures[lastIndex];
                    functionSignatureToIndex[functionSignatures[lastIndex]] = index + 1;
                }
                functionSignatures.length--;
                delete functionSignatureToIndex[signature];
                delegate = delegates[funcId];
                delete delegates[funcId];
                emit ContractUpdated(funcId, delegate, "removed", signature);
            }
        }
    }
}