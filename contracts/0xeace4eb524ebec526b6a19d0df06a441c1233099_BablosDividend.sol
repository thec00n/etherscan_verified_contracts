pragma solidity ^0.4.23;

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

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
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

/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6311060e000c2351">[email protected]</a>π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
  }

}

contract DividendInterface {
  function putProfit() public payable;
  function dividendBalanceOf(address _account) public view returns (uint256);
  function hasDividends() public view returns (bool);
  function claimDividends() public returns (uint256);
  function claimedDividendsOf(address _account) public view returns (uint256);
  function saveUnclaimedDividends(address _account) public;
}

contract BasicDividend is DividendInterface, ReentrancyGuard, Ownable {
  using SafeMath for uint256;

  event Dividends(uint256 amount);
  event DividendsClaimed(address claimer, uint256 amount);

  uint256 public totalDividends;
  mapping (address => uint256) public lastDividends;
  mapping (address => uint256) public unclaimedDividends;
  mapping (address => uint256) public claimedDividends;
  ERC20 public token;

  modifier onlyToken() {
    require(msg.sender == address(token));
    _;
  }

  constructor(ERC20 _token) public {
    token = _token;
  }

  /**
   * @dev fallback payment function
   */
  function () external payable {
    putProfit();
  }

  /**
   * @dev on every ether transaction totalDividends is incremented by amount
   */
  function putProfit() public nonReentrant onlyOwner payable {
    totalDividends = totalDividends.add(msg.value);
    emit Dividends(msg.value);
  }

  /**
  * @dev Gets the unclaimed dividends balance of the specified address.
  * @param _account The address to query the the dividends balance of.
  * @return An uint256 representing the amount of dividends owned by the passed address.
  */
  function dividendBalanceOf(address _account) public view returns (uint256) {
    uint256 accountBalance = token.balanceOf(_account);
    uint256 totalSupply = token.totalSupply();
    uint256 newDividends = totalDividends.sub(lastDividends[_account]);
    uint256 product = accountBalance.mul(newDividends);
    return product.div(totalSupply) + unclaimedDividends[_account];
  }

  function claimedDividendsOf(address _account) public view returns (uint256) {
    return claimedDividends[_account];
  }

  function hasDividends() public view returns (bool) {
    return totalDividends > 0 && address(this).balance > 0;
  }

  /**
  * @dev claim dividends
  */
  function claimDividends() public nonReentrant returns (uint256) {
    require(address(this).balance > 0);
    uint256 dividends = dividendBalanceOf(msg.sender);
    require(dividends > 0);
    lastDividends[msg.sender] = totalDividends;
    unclaimedDividends[msg.sender] = 0;
    claimedDividends[msg.sender] = claimedDividends[msg.sender].add(dividends);
    msg.sender.transfer(dividends);
    emit DividendsClaimed(msg.sender, dividends);
    return dividends;
  }

  function saveUnclaimedDividends(address _account) public onlyToken {
    if (totalDividends > lastDividends[_account]) {
      unclaimedDividends[_account] = dividendBalanceOf(_account);
      lastDividends[_account] = totalDividends;
    }
  }
}

contract BablosDividend is BasicDividend {

  constructor(ERC20 _token) public BasicDividend(_token) {

  }

}