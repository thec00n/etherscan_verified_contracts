pragma solidity ^0.4.15;

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
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
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of &quot;user permissions&quot;.
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

contract ClaimableTokens is Ownable {

    address public claimedTokensWallet;

    function ClaimableTokens(address targetWallet) {
        claimedTokensWallet = targetWallet;
    }

    function claimTokens(address tokenAddress) public onlyOwner {
        require(tokenAddress != 0x0);
        ERC20 claimedToken = ERC20(tokenAddress);
        uint balance = claimedToken.balanceOf(this);
        claimedToken.transfer(claimedTokensWallet, balance);
    }
}

contract CromToken is Ownable, ERC20, ClaimableTokens {
    using SafeMath for uint256;
    string public constant name = &quot;CROM Token&quot;;
    string public constant symbol = &quot;CROM&quot;;
    uint8 public constant decimals = 0;
    uint256 public constant INITIAL_SUPPLY = 10 ** 7;
    mapping (address =&gt; uint256) internal balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;

    function CromToken() Ownable() ClaimableTokens(msg.sender) {
        totalSupply = INITIAL_SUPPLY;
        balances[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 value) public returns (bool success) {
        require(to != 0x0);
        require(balances[msg.sender] &gt;= value);
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public constant returns (uint256 remaining) {
        return allowed[owner][spender];
    }

    function balanceOf(address who) public constant returns (uint256) {
        return balances[who];
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        require(to != 0x0);
        require(balances[from] &gt;= value);
        require(value &lt;= allowed[from][msg.sender]);
        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        Transfer(from, to, value);
        return true;
    }
}