pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="86e8efe5edc6ebe9ede3e8f5a8efe9">[email protected]</a>
* Copyright (c) 2018
* Mokens
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
    bytes[] internal functionSignatures;
    // signature => index+1
    mapping(bytes => uint256) internal functionSignatureToIndex;
}

contract MokenUpdates is Storage1 {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractUpdated(bytes4 indexed functionId, address indexed delegate, bytes32 indexed updateType, string functionSignature);

    function initializeMokensContract(address _mokenUpdates) external {
        require(contractOwner == address(0), "Contract owner has been set.");
        contractOwner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
        /////////////////////////////////////////
        //adding functions to Mokens contract
        /////////////////////////////////////////
        bytes memory signature;
        bytes4 funcId;
        bytes[] memory signatures = new bytes[](3);
        signatures[0] = "addFunctions(address,string)";
        signatures[1] = "updateFunctions(address,string)";
        signatures[2] = "removeFunctions(string)";
        for(uint256 i = 0; i < signatures.length; i++) {
            signature = signatures[i];
            funcId = bytes4(keccak256(signature));
            delegates[funcId] = _mokenUpdates;
            functionSignatures.push(signature);
            functionSignatureToIndex[signature] = functionSignatures.length;
            emit ContractUpdated(funcId, _mokenUpdates, "new", string(signature));
        }
    }

    function addFunctions(address _delegate, string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signatures = bytes(_functionSignatures);
        bytes memory signature;
        bytes4 funcId;
        uint256 pos = 2;
        uint256 start;
        uint256 num;
        for (; pos < signatures.length; pos++) {
            // 0x29 == )
            if (signatures[pos] == 0x29) {
                num = (pos - start) + 1;
                signature = new bytes(num);
                for (uint256 i = 0; i < num; i++) {
                    signature[i] = signatures[start + i];
                }
                start = pos + 1;
                funcId = bytes4(keccak256(signature));
                require(functionSignatureToIndex[signature] == 0, "Function already exists.");
                require(delegates[funcId] == address(0), "FuncId clash.");
                delegates[funcId] = _delegate;
                functionSignatures.push(signature);
                functionSignatureToIndex[signature] = functionSignatures.length;
                emit ContractUpdated(funcId, _delegate, "new", string(signature));
            }
        }
    }

    function updateFunctions(address _delegate, string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signatures = bytes(_functionSignatures);
        bytes memory signature;
        bytes4 funcId;
        uint256 pos = 2;
        uint256 start;
        uint256 num;
        for (; pos < signatures.length; pos++) {
            // 0x29 == )
            if (signatures[pos] == 0x29) {
                num = (pos - start) + 1;
                signature = new bytes(num);
                for (uint256 i = 0; i < num; i++) {
                    signature[i] = signatures[start + i];
                }
                start = pos + 1;
                funcId = bytes4(keccak256(signature));
                if (functionSignatureToIndex[signature] == 0) {
                    require(delegates[funcId] == address(0), "FuncId clash.");
                    delegates[funcId] = _delegate;
                    functionSignatures.push(signature);
                    functionSignatureToIndex[signature] = functionSignatures.length;
                    emit ContractUpdated(funcId, _delegate, "new", string(signature));
                }
                else if (delegates[funcId] != _delegate) {
                    delegates[funcId] = _delegate;
                    emit ContractUpdated(funcId, _delegate, "updated", string(signature));
                }
            }
        }
    }

    function removeFunctions(string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        address delegate;
        bytes memory signatures = bytes(_functionSignatures);
        bytes memory signature;
        bytes4 funcId;
        uint256 pos = 2;
        uint256 start;
        uint256 num;
        uint256 index;
        uint256 lastIndex;
        for (; pos < signatures.length; pos++) {
            // 0x29 == )
            if (signatures[pos] == 0x29) {
                num = (pos - start) + 1;
                signature = new bytes(num);
                for (uint256 i = 0; i < num; i++) {
                    signature[i] = signatures[start + i];
                }
                start = pos + 1;
                funcId = bytes4(keccak256(signature));
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
                emit ContractUpdated(funcId, delegate, "removed", string(signature));
            }
        }
    }
}