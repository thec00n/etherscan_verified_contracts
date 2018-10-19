pragma solidity ^0.4.24;

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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

// File: openzeppelin-solidity/contracts/AddressUtils.sol

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
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(addr) }
    return size > 0;
  }

}

// File: contracts/pricing/CvcPricingInterface.sol

/**
 * @title CvcPricingInterface
 * @dev This contract defines the pricing service interface.
 */
contract CvcPricingInterface {

    /**
    * @dev Returns the price by Credential Item ID.
    * @param _idv IDV address.
    * @param _credentialItemId Credential Item ID.
    * @return bytes32 Price ID.
    * @return uint256 Price value.
    * @return address IDV address.
    * @return string Credential Item type.
    * @return string Credential Item name.
    * @return string Credential Item version.
    */
    function getPriceByCredentialItemId(
        address _idv,
        bytes32 _credentialItemId
        ) external view returns (
            bytes32 id,
            uint256 price,
            address idv,
            string credentialItemType,
            string credentialItemName,
            string credentialItemVersion,
            bool deprecated
        );
}

// File: contracts/escrow/CvcEscrowInterface.sol

/**
 * @title CvcEscrowInterface
 * @dev This contract defines the escrow service interface.
 */
contract CvcEscrowInterface {

    /// Describes all possible states of the escrow placement:
    /// Empty - the placement with specific ID is unknown to the contract. i.e. was never placed.
    /// Placed - the placement is active, pending to be released or canceled.
    /// Released - the placement has been released and Identity Validator received payment.
    /// Canceled - the placement has been canceled and Identity Requester got refund, no payment was made to Identity Validator.
    enum PlacementState {Empty, Placed, Released, Canceled}

    /**
    * @dev The EscrowPlaced event is emitted when the placement is made and the corresponding amount of tokens
    * transferred from Identity Requester account to the escrow account.
    * The event is emitted individually for each placement item with unique scope request ID.
    *
    * @param idr ID Requester address.
    * @param idv Identity Validator address.
    * @param scopeRequestId Scope request identifier.
    * @param amount CVC token amount in creds (CVC x 10e-8).
    * @param credentialItemIds Array of credential item IDs.
    * @param placementId Escrow Placement Identifier
    */
    event EscrowPlaced(
        address indexed idr,
        address indexed idv,
        bytes32 indexed scopeRequestId,
        uint256 amount,
        bytes32[] credentialItemIds,
        bytes32 placementId
    );

    /**
    * @dev The EscrowMoved event is emitted for each placement item with unique scope request ID kept in escrow upon
    * placement partial release. It contains the old and new placement ID to track placement item lifecycle.
    * The placement ID from the latest EscrowMoved event effectively points to the active placement containing
    * specific scope request ID.
    *
    * @param idr ID Requester address.
    * @param idv Identity Validator address.
    * @param scopeRequestId Scope request identifier.
    * @param amount CVC token amount in creds (CVC x 10e-8).
    * @param credentialItemIds Array of credential item IDs.
    * @param oldPlacementId Escrow Placement Identifier of the partially released placement.
    * @param placementId Escrow Placement Identifier of new placement.
    */
    event EscrowMoved(
        address indexed idr,
        address indexed idv,
        bytes32 indexed scopeRequestId,
        uint256 amount,
        bytes32[] credentialItemIds,
        bytes32 oldPlacementId,
        bytes32 placementId
    );

    /**
    * @dev The EscrowReleased event is emitted when the placement is released and the corresponding amount of tokens
    * transferred from escrow account to Identity Validator account.
    * The event is emitted individually for each placement item with unique scope request ID.
    *
    * @param idr ID Requester address.
    * @param idv Identity Validator address.
    * @param scopeRequestId Scope request identifier.
    * @param platformFee CVC token amount transferred to the marketplace maintainer account as service fee.
    * @param idvFee CVC token amount transferred to the Identity Validator account.
    * @param credentialItemIds Array of credential item IDs.
    * @param placementId Escrow Placement Identifier
    */
    event EscrowReleased(
        address indexed idr,
        address indexed idv,
        bytes32 indexed scopeRequestId,
        uint256 platformFee,
        uint256 idvFee,
        bytes32[] credentialItemIds,
        bytes32 placementId
    );


    /**
    * @dev The EscrowCanceled event is emitted when the placement is canceled and the corresponding amount of tokens
    * refunded from escrow account to Identity Requester account.
    * The event is emitted individually for each placement item with unique scope request ID.
    *
    * @param idr ID Requester address.
    * @param idv Identity Validator address.
    * @param scopeRequestId Scope request identifier.
    * @param amount CVC token amount in creds (CVC x 10e-8) refunded to Identity Requester.
    * @param credentialItemIds Array of credential item IDs.
    * @param placementId Escrow Placement Identifier
    */
    event EscrowCanceled(
        address indexed idr,
        address indexed idv,
        bytes32 indexed scopeRequestId,
        uint256 amount,
        bytes32[] credentialItemIds,
        bytes32 placementId
    );

    /**
    * @dev Handles escrow placement for a single scope request.
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @return bytes32 New Placement ID
    */
    function place(address _idv, bytes32 _scopeRequestId, uint256 _amount, bytes32[] _credentialItemIds)
        external
        returns (bytes32);

    /**
    * @dev Handles escrow placement for multiple scope requests grouped by credential item IDs.
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @return bytes32 New Placement ID
    */
    function placeBatch(address _idv, bytes32[] _scopeRequestIds, uint256 _amount, bytes32[] _credentialItemIds)
        external
        returns (bytes32);

    /**
    * @dev Releases escrow placement for a single scope request and distributes funds.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    */
    function release(address _idr, address _idv, bytes32 _scopeRequestId) external;

    /**
    * @dev Releases escrow placement for multiple scope requests and distributes funds.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIdsToRelease Array of scope request IDs which will be released
    * @param _scopeRequestIdsToKeep Array of scope request IDs which will be kept in escrow
    * @return bytes32 Placement ID of remaining part of the batch. Empty when the placement was fully released
    */
    function releaseBatch(
        address _idr,
        address _idv,
        bytes32[] _scopeRequestIdsToRelease,
        bytes32[] _scopeRequestIdsToKeep
    )
        external
        returns (bytes32);

    /**
    * @dev Refunds escrowed tokens for a single scope request back to Identity Requester.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    */
    function refund(address _idr, address _idv, bytes32 _scopeRequestId) external;


    /**
    * @dev Refunds escrowed tokens for multiple scope requests back to Identity Requester.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    */
    function refundBatch(address _idr, address _idv, bytes32[] _scopeRequestIds) external;

    /**
    * @dev Returns placement details.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values.
    * @return bytes32[] Array of credential item IDs.
    * @return uint256 Block confirmations since escrow was placed.
    * @return bool True if placement can be refunded otherwise false
    */
    function verify(address _idr, address _idv, bytes32 _scopeRequestId)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        );

    /**
    * @dev Returns placement details.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values.
    * @return bytes32[] Array of credential item IDs.
    * @return uint256 Block confirmations since escrow was placed.
    * @return bool True if placement can be refunded otherwise false
    */
    function verifyBatch(address _idr, address _idv, bytes32[] _scopeRequestIds)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        );


    /**
    * @dev Returns placement details.
    * @param _placementId Escrow Placement identifier.
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values.
    * @return bytes32[] Array of credential item IDs.
    * @return uint256 Block confirmations since escrow was placed.
    * @return bool True if placement can be refunded otherwise false
    */
    function verifyPlacement(bytes32 _placementId)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        );


    /**
    * @dev Calculates escrow placement identifier.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds An array of scope request identifiers
    * @return bytes32 Placement ID
    */
    function calculatePlacementId(address _idr, address _idv, bytes32[] _scopeRequestIds)
        public
        pure
        returns (bytes32);

}

// File: contracts/upgradeability/EternalStorage.sol

/**
 * @title EternalStorage
 * @dev This contract defines the generic storage structure
 * so that it could be re-used to implement any domain specific storage functionality
 */
contract EternalStorage {

    mapping(bytes32 => uint256) internal uintStorage;
    mapping(bytes32 => string) internal stringStorage;
    mapping(bytes32 => address) internal addressStorage;
    mapping(bytes32 => bytes) internal bytesStorage;
    mapping(bytes32 => bool) internal boolStorage;
    mapping(bytes32 => int256) internal intStorage;
    mapping(bytes32 => bytes32) internal bytes32Storage;

}

// File: contracts/upgradeability/ImplementationStorage.sol

/**
 * @title ImplementationStorage
 * @dev This contract stores proxy implementation address.
 */
contract ImplementationStorage {

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "cvc.proxy.implementation", and is validated in the constructor.
     */
    bytes32 internal constant IMPLEMENTATION_SLOT = 0xa490aab0d89837371982f93f57ffd20c47991f88066ef92475bc8233036969bb;

    /**
    * @dev Constructor
    */
    constructor() public {
        assert(IMPLEMENTATION_SLOT == keccak256("cvc.proxy.implementation"));
    }

    /**
     * @dev Returns the current implementation.
     * @return Address of the current implementation
     */
    function implementation() public view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }
}

// File: contracts/upgradeability/Initializable.sol

/**
 * @title Initializable
 * @dev This contract provides basic initialization control
 */
contract Initializable is EternalStorage, ImplementationStorage {

    /**
    Data structures and storage layout:
    mapping(bytes32 => bool) initialized;
    **/

    /**
     * @dev Throws if called before contract was initialized.
     */
    modifier onlyInitialized() {
        // require(initialized[implementation()]);
        require(boolStorage[keccak256(abi.encodePacked(implementation(), "initialized"))], "Contract is not initialized");
        _;
    }

    /**
     * @dev Controls the initialization state, allowing to call an initialization function only once.
     */
    modifier initializes() {
        address impl = implementation();
        // require(!initialized[implementation()]);
        require(!boolStorage[keccak256(abi.encodePacked(impl, "initialized"))], "Contract is already initialized");
        _;
        // initialized[implementation()] = true;
        boolStorage[keccak256(abi.encodePacked(impl, "initialized"))] = true;
    }
}

// File: contracts/upgradeability/Ownable.sol

/**
 * @title Ownable
 * @dev This contract has an owner address providing basic authorization control
 */
contract Ownable is EternalStorage {

    /**
    Data structures and storage layout:
    address owner;
    **/

    /**
     * @dev Event to show ownership has been transferred
     * @param previousOwner representing the address of the previous owner
     * @param newOwner representing the address of the new owner
     */
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner(), "Message sender must be contract admin");
        _;
    }

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function owner() public view returns (address) {
        // return owner;
        return addressStorage[keccak256("owner")];
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner the address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Contract owner cannot be zero address");
        setOwner(newOwner);
    }

    /**
     * @dev Sets a new owner address
     */
    function setOwner(address newOwner) internal {
        emit OwnershipTransferred(owner(), newOwner);
        // owner = newOwner;
        addressStorage[keccak256("owner")] = newOwner;
    }
}

// File: contracts/upgradeability/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable, ImplementationStorage {

    /**
    Data structures and storage layout:
    mapping(bytes32 => bool) paused;
    **/

    event Pause();
    event Unpause();

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused(), "Contract is paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused(), "Contract must be paused");
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyOwner whenNotPaused {
        // paused[implementation()] = true;
        boolStorage[keccak256(abi.encodePacked(implementation(), "paused"))] = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyOwner whenPaused {
        // paused[implementation()] = false;
        boolStorage[keccak256(abi.encodePacked(implementation(), "paused"))] = false;
        emit Unpause();
    }

    /**
     * @dev Returns true when the contract is paused.
     * @return bool
     */
    function paused() public view returns (bool) {
        // return paused[implementation()];
        return boolStorage[keccak256(abi.encodePacked(implementation(), "paused"))];
    }
}

// File: contracts/escrow/CvcEscrow.sol

/**
 * @title CvcEscrow
 * @dev This contract provides escrow service functionality for the Identity.com marketplace.
 * It controls an escrow placement's lifecycle which involves transferring a pre-approved amount funds
 * from the Identity Requester account to its own account and keeping them until the marketplace deal is complete.
 *
 * Glossary:
 * Identity Requester (IDR) - Business entities requesting verifiable Credentials from a user in order to authenticate them.
 * Identity Validator (IDV) - Businesses or organizations that validate a user's identity and provide verifiable credentials.
 * Scope Request            - A request for identity information about a user from an IDR to an IDV.
 * Credential Item          - A single item in a set of verifiable credentials that an IDR can specify within a scope request.
 *
 * The marketplace flow has 2 possible outcomes:
 * 1. release - when user's personally identifiable information (PII) has been delivered to Identity Requester.
 *     In this case the release functionality is triggered and the contract transfers escrowed funds
 *     to the Identity Validator account, excluding the marketplace fee (if applied).
 *
 * 2. cancellation - when user's personally identifiable information (PII) has NOT been delivered to Identity Requester.
 *     In this case the refund procedure can be executed and all the escrowed funds will be returned
 *     back to Identity Requester account.
 *
 * The escrow contract depends on other marketplace contracts, such as:
 * CvcToken - to perform CVC transfers.
 * CvcPricing - to check the actual marketplace prices and ensure that placed amount of tokens
 *                covers the Credential Items price and matches the expectation of all involved parties.
 */
contract CvcEscrow is EternalStorage, Initializable, Pausable, CvcEscrowInterface {

    using SafeMath for uint256;

    /**
    Data structures and storage layout:
    struct EscrowPlacement {
        uint256 state;
        uint256 amount;
        uint256 credentialItemIdsCount;
        bytes32[] credentialItemIds;
        uint256 blockNumber;
    }
    uint256 timeoutThreshold;
    uint256 platformFeeRate;
    address cvcToken;
    address cvcPricing;
    address platform;
    mapping(bytes32 => EscrowPlacement) placements;
    **/

    /// The divisor for calculating platform fee rate.
    /// Solidity does not support floats,
    /// so we provide rather big unsigned integer and then divide it by this constant
    uint256 constant public RATE_PRECISION = 1e8;

    /**
    * @dev Constructor
    * @param _token CVC Token contract address
    * @param _platform Platform address to send retained fee to
    * @param _pricing Pricing contract address to lookup for escrow amount before placing
    */
    constructor(address _token, address _platform, address _pricing) public {
        initialize(_token, _platform, _pricing, msg.sender);
    }

    /**
    * @dev Handles escrow placement for a single scope request.
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @return bytes32 New Placement ID
    */
    function place(
        address _idv,
        bytes32 _scopeRequestId,
        uint256 _amount,
        bytes32[] _credentialItemIds
    )
        external
        onlyInitialized
        whenNotPaused
        returns (bytes32)
    {
        // Prepare a batch with single scope request ID.
        bytes32[] memory scopeRequestIds = new bytes32[](1);
        scopeRequestIds[0] = _scopeRequestId;

        return makePlacement(_idv, scopeRequestIds, _amount, _credentialItemIds);
    }

    /**
    * @dev Handles escrow placement for multiple scope requests grouped by credential item IDs.
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @return bytes32 New Placement ID
    */
    function placeBatch(address _idv, bytes32[] _scopeRequestIds, uint256 _amount, bytes32[] _credentialItemIds)
        external
        onlyInitialized
        whenNotPaused
        returns (bytes32)
    {
        return makePlacement(_idv, _scopeRequestIds, _amount, _credentialItemIds);
    }

    /**
    * @dev Releases escrow placement and distributes funds.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request identifier
    */
    function release(address _idr, address _idv, bytes32 _scopeRequestId)
        external
        onlyOwner
        onlyInitialized
        whenNotPaused
    {
        // Prepare a batch with single scope request ID.
        bytes32[] memory scopeRequestIdsToRelease = new bytes32[](1);
        scopeRequestIdsToRelease[0] = _scopeRequestId;

        // itemsToKeep is empty to indicate full release.
        makePartialRelease(_idr, _idv, scopeRequestIdsToRelease, new bytes32[](0));
    }


    /**
    * @dev Releases escrow placement for multiple scope requests and distributes funds.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIdsToRelease Array of scope request IDs which will be released
    * @param _scopeRequestIdsToKeep Array of scope request IDs which will be kept in escrow
    * @return bytes32 Placement ID of remaining part of the batch. Empty when the placement was fully released
    */
    function releaseBatch(
        address _idr,
        address _idv,
        bytes32[] _scopeRequestIdsToRelease,
        bytes32[] _scopeRequestIdsToKeep
    )
        external
        onlyOwner
        onlyInitialized
        whenNotPaused
        returns (bytes32)
    {
        return makePartialRelease(_idr, _idv, _scopeRequestIdsToRelease, _scopeRequestIdsToKeep);
    }

    /**
    * @dev Refunds escrowed tokens for a single scope request back to Identity Requester.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request ID
    */
    function refund(address _idr, address _idv, bytes32 _scopeRequestId) external onlyInitialized whenNotPaused {
        // Prepare a batch with single scope request ID.
        bytes32[] memory scopeRequestIds = new bytes32[](1);
        scopeRequestIds[0] = _scopeRequestId;
        makeFullRefund(_idr, _idv, scopeRequestIds);
    }


    /**
    * @dev Refunds escrowed tokens for for multiple scope requests back to Identity Requester.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    */
    function refundBatch(address _idr, address _idv, bytes32[] _scopeRequestIds)
        external
        onlyInitialized
        whenNotPaused
    {
        makeFullRefund(_idr, _idv, _scopeRequestIds);
    }

    /**
    * @dev Returns placement details.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestId Scope request ID
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values
    * @return bytes32[] Array of credential item IDs
    * @return uint256 Block confirmations since escrow was placed
    * @return bool True if placement can be refunded otherwise false
    */
    function verify(address _idr, address _idv, bytes32 _scopeRequestId)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        )
    {
        // Prepare a batch with single scope request ID.
        bytes32[] memory scopeRequestIds = new bytes32[](1);
        scopeRequestIds[0] = _scopeRequestId;

        return getPlacement(calculatePlacementId(_idr, _idv, scopeRequestIds));
    }

    /**
    * @dev Returns placement details.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values
    * @return bytes32[] Array of credential item IDs
    * @return uint256 Block confirmations since escrow was placed
    * @return bool True if placement can be refunded otherwise false
    */
    function verifyBatch(address _idr, address _idv, bytes32[] _scopeRequestIds)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        )
    {
        return getPlacement(calculatePlacementId(_idr, _idv, _scopeRequestIds));
    }

    /**
    * @dev Returns placement details.
    * @param _placementId Escrow Placement identifier.
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values.
    * @return bytes32[] Array of credential item IDs.
    * @return uint256 Block confirmations since escrow was placed.
    * @return bool True if placement can be refunded otherwise false
    */
    function verifyPlacement(bytes32 _placementId)
        external
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        )
    {
        return getPlacement(_placementId);
    }

    /**
    * @dev Contract initialization method.
    * @param _token CVC Token contract address
    * @param _platform Platform address to send retained fee to
    * @param _pricing Pricing contract address to lookup for escrow amount before placing
    * @param _owner Owner address, used for release
    */
    function initialize(address _token, address _platform, address _pricing, address _owner)
        public
        initializes
    {
        // Ensure contracts.
        require(AddressUtils.isContract(_token), "Initialization error: no contract code at token contract address");
        require(AddressUtils.isContract(_pricing), "Initialization error: no contract code at pricing contract address");

        /// Timeout value for escrowed funds before refund is available.
        /// Currently represents number of blocks for approx 24 hours.
        // timeoutThreshold = 5800;
        uintStorage[keccak256("timeout.threshold")] = 5800;
        /// The percentage of escrowed funds retained as a platform fee.
        /// The default rate is 10% (0.1 * 10^8).
        // platformFeeRate = 1e7;
        uintStorage[keccak256("platform.fee.rate")] = 1e7;
        // Initialize current implementation owner address.
        setOwner(_owner);
        // CVC Token contract address to transfer CVC tokens.
        // cvcToken = _token;
        addressStorage[keccak256("cvc.token")] = _token;
        // Pricing contract address to lookup attestation prices.
        // cvcPricing = _pricing;
        addressStorage[keccak256("cvc.pricing")] = _pricing;
        // Platform address is used to transfer platform usage fee.
        // platform = _platform;
        addressStorage[keccak256("platform")] = _platform;
    }

    /**
    * @dev Calculates escrow placement identifier.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds An array of scope request identifiers
    * @return bytes32 Placement ID
    */
    function calculatePlacementId(address _idr, address _idv, bytes32[] _scopeRequestIds)
        public
        pure
        returns (bytes32)
    {
        require(_idr != address(0), "Cannot calculate placement ID with IDR being a zero address");
        require(_idv != address(0), "Cannot calculate placement ID with IDV being a zero address");

        return keccak256(abi.encodePacked(_idr, _idv, calculateBatchReference(_scopeRequestIds)));
    }

    /**
    * @dev Returns platform fee amount based on given placement amount and current platform fee rate.
    * @param _amount Escrow placement total amount.
    * @return uint256
    */
    function calculatePlatformFee(uint256 _amount) public view returns (uint256) {
        return (_amount.mul(platformFeeRate()).add(RATE_PRECISION.div(2))).div(RATE_PRECISION);
    }

    /**
    * @dev Sets timeout threshold. Ensures it's more than 0.
    * @param _threshold New timeout threshold value
    */
    function setTimeoutThreshold(uint256 _threshold) public onlyOwner onlyInitialized {
        require(_threshold > 0, "Timeout threshold cannot be zero");
        // timeoutThreshold = _threshold;
        uintStorage[keccak256("timeout.threshold")] = _threshold;
    }

    /**
    * @dev Returns actual escrow timeout threshold value.
    * @return uint256
    */
    function timeoutThreshold() public view returns (uint256) {
        // return timeoutThreshold;
        return uintStorage[keccak256("timeout.threshold")];
    }

    /**
    * @dev Allows to change platform fee rate.
    * @param _feeRate A platform fee rate in percentage, e.g. 1e7 (10%).
    */
    function setFeeRate(uint256 _feeRate) public onlyOwner onlyInitialized {
        require(_feeRate <= RATE_PRECISION, "Platform fee rate cannot be more than 100%");
        // platformFeeRate = _feeRate;
        uintStorage[keccak256("platform.fee.rate")] = _feeRate;
    }

    /**
    * @dev Returns actual platform fee rate value.
    * @return uint256
    */
    function platformFeeRate() public view returns (uint256) {
        // return platformFeeRate;
        return uintStorage[keccak256("platform.fee.rate")];
    }

    /**
    * @dev Returns CvcToken contact instance.
    * @return ERC20
    */
    function token() public view returns (ERC20) {
        // return ERC20(cvcToken);
        return ERC20(addressStorage[keccak256("cvc.token")]);
    }

    /**
    * @dev Returns CvcPricing contact instance.
    * @return CvcPricingInterface
    */
    function pricing() public view returns (CvcPricingInterface) {
        // return CvcPricingInterface(cvcPricing);
        return CvcPricingInterface(addressStorage[keccak256("cvc.pricing")]);
    }

    /**
    * @dev Returns platform address.
    * @return address
    */
    function platformAddress() public view returns (address) {
        // return platform;
        return addressStorage[keccak256("platform")];
    }

    /**
    * @dev Stores placement data against the placement ID.
    * @param _placementId Unique placement identifier
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @param _blockNumber Block number at which the placement is received
    */
    function saveNewPlacement(bytes32 _placementId, uint256 _amount, bytes32[] _credentialItemIds, uint256 _blockNumber)
        internal
    {
        // Verify current state for given placementId to ensure operation is allowed.
        PlacementState placementState = getPlacementState(_placementId);
        // Placement is allowed when:
        //  1. it is a completely new escrow placement with fresh ID (Empty state)
        //  2. the placement with given ID was refunded (Canceled state)
        require(
            placementState == PlacementState.Empty || placementState == PlacementState.Canceled,
            "Invalid placement state: must be new or canceled"
        );

        // Write placement data into the contract storage.
        setPlacementState(_placementId, PlacementState.Placed);
        setPlacementCredentialItemIds(_placementId, _credentialItemIds);
        setPlacementAmount(_placementId, _amount);
        setPlacementBlockNumber(_placementId, _blockNumber);
    }

    /**
    * @dev Returns placement total price based on number of credential items and their current market prices.
    * @param _idv Identity Validator address
    * @param _credentialItemIds Array of credential item IDs
    * @param _batchSize Number of scope request IDs in placement
    * @return uint256
    */
    function getPlacementPrice(address _idv, bytes32[] _credentialItemIds, uint256 _batchSize)
        internal
        view
        returns (uint256)
    {
        uint256 price = 0;
        uint256 credentialItemPrice;
        CvcPricingInterface cvcPricing = pricing();
        for (uint256 i = 0; i < _credentialItemIds.length; i++) {
            (




            , credentialItemPrice, , , , ,) = cvcPricing.getPriceByCredentialItemId(_idv, _credentialItemIds[i]);
            price = price.add(credentialItemPrice);
        }
        return price.mul(_batchSize);
    }

    /**
    * @dev Check if the escrow placement can be refunded back to Identity Requester.
    * @param _placementState The escrow placement state.
    * @param _placementBlockNumber The escrow placement block number.
    * @return bool Whether escrow can be refunded.
    */
    function isRefundable(PlacementState _placementState, uint256 _placementBlockNumber) internal view returns (bool) {
        // Refund is allowed if the escrowed placement is still in "Placed" state & timeout is reached.
        // Timeout reached when number of blocks after the escrow was placed is greater than timeout threshold.
        return _placementState == PlacementState.Placed && block.number.sub(_placementBlockNumber) > timeoutThreshold();
    }

    /**
    * @dev Transfers funds from IRD account and stores the placement data.
    * @param _idv Address of Identity Validator
    * @param _scopeRequestIds Array of scope request IDs
    * @param _amount CVC token amount in creds (CVC x 10e-8)
    * @param _credentialItemIds Array of credential item IDs
    * @return bytes32 New Placement ID
    */
    function makePlacement(address _idv, bytes32[] _scopeRequestIds, uint256 _amount, bytes32[] _credentialItemIds)
        internal
        returns (bytes32)
    {
        // Calculate placement ID to validate arguments.
        bytes32 placementId = calculatePlacementId(msg.sender, _idv, _scopeRequestIds);

        // Ensure escrow amount is matching the total price of all credential items.
        require(
            _amount == getPlacementPrice(_idv, _credentialItemIds, _scopeRequestIds.length),
            "Placement amount does not match credential item total price"
        );

        // Store new placement data.
        saveNewPlacement(placementId, _amount, _credentialItemIds, block.number);

        // Transferring funds from IDR to escrow contract address.
        require(token().transferFrom(msg.sender, this, _amount), "Token transfer from IDR account failed");

        // Emitting escrow placement event for each individual scope request ID.
        uint256 amountPerItem = _amount.div(_scopeRequestIds.length);
        for (uint256 i = 0; i < _scopeRequestIds.length; i++) {
            emit EscrowPlaced(msg.sender, _idv, _scopeRequestIds[i], amountPerItem, _credentialItemIds, placementId);
        }

        return placementId;
    }

    /**
    * @dev Calculates scope request batch reference.
    * @param _scopeRequestIds An array of scope request identifiers
    * @return bytes32 Batch reference
    */
    function calculateBatchReference(bytes32[] _scopeRequestIds)
        internal
        pure
        returns (bytes32 batchReference)
    {
        // In order to increase batch reference entropy and prevent potential collision
        // caused by small difference between two or more scope request IDs from the same batch
        // we hash the scope request ID before adding to the batch reference.
        for (uint256 i = 0; i < _scopeRequestIds.length; i++) {
            // Ensure scopeRequestId is not empty & add its hash to batch reference.
            require(_scopeRequestIds[i] != 0x0, "Cannot calculate batch reference with empty scope request ID");
            batchReference = batchReference ^ keccak256(abi.encodePacked(_scopeRequestIds[i]));
        }
    }

    /**
    * @dev Releases placed batch items.
    * In case of partial release keeps the remaining part in escrow under new placement ID.
    * If the entire batch is release, empty bytes returned instead.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _itemsToRelease Array of scope request IDs to be released
    * @param _itemsToKeep Array of scope request IDs to keep in escrow
    * @return bytes32 Placement ID of remaining part of the batch. Empty when the placement was fully released
    */
    function makePartialRelease(address _idr, address _idv, bytes32[] _itemsToRelease, bytes32[] _itemsToKeep)
        internal
        returns (bytes32)
    {
        // Restore initial placement ID.
        bytes32 batchReference = calculateBatchReference(_itemsToRelease);
        if (_itemsToKeep.length > 0) {
            batchReference = batchReference ^ calculateBatchReference(_itemsToKeep);
        }
        bytes32 placementId = keccak256(abi.encodePacked(_idr, _idv, batchReference));

        // Allow release only when the escrow exists and it is not refundable yet.
        // If placement found by ID, we can be sure two arrays of scope request IDs together formed the initial batch.
        PlacementState placementState = getPlacementState(placementId);
        require(placementState == PlacementState.Placed, "Invalid placement state: must be placed");
        require(!isRefundable(placementState, getPlacementBlockNumber(placementId)), "Timed out: release is not possible anymore");

        // Change placement state to released.
        setPlacementState(placementId, PlacementState.Released);

        // Calculate released token amount.
        uint256 totalBatchSize = _itemsToRelease.length.add(_itemsToKeep.length);
        uint256 placementAmount = getPlacementAmount(placementId);
        uint256 amountToRelease = placementAmount.mul(_itemsToRelease.length).div(totalBatchSize);

        // Release batch items and distribute escrowed funds.
        releaseEscrowedFunds(placementId, _idr, _idv, _itemsToRelease, amountToRelease);

        // Return empty bytes when the entire batch released.
        if (_itemsToKeep.length == 0)
            return 0x0;

        // Keep the remaining part of the batch in escrow.
        uint256 amountToKeep = placementAmount.mul(_itemsToKeep.length).div(totalBatchSize);
        return keepPlacement(placementId, _idr, _idv, _itemsToKeep, amountToKeep);
    }

    /**
    * @dev Refunds escrowed tokens for for multiple scope requests back to Identity Requester.
    * @param _idr Address of Identity Requester
    * @param _idv Address of Identity Validator
    * @param _itemsToRefund Array of scope request IDs to be refunded
    */
    function makeFullRefund(address _idr, address _idv, bytes32[] _itemsToRefund) internal {
        // Calculate placement ID to validate arguments.
        bytes32 placementId = calculatePlacementId(_idr, _idv, _itemsToRefund);

        // Check if refund is allowed.
        require(
            isRefundable(getPlacementState(placementId), getPlacementBlockNumber(placementId)),
            "Placement is not refundable yet"
        );

        // Mark the escrow placement Canceled.
        setPlacementState(placementId, PlacementState.Canceled);

        // Transfer funds from the escrow contract balance to IDR account.
        uint256 placementAmount = getPlacementAmount(placementId);
        require(token().transfer(_idr, placementAmount), "Token transfer to IDR account failed");

        // Emitting escrow cancellation event for each individual scope request ID.
        uint256 amountPerItem = placementAmount.div(_itemsToRefund.length);
        bytes32[] memory credentialItemIds = getPlacementCredentialItemIds(placementId);
        for (uint256 i = 0; i < _itemsToRefund.length; i++) {
            emit EscrowCanceled(_idr, _idv, _itemsToRefund[i], amountPerItem, credentialItemIds, placementId);
        }
    }

    /**
    * @dev Stores items as a new placement.
    * @param _placementId Current placement identifier.
    * @param _idr Address of Identity Requester.
    * @param _idv Address of Identity Validator.
    * @param _itemsToKeep Array of scope request IDs to keep in escrow.
    * @param _amount New Placement amount.
    * @return bytes32 New Placement ID.
    */
    function keepPlacement(bytes32 _placementId, address _idr, address _idv,  bytes32[] _itemsToKeep, uint256 _amount)
        internal
        returns (bytes32)
    {
        // Calculate new placement ID.
        bytes32 newPlacementId = calculatePlacementId(_idr, _idv, _itemsToKeep);
        // Store data against new placement ID. Copy unchanged data from old placement.
        bytes32[] memory credentialItemIds = getPlacementCredentialItemIds(_placementId);
        saveNewPlacement(newPlacementId, _amount, credentialItemIds, getPlacementBlockNumber(_placementId));

        uint256 amountPerItem = _amount.div(_itemsToKeep.length);
        for (uint256 i = 0; i < _itemsToKeep.length; i++) {
            emit EscrowMoved(_idr, _idv, _itemsToKeep[i], amountPerItem, credentialItemIds, _placementId, newPlacementId);
        }

        return newPlacementId;
    }

    /**
    * @dev Transfers funds to IDV withholding platform fee (if applied).
    * @param _placementId Released placement identifier.
    * @param _idr Address of Identity Requester.
    * @param _idv Address of Identity Validator.
    * @param _releasedItems Array of released scope request IDs.
    * @param _amount Amount to release.
    */
    function releaseEscrowedFunds(bytes32 _placementId, address _idr, address _idv, bytes32[] _releasedItems, uint256 _amount)
        internal
    {
        // Calculate token distribution.
        uint256 platformFee = calculatePlatformFee(_amount);
        uint256 idvFee = platformFee > 0 ? _amount.sub(platformFee) : _amount;

        // Transfer tokens from escrow to IDV.
        ERC20 cvcToken = token();
        require(cvcToken.transfer(_idv, idvFee), "Token transfer to IDV account failed");

        // Transfer tokens from escrow to platform operator address.
        if (platformFee > 0) {
            require(cvcToken.transfer(platformAddress(), platformFee), "Token transfer to platform account failed");
        }

        logBatchRelease(
            _placementId,
            _idr,
            _idv,
            _releasedItems,
            platformFee.div(_releasedItems.length),
            idvFee.div(_releasedItems.length)
        );
    }

    /**
    * @dev Emits EscrowReleased event for each released item.
    * @param _placementId Released placement identifier.
    * @param _idr Address of Identity Requester.
    * @param _idv Address of Identity Validator.
    * @param _releasedItems Array of released scope request IDs.
    * @param _itemPlatformFee Platform fee charged per one item.
    * @param _itemIdvFee Identity Validator fee charged per one item.
    */
    function logBatchRelease(
        bytes32 _placementId,
        address _idr,
        address _idv,
        bytes32[] _releasedItems,
        uint256 _itemPlatformFee,
        uint256 _itemIdvFee
    )
        internal
    {
        bytes32[] memory credentialItemIds = getPlacementCredentialItemIds(_placementId);
        for (uint256 i = 0; i < _releasedItems.length; i++) {
            emit EscrowReleased(
                _idr,
                _idv,
                _releasedItems[i],
                _itemPlatformFee,
                _itemIdvFee,
                credentialItemIds,
                _placementId
            );
        }
    }

    /**
    * @dev Returns placement details.
    * @param _placementId Escrow Placement identifier.
    * @return uint256 CVC token amount in creds (CVC x 10e-8)
    * @return PlacementState One of the CvcEscrowInterface.PlacementState values.
    * @return bytes32[] Array of credential item IDs.
    * @return uint256 Block confirmations since escrow was placed.
    * @return bool True if placement can be refunded otherwise false
    */
    function getPlacement(bytes32 _placementId)
        internal
        view
        returns (
            uint256 placementAmount,
            PlacementState placementState,
            bytes32[] credentialItemIds,
            uint256 confirmations,
            bool refundable
        )
    {
        placementState = getPlacementState(_placementId);
        // Placement amount value is returned for Placed placements, otherwise 0;
        placementAmount = placementState == PlacementState.Placed ? getPlacementAmount(_placementId) : 0;
        credentialItemIds = getPlacementCredentialItemIds(_placementId);

        // 0 when empty, number of blocks in other states
        uint256 placementBlockNumber = getPlacementBlockNumber(_placementId);
        confirmations = placementState == PlacementState.Empty ? 0 : block.number.sub(placementBlockNumber);

        refundable = isRefundable(placementState, placementBlockNumber);
    }

    /**
    * @dev Returns placement state.
    * @param _placementId The placement ID.
    * @return PlacementState
    */
    function getPlacementState(bytes32 _placementId) internal view returns (PlacementState) {
        // return PlacementState(placements[_placementId].state);
        return PlacementState(uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".state"))]);
    }

    /**
    * @dev Saves placement state.
    * @param _placementId The placement ID.
    * @param state Placement state.
    */
    function setPlacementState(bytes32 _placementId, PlacementState state) internal {
        // placements[_placementId].state = uint256(state);
        uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".state"))] = uint256(state);
    }

    /**
    * @dev Returns placement amount.
    * @param _placementId The placement ID.
    * @return uint256
    */
    function getPlacementAmount(bytes32 _placementId) internal view returns (uint256) {
        // return placements[_placementId].amount;
        return uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".amount"))];
    }

    /**
    * @dev Saves placement amount.
    * @param _placementId The placement ID.
    * @param _amount Placement amount.
    */
    function setPlacementAmount(bytes32 _placementId, uint256 _amount) internal {
        // placements[_placementId].amount = _amount;
        uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".amount"))] = _amount;
    }

    /**
    * @dev Returns placement credential item IDs.
    * @param _placementId The placement ID.
    * @return bytes32[] Array of credential item IDs.
    */
    function getPlacementCredentialItemIds(bytes32 _placementId)
        internal
        view
        returns (bytes32[])
    {
        // uint256 count = placements[_placementId].credentialItemIdsCount;
        uint256 count = uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".credentialItemIds"))];
        bytes32[] memory credentialItemIds = new bytes32[](count);
        for (uint256 i = 0; i < count; i++) {
            // credentialItemIds[i] = placements[_placementId].credentialItemIds[i];
            credentialItemIds[i] = bytes32Storage[keccak256(abi.encodePacked("placements.", _placementId, ".credentialItemIds.", i))];
        }

        return credentialItemIds;
    }

    /**
    * @dev Saves placement credential item IDs.
    * @param _placementId The placement ID.
    * @param _credentialItemIds Array of credential item IDs.
    */
    function setPlacementCredentialItemIds(bytes32 _placementId, bytes32[] _credentialItemIds) internal
    {
        // placements[_placementId].credentialItemIdsCount = _credentialItemIds.length;
        uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".credentialItemIds"))] = _credentialItemIds.length;
        for (uint256 i = 0; i < _credentialItemIds.length; i++) {
            // placements[_placementId].credentialItemIds[i] = _credentialItemIds[i];
            bytes32Storage[keccak256(abi.encodePacked("placements.", _placementId, ".credentialItemIds.", i))] = _credentialItemIds[i];
        }
    }

    /**
    * @dev Returns placement block number.
    * @param _placementId The placement ID.
    * @return uint256
    */
    function getPlacementBlockNumber(bytes32 _placementId) internal view returns (uint256) {
        // return placements[_placementId].blockNumber;
        return uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".blockNumber"))];
    }

    /**
    * @dev Saves placement block number.
    * @param _placementId The placement ID.
    * @param _blockNumber Placement block number.
    */
    function setPlacementBlockNumber(bytes32 _placementId, uint256 _blockNumber) internal {
        // placements[_placementId].blockNumber = _blockNumber;
        uintStorage[keccak256(abi.encodePacked("placements.", _placementId, ".blockNumber"))] = _blockNumber;
    }
}