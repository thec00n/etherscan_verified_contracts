pragma solidity ^0.4.18;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract ERC20Token {

  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function mint(address _to, uint256 _amount) public returns (bool);
  function totalSupply() public returns (uint256);

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
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale is Ownable {
  using SafeMath for uint256;

  ERC20Token token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  uint256 public maxWei;

  bool paused;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, address _token, uint256 _maxWei) public {
    require(_startTime &gt;= now);
    require(_endTime &gt;= _startTime);
    require(_rate &gt; 0);
    require(_wallet != address(0));
    require(_token != address(0));
    require(_maxWei &gt; 0);

    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;
    token = ERC20Token(_token);
    maxWei = _maxWei;
    paused = false;
  }

  /**
   * @notice Funtion to update exchange rate
   * @dev Only owner is allowed
   * @param _rate new exchange rate
   */
  function updateRate(uint256 _rate) public onlyOwner {
    rate = _rate;
  }

  /**
   * @notice Funtion to update maxWei contribution
   * @dev Only owner is allowed
   * @param _maxWei new maxWei contribution
   */
  function updateMaxWei(uint256 _maxWei) public onlyOwner {
    maxWei = _maxWei;
  }

  /**
   * @notice Funtion to update wallet for contributions
   * @dev Only owner is allowed
   * @param _newWallet new maxWei contribution
   */
  function updateWallet(address _newWallet) public onlyOwner {
    wallet = _newWallet;
  }

  /**
   * @notice Funtion to pause the sale
   * @dev Only owner is allowed
   * @param _flag bool to set or unset pause on sale
   */
  function pauseSale(bool _flag) public onlyOwner {
    paused = _flag;
  }

  // fallback function can be used to buy tokens
  function () external payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) public payable {
    require(paused == false);
    require(msg.value &lt;= maxWei);
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = weiAmount.mul(rate);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    token.mint(beneficiary, tokens);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now &gt;= startTime &amp;&amp; now &lt;= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod &amp;&amp; nonZeroPurchase;
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    return now &gt; endTime;
  }


}

/**
 * @title CappedCrowdsale
 * @dev Extension of Crowdsale with a max amount of funds raised
 */
contract CappedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public cap;

  function CappedCrowdsale(uint256 _cap) public {
    require(_cap &gt; 0);
    cap = _cap;
  }

  /**
   * @notice Funtion to updateCap
   * @dev Only owner is allowed
   * @param _newCap new cap of the crowdsale
   */

  function updateCap(uint256 _newCap) public onlyOwner {
    require(_newCap &gt; weiRaised);
    cap = _newCap;
  }

  // overriding Crowdsale#validPurchase to add extra cap logic
  // @return true if investors can buy at the moment
  function validPurchase() internal view returns (bool) {
    bool withinCap = weiRaised.add(msg.value) &lt;= cap;
    return super.validPurchase() &amp;&amp; withinCap;
  }

  // overriding Crowdsale#hasEnded to add cap logic
  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    bool capReached = weiRaised &gt;= cap;
    return super.hasEnded() || capReached;
  }

}

/**
 * @title PrimelendTokenCrowdsale
 */
contract PrimelendPrivateSale is CappedCrowdsale {


  function PrimelendPrivateSale(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, address _wallet, address _token, uint256 _maxWei) public
    CappedCrowdsale(_cap)
    Crowdsale(_startTime, _endTime, _rate, _wallet, _token, _maxWei)
  {
      require(_maxWei &gt; 0);

  }

  function updateEndTime(uint256 _unixTime) public onlyOwner {

    endTime = _unixTime;
    require(endTime &gt; now);

  }

}