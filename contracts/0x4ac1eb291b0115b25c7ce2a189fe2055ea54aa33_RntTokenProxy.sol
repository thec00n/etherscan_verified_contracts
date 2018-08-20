pragma solidity ^0.4.15;

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
  function Ownable() {
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
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/**
 * @title Contracts that should not own Ether
 * @author Remco Bloemen <<span class="__cf_email__" data-cfemail="b0c2d5ddd3dff082">[email protected]</span>π.com>
 * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
 * in the contract, it will allow the owner to reclaim this ether.
 * @notice Ether can still be send to this contract by:
 * calling functions labeled `payable`
 * `selfdestruct(contract_address)`
 * mining directly to the contract address
*/
contract HasNoEther is Ownable {

  /**
  * @dev Constructor that rejects incoming Ether
  * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
  * leave out payable, then Solidity will allow inheriting contracts to implement a payable
  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
  * we could use assembly to access msg.value.
  */
  function HasNoEther() payable {
    require(msg.value == 0);
  }

  /**
   * @dev Disallows direct send by settings a default function without the `payable` flag.
   */
  function() external {
  }

  /**
   * @dev Transfer all Ether held by the contract to the owner.
   */
  function reclaimEther() external onlyOwner {
    assert(owner.send(this.balance));
  }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
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
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract IRntToken {
    uint256 public decimals = 18;

    uint256 public totalSupply = 1000000000 * (10 ** 18);

    string public name = "RNT Token";

    string public code = "RNT";


    function balanceOf() public constant returns (uint256 balance);

    function transfer(address _to, uint _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
}

contract RntTokenVault is HasNoEther, Pausable {
    using SafeMath for uint256;

    IRntToken public rntToken;

    uint256 public accountsCount = 0;

    uint256 public tokens = 0;

    mapping (bytes16 => bool) public accountsStatuses;

    mapping (bytes16 => uint256) public balances;

    mapping (address => bool) public allowedAddresses;

    mapping (address => bytes16) public tokenTransfers;


    function RntTokenVault(address _rntTokenAddress){
        rntToken = IRntToken(_rntTokenAddress);
    }

    /**
    @notice Modifier that prevent calling function from not allowed address.
    @dev Owner always allowed address.
    */
    modifier onlyAllowedAddresses {
        require(msg.sender == owner || allowedAddresses[msg.sender] == true);
        _;
    }

    /**
    @notice Modifier that prevent calling function if account not registered.
    */
    modifier onlyRegisteredAccount(bytes16 _uuid) {
        require(accountsStatuses[_uuid] == true);
        _;
    }

    /**
    @notice Get current amount of tokens on Vault address.
    @return { amount of tokens }
    */
    function getVaultBalance() onlyAllowedAddresses public constant returns (uint256) {
        return rntToken.balanceOf();
    }

    /**
    @notice Get uuid of account taht transfer tokens to specified address.
    @param  _address Transfer address.
    @return { uuid that wsa transfer tokens }
    */
    function getTokenTransferUuid(address _address) onlyAllowedAddresses public constant returns (bytes16) {
        return tokenTransfers[_address];
    }

    /**
    @notice Check that address is allowed to interact with functions.
    @return { true if allowed, false if not }
    */
    function isAllowedAddress(address _address) onlyAllowedAddresses public constant returns (bool) {
        return allowedAddresses[_address];
    }

    /**
    @notice Check that address is registered.
    @return { true if registered, false if not }
    */
    function isRegisteredAccount(address _address) onlyAllowedAddresses public constant returns (bool) {
        return allowedAddresses[_address];
    }

    /**
     @notice Register account.
     @dev It used for accounts counting.
     */
    function registerAccount(bytes16 _uuid) public {
        accountsStatuses[_uuid] = true;
        accountsCount = accountsCount.add(1);
    }

    /**
     @notice Set allowance for address to interact with contract.
     @param _address Address to allow or disallow.
     @param _allow True to allow address to interact with function, false to disallow.
    */
    function allowAddress(address _address, bool _allow) onlyOwner {
        allowedAddresses[_address] = _allow;
    }

    /**
    @notice Function for adding tokens to specified account.
    @dev Account will be registered if it wasn't. Tokens will not be added to Vault address.
    @param _uuid Uuid of account.
    @param _tokensCount Number of tokens for adding to account.
    @return { true if added, false if not }
    */
    function addTokensToAccount(bytes16 _uuid, uint256 _tokensCount) onlyAllowedAddresses whenNotPaused public returns (bool) {
        registerAccount(_uuid);
        balances[_uuid] = balances[_uuid].add(_tokensCount);
        tokens = tokens.add(_tokensCount);
        return true;
    }

    /**
    @notice Function for removing tokens from specified account.
    @dev Function throw exception if account wasn't registered. Tokens will not be returned to owner address.
    @param _uuid Uuid of account.
    @param _tokensCount Number of tokens for adding to account.
    @return { true if added, false if not }
    */
    function removeTokensFromAccount(bytes16 _uuid, uint256 _tokensCount) onlyAllowedAddresses
            onlyRegisteredAccount(_uuid) whenNotPaused internal returns (bool) {
        balances[_uuid] = balances[_uuid].sub(_tokensCount);
        return true;
    }

    /**
    @notice Function for transfering tokens from one account to another.
    @param _from Account from which tokens will be transfered.
    @param _to Account to which tokens will be transfered.
    @param _tokensCount Number of tokens that will be transfered.
    @return { true if transfered successful, false if not }
    */
    function transferTokensToAccount(bytes16 _from, bytes16 _to, uint256 _tokensCount) onlyAllowedAddresses
            onlyRegisteredAccount(_from) whenNotPaused public returns (bool) {
        registerAccount(_to);
        balances[_from] = balances[_from].sub(_tokensCount);
        balances[_to] = balances[_to].add(_tokensCount);
        return true;
    }

    /**
    @notice Function for withdrawal all tokens from Vault account to address.
    @dev Will transfer tokens from Vault address to specified address.
    @param _uuid Account from which tokens will be transfered.
    @param _address Address on which tokens will be transfered.
    @return { true if withdrawal successful, false if not }
    */
    function moveAllTokensToAddress(bytes16 _uuid, address _address) onlyAllowedAddresses
            onlyRegisteredAccount(_uuid) whenNotPaused public returns (bool) {
        uint256 accountBalance = balances[_uuid];
        removeTokensFromAccount(_uuid, accountBalance);
        rntToken.transfer(_address, accountBalance);
        tokens = tokens.sub(accountBalance);
        tokenTransfers[_address] = _uuid;
        return true;
    }

    /**
    @notice Function for withdrawal tokens from Vault account to address.
    @dev Will transfer tokens from Vault address to specified address.
    @param _uuid Account from which tokens will be transfered.
    @param _address Address on which tokens will be transfered.
    @param _tokensCount Number of tokens that will be transfered.
    @return { true if transfered successful, false if not }
    */
    function moveTokensToAddress(bytes16 _uuid, address _address, uint256 _tokensCount) onlyAllowedAddresses
            onlyRegisteredAccount(_uuid) whenNotPaused public returns (bool) {
        removeTokensFromAccount(_uuid, _tokensCount);
        rntToken.transfer(_address, _tokensCount);
        tokens = tokens.sub(_tokensCount);
        tokenTransfers[_address] = _uuid;
        return true;
    }

    /**
    @notice Function for withdrawal tokens from Vault to specified address.
    @dev Will transfer tokens from Vault address to specified address.
    @param _to Address on which tokens will be transfered.
    @param _tokensCount Number of tokens that will be transfered.
    @return { true if transfered successful, false if not }
    */
    function transferTokensFromVault(address _to, uint256 _tokensCount) onlyOwner public returns (bool) {
        rntToken.transfer(_to, _tokensCount);
        return true;
    }
}

/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {

  function Destructible() payable { }

  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}

contract ICrowdsale {
    function allocateTokens(address _receiver, bytes16 _customerUuid, uint256 _weiAmount) public;
}

contract RntTokenProxy is Destructible, Pausable, HasNoEther {
    IRntToken public rntToken;

    ICrowdsale public crowdsale;

    RntTokenVault public rntTokenVault;

    mapping (address => bool) public allowedAddresses;

    function RntTokenProxy(address _tokenAddress, address _vaultAddress, address _defaultAllowed, address _crowdsaleAddress) {
        rntToken = IRntToken(_tokenAddress);
        rntTokenVault = RntTokenVault(_vaultAddress);
        crowdsale = ICrowdsale(_crowdsaleAddress);
        allowedAddresses[_defaultAllowed] = true;
    }

    /**
      @notice Modifier that prevent calling function from not allowed address.
      @dev Owner always allowed address.
     */
    modifier onlyAllowedAddresses {
        require(msg.sender == owner || allowedAddresses[msg.sender] == true);
        _;
    }

    /**
      @notice Set allowance for address to interact with contract.
      @param _address Address to allow or disallow.
      @param _allow True to allow address to interact with function, false to disallow.
     */
    function allowAddress(address _address, bool _allow) onlyOwner external {
        allowedAddresses[_address] = _allow;
    }

    /**
      @notice Function for adding tokens to account.
      @dev If account wasn't created, it will be created and tokens will be added. Also this function transfer tokens to address of Valut.
      @param _uuid Account uuid.
      @param _tokensCount Number of tokens that will be added to account.
     */
    function addTokens(bytes16 _uuid, uint256 _tokensCount) onlyAllowedAddresses whenNotPaused external {
        rntTokenVault.addTokensToAccount(_uuid, _tokensCount);
        rntToken.transferFrom(owner, address(rntTokenVault), _tokensCount);
    }

    /**
      @notice Function for transfering tokens from account to specified address.
      @dev It will transfer tokens from Vault address to specified address.
      @param _to Address, on wich tokens will be added.
      @param _uuid Account, from wich token will be taken.
      @param _tokensCount Number of tokens for transfering.
     */
    function moveTokens(address _to, bytes16 _uuid, uint256 _tokensCount) onlyAllowedAddresses whenNotPaused external {
        rntTokenVault.moveTokensToAddress(_uuid, _to, _tokensCount);
    }

    /**
      @notice Function for transfering all tokens from account to specified address.
      @dev It will transfer all account allowed tokens from Vault address to specified address.
      @param _to Address, on wich tokens will be added.
      @param _uuid Account, from wich token will be taken.
     */
    function moveAllTokens(address _to, bytes16 _uuid) onlyAllowedAddresses whenNotPaused external {
        rntTokenVault.moveAllTokensToAddress(_uuid, _to);
    }

    /**
      @notice Add tokens to specified address, tokens amount depends of wei amount.
      @dev Tokens acount calculated using token price that specified in Prixing Strategy. This function should be used when tokens was buyed outside ethereum.
      @param _receiver Address, on wich tokens will be added.
      @param _customerUuid Uuid of account that was bought tokens.
      @param _weiAmount Wei that account was invest.
     */
    function allocate(address _receiver, bytes16 _customerUuid, uint256 _weiAmount) onlyAllowedAddresses whenNotPaused external {
        crowdsale.allocateTokens(_receiver, _customerUuid, _weiAmount);
    }
}