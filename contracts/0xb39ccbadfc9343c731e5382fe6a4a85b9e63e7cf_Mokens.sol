pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
*..................................Mokens......................................*
*.....................General purpose cryptocollectibles.......................*
*..............................................................................*
/******************************************************************************/

/******************************************************************************\
* Author: Nick Mudge, <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="9ff1f6fcf4dff2f0f4faf1ecb1f6f0">[email protected]</a>>
* Copyright (c) 2018
*
* The Mokens contract is a proxy contract that delegates all functionality
* to delegate contracts. This design enables new functionality and improvements
* to be added to the Mokens contract over time.
*
* Changes to the Mokens contract are transparent and visible. To make changes
* easier to monitor the ContractUpdated event is emitted any time a function is
* added, removed or updated. The ContractUpdated event exists in the
* MokenUpdates delegate contract
*
* The source code for all delegate contracts used by the Mokens contract can be
* found online and inspected.
*
* The Mokens contract is reflective or self inspecting. It contains functions
* for inspecting what delegate contracts it has and what functions they have.
* Specifically, the QueryMokenDelegates delegate contract contains functions for
* querying delegate contracts and functions.
*
*    Here are some of the other delegate contracts:
*
*  - MokenERC721: Implements the ERC721 standard for mokens.
*  - MokenERC721Batch: Implements batch transfers and approvals.
*  - MokenERC998ERC721TopDown: Implements ERC998 composable functionality.
*  - MokenERC998ERC20TopDown: Implements ERC998 composable functionality.
*  - MokenERC998ERC721BottomUp: Implements ERC998 composable functionality.
*  - MokenMinting: Implements moken minting functionality.
*  - MokenEras: Implements moken era functionality.
*  - QueryMokenData: Implements functions to query info about mokens.
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

contract Mokens is Storage0 {
    constructor(address mokenUpdates) public {
        //0x584fc325 == "initializeMokensContract()"
        bytes memory calldata = abi.encodeWithSelector(0x584fc325,mokenUpdates);
        assembly {
            let callSuccess := delegatecall(gas, mokenUpdates, add(calldata, 0x20), mload(calldata), 0, 0)
            let size := returndatasize
            returndatacopy(calldata, 0, size)
            if eq(callSuccess,0) {revert(calldata, size)}
        }
    }

    function() external payable {
        address delegate = delegates[msg.sig];
        require(delegate != address(0), "Mokens function does not exist.");
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, delegate, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)
            switch result
            case 0 {revert(ptr, size)}
            default {return (ptr, size)}
        }
    }
}