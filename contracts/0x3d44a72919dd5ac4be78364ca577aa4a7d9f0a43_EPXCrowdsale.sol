pragma solidity ^0.4.18;
// -------------------------------------------------
// ethPoker.io EPX token - Presale &amp; ICO token sale contract
// contact <span class="__cf_email__" data-cfemail="5233363f3b3c1237263a223d3937207c3b3d">[email&#160;protected]</span> for queries
// Revision 20b
// Refunds integrated, full test suite 20r passed
// -------------------------------------------------
// ERC Token Standard #20 interface:
// https://github.com/ethereum/EIPs/issues/20
// EPX contract sources:
// https://github.com/EthPokerIO/ethpokerIO
// ------------------------------------------------
// 2018 improvements:
// - Updates to comply with latest Solidity versioning (0.4.18):
// -   Classification of internal/private vs public functions
// -   Specification of pure functions such as SafeMath integrated functions
// -   Conversion of all constant to view or pure dependant on state changed
// -   Full regression test of code updates
// -   Revision of block number timing for new Ethereum block times
// - Removed duplicate Buy/Transfer event call in buyEPXtokens function (ethScan output verified)
// - Burn event now records number of EPX tokens burned vs Refund event Eth
// - Transfer event now fired when beneficiaryWallet withdraws
// - Gas req optimisation for payable function to maximise compatibility
// - Going live for initial Presale round 02/03/2018
// -------------------------------------------------
// Security reviews passed - cycle 20r
// Functional reviews passed - cycle 20r
// Final code revision and regression test cycle passed - cycle 20r
// -------------------------------------------------

contract owned {
  address public owner;

  function owned() internal {
    owner = msg.sender;
  }
  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }
}

contract safeMath {
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    safeAssert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    safeAssert(b &gt; 0);
    uint256 c = a / b;
    safeAssert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    safeAssert(b &lt;= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    safeAssert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }

  function safeAssert(bool assertion) internal pure {
    if (!assertion) revert();
  }
}

contract StandardToken is owned, safeMath {
  function balanceOf(address who) view public returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract EPXCrowdsale is owned, safeMath {
  // owner/admin &amp; token reward
  address        public admin                     = owner;    // admin address
  StandardToken  public tokenReward;                          // address of the token used as reward

  // deployment variables for static supply sale
  uint256 private initialTokenSupply;
  uint256 private tokensRemaining;

  // multi-sig addresses and price variable
  address private beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account

  // uint256 values for min,max,caps,tracking
  uint256 public amountRaisedInWei;                           //
  uint256 public fundingMinCapInWei;                          //

  // loop control, ICO startup and limiters
  string  public CurrentStatus                    = &quot;&quot;;        // current crowdsale status
  uint256 public fundingStartBlock;                           // crowdsale start block#
  uint256 public fundingEndBlock;                             // crowdsale end block#
  bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
  bool    private areFundsReleasedToBeneficiary  = false;     // boolean for founder to receive Eth or not
  bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Buy(address indexed _sender, uint256 _eth, uint256 _EPX);
  event Refund(address indexed _refunder, uint256 _value);
  event Burn(address _from, uint256 _value);
  mapping(address =&gt; uint256) balancesArray;
  mapping(address =&gt; uint256) usersEPXfundValue;

  // default function, map admin
  function EPXCrowdsale() public onlyOwner {
    admin = msg.sender;
    CurrentStatus = &quot;Crowdsale deployed to chain&quot;;
  }

  // total number of tokens initially
  function initialEPXSupply() public view returns (uint256 initialEPXtokenCount) {
    return safeDiv(initialTokenSupply,10000); // div by 10,000 for display normalisation (4 decimals)
  }

  // remaining number of tokens
  function remainingEPXSupply() public view returns (uint256 remainingEPXtokenCount) {
    return safeDiv(tokensRemaining,10000); // div by 10,000 for display normalisation (4 decimals)
  }

  // setup the CrowdSale parameters
  function SetupCrowdsale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) public onlyOwner returns (bytes32 response) {
    if ((msg.sender == admin)
    &amp;&amp; (!(isCrowdSaleSetup))
    &amp;&amp; (!(beneficiaryWallet &gt; 0))) {
      // init addresses
      beneficiaryWallet                       = 0x7A29e1343c6a107ce78199F1b3a1d2952efd77bA;
      tokenReward                             = StandardToken(0x0C686Cd98F816bf63C037F39E73C1b7A35b51D4C);

      // funding targets
      fundingMinCapInWei                      = 30000000000000000000;                       // ETH 300 + 000000000000000000 18 dec wei

      // update values
      amountRaisedInWei                       = 0;
      initialTokenSupply                      = 200000000000;                               // 20,000,000 + 4 dec resolution
      tokensRemaining                         = initialTokenSupply;
      fundingStartBlock                       = _fundingStartBlock;
      fundingEndBlock                         = _fundingEndBlock;

      // configure crowdsale
      isCrowdSaleSetup                        = true;
      isCrowdSaleClosed                       = false;
      CurrentStatus                           = &quot;Crowdsale is setup&quot;;
      return &quot;Crowdsale is setup&quot;;
    } else if (msg.sender != admin) {
      return &quot;not authorised&quot;;
    } else  {
      return &quot;campaign cannot be changed&quot;;
    }
  }

  function checkPrice() internal view returns (uint256 currentPriceValue) {
    if (block.number &gt;= fundingStartBlock+177534) { // 30-day price change/final 30day change
      return (7600); //30days-end   =7600ARX:1ETH
    } else if (block.number &gt;= fundingStartBlock+124274) { //3 week mark/over 21days
      return (8200); //3w-30days    =8200ARX:1ETH
    } else if (block.number &gt;= fundingStartBlock) { // start [0 hrs]
      return (8800); //0-3weeks     =8800ARX:1ETH
    }
  }

  // default payable function when sending ether to this contract
  function () public payable {
    // 0. conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
    require(!(msg.value == 0)
    &amp;&amp; (msg.data.length == 0)
    &amp;&amp; (block.number &lt;= fundingEndBlock)
    &amp;&amp; (block.number &gt;= fundingStartBlock)
    &amp;&amp; (tokensRemaining &gt; 0));

    // 1. vars
    uint256 rewardTransferAmount    = 0;

    // 2. effects
    amountRaisedInWei               = safeAdd(amountRaisedInWei, msg.value);
    rewardTransferAmount            = ((safeMul(msg.value, checkPrice())) / 100000000000000);

    // 3. interaction
    tokensRemaining                 = safeSub(tokensRemaining, rewardTransferAmount);
    tokenReward.transfer(msg.sender, rewardTransferAmount);

    // 4. events
    usersEPXfundValue[msg.sender]   = safeAdd(usersEPXfundValue[msg.sender], msg.value);
    Buy(msg.sender, msg.value, rewardTransferAmount);
  }

  function beneficiaryMultiSigWithdraw(uint256 _amount) public onlyOwner {
    require(areFundsReleasedToBeneficiary &amp;&amp; (amountRaisedInWei &gt;= fundingMinCapInWei));
    beneficiaryWallet.transfer(_amount);
    Transfer(this, beneficiaryWallet, _amount);
  }

  function checkGoalReached() public onlyOwner { // return crowdfund status to owner for each result case, update public vars
    // update state &amp; status variables
    require (isCrowdSaleSetup);
    if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &lt;= fundingEndBlock &amp;&amp; block.number &gt;= fundingStartBlock)) { // ICO in progress, under softcap
      areFundsReleasedToBeneficiary = false;
      isCrowdSaleClosed = false;
      CurrentStatus = &quot;In progress (Eth &lt; Softcap)&quot;;
    } else if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &lt; fundingStartBlock)) { // ICO has not started
      areFundsReleasedToBeneficiary = false;
      isCrowdSaleClosed = false;
      CurrentStatus = &quot;Crowdsale is setup&quot;;
    } else if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &gt; fundingEndBlock)) { // ICO ended, under softcap
      areFundsReleasedToBeneficiary = false;
      isCrowdSaleClosed = true;
      CurrentStatus = &quot;Unsuccessful (Eth &lt; Softcap)&quot;;
    } else if ((amountRaisedInWei &gt;= fundingMinCapInWei) &amp;&amp; (tokensRemaining == 0)) { // ICO ended, all tokens bought!
      areFundsReleasedToBeneficiary = true;
      isCrowdSaleClosed = true;
      CurrentStatus = &quot;Successful (EPX &gt;= Hardcap)!&quot;;
    } else if ((amountRaisedInWei &gt;= fundingMinCapInWei) &amp;&amp; (block.number &gt; fundingEndBlock) &amp;&amp; (tokensRemaining &gt; 0)) { // ICO ended, over softcap!
      areFundsReleasedToBeneficiary = true;
      isCrowdSaleClosed = true;
      CurrentStatus = &quot;Successful (Eth &gt;= Softcap)!&quot;;
    } else if ((amountRaisedInWei &gt;= fundingMinCapInWei) &amp;&amp; (tokensRemaining &gt; 0) &amp;&amp; (block.number &lt;= fundingEndBlock)) { // ICO in progress, over softcap!
      areFundsReleasedToBeneficiary = true;
      isCrowdSaleClosed = false;
      CurrentStatus = &quot;In progress (Eth &gt;= Softcap)!&quot;;
    }
  }

  function refund() public { // any contributor can call this to have their Eth returned. user&#39;s purchased EPX tokens are burned prior refund of Eth.
    //require minCap not reached
    require ((amountRaisedInWei &lt; fundingMinCapInWei)
    &amp;&amp; (isCrowdSaleClosed)
    &amp;&amp; (block.number &gt; fundingEndBlock)
    &amp;&amp; (usersEPXfundValue[msg.sender] &gt; 0));

    //burn user&#39;s token EPX token balance, refund Eth sent
    uint256 ethRefund = usersEPXfundValue[msg.sender];
    balancesArray[msg.sender] = 0;
    usersEPXfundValue[msg.sender] = 0;

    //record Burn event with number of EPX tokens burned
    Burn(msg.sender, usersEPXfundValue[msg.sender]);

    //send Eth back
    msg.sender.transfer(ethRefund);

    //record Refund event with number of Eth refunded in transaction
    Refund(msg.sender, ethRefund);
  }
}