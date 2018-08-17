pragma solidity ^0.4.11;


contract MaptPricing {
  // MAPT TOKEN PRICE:
  uint256 constant MAPT_IN_ETH = 100; // 1 MAPT = 0.01 ETH

  uint256 constant FRACTIONAL_DIVIDER = 100;
  uint256 constant DEFAULT_MULTIPLIER = 1 * FRACTIONAL_DIVIDER;

  uint constant MIN_ETH = 100 ether;

  uint256[4] prices;
  uint256[3] dates;
  mapping (uint256 =&gt; uint256[]) rules;

  function MaptPricing() {
  }

  function createPricing() {
    prices[0] = 3000 ether;
    prices[1] = 1500 ether;
    prices[2] = 300 ether;
    prices[3] = 100 ether;

    dates[0] = 7 days;
    dates[1] = 14 days;
    dates[2] = 140 days;

    rules[0] = [200, 150, 130, 120];
    rules[1] = [200, 145, 125, 115];
    rules[2] = [200, 145, 125, 115];
  }

  function calculatePrice(uint valueWei, uint256 timeSinceStart, uint decimals) public returns (uint tokenAmount) {
    uint Z = 1231231;
    uint m = 0;
    uint ip = Z;
    uint dp = Z;
    uint tokens;

    require(valueWei &gt;= MIN_ETH);

    if (valueWei &gt;= prices[0]) ip = 0;
    else for (uint i = 1; i &lt; prices.length &amp;&amp; ip == Z; i++) {
      if (valueWei &lt; prices[i-1] &amp;&amp; valueWei &gt;= prices[i]) ip = i;
    }

    if (ip == Z) {
      m = DEFAULT_MULTIPLIER;
    } else {
      if (timeSinceStart &lt;= dates[0]) {
        dp = 0;
      } else {
        for (i = 1; i &lt; dates.length &amp;&amp; dp == Z; i++) {
          if (timeSinceStart &gt; dates[i-1] &amp;&amp; timeSinceStart &lt; dates[i]) {
            dp = i;
          }
        }
        //later on
        if (timeSinceStart &gt; dates[dates.length-1]) {
          dp = dates.length-1;
        }
      }

      if (dp == Z) {
        m = DEFAULT_MULTIPLIER;
      } else {
        m = (rules[dp])[ip];
      }
    }

    tokens = valueWei * MAPT_IN_ETH;

    uint d = decimals;
    d++;

    uint res = tokens * m / DEFAULT_MULTIPLIER;

    return res;
  }
}

contract MaptPresaleToken {

    uint constant MIN_TRANSACTION_AMOUNT_ETH = 100 ether;

    MaptPricing priceRules = new MaptPricing();
    uint public PRESALE_START_DATE = 1503313200; //Mon Aug 21 12:00:00 +00 2017
    uint public PRESALE_END_DATE = PRESALE_START_DATE + 30 days;

    function MaptPresaleToken(address _tokenManager, address _escrow) {
        tokenManager = _tokenManager;
        escrow = _escrow;
        priceRules.createPricing();
    }

    string public constant name = &quot;MAT Presale Token&quot;;
    string public constant symbol = &quot;MAPT&quot;;
    uint   public constant decimals = 18;

    uint public constant TOKEN_SUPPLY_LIMIT = 2800000 * 1 ether / 1 wei;

    enum Phase {
        Created,
        Running,
        Paused,
        Migrating,
        Migrated
    }

    Phase public currentPhase = Phase.Created;

    uint public totalSupply = 0;

    address public tokenManager;

    address public escrow;

    address public crowdsaleManager;

    mapping (address =&gt; uint256) private balanceTable;

    modifier onlyTokenManager()     { if(msg.sender != tokenManager) throw; _; }
    modifier onlyCrowdsaleManager() { if(msg.sender != crowdsaleManager) throw; _; }

    event LogBuy(address indexed owner, uint etherWeiIncoming, uint tokensSold);
    event LogBuyForFiat(address indexed owner, uint tokensSold);
    event LogBurn(address indexed owner, uint value);
    event LogPhaseSwitch(Phase newPhase);
    event LogEscrow(uint balance);
    event LogEscrowReq(uint balance);
    event LogStartDate(uint newdate, uint oldDate);

    function() payable {
        buyTokens(msg.sender);
    }

    function burnTokens(address _owner)
        public
        onlyCrowdsaleManager
        returns (uint)
    {
        if(currentPhase != Phase.Migrating) return 1;

        uint tokens = balanceTable[_owner];
        if(tokens == 0) return 2;
        totalSupply -= tokens;
        balanceTable[_owner] = 0;
        LogBurn(_owner, tokens);

        if(totalSupply == 0) {
            currentPhase = Phase.Migrated;
            LogPhaseSwitch(Phase.Migrated);
        }

        return 0;
    }

    function balanceOf(address _owner) constant returns (uint256) {
        return balanceTable[_owner];
    }

    function setPresalePhaseUInt(uint phase)
        public
        onlyTokenManager
    {
      require( uint(Phase.Migrated) &gt;= phase &amp;&amp; phase &gt;= 0 );
      setPresalePhase(Phase(phase));
    }

    function setPresalePhase(Phase _nextPhase)
        public
        onlyTokenManager
    {
      _setPresalePhase(_nextPhase);
    }

    function _setPresalePhase(Phase _nextPhase)
        private
    {
        bool canSwitchPhase
            =  (currentPhase == Phase.Created &amp;&amp; _nextPhase == Phase.Running)
            || (currentPhase == Phase.Running &amp;&amp; _nextPhase == Phase.Paused)
            || ((currentPhase == Phase.Running || currentPhase == Phase.Paused)
                &amp;&amp; _nextPhase == Phase.Migrating
                &amp;&amp; crowdsaleManager != 0x0)
            || (currentPhase == Phase.Paused &amp;&amp; _nextPhase == Phase.Running)
            || (currentPhase == Phase.Migrating &amp;&amp; _nextPhase == Phase.Migrated
                &amp;&amp; totalSupply == 0);

        if(!canSwitchPhase) throw;
        currentPhase = _nextPhase;
        LogPhaseSwitch(_nextPhase);
    }

    function setCrowdsaleManager(address _mgr)
        public
        onlyTokenManager
    {
        if(currentPhase == Phase.Migrating) throw;
        crowdsaleManager = _mgr;
    }

    function setStartDate(uint _date)
        public
        onlyTokenManager
    {
        if(currentPhase != Phase.Created) throw;
        LogStartDate(_date, PRESALE_START_DATE);
        PRESALE_START_DATE = _date;
        PRESALE_END_DATE = PRESALE_START_DATE + 30 days;
    }

    function buyTokens(address _buyer)
        public
        payable
    {
        require(totalSupply &lt; TOKEN_SUPPLY_LIMIT);
        uint valueWei = msg.value;

        require(currentPhase == Phase.Running);
        require(valueWei &gt;= MIN_TRANSACTION_AMOUNT_ETH);
        require(now &gt;= PRESALE_START_DATE);
        require(now &lt;= PRESALE_END_DATE);

        uint timeSinceStart = now - PRESALE_START_DATE;
        uint newTokens = priceRules.calculatePrice(valueWei, timeSinceStart, 18);

        require(newTokens &gt; 0);
        require(totalSupply + newTokens &lt;= TOKEN_SUPPLY_LIMIT);

        totalSupply += newTokens;
        balanceTable[_buyer] += newTokens;

        LogBuy(_buyer, valueWei, newTokens);
    }

    function buyTokensForFiat(address _buyer, uint tokens)
        public
        onlyTokenManager
    {
      require(currentPhase == Phase.Running);
      require(tokens &gt; 0);

      uint newTokens = tokens;
      require (totalSupply + newTokens &lt;= TOKEN_SUPPLY_LIMIT);
      totalSupply += newTokens;
      balanceTable[_buyer] += newTokens;

      LogBuyForFiat(_buyer, newTokens);
    }

    function withdrawEther(uint bal)
        public
        onlyTokenManager
        returns (uint)
    {
        LogEscrowReq(bal);
        if(this.balance &gt;= bal) {
            escrow.transfer(bal);
            LogEscrow(bal);
            return 0;
        }
        return 1;
    }
}