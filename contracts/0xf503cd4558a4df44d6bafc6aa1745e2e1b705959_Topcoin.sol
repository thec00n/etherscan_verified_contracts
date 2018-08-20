pragma solidity ^0.4.15;

/// @title SafeMath
/// @dev Math operations with safety checks that throw on error
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns(uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns(uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns(uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns(uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/// @title Ownable
/// @dev The Ownable contract has an owner address, and provides basic authorization control
/// functions, this simplifies the implementation of "user permissions".
contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /// @dev The Ownable constructor sets the original `owner` of the contract to the sender
  /// account.
  function Ownable() public {
    owner = msg.sender;
  }

  /// @dev Throws if called by any account other than the owner.
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /// @dev Allows the current owner to transfer control of the contract to a newOwner.
  /// @param newOwner The address to transfer ownership to.
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }
}


/// @title Pausable
/// @dev Base contract which allows children to implement an emergency stop mechanism.
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;

  /// @dev Modifier to make a function callable only when the contract is not paused.
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /// @dev Modifier to make a function callable only when the contract is paused.
  modifier whenPaused() {
    require(paused);
    _;
  }

  /// @dev called by the owner to pause, triggers stopped state
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    Pause();
  }

  /// @dev called by the owner to unpause, returns to normal state
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
  }
}


/// @title The interface to execute the tokenFallback
/// @author Merunas Grincalaitis <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="09646c7b7c67687a6e7b60676a686568607d607a496e64686065276a6664">[email protected]</a>>
contract ContractReceiver {
  function tokenFallback(address from, uint value, bytes data) public;
}


/// @title Custom ERC223 Implementation
/// @author Merunas Grincalaitis <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="29444c5b5c47485a4e5b40474a484548405d405a694e44484045074a4644">[email protected]</a>>
contract ERC223 {
  using SafeMath for uint256;

  mapping(address => uint256) balances;
  mapping(address => mapping (address => uint256)) allowed;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  event Approval(address owner, address spender, uint256 amount);
  event Transfer(address from, address to, uint256 value);
  event Transfer(address from, address to, uint256 value, bytes data);

  /// @notice To make token transfers to a user or a contract
  /// @param to The receiver of the tokens
  /// @param value The amount of tokens to transfer
  /// @return _success If the transfer was successful
  function transfer(address to, uint256 value) public returns (bool _success) {
    require(to != address(0));
    require(value != 0);

    bytes memory emptyData;

    if (isContract(to)) {
      return transferToContract(to, value, emptyData);
    } else {
      return transferToAddress(to, value, emptyData);
    }
  }

  /// @notice To make token transfers to a user or a contract with additional data
  /// @param to The receiver of the tokens
  /// @param value The amount of tokens to transfer
  /// @param data The data to send
  /// @return _success If the transfer was successful
  function transfer(address to, uint256 value, bytes data) public returns (bool _success) {
    require(to != address(0));
    require(value != 0);
    require(data.length != 0);

    if (isContract(to)) {
      return transferToContract(to, value, data);
    } else {
      return transferToAddress(to, value, data);
    }
  }

  /// @notice To make token transfers from the allowance of another user
  /// @param from The user that allowed you to use his tokens
  /// @param to The amount of tokens to use
  /// @param value The amount of tokens to transfer
  /// @return _success If the transfer was successful
  function transferFrom(address from, address to, uint256 value) public returns (bool _success) {
    require(from != address(0));
    require(to != address(0));
    require(value != 0);

    uint256 allowance = allowed[from][msg.sender];

    balances[from] = balances[from].sub(value);
    allowed[from][msg.sender] = allowance.sub(value);
    balances[to] = balances[to].add(value);

    Transfer(from, to, value);

    return true;
  }

  /// @notice To approve another user to use your tokens
  /// @param spender The user that will be able to use your tokens
  /// @param value The amount of tokens to approve
  /// @return _success If the transfer was successful
  function approve(address spender, uint256 value) public returns (bool _success) {
    require(spender != address(0));
    require(value != 0);

    allowed[msg.sender][spender] = value;

    Approval(msg.sender, spender, value);

    return true;
  }

  /// @notice To transfer tokens to a user address
  /// @param to The receiver of the tokens
  /// @param value How many tokens he'll receive
  /// @param data Additional data
  /// @return _success If the transfer was successful
  function transferToAddress(address to, uint256 value, bytes data) public returns (bool _success) {
    require(to != address(0));
    require(value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);

    Transfer(msg.sender, to, value, data);

    return true;
  }

  /// @notice To transfer tokens to a contract address
  /// @param to The receiver of the tokens
  /// @param value How many tokens he'll receive
  /// @param data Additional data
  /// @return _success If the transfer was successful
  function transferToContract(address to, uint256 value, bytes data) public returns (bool _success) {
    require(to != address(0));
    require(value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);

    ContractReceiver(to).tokenFallback(msg.sender, value, data);

    Transfer(msg.sender, to, value, data);

    return true;
  }

  /// @dev Function to check the amount of tokens that an owner allowed to a spender.
  /// @param _owner address The address which owns the funds.
  /// @param _spender address The address which will spend the funds.
  /// @return A uint256 specifying the amount of tokens still available for the spender.
  function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /// @notice To get the token balance of a user
  /// @return _balance How much balance that user has
  function balanceOf(address owner) public constant returns (uint256 _balance) {
    require(owner != address(0));
    return balances[owner];
  }

  /// @notice To check if an address is a contract or not
  /// @return _isContract If it's a contract or not
  function isContract(address addr) public constant returns (bool _isContract) {
    require(addr != address(0));

    uint256 length;

    assembly {
      length := extcodesize(addr)
    }

    return (length > 0);
  }
}


/// @title The ERC223 Topcoin Smart Contract
/// @author Merunas Grincalaitis <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a1ccc4d3d4cfc0d2c6d3c8cfc2c0cdc0c8d5c8d2e1c6ccc0c8cd8fc2cecc">[email protected]</a>>
contract Topcoin is ERC223, Pausable {
  string public constant name = 'Topcoin';
  string public constant symbol = 'TPC';
  uint8 public constant decimals = 18;

  // 3000M tokens with 18 decimals maximum
  uint256 public constant totalSupply = 3000e24;

  // The amount of tokens to distribute on the crowsale
  uint256 public constant crowdsaleTokens = 1000e24;
  uint256 public ICOEndTime;
  address public crowdsale;
  uint256 public tokensRaised;

  // Only allow token transfers after the ICO
  modifier afterCrowdsale() {
     require(now >= ICOEndTime);
     _;
  }

  // Only the crowdsale
  modifier onlyCrowdsale() {
     require(msg.sender == crowdsale);
     _;
  }

  // For the crowsale closing function
  modifier onlyOwnerOrCrowdsale() {
    require(msg.sender == owner || msg.sender == crowdsale);
    _;
  }

  /// @notice The constructor used to set the initial balance for the founder and development
  /// the owner of those tokens will distribute the tokens for development and platform
  /// @param _ICOEndTime When will the ICO end to allow token transfers after the ICO only,
  /// required parameter
  function Topcoin(uint256 _ICOEndTime) public {
     require(_ICOEndTime > 0 && _ICOEndTime > now);

     ICOEndTime = _ICOEndTime;
     balances[msg.sender] = totalSupply;
  }

  /// @notice To set the address of the crowdsale in order to distribute the tokens
  /// @param _crowdsale The address of the crowdsale
  function setCrowdsaleAddress(address _crowdsale) public onlyOwner {
     require(_crowdsale != address(0));

     crowdsale = _crowdsale;
  }

  /// @notice To distribute the presale and ICO tokens and increase the total
  /// supply accordingly. The unsold tokens will be deleted, not generated
  /// @param _to The user that will receive the tokens
  /// @param _amount How many tokens he'll receive
  function distributeTokens(address _to, uint256 _amount) public onlyOwnerOrCrowdsale {
     require(_to != address(0));
     require(_amount > 0);
     require(tokensRaised.add(_amount) <= crowdsaleTokens);

     tokensRaised = tokensRaised.add(_amount);
     balances[msg.sender] = balances[msg.sender].sub(_amount);
     balances[_to] = balances[_to].add(_amount);
  }

  /// @notice To convert the old tokens to the new version manually
  /// @param _receiver The receiver of the tokens
  /// @param _oldAmount How many old tokens does that user have
  function convertOldTokens(address _receiver, uint256 _oldAmount) external onlyOwner {
    require(_receiver != address(0));
    require(_oldAmount > 0);

    uint256 amountNewTokens = _oldAmount.mul(2);

    balances[owner] = balances[owner].sub(amountNewTokens);
    balances[_receiver] = balances[_receiver].add(amountNewTokens);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function transfer(address _to, uint256 _value) public whenNotPaused afterCrowdsale returns(bool) {
     return super.transfer(_to, _value);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function transfer(address to, uint256 value, bytes data) public whenNotPaused afterCrowdsale returns (bool _success) {
    return super.transfer(to, value, data);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused afterCrowdsale returns(bool) {
     return super.transferFrom(_from, _to, _value);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function approve(address _spender, uint256 _value) public whenNotPaused afterCrowdsale returns(bool) {
    return super.approve(_spender, _value);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function transferToAddress(address to, uint256 value, bytes data) public whenNotPaused afterCrowdsale returns (bool _success) {
    return super.transferToAddress(to, value, data);
  }

  /// @notice Override the functions to not allow token transfers until the end of the ICO
  function transferToContract(address to, uint256 value, bytes data) public whenNotPaused afterCrowdsale returns (bool _success) {
    return super.transferToContract(to, value, data);
  }
}