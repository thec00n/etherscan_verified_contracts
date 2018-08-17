pragma solidity ^0.4.18;

/// @title Ownable contract
library SafeMath {

  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a / b;
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

/// @title Ownable contract
contract Ownable {
  
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /// @dev Change ownership
  /// @param newOwner Address of the new owner
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/// @title ERC20 contract
/// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
contract ERC20 {
  uint public totalSupply;
  function balanceOf(address who) public constant returns (uint);
  function transfer(address to, uint value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint value);
  
  function allowance(address owner, address spender) public constant returns (uint);
  function transferFrom(address from, address to, uint value) public returns (bool);
  function approve(address spender, uint value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint value);
}

/// @title ExtendedERC20 contract
contract ExtendedERC20 is ERC20 {
  function mint(address _to, uint _amount) public returns (bool);
}

/// @title WizzleInfinityHelper contract
contract WizzleInfinityHelper {
  function isWhitelisted(address addr) public constant returns (bool);
}

/// @title Crowdsale contract
contract Crowdsale is Ownable {
  using SafeMath for uint256;
  
  /// Token reference
  ExtendedERC20 public token;
  /// WizzleInfinityHelper reference - helper for whitelisting
  WizzleInfinityHelper public helper;
  /// Presale start time (inclusive)
  uint256 public startTimePre;
  /// Presale end time (inclusive)
  uint256 public endTimePre;
  /// ICO start time (inclusive)
  uint256 public startTimeIco;
  /// ICO end time (inclusive)
  uint256 public endTimeIco;
  /// Address where the funds will be collected
  address public wallet;
  /// EUR per 1 ETH rate
  uint32 public rate;
  /// Amount of tokens sold in presale
  uint256 public tokensSoldPre;
  /// Amount of tokens sold in ICO
  uint256 public tokensSoldIco;
  /// Amount of raised ethers expressed in weis
  uint256 public weiRaised;
  /// Number of contributors
  uint256 public contributors;
  /// Presale cap
  uint256 public preCap;
  /// ICO cap
  uint256 public icoCap;
  /// Presale discount percentage
  uint8 public preDiscountPercentage;
  /// Amount of tokens in ICO discount level 1 
  uint256 public icoDiscountLevel1;
  /// Amount of tokens in ICO discount level 2
  uint256 public icoDiscountLevel2;
  /// ICO discount percentage 1
  uint8 public icoDiscountPercentageLevel1;
  /// ICO discount percentage 2
  uint8 public icoDiscountPercentageLevel2;
  /// ICO discount percentage 3
  uint8 public icoDiscountPercentageLevel3;

  function Crowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _rate, address _wallet, address _tokenAddress, address _helperAddress) {
    require(_startTimePre &gt;= now);
    require(_endTimePre &gt;= _startTimePre);
    require(_startTimeIco &gt;= _endTimePre);
    require(_endTimeIco &gt;= _startTimeIco);
    require(_rate &gt; 0);
    require(_wallet != address(0));
    require(_tokenAddress != address(0));
    require(_helperAddress != address(0));
    startTimePre = _startTimePre;
    endTimePre = _endTimePre;
    startTimeIco = _startTimeIco;
    endTimeIco = _endTimeIco;
    rate = _rate;
    wallet = _wallet;
    token = ExtendedERC20(_tokenAddress);
    helper = WizzleInfinityHelper(_helperAddress);
    preCap = 1500 * 10**24;           // 1500m tokens
    preDiscountPercentage = 50;       // 50% discount
    icoCap = 3450 * 10**24;           // 3450m tokens (500m + 500m + 2450m)
    icoDiscountLevel1 = 500 * 10**24; // 500m tokens 
    icoDiscountLevel2 = 500 * 10**24; // 500m tokens
    icoDiscountPercentageLevel1 = 40; // 40% discount
    icoDiscountPercentageLevel2 = 30; // 30% discount
    icoDiscountPercentageLevel3 = 25; // 25% discount
  }

  /// @dev Set the rate of ETH - EUR
  /// @param _rate Rate of ETH - EUR
  function setRate(uint32 _rate) public onlyOwner {
    require(_rate &gt; 0);
    rate = _rate;
  }

  /// @dev Fallback function for crowdsale contribution
  function () payable {
    buyTokens(msg.sender);
  }

  /// @dev Buy tokens function
  /// @param beneficiary Address which will receive the tokens
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(helper.isWhitelisted(beneficiary));
    uint256 weiAmount = msg.value;
    require(weiAmount &gt; 0);
    uint256 tokenAmount = 0;
    if (isPresale()) {
      /// Minimum contribution of 1 ether during presale
      require(weiAmount &gt;= 1 ether); 
      tokenAmount = getTokenAmount(weiAmount, preDiscountPercentage);
      uint256 newTokensSoldPre = tokensSoldPre.add(tokenAmount);
      require(newTokensSoldPre &lt;= preCap);
      tokensSoldPre = newTokensSoldPre;
    } else if (isIco()) {
      uint8 discountPercentage = getIcoDiscountPercentage();
      tokenAmount = getTokenAmount(weiAmount, discountPercentage);
      /// Minimum contribution 1 token during ICO
      require(tokenAmount &gt;= 10**18); 
      uint256 newTokensSoldIco = tokensSoldIco.add(tokenAmount);
      require(newTokensSoldIco &lt;= icoCap);
      tokensSoldIco = newTokensSoldIco;
    } else {
      /// Stop execution and return remaining gas
      require(false);
    }
    executeTransaction(beneficiary, weiAmount, tokenAmount);
  }

  /// @dev Internal function used for calculating ICO discount percentage depending on levels
  function getIcoDiscountPercentage() internal constant returns (uint8) {
    if (tokensSoldIco &lt;= icoDiscountLevel1) {
      return icoDiscountPercentageLevel1;
    } else if (tokensSoldIco &lt;= icoDiscountLevel1.add(icoDiscountLevel2)) {
      return icoDiscountPercentageLevel2;
    } else { 
      return icoDiscountPercentageLevel3; //for everything else
    }
  }

  /// @dev Internal function used to calculate amount of tokens based on discount percentage
  function getTokenAmount(uint256 weiAmount, uint8 discountPercentage) internal constant returns (uint256) {
    /// Less than 100 to avoid division with zero
    require(discountPercentage &gt;= 0 &amp;&amp; discountPercentage &lt; 100); 
    uint256 baseTokenAmount = weiAmount.mul(rate);
    uint256 tokenAmount = baseTokenAmount.mul(10000).div(100 - discountPercentage);
    return tokenAmount;
  }

  /// @dev Internal function for execution of crowdsale transaction and proper logging used by payable functions
  function executeTransaction(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
    weiRaised = weiRaised.add(weiAmount);
    token.mint(beneficiary, tokenAmount);
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokenAmount);
	  contributors = contributors.add(1);
    wallet.transfer(weiAmount);
  }

  /// @dev Used to change presale cap (maximum tokens sold during presale)
  /// @param _preCap Presale cap
  function changePresaleCap(uint256 _preCap) public onlyOwner {
    require(_preCap &gt; 0);
    PresaleCapChanged(owner, _preCap);
    preCap = _preCap;
  }

  /// @dev Used to change presale discount percentage
  /// @param _preDiscountPercentage Presale discount percentage
  function changePresaleDiscountPercentage(uint8 _preDiscountPercentage) public onlyOwner {
    require(_preDiscountPercentage &gt;= 0 &amp;&amp; _preDiscountPercentage &lt; 100);
    PresaleDiscountPercentageChanged(owner, _preDiscountPercentage);
    preDiscountPercentage = _preDiscountPercentage;
  }

  /// @dev Used to change presale time
  /// @param _startTimePre Start time of presale
  /// @param _endTimePre End time of presale
  function changePresaleTimeRange(uint256 _startTimePre, uint256 _endTimePre) public onlyOwner {
    require(_endTimePre &gt;= _startTimePre);
    PresaleTimeRangeChanged(owner, _startTimePre, _endTimePre);
    startTimePre = _startTimePre;
    endTimePre = _endTimePre;
  }

  /// @dev Used to change ICO cap in case the hard cap has been reached
  /// @param _icoCap ICO cap
  function changeIcoCap(uint256 _icoCap) public onlyOwner {
    require(_icoCap &gt; 0);
    IcoCapChanged(owner, _icoCap);
    icoCap = _icoCap;
  }

  /// @dev Used to change time of ICO
  /// @param _startTimeIco Start time of ICO
  /// @param _endTimeIco End time of ICO
  function changeIcoTimeRange(uint256 _startTimeIco, uint256 _endTimeIco) public onlyOwner {
    require(_endTimeIco &gt;= _startTimeIco);
    IcoTimeRangeChanged(owner, _startTimeIco, _endTimeIco);
    startTimeIco = _startTimeIco;
    endTimeIco = _endTimeIco;
  }

  /// @dev Change amount of tokens in discount phases
  /// @param _icoDiscountLevel1 Amount of tokens in first phase
  /// @param _icoDiscountLevel2 Amount of tokens in second phase
  function changeIcoDiscountLevels(uint256 _icoDiscountLevel1, uint256 _icoDiscountLevel2) public onlyOwner {
    require(_icoDiscountLevel1 &gt; 0 &amp;&amp; _icoDiscountLevel2 &gt; 0);
    IcoDiscountLevelsChanged(owner, _icoDiscountLevel1, _icoDiscountLevel2);
    icoDiscountLevel1 = _icoDiscountLevel1;
    icoDiscountLevel2 = _icoDiscountLevel2;
  }

  /// @dev Change discount percentages for different phases
  /// @param _icoDiscountPercentageLevel1 Discount percentage of phase 1
  /// @param _icoDiscountPercentageLevel2 Discount percentage of phase 2
  /// @param _icoDiscountPercentageLevel3 Discount percentage of phase 3
  function changeIcoDiscountPercentages(uint8 _icoDiscountPercentageLevel1, uint8 _icoDiscountPercentageLevel2, uint8 _icoDiscountPercentageLevel3) public onlyOwner {
    require(_icoDiscountPercentageLevel1 &gt;= 0 &amp;&amp; _icoDiscountPercentageLevel1 &lt; 100);
    require(_icoDiscountPercentageLevel2 &gt;= 0 &amp;&amp; _icoDiscountPercentageLevel2 &lt; 100);
    require(_icoDiscountPercentageLevel3 &gt;= 0 &amp;&amp; _icoDiscountPercentageLevel3 &lt; 100);
    IcoDiscountPercentagesChanged(owner, _icoDiscountPercentageLevel1, _icoDiscountPercentageLevel2, _icoDiscountPercentageLevel3);
    icoDiscountPercentageLevel1 = _icoDiscountPercentageLevel1;
    icoDiscountPercentageLevel2 = _icoDiscountPercentageLevel2;
    icoDiscountPercentageLevel3 = _icoDiscountPercentageLevel3;
  }

  /// @dev Check if presale is active
  function isPresale() public constant returns (bool) {
    return now &gt;= startTimePre &amp;&amp; now &lt;= endTimePre;
  }

  /// @dev Check if ICO is active
  function isIco() public constant returns (bool) {
    return now &gt;= startTimeIco &amp;&amp; now &lt;= endTimeIco;
  }

  /// @dev Check if presale has ended
  function hasPresaleEnded() public constant returns (bool) {
    return now &gt; endTimePre;
  }

  /// @dev Check if ICO has ended
  function hasIcoEnded() public constant returns (bool) {
    return now &gt; endTimeIco;
  }

  /// @dev Amount of tokens that have been sold during both presale and ICO phase
  function cummulativeTokensSold() public constant returns (uint256) {
    return tokensSoldPre + tokensSoldIco;
  }

  /// @dev Function to extract mistakenly sent ERC20 tokens sent to Crowdsale contract
  /// @param _token Address of token we want to extract
  function claimTokens(address _token) public onlyOwner {
    if (_token == address(0)) { 
         owner.transfer(this.balance);
         return;
    }

    ERC20 erc20Token = ERC20(_token);
    uint balance = erc20Token.balanceOf(this);
    erc20Token.transfer(owner, balance);
    ClaimedTokens(_token, owner, balance);
  }

  /// Events
  event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
  event PresaleTimeRangeChanged(address indexed _owner, uint256 _startTimePre, uint256 _endTimePre);
  event PresaleCapChanged(address indexed _owner, uint256 _preCap);
  event PresaleDiscountPercentageChanged(address indexed _owner, uint8 _preDiscountPercentage);
  event IcoCapChanged(address indexed _owner, uint256 _icoCap);
  event IcoTimeRangeChanged(address indexed _owner, uint256 _startTimeIco, uint256 _endTimeIco);
  event IcoDiscountLevelsChanged(address indexed _owner, uint256 _icoDiscountLevel1, uint256 _icoDiscountLevel2);
  event IcoDiscountPercentagesChanged(address indexed _owner, uint8 _icoDiscountPercentageLevel1, uint8 _icoDiscountPercentageLevel2, uint8 _icoDiscountPercentageLevel3);
  event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);

}

/// @title WizzleInfinityTokenCrowdsale contract
contract WizzleInfinityTokenCrowdsale is Crowdsale {

  function WizzleInfinityTokenCrowdsale(uint256 _startTimePre, uint256 _endTimePre, uint256 _startTimeIco, uint256 _endTimeIco, uint32 _rate, address _wallet, address _tokenAddress, address _helperAddress) 
  Crowdsale(_startTimePre, _endTimePre, _startTimeIco, _endTimeIco, _rate, _wallet, _tokenAddress, _helperAddress) public {

  }

}