pragma solidity 0.4.19;

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
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
    assert(token.transfer(to, value));
  }

  function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
    assert(token.transferFrom(from, to, value));
  }

  function safeApprove(ERC20 token, address spender, uint256 value) internal {
    assert(token.approve(spender, value));
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
  function Ownable() public {
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
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title RTEBonusTokenVault
 * @dev Token holder contract that releases tokens to the respective addresses
 * and _lockedReleaseTime
 */
contract RTEBonusTokenVault is Ownable {
  using SafeERC20 for ERC20Basic;
  using SafeMath for uint256;

  // ERC20 basic token contract being held
  ERC20Basic public token;

  bool public vaultUnlocked;

  bool public vaultSecondaryUnlocked;

  // How much we have allocated to the investors invested
  mapping(address => uint256) public balances;

  mapping(address => uint256) public lockedBalances;

  /**
   * @dev Allocation event
   * @param _investor Investor address
   * @param _value Tokens allocated
   */
  event Allocated(address _investor, uint256 _value);

  /**
   * @dev Distribution event
   * @param _investor Investor address
   * @param _value Tokens distributed
   */
  event Distributed(address _investor, uint256 _value);

  function RTEBonusTokenVault(
    ERC20Basic _token
  )
    public
  {
    token = _token;
    vaultUnlocked = false;
    vaultSecondaryUnlocked = false;
  }

  /**
   * @dev Unlocks vault
   */
  function unlock() public onlyOwner {
    require(!vaultUnlocked);
    vaultUnlocked = true;
  }

  /**
   * @dev Unlocks secondary vault
   */
  function unlockSecondary() public onlyOwner {
    require(vaultUnlocked);
    require(!vaultSecondaryUnlocked);
    vaultSecondaryUnlocked = true;
  }

  /**
   * @dev Add allocation amount to investor addresses
   * Only the owner of this contract - the crowdsale can call this function
   * Split half to be locked by timelock in vault, the other half to be released on vault unlock
   * @param _investor Investor address
   * @param _amount Amount of tokens to add
   */
  function allocateInvestorBonusToken(address _investor, uint256 _amount) public onlyOwner {
    require(!vaultUnlocked);
    require(!vaultSecondaryUnlocked);

    uint256 bonusTokenAmount = _amount.div(2);
    uint256 bonusLockedTokenAmount = _amount.sub(bonusTokenAmount);

    balances[_investor] = balances[_investor].add(bonusTokenAmount);
    lockedBalances[_investor] = lockedBalances[_investor].add(bonusLockedTokenAmount);

    Allocated(_investor, _amount);
  }

  /**
   * @dev Transfers bonus tokens held to investor
   * @param _investor Investor address making the claim
   */
  function claim(address _investor) public onlyOwner {
    // _investor is the original initiator
    // msg.sender is the contract that called this.
    require(vaultUnlocked);

    uint256 claimAmount = balances[_investor];
    require(claimAmount > 0);

    uint256 tokenAmount = token.balanceOf(this);
    require(tokenAmount > 0);

    // Empty token balance
    balances[_investor] = 0;

    token.safeTransfer(_investor, claimAmount);

    Distributed(_investor, claimAmount);
  }

  /**
   * @dev Transfers secondary bonus tokens held to investor
   * @param _investor Investor address making the claim
   */
  function claimLocked(address _investor) public onlyOwner {
    // _investor is the original initiator
    // msg.sender is the contract that called this.
    require(vaultUnlocked);
    require(vaultSecondaryUnlocked);

    uint256 claimAmount = lockedBalances[_investor];
    require(claimAmount > 0);

    uint256 tokenAmount = token.balanceOf(this);
    require(tokenAmount > 0);

    // Empty token balance
    lockedBalances[_investor] = 0;

    token.safeTransfer(_investor, claimAmount);

    Distributed(_investor, claimAmount);
  }
}