pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="452b2c262e05282a2e202b366b2c2a">[email protected]</a>
* Copyright (c) 2018
* Mokens
*
* The MokenUpdates contract adds/updates/removes functions. This is how the Mokens
* contract is updated
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
    bytes[] internal funcSignatures;
    // signature => index+1
    mapping(bytes => uint256) internal funcSignatureToIndex;
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
            funcSignatures.push(signature);
            funcSignatureToIndex[signature] = funcSignatures.length;
            emit ContractUpdated(funcId, _mokenUpdates, "new", string(signature));
        }
    }

    function addFunctions(address _delegate, string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signatures = bytes(_functionSignatures);
        uint256 signaturesEnd;
        uint256 pos;
        uint256 start;
        assembly {
            pos := add(signatures,32)
            start := pos
            signaturesEnd := add(pos,mload(signatures))
        }
        bytes4 funcId;
        uint256 num;
        uint256 char;
        for (; pos < signaturesEnd; pos++) {
            assembly {char := byte(0,mload(pos))}
            // 0x29 == )
            if (char == 0x29) {
                pos++;
                num = (pos - start);
                start = pos;
                assembly {
                    mstore(signatures,num)
                }
                funcId = bytes4(keccak256(signatures));
                require(funcSignatureToIndex[signatures] == 0, "Function already exists.");
                require(delegates[funcId] == address(0), "FuncId clash.");
                delegates[funcId] = _delegate;
                funcSignatures.push(signatures);
                funcSignatureToIndex[signatures] = funcSignatures.length;
                emit ContractUpdated(funcId, _delegate, "new", string(signatures));
                assembly {signatures := add(signatures,num)}
            }
        }
    }

    function updateFunctions(address _delegate, string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        require(_delegate != address(0), "delegate can't be zero address.");
        bytes memory signatures = bytes(_functionSignatures);
        uint256 signaturesEnd;
        uint256 pos;
        uint256 start;
        assembly {
            pos := add(signatures,32)
            start := pos
            signaturesEnd := add(pos,mload(signatures))
        }
        bytes4 funcId;
        uint256 num;
        uint256 char;
        for (; pos < signaturesEnd; pos++) {
            assembly {char := byte(0,mload(pos))}
            // 0x29 == )
            if (char == 0x29) {
                pos++;
                num = (pos - start);
                start = pos;
                assembly {
                    mstore(signatures,num)
                }
                funcId = bytes4(keccak256(signatures));
                if (funcSignatureToIndex[signatures] == 0) {
                    require(delegates[funcId] == address(0), "FuncId clash.");
                    delegates[funcId] = _delegate;
                    funcSignatures.push(signatures);
                    funcSignatureToIndex[signatures] = funcSignatures.length;
                    emit ContractUpdated(funcId, _delegate, "new", string(signatures));
                    assembly {signatures := add(signatures,num)}
                }
                else if (delegates[funcId] != _delegate) {
                    delegates[funcId] = _delegate;
                    emit ContractUpdated(funcId, _delegate, "updated", string(signatures));
                    assembly {signatures := add(signatures,num)}
                }
            }
        }
    }

    function removeFunctions(string _functionSignatures) external {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        address delegate;
        bytes memory signatures = bytes(_functionSignatures);
        uint256 signaturesEnd;
        uint256 pos;
        uint256 start;
        assembly {
            pos := add(signatures,32)
            start := pos
            signaturesEnd := add(pos,mload(signatures))
        }
        bytes4 funcId;
        uint256 num;
        uint256 char;
        uint256 index;
        uint256 lastIndex;
        for (; pos < signaturesEnd; pos++) {
            assembly {char := byte(0,mload(pos))}
            // 0x29 == )
            if (char == 0x29) {
                pos++;
                num = (pos - start);
                start = pos;
                assembly {
                    mstore(signatures,num)
                }
                funcId = bytes4(keccak256(signatures));
                index = funcSignatureToIndex[signatures];
                require(index != 0, "Function does not exist.");
                index--;
                lastIndex = funcSignatures.length - 1;
                if (index != lastIndex) {
                    funcSignatures[index] = funcSignatures[lastIndex];
                    funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
                }
                funcSignatures.length--;
                delete funcSignatureToIndex[signatures];
                delegate = delegates[funcId];
                delete delegates[funcId];
                emit ContractUpdated(funcId, delegate, "removed", string(signatures));
                assembly {signatures := add(signatures,num)}
            }
        }
    }
}