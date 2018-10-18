pragma solidity 0.4.24;
pragma experimental "v0.5.0";
/******************************************************************************\
* Author: Nick Mudge, <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f29c9b9199b29f9d99979c81dc9b9d">[email protected]</a>
* Mokens
* Copyright (c) 2018
*
* Implements batch transfers for mokens.
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
///////////////////////////////////////////////////////////////////////////////////
//MokensSupportsInterfaces
///////////////////////////////////////////////////////////////////////////////////
contract Storage2 is Storage1 {
    mapping(bytes4 => bool) internal supportedInterfaces;
}
///////////////////////////////////////////////////////////////////////////////////
//MokenRootOwnerOf
//MokenERC721Metadata
///////////////////////////////////////////////////////////////////////////////////
contract Storage3 is Storage2 {
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
}
///////////////////////////////////////////////////////////////////////////////////
//MokenERC721Enumerable
//MokenLinkHash
///////////////////////////////////////////////////////////////////////////////////
contract Storage4 is Storage3 {
    // root token owner address => (tokenId => approved address)
    mapping(address => mapping(uint256 => address)) internal rootOwnerAndTokenIdToApprovedAddress;
    // token owner => (operator address => bool)
    mapping(address => mapping(address => bool)) internal tokenOwnerToOperators;
    // Mapping from owner to list of owned token IDs
    mapping(address => uint32[]) internal ownedTokens;
}
///////////////////////////////////////////////////////////////////////////////////
//MokenERC998ERC721TopDown
//MokenERC998ERC721TopDownBatch
//MokenERC721
//MokenERC721Batch
///////////////////////////////////////////////////////////////////////////////////
contract Storage5 is Storage4 {
    // tokenId => (child address => array of child tokens)
    mapping(uint256 => mapping(address => uint256[])) internal childTokens;
    // tokenId => (child address => (child token => child index)
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) internal childTokenIndex;
    // tokenId => (child address => contract index)
    mapping(uint256 => mapping(address => uint256)) internal childContractIndex;
    // tokenId => child contract
    mapping(uint256 => address[]) internal childContracts;
}

contract RootOwnerOfHelper is Storage3 {

    bytes32 constant ERC998_MAGIC_VALUE = 0xcd740db5;

    // Use Cases handled:
    // Case 1: Token owner is this contract and token
    // Case 2: Token owner is this contract and top-down composable.
    // Case 3: Token owner is top-down composable
    // Case 4: Token owner is an unknown contract
    // Case 5: Token owner is a user
    // Case 6: Token owner is a bottom-up composable
    // Case 7: Token owner is ERC721 token owned by top-down token
    // Case 8: Token owner is ERC721 token owned by unknown contract
    // Case 9: Token owner is ERC721 token owned by user
    function rootOwnerOf_(uint256 _tokenId) internal view returns (bytes32 rootOwner) {
        address rootOwnerAddress = address(mokens[_tokenId].data);
        require(rootOwnerAddress != address(0), "tokenId not found.");
        uint256 parentTokenId;
        bool isParent;

        while (rootOwnerAddress == address(this)) {
            parentTokenId = mokens[_tokenId].parentTokenId;
            isParent = parentTokenId > 0;
            if (isParent) {
                // Case 1: Token owner is this contract and token
                _tokenId = parentTokenId - 1;
            }
            else {
                // Case 2: Token owner is this contract and top-down composable.
                _tokenId = childTokenOwner[rootOwnerAddress][_tokenId] - 1;
            }
            rootOwnerAddress = address(mokens[_tokenId].data);
        }

        parentTokenId = mokens[_tokenId].parentTokenId;
        isParent = parentTokenId > 0;
        if (isParent) {
            parentTokenId--;
        }

        bytes memory calldata;
        bool callSuccess;

        if (isParent == false) {

            // success if this token is owned by a top-down token
            // 0xed81cdda == rootOwnerOfChild(address,uint256)
            calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
            assembly {
                callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
                if callSuccess {
                    rootOwner := mload(calldata)
                }
            }
            if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
                // Case 3: Token owner is top-down composable
                return rootOwner;
            }
            else {
                // Case 4: Token owner is an unknown contract
                // Or
                // Case 5: Token owner is a user
                return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
            }
        }
        else {

            // 0x43a61a8e == rootOwnerOf(uint256)
            calldata = abi.encodeWithSelector(0x43a61a8e, parentTokenId);
            assembly {
                callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
                if callSuccess {
                    rootOwner := mload(calldata)
                }
            }
            if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
                // Case 6: Token owner is a bottom-up composable
                // Or
                // Case 2: Token owner is top-down composable
                return rootOwner;
            }
            else {
                // token owner is ERC721
                address childContract = rootOwnerAddress;
                //0x6352211e == "ownerOf(uint256)"
                calldata = abi.encodeWithSelector(0x6352211e, parentTokenId);
                assembly {
                    callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
                    if callSuccess {
                        rootOwnerAddress := mload(calldata)
                    }
                }
                require(callSuccess, "Call to ownerOf failed");

                // 0xed81cdda == rootOwnerOfChild(address,uint256)
                calldata = abi.encodeWithSelector(0xed81cdda, childContract, parentTokenId);
                assembly {
                    callSuccess := staticcall(gas, rootOwnerAddress, add(calldata, 0x20), mload(calldata), calldata, 0x20)
                    if callSuccess {
                        rootOwner := mload(calldata)
                    }
                }
                if (callSuccess == true && rootOwner >> 224 == ERC998_MAGIC_VALUE) {
                    // Case 7: Token owner is ERC721 token owned by top-down token
                    return rootOwner;
                }
                else {
                    // Case 8: Token owner is ERC721 token owned by unknown contract
                    // Or
                    // Case 9: Token owner is ERC721 token owned by user
                    return ERC998_MAGIC_VALUE << 224 | bytes32(rootOwnerAddress);
                }
            }
        }
    }
}

contract MokenHelpers is Storage4, RootOwnerOfHelper {

    bytes4 constant ERC721_RECEIVED_NEW = 0x150b7a02;

    uint256 constant UINT16_MASK = 0x000000000000000000000000000000000000000000000000000000000000ffff;
    uint256 constant MAX_OWNER_MOKENS = 65536;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed tokenOwner, address indexed approved, uint256 indexed tokenId);

    function childApproved(address _from, uint256 _tokenId) internal {
        address approvedAddress = rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
        if(msg.sender != _from) {
            bytes32 tokenOwner;
            bool callSuccess;
            // 0xeadb80b8 == ownerOfChild(address,uint256)
            bytes memory calldata = abi.encodeWithSelector(0xed81cdda, address(this), _tokenId);
            assembly {
                callSuccess := staticcall(gas, _from, add(calldata, 0x20), mload(calldata), calldata, 0x20)
                if callSuccess {
                    tokenOwner := mload(calldata)
                }
            }
            if(callSuccess == true) {
                require(tokenOwner >> 224 != ERC998_MAGIC_VALUE, "Token is child of top down composable");
            }
            require(tokenOwnerToOperators[_from][msg.sender] || approvedAddress == msg.sender, "msg.sender not _from/operator/approved.");
        }
        if (approvedAddress != address(0)) {
            delete rootOwnerAndTokenIdToApprovedAddress[_from][_tokenId];
            emit Approval(_from, address(0), _tokenId);
        }
    }


    function _transferFrom(uint256 data, address _to, uint256 _tokenId) internal {
        address _from = address(data);
        //removing the tokenId
        // 1. We replace _tokenId in ownedTokens[_from] with the last token id
        //    in ownedTokens[_from]
        uint256 lastTokenIndex = ownedTokens[_from].length - 1;
        uint256 lastTokenId = ownedTokens[_from][lastTokenIndex];
        if (lastTokenId != _tokenId) {
            uint256 tokenIndex = data >> 160 & UINT16_MASK;
            ownedTokens[_from][tokenIndex] = uint32(lastTokenId);
            // 2. We set lastTokeId to point to its new position in ownedTokens[_from]
            mokens[lastTokenId].data = mokens[lastTokenId].data & 0xffffffffffffffffffff0000ffffffffffffffffffffffffffffffffffffffff | tokenIndex << 160;
        }
        // 3. We remove lastTokenId from the end of ownedTokens[_from]
        ownedTokens[_from].length--;

        //adding the tokenId
        uint256 ownedTokensIndex = ownedTokens[_to].length;
        // prevents 16 bit overflow
        require(ownedTokensIndex < MAX_OWNER_MOKENS, "A token owner address cannot possess more than 65,536 mokens.");
        mokens[_tokenId].data = data & 0xffffffffffffffffffff00000000000000000000000000000000000000000000 | ownedTokensIndex << 160 | uint256(_to);
        ownedTokens[_to].push(uint32(_tokenId));

        emit Transfer(_from, _to, _tokenId);
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {size := extcodesize(addr)}
        return size > 0;
    }
}

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns (bytes4);
}

contract MokenERC721Batch is Storage5, MokenHelpers {

    event ReceivedChild(address indexed from, uint256 indexed tokenId, address indexed childContract, uint256 childTokenId);

    function receiveChild(address _from, uint256 _toTokenId, address _childContract, uint256 _childTokenId) internal {
        require(address(mokens[_toTokenId].data) != address(0), "_tokenId does not exist.");
        require(childTokenOwner[_childContract][_childTokenId] == 0, "Child token already received.");
        uint256 childTokensLength = childTokens[_toTokenId][_childContract].length;
        if (childTokensLength == 0) {
            childContractIndex[_toTokenId][_childContract] = childContracts[_toTokenId].length;
            childContracts[_toTokenId].push(_childContract);
        }
        childTokenIndex[_toTokenId][_childContract][_childTokenId] = childTokensLength;
        childTokens[_toTokenId][_childContract].push(_childTokenId);
        childTokenOwner[_childContract][_childTokenId] = _toTokenId + 1;
        emit ReceivedChild(_from, _toTokenId, _childContract, _childTokenId);
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] _tokenIds, bytes _data) external {
        require(_from != address(0), "_from cannot be the 0 address.");
        require(_to != address(0), "_to cannot be the 0 address.");
        uint256 tokenId;
        uint256 data;
        uint256 i = 0;
        if (_to == address(this)) {
            require(_data.length > 0, "_data must contain the uint256 tokenId to transfer the token to.");
            bytes memory tokenIdBytes = _data;
            uint256 toTokenId;
            assembly {
                toTokenId := mload(add(tokenIdBytes,0x20))
            }
            if (_data.length < 32) {
                toTokenId = toTokenId >> 256 - _data.length * 8;
            }
            for(; i < _tokenIds.length; i++) {
                tokenId = _tokenIds[i];
                data = mokens[tokenId].data;
                require(address(data) == _from, "The tokenId is not owned by _from.");
                require(mokens[tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
                childApproved(_from, tokenId);
                _transferFrom(data, _to, tokenId);
                receiveChild(_from, toTokenId, _to, tokenId);
            }
        }
        else if(isContract(_to)){
            bytes4 retval;
            for(; i < _tokenIds.length; i++) {
                tokenId = _tokenIds[i];
                data = mokens[tokenId].data;
                require(address(data) == _from, "The tokenId is not owned by _from.");
                require(mokens[tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
                childApproved(_from, tokenId);
                _transferFrom(data, _to, tokenId);
                retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, tokenId, _data);
                require(retval == ERC721_RECEIVED_NEW, "_to contract cannot receive ERC721 tokens.");
            }
        }
        else {
            for(; i < _tokenIds.length; i++) {
                tokenId = _tokenIds[i];
                data = mokens[tokenId].data;
                require(address(data) == _from, "The tokenId is not owned by _from.");
                require(mokens[tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
                childApproved(_from, tokenId);
                _transferFrom(data, _to, tokenId);
            }
        }
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] _tokenIds) external {
        require(_from != address(0), "_from cannot be the 0 address.");
        require(_to != address(0), "_to cannot be the 0 address.");
        bool isContract_ = isContract(_to);
        uint256 tokenId;
        uint256 data;
        bytes4 retval;
        for(uint256 i = 0; i < _tokenIds.length; i++) {
            tokenId = _tokenIds[i];
            data = mokens[tokenId].data;
            require(address(data) == _from, "The tokenId is not owned by _from.");
            require(mokens[tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
            childApproved(_from, tokenId);
            _transferFrom(data, _to, tokenId);
            if (isContract_) {
                retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, tokenId, "");
                require(retval == ERC721_RECEIVED_NEW, "_to contract cannot receive ERC721 tokens.");
            }
        }
    }

    function batchTransferFrom(address _from, address _to, uint256[] _tokenIds) external {
        require(_from != address(0), "_from cannot be the 0 address.");
        require(_to != address(0), "_to cannot be the 0 address.");
        uint256 tokenId;
        uint256 data;
        for(uint256 i = 0; i < _tokenIds.length; i++) {
            tokenId = _tokenIds[i];
            data = mokens[tokenId].data;
            require(address(data) == _from, "The tokenId is not owned by _from.");
            require(_to != address(this), "Cannot transfer to this contract.");
            require(mokens[tokenId].parentTokenId == 0, "Cannot transfer from an address when owned by a token.");
            childApproved(_from, tokenId);
            _transferFrom(data, _to, tokenId);
        }
    }

    function batchApprove(address _approved, uint256[] _tokenIds) external {
        address rootOwner;
        uint256 tokenId;
        for(uint256 i = 0; i < _tokenIds.length; i++) {
            tokenId = _tokenIds[i];
            rootOwner = address(rootOwnerOf_(tokenId));
            require(rootOwner == msg.sender || tokenOwnerToOperators[rootOwner][msg.sender], "Must be rootOwner or operator.");
            rootOwnerAndTokenIdToApprovedAddress[rootOwner][tokenId] = _approved;
            emit Approval(rootOwner, _approved, tokenId);
        }
    }
}