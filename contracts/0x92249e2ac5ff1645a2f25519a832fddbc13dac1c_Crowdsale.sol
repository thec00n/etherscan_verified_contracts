pragma solidity ^0.4.15;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract Ownable {

  address public owner;
  function Ownable() { owner = msg.sender; }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner {owner = newOwner;}
}

contract ERC20Interface {

  function totalSupply() constant returns (uint256);

  function balanceOf(address _owner) constant returns (uint256);

  function transfer(address _to, uint256 _value) returns (bool);

  function transferFrom(address _from, address _to, uint256 _value) returns (bool);

  function approve(address _spender, uint256 _value) returns (bool);

  function allowance(address _owner, address _spender) constant returns (uint256);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

 }

contract GMPToken is Ownable, ERC20Interface {

  using SafeMath for uint256;

  /* Public variables of the token */
  string public constant name = &quot;GMP Coin&quot;;
  string public constant symbol = &quot;GMP&quot;;
  uint public constant decimals = 18;
  uint256 public constant initialSupply = 220000000 * 1 ether;
  uint256 public totalSupply;

  /* This creates an array with all balances */
  mapping (address =&gt; uint256) public balances;
  mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;

  /* Events */
  event Burn(address indexed burner, uint256 value);
  event Mint(address indexed to, uint256 amount);

  /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */
  function GMPToken() {
      balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
      totalSupply = initialSupply;                        // Update total supply
  }


  /* Implementation of ERC20Interface */

  function totalSupply() constant returns (uint256) { return totalSupply; }

  function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }

  /* Internal transfer, only can be called by this contract */
  function _transfer(address _from, address _to, uint _amount) internal {
      require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
      require (balances[_from] &gt; _amount);                // Check if the sender has enough
      balances[_from] = balances[_from].sub(_amount);
      balances[_to] = balances[_to].add(_amount);
      Transfer(_from, _to, _amount);

  }

  function transfer(address _to, uint256 _amount) returns (bool) {
    _transfer(msg.sender, _to, _amount);
    return true;
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
    require (_value &lt; allowed[_from][msg.sender]);     // Check allowance
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    _transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _amount) returns (bool) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  function allowance(address _owner, address _spender) constant returns (uint256) {
    return allowed[_owner][_spender];
  }

  function mintToken(uint256 _mintedAmount) onlyOwner {
    balances[Ownable.owner] = balances[Ownable.owner].add(_mintedAmount);
    totalSupply = totalSupply.add(_mintedAmount);
    Mint(Ownable.owner, _mintedAmount);
  }

  //For refund only
  function burnToken(address _burner, uint256 _value) onlyOwner {
    require(_value &gt; 0);
    require(_value &lt;= balances[_burner]);

    balances[_burner] = balances[_burner].sub(_value);
    totalSupply = totalSupply.sub(_value);
    Burn(_burner, _value);
  }


}


contract Crowdsale is Ownable {

  using SafeMath for uint256;

  // The token being sold
  GMPToken public token;

  // Flag setting that investments are allowed (both inclusive)
  bool public saleIsActive;

  // address where funds are collected
  address public wallet;

  // Number of tokents for 1 ETH, i.e. 683 tokens for 1 ETH
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  /* -----------   A D M I N        F U N C T I O N S    ----------- */

  function Crowdsale(uint256 _initialRate, address _targetWallet) {

    //Checks
    require(_initialRate &gt; 0);
    require(_targetWallet != 0x0);

    //Init
    token = new GMPToken();
    rate = _initialRate;
    wallet = _targetWallet;
    saleIsActive = true;

  }

  function close() onlyOwner {
    selfdestruct(owner);
  }

  //Transfer token to
  function transferToAddress(address _targetWallet, uint256 _tokenAmount) onlyOwner {
    token.transfer(_targetWallet, _tokenAmount * 1 ether);
  }


  //Setters
  function enableSale() onlyOwner {
    saleIsActive = true;
  }

  function disableSale() onlyOwner {
    saleIsActive = false;
  }

  function setRate(uint256 _newRate)  onlyOwner {
    rate = _newRate;
  }

  //Mint new tokens
  function mintToken(uint256 _mintedAmount) onlyOwner {
    token.mintToken(_mintedAmount);
  }



  /* -----------   P U B L I C      C A L L B A C K       F U N C T I O N     ----------- */

  function () payable {

    require(msg.sender != 0x0);
    require(saleIsActive);
    require(msg.value &gt; 0.01 * 1 ether);

    uint256 weiAmount = msg.value;

    //Update total wei counter
    weiRaised = weiRaised.add(weiAmount);

    //Calc number of tokents
    uint256 tokenAmount = weiAmount.mul(rate);

    //Forward wei to wallet account
    wallet.transfer(weiAmount);

    //Transfer token to sender
    token.transfer(msg.sender, tokenAmount);
    TokenPurchase(msg.sender, wallet, weiAmount, tokenAmount);

  }



}