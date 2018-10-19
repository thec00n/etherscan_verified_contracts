pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6f01060c042f0200040a011c410600">[email protected]</a>
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
    string[] internal functionSignatures;
    // signature => index+1
    mapping(string => uint256) internal functionSignatureToIndex;
}

contract QueryMokenDelegates is Storage1 {

    function totalFunctions() external view returns(uint256) {
        return functionSignatures.length;
    }

    function functionByIndex(uint256 _index) external view returns(string memory signature, bytes4 functionId, address delegate) {
        require(_index < functionSignatures.length, "functionSignatures index does not exist.");
        signature = functionSignatures[_index];
        functionId = bytes4(keccak256(bytes(signature)));
        delegate = delegates[functionId];
        return (signature, functionId, delegate);
    }

    function functionExists(string signature) external view returns(bool) {
        return functionSignatureToIndex[signature] != 0;
    }

    function getFunctions() external view returns(string) {
        uint256 functionSignaturesSize = 0;
        bytes memory functionSignaturesBytes;
        bytes memory functionSignatureBytes;
        uint256 functionIndex = 0;
        uint256 charPos = 0;
        for(; functionIndex < functionSignatures.length; functionIndex++) {
            functionSignaturesSize += bytes(functionSignatures[functionIndex]).length;
        }
        functionSignaturesBytes = new bytes(functionSignaturesSize);
        functionIndex = 0;
        for(; functionIndex < functionSignatures.length; functionIndex++) {
            functionSignatureBytes = bytes(functionSignatures[functionIndex]);
            for(uint256 i = 0; i < functionSignatureBytes.length; i++) {
                functionSignaturesBytes[charPos] = functionSignatureBytes[i];
                charPos++;
            }
        }
        return string(functionSignaturesBytes);
    }

    function getDelegateFunctions(address _delegate) external view returns(string) {
        bytes[] memory delegateFunctionSignatures = new bytes[](functionSignatures.length);
        uint256 delegateFunctionSignaturesPos = 0;
        uint256 functionSignaturesSize = 0;
        bytes memory functionSignaturesBytes;
        bytes memory functionSignatureBytes;
        uint256 functionIndex = 0;
        uint256 charPos = 0;
        for(; functionIndex < functionSignatures.length; functionIndex++) {
            functionSignatureBytes = bytes(functionSignatures[functionIndex]);
            if(_delegate == delegates[bytes4(keccak256(functionSignatureBytes))]) {
                functionSignaturesSize += functionSignatureBytes.length;
                delegateFunctionSignatures[delegateFunctionSignaturesPos] = functionSignatureBytes;
                delegateFunctionSignaturesPos++;
            }

        }
        functionSignaturesBytes = new bytes(functionSignaturesSize);
        functionIndex = 0;
        for(; functionIndex < delegateFunctionSignatures.length; functionIndex++) {
            functionSignatureBytes = delegateFunctionSignatures[functionIndex];
            if(functionSignatureBytes.length == 0) {
                break;
            }
            for(uint256 i = 0; i < functionSignatureBytes.length; i++) {
                functionSignaturesBytes[charPos] = functionSignatureBytes[i];
                charPos++;
            }
        }
        return string(functionSignaturesBytes);
    }

    function getDelegate(string signature) external view returns(address) {
        require(functionSignatureToIndex[signature] != 0, "Function signature not found.");
        return delegates[bytes4(keccak256(bytes(signature)))];
    }

    function getFunctionBySignature(string signature) external view returns(bytes4 functionId, address delegate) {
        require(functionSignatureToIndex[signature] != 0, "Function signature not found.");
        functionId = bytes4(keccak256(bytes(signature)));
        return (functionId,delegates[functionId]);
    }

    function getFunctionById(bytes4 functionId) external view returns(string signature, address delegate) {
        for(uint256 i = 0; i < functionSignatures.length; i++) {
            if(functionId == keccak256(bytes(functionSignatures[i]))) {
                return (functionSignatures[i], delegates[functionId]);
            }
        }
        revert("functionId not found");
    }

    function getDelegates() external view returns(address[]) {
        uint256 functionSignaturesNum = functionSignatures.length;
        address[] memory delegatesBucket = new address[](functionSignaturesNum);
        uint256 numDelegates = 0;
        uint256 functionIndex = 0;
        bool foundDelegate = false;
        address delegate;
        for(; functionIndex < functionSignaturesNum; functionIndex++) {
            delegate = delegates[bytes4(keccak256(bytes(functionSignatures[functionIndex])))];
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