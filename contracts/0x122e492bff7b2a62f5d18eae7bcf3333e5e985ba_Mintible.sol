pragma solidity ^0.4.24;

contract ERC721 {
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) public view returns (uint256 _balance);
    function ownerOf(uint256 _tokenId) public view returns (address _owner);
    function exists(uint256 _tokenId) public view returns (bool _exists);

    function approve(address _to, uint256 _tokenId) public;
    function getApproved(uint256 _tokenId) public view returns (address _operator);

    function setApprovalForAll(address _operator, bool _approved) public;
    function isApprovedForAll(address _owner, address _operator) public view returns (bool);

    function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes _data
    )
    public;
}
/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 *  from ERC721 asset contracts.
 */
contract ERC721Receiver {
    /**
     * @dev Magic value to be returned upon successful reception of an NFT
     *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
     *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
     */
    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;

    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     *  after a `safetransfer`. This function MAY throw to revert and reject the
     *  transfer. This function MUST use 50,000 gas or less. Return of other
     *  than the magic value MUST result in the transaction being reverted.
     *  Note: the contract address is always the message sender.
     * @param _from The sending address
     * @param _tokenId The NFT identifier which is being transfered
     * @param _data Additional data with no specified format
     * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
     */
    function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);

}



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath128 {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint128 a, uint128 b) internal pure returns (uint128 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint128 a, uint128 b) internal pure returns (uint128) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint128 a, uint128 b) internal pure returns (uint128) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath64 {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint64 a, uint64 b) internal pure returns (uint64) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint64 a, uint64 b) internal pure returns (uint64) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath32 {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint32 a, uint32 b) internal pure returns (uint32) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint32 a, uint32 b) internal pure returns (uint32) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath16 {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint16 a, uint16 b) internal pure returns (uint16) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint16 a, uint16 b) internal pure returns (uint16) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath8 {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint8 a, uint8 b) internal pure returns (uint8) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint8 a, uint8 b) internal pure returns (uint8) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}



/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     *  as the code is not actually created until after the constructor finishes.
     * @param addr address to check
     * @return whether the target address is a contract
     */
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
        return size > 0;
    }

}


/**
 * @title Eliptic curve signature operations
 *
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 *
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 *
 */

library ECRecovery {

    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param sig bytes signature, the signature is generated using web3.eth.sign()
     */
    function recover(bytes32 hash, bytes sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        //Check the signature length
        if (sig.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }

        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(hash, v, r, s);
        }
    }

}

contract MintibleUtility is Ownable {
    using SafeMath     for uint256;
    using SafeMath128  for uint128;
    using SafeMath64   for uint64;
    using SafeMath32   for uint32;
    using SafeMath16   for uint16;
    using SafeMath8    for uint8;
    using AddressUtils for address;
    using ECRecovery   for bytes32;

    uint256 private nonce;

    bool public paused;

    modifier notPaused() {
        require(!paused);
        _;
    }

    /*
     * @dev Uses binary search to find the index of the off given
     */
    function getIndexFromOdd(uint32 _odd, uint32[] _odds) internal pure returns (uint) {
        uint256 low = 0;
        uint256 high = _odds.length.sub(1);

        while (low < high) {
            uint256 mid = (low.add(high)) / 2;
            if (_odd >= _odds[mid]) {
                low = mid.add(1);
            } else {
                high = mid;
            }
        }

        return low;
    }

    /*
     * Using the `nonce` and a range, it generates a random value using `keccak256` and random distribution
     */
    function rand(uint32 min, uint32 max) internal returns (uint32) {
        nonce++;
        return uint32(keccak256(abi.encodePacked(nonce, uint(blockhash(block.number.sub(1)))))) % (min.add(max)).sub(min);
    }


    /*
     *  Sub array utility functions
     */

    function getUintSubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint256[]) {
        uint256[] memory ret = new uint256[](_end.sub(_start));
        for (uint256 i = _start; i < _end; i++) {
            ret[i - _start] = _arr[i];
        }

        return ret;
    }

    function getUint32SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint32[]) {
        uint32[] memory ret = new uint32[](_end.sub(_start));
        for (uint256 i = _start; i < _end; i++) {
            ret[i - _start] = uint32(_arr[i]);
        }

        return ret;
    }

    function getUint64SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint64[]) {
        uint64[] memory ret = new uint64[](_end.sub(_start));
        for (uint256 i = _start; i < _end; i++) {
            ret[i - _start] = uint64(_arr[i]);
        }

        return ret;
    }
}

/****************************************
 *                                      *
 *        ERC721 IMPLEMENTATION         *
 *                                      *
 ****************************************/

contract MintibleOwnership is ERC721, MintibleUtility {

    struct AccountItem {
        uint64  categoryId;
        uint128 latestActionTime;
        uint64  lastModifiedNonce;
        address owner;
    }

    struct ShopItem {
        uint128  cooldown;
        uint128  price;
        uint64   supply;
        uint16   numberOfOutputs;
        uint8    isDestroyable;
        uint32[] odds;
        uint64[] categoryIds;
    }

    // Marketplace handling
    mapping(address => uint) public marketplaceToValidBlockNumber;

    // id specific mappings
    uint256 public id;
    mapping(uint256 => AccountItem) public idToAccountItem;

    // User address specific mappings
    mapping(address => uint256) public numberOfItemsOwned;
    mapping(address => uint)    public balances;

    // Category Id creator
    uint64 public categoryId;
    mapping(uint64 => ShopItem) public categoryIdToItem;
    mapping(uint64 => address)  public categoryIdCreator;

    // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
    // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;

    // Mapping from token ID to approved address
    mapping(uint256 => address) internal tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) internal operatorApprovals;

    /**
     * @dev Guarantees msg.sender is owner of the given token
     * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
     */
    modifier onlyOwnerOf(uint256 _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }

    /**
     * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
     * @param _tokenId uint256 ID of the token to validate
     */
    modifier canTransfer(uint256 _tokenId) {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }

    /**
     * @dev Gets the balance of the specified address
     * @param _owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0));
        return numberOfItemsOwned[owner];
    }

    /**
     * @dev Gets the owner of the specified token ID
     * @param _tokenId uint256 ID of the token to query the owner of
     * @return owner address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = idToAccountItem[_tokenId].owner;
        require(owner != address(0));
        return owner;
    }

    /**
     * @dev Returns whether the specified token exists
     * @param _tokenId uint256 ID of the token to query the existence of
     * @return whether the token exists
     */
    function exists(uint256 _tokenId) public view returns (bool) {
        address owner = idToAccountItem[_tokenId].owner;
        return owner != address(0);
    }

    /**
     * @dev Approves another address to transfer the given token ID
     * @dev The zero address indicates there is no approved address.
     * @dev There can only be one approved address per token at a given time.
     * @dev Can only be called by the token owner or an approved operator.
     * @param _to address to be approved for the given token ID
     * @param _tokenId uint256 ID of the token to be approved
     */
    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        if (getApproved(_tokenId) != address(0) || _to != address(0)) {
            tokenApprovals[_tokenId] = _to;
            emit Approval(owner, _to, _tokenId);
        }
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * @param _tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * @dev An operator is allowed to transfer all tokens of the sender on their behalf
     * @param _to operator address to set the approval
     * @param _approved representing the status of the approval to be set
     */
    function setApprovalForAll(address _to, bool _approved) public {
        require(_to != msg.sender);
        operatorApprovals[msg.sender][_to] = _approved;
        emit ApprovalForAll(msg.sender, _to, _approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param _owner owner address which you want to query the approval of
     * @param _operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * @dev Requires the msg sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
    */
    function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) notPaused {
        require(_from != address(0));
        require(_to != address(0));

        idToAccountItem[_tokenId].lastModifiedNonce = idToAccountItem[_tokenId].lastModifiedNonce.add(1);

        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);

        emit Transfer(_from, _to, _tokenId);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * @dev If the target address is a contract, it must implement `onERC721Received`,
     *  which is called upon a safe transfer, and return the magic value
     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
     *  the transfer is reverted.
     * @dev Requires the msg sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
    */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
    public
    canTransfer(_tokenId)
    notPaused
    {
        // solium-disable-next-line arg-overflow
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * @dev If the target address is a contract, it must implement `onERC721Received`,
     *  which is called upon a safe transfer, and return the magic value
     *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
     *  the transfer is reverted.
     * @dev Requires the msg sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes _data
    )
    public
    canTransfer(_tokenId)
    notPaused
    {
        transferFrom(_from, _to, _tokenId);
        // solium-disable-next-line arg-overflow
        require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID
     * @param _spender address of the spender to query
     * @param _tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     *  is an operator of the owner, or is the owner of the token
     * NB: We allow the this contract in all cases, since any action on that contract requires a user signature
     */
    function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
        address owner = ownerOf(_tokenId);
        bool isApproved = block.number > marketplaceToValidBlockNumber[_spender] && marketplaceToValidBlockNumber[_spender] > 0;
        return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender) || isApproved;
    }

    /**
     * @dev Internal function to mint a new token
     * @dev Reverts if the given token ID already exists
     * @param _to The address that will own the minted token
     * @param _tokenId uint256 ID of the token to be minted by the msg.sender
     */
    function _mint(address _to, uint256 _tokenId) internal {
        require(_to != address(0));
        addTokenTo(_to, _tokenId);
        emit Transfer(address(0), _to, _tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * @dev Reverts if the token does not exist
     * @param _tokenId uint256 ID of the token being burned by the msg.sender
     */
    function _burn(address _owner, uint256 _tokenId) internal {
        clearApproval(_owner, _tokenId);
        removeTokenFrom(_owner, _tokenId);
        emit Transfer(_owner, address(0), _tokenId);
    }

    /**
     * @dev Internal function to clear current approval of a given token ID
     * @dev Reverts if the given address is not indeed the owner of the token
     * @param _owner owner of the token
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function clearApproval(address _owner, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _owner);
        if (tokenApprovals[_tokenId] != address(0)) {
            tokenApprovals[_tokenId] = address(0);
            emit Approval(_owner, address(0), _tokenId);
        }
    }

    /**
     * @dev Internal function to add a token ID to the list of a given address
     * @param _to address representing the new owner of the given token ID
     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function addTokenTo(address _to, uint256 _tokenId) internal {
        require(idToAccountItem[_tokenId].owner == address(0));
        idToAccountItem[_tokenId].owner = _to;
        numberOfItemsOwned[_to] = numberOfItemsOwned[_to].add(1);
    }

    /**
     * @dev Internal function to remove a token ID from the list of a given address
     * @param _from address representing the previous owner of the given token ID
     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from);
        numberOfItemsOwned[_from] = numberOfItemsOwned[_from].sub(1);
        idToAccountItem[_tokenId].owner = address(0);
    }

    /**
     * @dev Internal function to invoke `onERC721Received` on a target address
     * @dev The call is not executed if the target address is not a contract
     * @param _from address representing the previous owner of the given token ID
     * @param _to target address that will receive the tokens
     * @param _tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return whether the call correctly returned the expected magic value
     */
    function checkAndCallSafeTransfer(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes _data
    )
    internal
    returns (bool)
    {
        if (!_to.isContract()) {
            return true;
        }
        bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
        return (retval == ERC721_RECEIVED);
    }
}

contract Mintible is MintibleOwnership {

    event Create(uint256[] flattenedMetadata, uint128[] prices, uint64[] supplies, uint64 firstCategoryId, uint128[] localShopItemIds);
    event Buy(uint64 categoryId, uint256[] itemIds, address buyerAddress, uint256 totalPaid, uint256 fee);
    event Withdraw(address user, uint256 amount);
    event ActionResult(uint256 id, uint256[] newIds, uint64[] newCategoryIds, uint256 lastActionTime);

    /*
     * @dev Sets `id` and `categoryId` to 1, since we want 0 as the invalid value
     */
    constructor(address _marketplace) public {
        marketplaceToValidBlockNumber[_marketplace] = block.number;
        categoryId++;
        id++;
    }

    /*
     * @dev Sets the contract `pause` boolean
     */
    function setPaused(bool _isPaused) public onlyOwner {
        paused = _isPaused;
    }

    /*
     * @dev Sets `_marketplace` to valid at block number `_blockNumber`
     */
    function setMarketplace(address _marketplace, uint _blockNumber) public onlyOwner {
        marketplaceToValidBlockNumber[_marketplace] = _blockNumber;
    }

    /*
     * @dev Creates a tree-like structure of categoryIds that are linked through their actions
     * Also defines prices and supplies for those put for sale directly
     */
    function create(uint256[] _creationData, uint128[] _prices, uint64[] _supplies, uint128[] _localShopItemIds) external notPaused {

        // Validate Supply and Prices
        require(_prices.length > 0 && _prices.length == _supplies.length);

        // Index in data array
        uint64 indexOffset = categoryId;

        uint256 j = 0;
        for (uint64 i = indexOffset; i < indexOffset.add(uint64(_prices.length)); i++) {

            _create(i, _prices[i.sub(indexOffset)], _supplies[i.sub(indexOffset)]);

            if (_creationData[j] > 0) {
                _handleData(_creationData, i, j, indexOffset, _prices.length);
                j = j.add(4).add(_creationData[j].mul(2));
            } else {
                j = j.add(1);
            }
        }

        emit Create(_creationData, _prices, _supplies, indexOffset, _localShopItemIds);
    }

    /*
     * @dev Creates a new item and sets price and supply if necessary
     */
    function _create(uint64 _categoryId, uint128 _price, uint64 _supply) private {

        categoryIdCreator[_categoryId] = msg.sender;

        if (_supply != 0) {
            categoryIdToItem[_categoryId].supply = _supply;
            categoryIdToItem[_categoryId].price = _price;
        }

        categoryId++;
    }

    /*
     * @dev Creates the action data and validates it
     */
    function _handleData(uint256[] _creationData, uint64 _i, uint256 _j, uint64 _indexOffset, uint256 _length) private {
        uint32[] memory odds        = getUint32SubArray(_creationData, _j.add(1), _j.add(1).add(_creationData[_j]));
        uint64[] memory categoryIds = getUint64SubArray(_creationData, _j.add(1).add(_creationData[_j]), _j.add(1).add(_creationData[_j].mul(2)));

        _validateData(odds, categoryIds, _length);

        for (uint256 k = 0; k < categoryIds.length; k++) {
            categoryIds[k] = categoryIds[k].add(_indexOffset);
        }

        categoryIdToItem[_i].cooldown        = uint128(_creationData[_j.add(3).add(_creationData[_j].mul(2))]);
        categoryIdToItem[_i].numberOfOutputs = uint16(_creationData[_j.add(2).add(_creationData[_j].mul(2))]);
        categoryIdToItem[_i].isDestroyable   = uint8(_creationData[_j.add(1).add(_creationData[_j].mul(2))]);
        categoryIdToItem[_i].odds            = odds;
        categoryIdToItem[_i].categoryIds     = categoryIds;
    }

    /*
     * @dev Validates that the action data is valid
     */
    function _validateData(uint32[] _odds, uint64[] _categoryIds, uint256 _length) private pure {

        // Validate length
        require(_odds.length == _categoryIds.length);

        // Validate id in range
        for (uint256 i = 0; i < _categoryIds.length; i++) {
            require(_categoryIds[i] <= _length);
        }

        // Validate Odds
        require(_odds[0] > 0);
        for (uint256 j = 0; j < _odds.length.sub(1); j++) {
            require(_odds[j] < _odds[j + 1]);
        }
    }

    /*
     * @dev This function can be called by anyone to buy `_amount` of `_categoryId` if there is enough supply left
     */
    function buy(uint64 _categoryId, uint64 _amount) external payable notPaused {
        require(_categoryId > 0 && _categoryId < categoryId);
        require(_amount > 0);

        require(categoryIdToItem[_categoryId].supply >= _amount);
        require(categoryIdToItem[_categoryId].price.mul(uint128(_amount)) == msg.value);

        categoryIdToItem[_categoryId].supply = categoryIdToItem[_categoryId].supply.sub(_amount);

        uint256[] memory itemIds = new uint[](_amount);
        for (uint64 i = 0; i < _amount; i++) {
            idToAccountItem[id].categoryId = _categoryId;
            _mint(msg.sender, id);

            itemIds[i] = id;
            id++;
        }

        uint256 totalPaid = msg.value;

        // 3.5% fee
        uint256 fee = totalPaid.mul(35 finney) / 1 ether;

        uint256 netPaid = totalPaid.sub(fee);

        balances[categoryIdCreator[_categoryId]] = balances[categoryIdCreator[_categoryId]].add(netPaid);
        balances[owner] = balances[owner].add(fee);

        emit Buy(_categoryId, itemIds, msg.sender, totalPaid, fee);
    }

    /*
     * @dev This function is called on an item and does what its shopItem is defined to do
     *      It can generate new items and it can also destroy itself in the process
     *      In order to be called, the `cooldown` must be satisfied. All items start with no cooldown
     *
     */
    function action(uint256 _id) external notPaused {
        AccountItem storage accountItem = idToAccountItem[_id];

        require(accountItem.owner == msg.sender);

        ShopItem storage shopItem = categoryIdToItem[accountItem.categoryId];

        // This is simply verifying that calling an action on the item makes sense
        require(shopItem.odds.length > 0);

        // Verify that the cooldown is satisfied
        require(accountItem.latestActionTime == 0 || now.sub(accountItem.latestActionTime) > shopItem.cooldown);
        // Refresh cooldown
        accountItem.latestActionTime = uint128(now);
        accountItem.lastModifiedNonce = accountItem.lastModifiedNonce.add(1);

        uint32[] memory odds = shopItem.odds;
        uint64[] memory categoryIds = shopItem.categoryIds;

        uint256[] memory newIds = new uint256[](shopItem.numberOfOutputs);
        uint64[] memory newCategoryIds = new uint64[](shopItem.numberOfOutputs);

        // shopItem[2*len+1] is the number of items returned
        for (uint256 i = 0; i < shopItem.numberOfOutputs; i++) {
            uint32 randomValue = rand(0, odds[odds.length.sub(1)]);

            uint256 index = getIndexFromOdd(randomValue, odds);

            idToAccountItem[id].categoryId = categoryIds[index];
            _mint(msg.sender, id);

            newIds[i] = id;
            newCategoryIds[i] = categoryIds[index];

            id++;
        }

        // Destroy item if necessary
        if (shopItem.isDestroyable == 1) {
            // Destroy _id
            _burn(msg.sender, _id);
        }

        emit ActionResult(_id, newIds, newCategoryIds, accountItem.latestActionTime);
    }

    /*
     * @dev Function to allow `msg.sender` to withdraw `_amount` of money from his balance
     * Balance is build from fees on buy and on trades on the marketplace
     */
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        msg.sender.transfer(_amount);

        emit Withdraw(msg.sender, _amount);
    }

    /*
     * Below is the implementation of the Mintible Interface
     */


    /*
     * @dev pays `msg.value` to the creator of categoryId related to `_id`
     */
    function payFee(uint256 _id) public payable {
        address creator = categoryIdCreator[idToAccountItem[_id].categoryId];
        balances[creator] = balances[creator].add(msg.value);
    }

    /*
     * @dev This is to keep track of the state of the item. If anything is executed on the item, this nonce
     * ensures that it represents the latest state
     */
    function getLastModifiedNonce(uint256 _id) public view returns (uint) {
        return idToAccountItem[_id].lastModifiedNonce;
    }

    /**
     * Functionality Accessors
     */
    function getCategoryId() public view returns (uint) {
        return categoryId;
    }

    function getNumberOfOdds(uint64 _categoryId) public view returns (uint) {
        return categoryIdToItem[_categoryId].odds.length;
    }

    function getOddValue(uint64 _categoryId, uint256 _i) public view returns (uint) {
        return categoryIdToItem[_categoryId].odds[_i];
    }

    function getNumberOfCategoryIds(uint64 _categoryId) public view returns (uint) {
        return categoryIdToItem[_categoryId].categoryIds.length;
    }

    function getCategoryIdsValue(uint64 _categoryId, uint256 _i) public view returns (uint) {
        return categoryIdToItem[_categoryId].categoryIds[_i];
    }
}