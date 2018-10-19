pragma solidity ^0.4.13;

contract RBAC {
  using Roles for Roles.Role;

  mapping (string => Roles.Role) private roles;

  event RoleAdded(address indexed operator, string role);
  event RoleRemoved(address indexed operator, string role);

  /**
   * @dev reverts if addr does not have role
   * @param _operator address
   * @param _role the name of the role
   * // reverts
   */
  function checkRole(address _operator, string _role)
    public
    view
  {
    roles[_role].check(_operator);
  }

  /**
   * @dev determine if addr has role
   * @param _operator address
   * @param _role the name of the role
   * @return bool
   */
  function hasRole(address _operator, string _role)
    public
    view
    returns (bool)
  {
    return roles[_role].has(_operator);
  }

  /**
   * @dev add a role to an address
   * @param _operator address
   * @param _role the name of the role
   */
  function addRole(address _operator, string _role)
    internal
  {
    roles[_role].add(_operator);
    emit RoleAdded(_operator, _role);
  }

  /**
   * @dev remove a role from an address
   * @param _operator address
   * @param _role the name of the role
   */
  function removeRole(address _operator, string _role)
    internal
  {
    roles[_role].remove(_operator);
    emit RoleRemoved(_operator, _role);
  }

  /**
   * @dev modifier to scope access to a single role (uses msg.sender as addr)
   * @param _role the name of the role
   * // reverts
   */
  modifier onlyRole(string _role)
  {
    checkRole(msg.sender, _role);
    _;
  }

  /**
   * @dev modifier to scope access to a set of roles (uses msg.sender as addr)
   * @param _roles the names of the roles to scope access to
   * // reverts
   *
   * @TODO - when solidity supports dynamic arrays as arguments to modifiers, provide this
   *  see: https://github.com/ethereum/solidity/issues/2467
   */
  // modifier onlyRoles(string[] _roles) {
  //     bool hasAnyRole = false;
  //     for (uint8 i = 0; i < _roles.length; i++) {
  //         if (hasRole(msg.sender, _roles[i])) {
  //             hasAnyRole = true;
  //             break;
  //         }
  //     }

  //     require(hasAnyRole);

  //     _;
  // }
}

library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

  /**
   * @dev give an address access to this role
   */
  function add(Role storage _role, address _addr)
    internal
  {
    _role.bearer[_addr] = true;
  }

  /**
   * @dev remove an address' access to this role
   */
  function remove(Role storage _role, address _addr)
    internal
  {
    _role.bearer[_addr] = false;
  }

  /**
   * @dev check if an address has this role
   * // reverts
   */
  function check(Role storage _role, address _addr)
    internal
    view
  {
    require(has(_role, _addr));
  }

  /**
   * @dev check if an address has this role
   * @return bool
   */
  function has(Role storage _role, address _addr)
    internal
    view
    returns (bool)
  {
    return _role.bearer[_addr];
  }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


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
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

contract Claimable is Ownable {
  address public pendingOwner;

  /**
   * @dev Modifier throws if called by any account other than the pendingOwner.
   */
  modifier onlyPendingOwner() {
    require(msg.sender == pendingOwner);
    _;
  }

  /**
   * @dev Allows the current owner to set the pendingOwner address.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    pendingOwner = newOwner;
  }

  /**
   * @dev Allows the pendingOwner address to finalize the transfer.
   */
  function claimOwnership() public onlyPendingOwner {
    emit OwnershipTransferred(owner, pendingOwner);
    owner = pendingOwner;
    pendingOwner = address(0);
  }
}

contract HasNoEther is Ownable {

  /**
  * @dev Constructor that rejects incoming Ether
  * The `payable` flag is added so we can access `msg.value` without compiler warning. If we
  * leave out payable, then Solidity will allow inheriting contracts to implement a payable
  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
  * we could use assembly to access msg.value.
  */
  constructor() public payable {
    require(msg.value == 0);
  }

  /**
   * @dev Disallows direct send by setting a default function without the `payable` flag.
   */
  function() external {
  }

  /**
   * @dev Transfer all Ether held by the contract to the owner.
   */
  function reclaimEther() external onlyOwner {
    owner.transfer(address(this).balance);
  }
}

contract BitwordsVault is RBAC, HasNoEther, Pausable, Claimable {
    using SafeMath for uint256;

    // A constant role name representing the bitwords server.
    string internal constant ROLE_SERVER = "server";

    // A constant role name representing the bitwords authorizer
    string internal constant ROLE_AUTHORIZER = "authorizer";

    struct TransferQueue {
        address[] destinations;
        mapping(address => uint256) balances;
        mapping(address => uint256) kind; // 0 = publisher, 1 = bitwords, 2 = advertiser affiliate, 3 = publisher affiliate
    }

    // A mapping to keep track of all pending transfers
    uint256 public lastTransferQueueIndex = 0;
    TransferQueue[] internal transferQueue;

    // Advertiser and publisher affiliates mapping
    mapping(uint256 => address) public advertiserAffiliates;
    mapping(uint256 => address) public publisherAffiliates;

    // This mapping overrides the default bitwords cut for a specific publisher.
    mapping(uint256 => uint256) public bitwordsCutOverride;

    // The bitwords address, where all the 30% cut is received ETH
    address public bitwordsWithdrawalAddress;

    // How much cut out of 100 Bitwords takes. By default 30%
    uint256 public bitwordsCutOutof100 = 30;

    // How much cut out of Bitwords cut, do affiliates take? By default 40%
    uint256 public affiliatesCutOutof100 = 40;

    // point to the TrueUSD ERC20 token
    ERC20 public tokenTrueUSD;


    /**
     * @dev The Bitwords constructor sets the address where all the withdrawals will
     * happen.
     */
    constructor (ERC20 _tokenTrueUSD) public {
        tokenTrueUSD = _tokenTrueUSD;
        bitwordsWithdrawalAddress = msg.sender;
    }


    modifier hasServerPermission () {
        checkRole(msg.sender, ROLE_SERVER);
        _;
    }


    modifier hasAuthorizerPermission () {
        checkRole(msg.sender, ROLE_AUTHORIZER);
        _;
    }


    /**
     * @dev Add a authorizer
     */
    function addAuthorizer (address _user) onlyOwner public {
        addRole(_user, ROLE_AUTHORIZER);
        emit AuthorizerAdded(_user);
    }


    /**
     * @dev Add a server
     */
    function addServer (address _user) onlyOwner public {
        addRole(_user, ROLE_SERVER);
        emit ServerAdded(_user);
    }


    /**
     * @dev Refund the TUSD tokens back to the owner
     *
     * @param value     The amount of tokens that need to be refunded
     */
    function refundTokens (uint256 value) onlyOwner public {
        tokenTrueUSD.transfer(msg.sender, value);
        emit RefundToOwner(msg.sender, value);
    }


    /**
     * Used by the owner to set the withdrawal address for Bitwords. This address
     * is where Bitwords will receive all the cut from the advertisements.
     *
     * @param _newAddress    the new withdrawal address
     */
    function setBitwordsWithdrawalAddress (address _newAddress) onlyOwner public {
        require(_newAddress != address(0));
        bitwordsWithdrawalAddress = _newAddress;

        emit BitwordsWithdrawalAddressChanged(msg.sender, _newAddress);
    }


    /**
     * @dev Set the affiliate for the advertiser
     */
    function setAdvertiserAffiliate (address _affiliate, uint256 _advertiser) public onlyOwner {
        require(_affiliate != address(0));
        advertiserAffiliates[_advertiser] = _affiliate;

        emit SetAdvertiserAffiliate(_advertiser, _affiliate);
    }


    /**
     * @dev Set the affiliate for the publisher
     */
    function setPublisherAffiliate (address _affiliate, uint256 _publisher) public onlyOwner {
        require(_affiliate != address(0));
        publisherAffiliates[_publisher] = _affiliate;

        emit SetPublisherAffiliate(_publisher, _affiliate);
    }


    /**
     * Change the cut that Bitwords takes.
     *
     * @param _cut   the amount of cut that Bitwords takes.
     */
    function setBitwordsCut (uint256 _cut) onlyOwner public {
        require(_cut <= 30, "cut cannot be more than 30%");
        require(_cut >= 0, "cut should be greater than 0%");
        bitwordsCutOutof100 = _cut;

        emit BitwordsCutChanged(msg.sender, _cut);
    }


    /**
     * Anybody can credit ether on behalf of an advertiser
     *
     * @param publisherId  The address of the publisher
     * @param cut          How much cut should be taken from this publisher
     */
    function setPublisherCut (uint256 publisherId, uint cut) onlyOwner public {
        // require(publisher != address(0));
        require(cut <= 30, "cut cannot be more than 30%");
        require(cut >= 0, "cut should be greater than 0%");

        bitwordsCutOverride[publisherId] = cut;
        emit SetPublisherCut(publisherId, cut);
    }


    /**
     * Charge the advertiser with whatever clicks have been served by the ad engine.
     *
     * @param advertiserIds         Array of address of the advertiser from whom we should debit ether
     * @param costs                 Array of the cost to be paid to publisher by advertisers
     * @param publisherIds          Array of indices of publishers that need to be credited than debited.
     * @param publishers            Array of address of the publisher from whom we should credit ether
     */
    bool private inChargeAdvertisers = false;
    function chargeAdvertisers (uint256[] advertiserIds, uint256[] costs, uint256[] publisherIds, address[] publishers)
    public hasServerPermission {
        // Prevent re-entry bug
        require(!inChargeAdvertisers, "avoid rentry bug");
        inChargeAdvertisers = true;

        for (uint256 i = 0; i < advertiserIds.length; i++) {
            uint256 toWithdraw = costs[i];

            // Update the advertiser
            emit DeductFromAdvertiser(advertiserIds[i], toWithdraw);

            // Calculate how much cut Bitwords should take
            uint256 bitwordsCutPercent = bitwordsCutOutof100;
            if (bitwordsCutOverride[publisherIds[i]] > 0 && bitwordsCutOverride[publisherIds[i]] <= 30) {
                bitwordsCutPercent = bitwordsCutOverride[publisherIds[i]];
            }

            // Figure out how much should go to Bitwords and how much should go to the publishers.
            uint256 publisherNetCut = toWithdraw * (100 - bitwordsCutPercent) / 100;
            uint256 bitwordsCut = toWithdraw.sub(publisherNetCut);
            uint256 bitwordsNetCut = bitwordsCut;
            uint256 affiliateCut = affiliatesCutOutof100.mul(bitwordsNetCut);

            // Send the usd to the publishers right away
            queueTransfer(publishers[i], publisherNetCut, 0);

            // Calculate how much from Bitword's cut should goto affiliates
            // If there is an advertiser affiliate
            if (advertiserAffiliates[advertiserIds[i]] != address(0)) {
                // send usd to the affiliate
                queueTransfer(advertiserAffiliates[advertiserIds[i]], affiliateCut, 2);
                bitwordsCut = bitwordsCut.sub(affiliateCut);
            }

            // Calculate how much from Bitword's cut should goto publishers
            // TODO: check if bitwordsCut > 0
            if (publisherAffiliates[publisherIds[i]] != address(0)) {
                // send usd to the affiliate
                queueTransfer(publisherAffiliates[advertiserIds[i]], affiliateCut, 3);
                bitwordsCut = bitwordsCut.sub(affiliateCut);
            }

            // Send the remaining usd to Bitwords
            queueTransfer(bitwordsWithdrawalAddress, bitwordsCut, 1);
        }

        inChargeAdvertisers = false;
    }


    /**
     * @dev Helper function to queue a transfer. A transfer which is queued is only executable
     * once an authorizer approves it.
     *
     * @param _to       The destination to TUSD to
     * @param _value    The amount of TUSD to send
     * @param _kind     The kind of user
     */
    function queueTransfer (address _to, uint256 _value, uint256 _kind) internal {
        if (transferQueue.length == lastTransferQueueIndex) {
            TransferQueue memory t1 = TransferQueue({ destinations: new address[](0) });
            transferQueue.push(t1);
        }

        TransferQueue storage t = transferQueue[lastTransferQueueIndex];

        if (t.balances[_to] == 0) t.destinations.push(_to);
        t.balances[_to] = t.balances[_to].add(_value);
        t.kind[_to] = _kind;

        emit PayoutQueued(_to, _value, _kind);
    }


    /**
     * @dev Called by an authorizer to make all the transactions
     */
    function approveAdvertiserCharges () public hasAuthorizerPermission payable {
        TransferQueue storage t = transferQueue[lastTransferQueueIndex];

        for (uint256 i = 0; i < t.destinations.length; i++) {
            tokenTrueUSD.transfer(t.destinations[i], t.balances[t.destinations[i]]);
            emit PayoutProcessed(t.destinations[i], t.balances[t.destinations[i]], t.kind[t.destinations[i]]);
        }

        lastTransferQueueIndex = transferQueue.length;
    }


    /**
     * @dev Called by an approver to reject all the pending changes
     */
    function rejectAdvertiserCharges () public hasAuthorizerPermission payable {
        lastTransferQueueIndex = transferQueue.length;
        emit PayoutsRejected();
    }


    /** Events */
    event BitwordsCutChanged(address indexed _by, uint256 _value);
    event BitwordsWithdrawalAddressChanged(address indexed _by, address indexed _from);
    event SetPublisherCut(uint256 indexed _id, uint256 _value);
    event SetAdvertiserAffiliate(uint256 indexed _id, address indexed _affiliate);
    event SetPublisherAffiliate(uint256 indexed _id, address indexed _affiliate);

    event DeductFromAdvertiser(uint256 indexed _id, uint256 _value);
    event PayoutQueued(address indexed _to, uint256 _value, uint256 _kind);
    event PayoutProcessed(address indexed _to, uint256 _value, uint256 _kind);
    event PayoutsRejected();

    event RefundToOwner(address indexed _to, uint256 _value);

    event ServerAdded(address _to);
    event AuthorizerAdded(address _to);
}

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}