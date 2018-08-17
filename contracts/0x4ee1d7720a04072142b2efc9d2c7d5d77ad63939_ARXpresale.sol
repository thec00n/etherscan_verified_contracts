pragma solidity ^0.4.13;
// -------------------------------------------------
// 0.4.13+commit.0fb4cb1a
// [Assistive Reality ARX token ETH cap presale contract]
// [Contact <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="3340475255557352415c5d5f5a5d561d5a5c">[email&#160;protected]</a> for any queries]
// [Join us in changing the world]
// [aronline.io]
// -------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
// -------------------------------------------------
// 1,000 ETH capped Pre-sale contract
// Security reviews completed 26/09/17 [passed OK]
// Functional reviews completed 26/09/17 [passed OK]
// Final code revision and regression test cycle complete 26/09/17 [passed OK]
// -------------------------------------------------

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract safeMath {
  function safeMul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    safeAssert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
    safeAssert(b &gt; 0);
    uint256 c = a / b;
    safeAssert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal returns (uint256) {
    safeAssert(b &lt;= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    safeAssert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }

  function safeAssert(bool assertion) internal {
    if (!assertion) revert();
  }
}

contract ERC20Interface is owned, safeMath {
  function balanceOf(address _owner) constant returns (uint256 balance);
  function transfer(address _to, uint256 _value) returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
  function approve(address _spender, uint256 _value) returns (bool success);
  function increaseApproval (address _spender, uint _addedValue) returns (bool success);
  function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
  function allowance(address _owner, address _spender) constant returns (uint256 remaining);
  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ARXpresale is owned, safeMath {
  // owner/admin &amp; token reward
  address         public admin                   = owner;     // admin address
  ERC20Interface  public tokenReward;                         // address of the token used as reward

  // multi-sig addresses and price variable
  address public foundationWallet;                            // foundationMultiSig (foundation fund) or wallet account, for company operations/licensing of Assistive Reality products
  address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account, live is 0x00F959866E977698D14a36eB332686304a4d6AbA
  uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 1,500 tokens per Eth

  // uint256 values for min,max caps &amp; tracking
  uint256 public amountRaisedInWei;                           // 0 initially (0)
  uint256 public fundingMinCapInWei;                          // 100 ETH (10%) (100 000 000 000 000 000 000)
  uint256 public fundingMaxCapInWei;                          // 1,000 ETH in Wei (1000 000 000 000 000 000 000)
  uint256 public fundingRemainingAvailableInEth;              // ==((fundingMaxCapInWei - amountRaisedInWei)/1 ether); (resolution will only be to integer)

  // loop control, ICO startup and limiters
  string  public currentStatus                   = &quot;&quot;;        // current presale status
  uint256 public fundingStartBlock;                           // presale start block#
  uint256 public fundingEndBlock;                             // presale end block#
  bool    public isPresaleClosed                 = false;     // presale completion boolean
  bool    public isPresaleSetup                  = false;     // boolean for presale setup

  event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  event Refund(address indexed _refunder, uint256 _value);
  event Burn(address _from, uint256 _value);

  mapping(address =&gt; uint256) balances;
  mapping(address =&gt; uint256) fundValue;

  // default function, map admin
  function ARXpresale() onlyOwner {
    admin = msg.sender;
    currentStatus = &quot;presale deployed to chain&quot;;
  }

  // setup the presale parameters
  function Setuppresale(uint256 _fundingStartBlock, uint256 _fundingEndBlock) onlyOwner returns (bytes32 response) {
      if ((msg.sender == admin)
      &amp;&amp; (!(isPresaleSetup))
      &amp;&amp; (!(beneficiaryWallet &gt; 0))){
          // init addresses
          tokenReward                             = ERC20Interface(0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5);   // mainnet is 0xb0D926c1BC3d78064F3e1075D5bD9A24F35Ae6C5
          beneficiaryWallet                       = 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f;                   // mainnet is 0xd93333f8cb765397A5D0d0e0ba53A2899B48511f
          foundationWallet                        = 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA;                   // mainnet is 0x70A0bE1a5d8A9F39afED536Ec7b55d87067371aA
          tokensPerEthPrice                       = 8000;                                                         // set day1 presale value floating priceVar 8,000 ARX tokens per 1 ETH

          // funding targets
          fundingMinCapInWei                      = 100000000000000000000;                                        // 100000000000000000000  = 100 Eth (min cap) //testnet 2500000000000000000   = 2.5 Eth
          fundingMaxCapInWei                      = 1000000000000000000000;                                       // 1000000000000000000000 = 1000 Eth (max cap) //testnet 6500000000000000000  = 6.5 Eth

          // update values
          amountRaisedInWei                       = 0;                                                            // init value to 0
          fundingRemainingAvailableInEth          = safeDiv(fundingMaxCapInWei,1 ether);

          fundingStartBlock                       = _fundingStartBlock;
          fundingEndBlock                         = _fundingEndBlock;

          // configure presale
          isPresaleSetup                          = true;
          isPresaleClosed                         = false;
          currentStatus                           = &quot;presale is setup&quot;;

          //gas reduction experiment
          setPrice();
          return &quot;presale is setup&quot;;
      } else if (msg.sender != admin) {
          return &quot;not authorized&quot;;
      } else  {
          return &quot;campaign cannot be changed&quot;;
      }
    }

    function setPrice() {
      // Price configuration mainnet:
      // Day 0-1 Price   1 ETH = 8000 ARX [blocks: start    -&gt; s+3600]  0 - +24hr
      // Day 1-3 Price   1 ETH = 7250 ARX [blocks: s+3601   -&gt; s+10800] +24hr - +72hr
      // Day 3-5 Price   1 ETH = 6750 ARX [blocks: s+10801  -&gt; s+18000] +72hr - +120hr
      // Dau 5-7 Price   1 ETH = 6250 ARX [blocks: s+18001  -&gt; &lt;=fundingEndBlock] = +168hr (168/24 = 7 [x])

      if (block.number &gt;= fundingStartBlock &amp;&amp; block.number &lt;= fundingStartBlock+3600) { // 8000 ARX Day 1 level only
        tokensPerEthPrice=8000;
      } else if (block.number &gt;= fundingStartBlock+3601 &amp;&amp; block.number &lt;= fundingStartBlock+10800) { // 7250 ARX Day 2,3
        tokensPerEthPrice=7250;
      } else if (block.number &gt;= fundingStartBlock+10801 &amp;&amp; block.number &lt;= fundingStartBlock+18000) { // 6750 ARX Day 4,5
        tokensPerEthPrice=6750;
      } else if (block.number &gt;= fundingStartBlock+18001 &amp;&amp; block.number &lt;= fundingEndBlock) { // 6250 ARX Day 6,7
        tokensPerEthPrice=6250;
      } else {
        tokensPerEthPrice=6250; // default back out to this value instead of failing to return or return 0/halting;
      }
    }

    // default payable function when sending ether to this contract
    function () payable {
      require(msg.data.length == 0);
      BuyARXtokens();
    }

    function BuyARXtokens() payable {
      // 0. conditions (length, presale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
      require(!(msg.value == 0)
      &amp;&amp; (isPresaleSetup)
      &amp;&amp; (block.number &gt;= fundingStartBlock)
      &amp;&amp; (block.number &lt;= fundingEndBlock)
      &amp;&amp; !(safeAdd(amountRaisedInWei,msg.value) &gt; fundingMaxCapInWei));

      // 1. vars
      uint256 rewardTransferAmount    = 0;

      // 2. effects
      setPrice();
      amountRaisedInWei               = safeAdd(amountRaisedInWei,msg.value);
      rewardTransferAmount            = safeMul(msg.value,tokensPerEthPrice);
      fundingRemainingAvailableInEth  = safeDiv(safeSub(fundingMaxCapInWei,amountRaisedInWei),1 ether);

      // 3. interaction
      tokenReward.transfer(msg.sender, rewardTransferAmount);
      fundValue[msg.sender]           = safeAdd(fundValue[msg.sender], msg.value);

      // 4. events
      Transfer(this, msg.sender, msg.value);
      Buy(msg.sender, msg.value, rewardTransferAmount);
    }

    function beneficiaryMultiSigWithdraw(uint256 _amount) onlyOwner {
      require(amountRaisedInWei &gt;= fundingMinCapInWei);
      beneficiaryWallet.transfer(_amount);
    }

    function checkGoalandPrice() onlyOwner returns (bytes32 response) {
      // update state &amp; status variables
      require (isPresaleSetup);
      if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &lt;= fundingEndBlock &amp;&amp; block.number &gt;= fundingStartBlock)) { // presale in progress, under softcap
        currentStatus = &quot;In progress (Eth &lt; Softcap)&quot;;
        return &quot;In progress (Eth &lt; Softcap)&quot;;
      } else if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &lt; fundingStartBlock)) { // presale has not started
        currentStatus = &quot;presale is setup&quot;;
        return &quot;presale is setup&quot;;
      } else if ((amountRaisedInWei &lt; fundingMinCapInWei) &amp;&amp; (block.number &gt; fundingEndBlock)) { // presale ended, under softcap
        currentStatus = &quot;Unsuccessful (Eth &lt; Softcap)&quot;;
        return &quot;Unsuccessful (Eth &lt; Softcap)&quot;;
      } else if (amountRaisedInWei &gt;= fundingMaxCapInWei) {  // presale successful, at hardcap!
          currentStatus = &quot;Successful (ARX &gt;= Hardcap)!&quot;;
          return &quot;Successful (ARX &gt;= Hardcap)!&quot;;
      } else if ((amountRaisedInWei &gt;= fundingMinCapInWei) &amp;&amp; (block.number &gt; fundingEndBlock)) { // presale ended, over softcap!
          currentStatus = &quot;Successful (Eth &gt;= Softcap)!&quot;;
          return &quot;Successful (Eth &gt;= Softcap)!&quot;;
      } else if ((amountRaisedInWei &gt;= fundingMinCapInWei) &amp;&amp; (block.number &lt;= fundingEndBlock)) { // presale in progress, over softcap!
        currentStatus = &quot;In progress (Eth &gt;= Softcap)!&quot;;
        return &quot;In progress (Eth &gt;= Softcap)!&quot;;
      }
      setPrice();
    }

    function refund() { // any contributor can call this to have their Eth returned. user&#39;s purchased ARX tokens are burned prior refund of Eth.
      //require minCap not reached
      require ((amountRaisedInWei &lt; fundingMinCapInWei)
      &amp;&amp; (isPresaleClosed)
      &amp;&amp; (block.number &gt; fundingEndBlock)
      &amp;&amp; (fundValue[msg.sender] &gt; 0));

      //burn user&#39;s token ARX token balance, refund Eth sent
      uint256 ethRefund = fundValue[msg.sender];
      balances[msg.sender] = 0;
      fundValue[msg.sender] = 0;
      Burn(msg.sender, ethRefund);

      //send Eth back, burn tokens
      msg.sender.transfer(ethRefund);
      Refund(msg.sender, ethRefund);
    }

    function withdrawRemainingTokens(uint256 _amountToPull) onlyOwner {
      require(block.number &gt;= fundingEndBlock);
      tokenReward.transfer(msg.sender, _amountToPull);
    }

    function updateStatus() onlyOwner {
      require((block.number &gt;= fundingEndBlock) || (amountRaisedInWei &gt;= fundingMaxCapInWei));
      isPresaleClosed = true;
      currentStatus = &quot;packagesale is closed&quot;;
    }
  }