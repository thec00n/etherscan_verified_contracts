pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="137d7a7078537e7c78767d603d7a7c">[email protected]</a>
* Copyright (c) 2018
*
* The QueryMokenDelegates contract contains functions for retrieving function
* signatures and delegate contract addresses used by the Mokens contract.
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
    bytes[] internal functionSignatures;
    // signature => index+1
    mapping(bytes => uint256) internal functionSignatureToIndex;
}

contract QueryMokenDelegates is Storage1 {

    function totalFunctions() external view returns(uint256) {
        return functionSignatures.length;
    }

    function functionByIndex(uint256 _index) external view returns(string memory functionSignature, bytes4 functionId, address delegate) {
        require(_index < functionSignatures.length, "functionSignatures index does not exist.");
        bytes memory signature = functionSignatures[_index];
        functionId = bytes4(keccak256(signature));
        delegate = delegates[functionId];
        return (string(signature), functionId, delegate);
    }

    function functionExists(string signature) external view returns(bool) {
        return functionSignatureToIndex[bytes(signature)] != 0;
    }

    function getFunctionSignatures() external view returns(string) {
        uint256 signaturesLength;
        bytes memory signatures;
        bytes memory signature;
        uint256 functionIndex;
        uint256 charPos;
        uint256 functionSignaturesNum = functionSignatures.length;
        bytes[] memory memoryFunctionSignatures = new bytes[](functionSignaturesNum);
        for(; functionIndex < functionSignaturesNum; functionIndex++) {
            signature = functionSignatures[functionIndex];
            signaturesLength += signature.length;
            memoryFunctionSignatures[functionIndex] = signature;
        }
        signatures = new bytes(signaturesLength);
        functionIndex = 0;
        for(; functionIndex < functionSignaturesNum; functionIndex++) {
            signature = memoryFunctionSignatures[functionIndex];
            for(uint256 i = 0; i < signature.length; i++) {
                signatures[charPos] = signature[i];
                charPos++;
            }
        }
        return string(signatures);
    }

    function getDelegateFunctionSignatures(address _delegate) external view returns(string) {
        uint256 signaturesNum = functionSignatures.length;
        bytes[] memory delegateSignatures = new bytes[](signaturesNum);
        uint256 delegateSignaturesPos;
        uint256 signaturesLength;
        bytes memory signatures;
        bytes memory signature;
        uint256 functionIndex;
        uint256 charPos;
        for(; functionIndex < signaturesNum; functionIndex++) {
            signature = functionSignatures[functionIndex];
            if(_delegate == delegates[bytes4(keccak256(signature))]) {
                signaturesLength += signature.length;
                delegateSignatures[delegateSignaturesPos] = signature;
                delegateSignaturesPos++;
            }

        }
        signatures = new bytes(signaturesLength);
        functionIndex = 0;
        for(; functionIndex < delegateSignatures.length; functionIndex++) {
            signature = delegateSignatures[functionIndex];
            if(signature.length == 0) {
                break;
            }
            for(uint256 i = 0; i < signature.length; i++) {
                signatures[charPos] = signature[i];
                charPos++;
            }
        }
        return string(signatures);
    }

    function getDelegate(string functionSignature) external view returns(address) {
        require(functionSignatureToIndex[bytes(functionSignature)] != 0, "Function signature not found.");
        return delegates[bytes4(keccak256(bytes(functionSignature)))];
    }

    function getFunctionBySignature(string functionSignature) external view returns(bytes4 functionId, address delegate) {
        require(functionSignatureToIndex[bytes(functionSignature)] != 0, "Function signature not found.");
        functionId = bytes4(keccak256(bytes(functionSignature)));
        return (functionId,delegates[functionId]);
    }

    function getFunctionById(bytes4 functionId) external view returns(string signature, address delegate) {
        for(uint256 i = 0; i < functionSignatures.length; i++) {
            if(functionId == bytes4(keccak256(functionSignatures[i]))) {
                return (string(functionSignatures[i]), delegates[functionId]);
            }
        }
        revert("functionId not found");
    }

    function getDelegates() external view returns(address[]) {
        uint256 functionSignaturesNum = functionSignatures.length;
        address[] memory delegatesBucket = new address[](functionSignaturesNum);
        uint256 numDelegates;
        uint256 functionIndex;
        bool foundDelegate;
        address delegate;
        for(; functionIndex < functionSignaturesNum; functionIndex++) {
            delegate = delegates[bytes4(keccak256(functionSignatures[functionIndex]))];
            for(uint256 i = 0; i < numDelegates; i++) {
                if(delegate == delegatesBucket[i]) {
                    foundDelegate = true;
                    break;
                }
            }
            if(foundDelegate == false) {
                delegatesBucket[numDelegates] = delegate;
                numDelegates++;
            }
            else {
                foundDelegate = false;
            }
        }
        address[] memory delegates_ = new address[](numDelegates);
        functionIndex = 0;
        for(; functionIndex < numDelegates; functionIndex++) {
            delegates_[functionIndex] = delegatesBucket[functionIndex];
        }
        return delegates_;
    }
}