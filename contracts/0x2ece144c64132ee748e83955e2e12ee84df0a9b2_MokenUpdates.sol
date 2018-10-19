pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="aac4c3c9c1eac7c5c1cfc4d984c3c5">[email protected]</a>>
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
// All storage variables are declared here
///////////////////////////////////////////////////////////////////////////////////
contract Storage0 {
    ///////////////////////////////////////////////////////////////////////////////////
    //Storage version 0
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////
    //Contract Management
    ///////////////////////////////////////////////////////////////////////////////////
    // funcId => delegate contract
    mapping(bytes4 => address) internal delegates;
    address internal contractOwner;
    string[] internal functionSignatures;
    // signature => index+1
    mapping(string => uint256) internal functionSignatureToIndex;


    ///////////////////////////////////////////////////////////////////////////////////
    //SupportsInterfaces
    ///////////////////////////////////////////////////////////////////////////////////
    mapping(bytes4 => bool) internal supportedInterfaces;


    ///////////////////////////////////////////////////////////////////////////////////
    //RootOwnerOf
    //ERC721Metadata
    ///////////////////////////////////////////////////////////////////////////////////
    struct Moken {
        string name;
        uint256 data;
        uint256 parentTokenId;
    }
    //tokenId => moken
    mapping(uint256 => Moken) internal mokens;
    uint256 internal mokensLength;
    // child address => child tokenId => tokenId+1
    mapping(address => mapping(uint256 => uint256)) internal childTokenOwner;


    ///////////////////////////////////////////////////////////////////////////////////
    //ERC721
    //ERC721Enumerable
    ///////////////////////////////////////////////////////////////////////////////////
    // root token owner address => (tokenId => approved address)
    mapping(address => mapping(uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
    // token owner => (operator address => bool)
    mapping(address => mapping(address => bool)) internal tokenOwnerToOperators;
    // Mapping from owner to list of owned token IDs
    mapping(address => uint32[]) internal ownedTokens;


    ///////////////////////////////////////////////////////////////////////////////////
    //ERC998ERC721TopDown
    ///////////////////////////////////////////////////////////////////////////////////
    // tokenId => (child address => array of child tokens)
    mapping(uint256 => mapping(address => uint256[])) internal childTokens;
    // tokenId => (child address => (child token => child index)
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) internal childTokenIndex;
    // tokenId => (child address => contract index)
    mapping(uint256 => mapping(address => uint256)) internal childContractIndex;
    // tokenId => child contract
    mapping(uint256 => address[]) internal childContracts;


    ///////////////////////////////////////////////////////////////////////////////////
    //ERC998ERC20TopDown
    ///////////////////////////////////////////////////////////////////////////////////
    // tokenId => token contract
    mapping(uint256 => address[]) internal erc20Contracts;
    // tokenId => (token contract => token contract index)
    mapping(uint256 => mapping(address => uint256)) erc20ContractIndex;
    // tokenId => (token contract => balance)
    mapping(uint256 => mapping(address => uint256)) internal erc20Balances;


    ///////////////////////////////////////////////////////////////////////////////////
    //ERC998ERC721BottomUp
    ///////////////////////////////////////////////////////////////////////////////////
    // parent address => (parent tokenId => array of child tokenIds)
    mapping(address => mapping(uint256 => uint32[])) internal parentToChildTokenIds;
    // tokenId => position in childTokens array
    mapping(uint256 => uint256) internal tokenIdToChildTokenIdsIndex;


    ///////////////////////////////////////////////////////////////////////////////////
    //Era
    ///////////////////////////////////////////////////////////////////////////////////
    // index => era
    mapping(uint256 => bytes32) internal eras;
    uint256 internal eraLength;
    // era => index+1
    mapping(bytes32 => uint256) internal eraIndex;


    ///////////////////////////////////////////////////////////////////////////////////
    //Minting
    ///////////////////////////////////////////////////////////////////////////////////
    uint256 internal mintPriceOffset; // = 0 szabo;
    uint256 internal mintStepPrice; // = 500 szabo;
    uint256 internal mintPriceBuffer; // = 5000 szabo;
    address[] internal mintContracts;
    mapping(address => uint256) internal mintContractIndex;
    //moken name => tokenId+1
    mapping(string => uint256) internal tokenByName_;
}

contract MokenUpdates is Storage0 {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ContractUpdated(bytes32 indexed indexedFunctionSignature, address indexed delegate, bytes32 indexed updateType, string functionSignature);

    function initializeMokensContract(address contractManagement) external {
        require(contractOwner == address(0), "Contract owner has been set.");
        contractOwner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
        updateContract(1 /* addFunctions */, contractManagement, "executeDelegate(address,bytes)addFunctions(address,string)updateFunctions(address,string)removeFunctions(string)");
    }

    function updateContract(uint256 _updateType, address _delegate, string signatures) internal {
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
        uint256 lastIndex;
        bytes32 signatureHash;
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
                signatureHash = keccak256(signatureBytes);
                funcId = bytes4(signatureHash);
                if (_updateType == 1) {
                    require(functionSignatureToIndex[signature] == 0, "Function already exists.");
                    require(delegates[funcId] == address(0), "FuncId clash.");
                    delegates[funcId] = _delegate;
                    functionSignatures.push(signature);
                    functionSignatureToIndex[signature] = functionSignatures.length;
                    emit ContractUpdated(signatureHash, _delegate, "new", signature);
                }
                else if (_updateType == 2) {
                    index = functionSignatureToIndex[signature];
                    if (index == 0) {
                        require(delegates[funcId] == address(0), "FuncId clash.");
                        delegates[funcId] = _delegate;
                        emit ContractUpdated(signatureHash, _delegate, "new", signature);
                    }
                    else if (delegates[funcId] != _delegate) {
                        delegates[funcId] = _delegate;
                        emit ContractUpdated(signatureHash, _delegate, "updated", signature);
                    }
                }
                else if (_updateType == 3) {
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
                    _delegate = delegates[funcId];
                    delete delegates[funcId];
                    emit ContractUpdated(signatureHash, _delegate, "removed", signature);
                }
            }
        }
    }

    function addFunctions(address _delegate, string signatures) external {
        updateContract(1, _delegate, signatures);
    }

    function updateFunctions(address _delegate, string signatures) external {
        updateContract(2, _delegate, signatures);
    }

    function removeFunctions(string signatures) external {
        updateContract(3, address(1), signatures);
    }


    function executeDelegate(address _delegate, bytes _functionCall) external returns(string) {
        require(msg.sender == contractOwner, "Must own Mokens contract.");
        bytes memory functionCall = _functionCall;
        assembly {
            let callSuccess := delegatecall(gas, _delegate, add(functionCall, 0x20), mload(functionCall), 0, 0)
            let size := returndatasize
            returndatacopy(functionCall, 0, size)
            switch callSuccess
            case 0 {revert(functionCall, size)}
            default {return (functionCall, size)}
        }
    }
}