pragma solidity 0.4.18;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
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


contract Telcoin {
    using SafeMath for uint256;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    string public constant name = &quot;Telcoin&quot;;
    string public constant symbol = &quot;TEL&quot;;
    uint8 public constant decimals = 2;

    /// The ERC20 total fixed supply of tokens.
    uint256 public constant totalSupply = 100000000000 * (10 ** uint256(decimals));

    /// Account balances.
    mapping(address =&gt; uint256) balances;

    /// The transfer allowances.
    mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;

    /// The initial distributor is responsible for allocating the supply
    /// into the various pools described in the whitepaper. This can be
    /// verified later from the event log.
    function Telcoin(address _distributor) public {
        balances[_distributor] = totalSupply;
        Transfer(0x0, _distributor, totalSupply);
    }

    /// ERC20 balanceOf().
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    /// ERC20 transfer().
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    /// ERC20 transferFrom().
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[_from]);
        require(_value &lt;= allowed[_from][msg.sender]);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    /// ERC20 approve(). Comes with the standard caveat that an approval
    /// meant to limit spending may actually allow more to be spent due to
    /// unfortunate ordering of transactions. For safety, this method
    /// should only be called if the current allowance is 0. Alternatively,
    /// non-ERC20 increaseApproval() and decreaseApproval() can be used.
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    /// ERC20 allowance().
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    /// Not officially ERC20. Allows an allowance to be increased safely.
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    /// Not officially ERC20. Allows an allowance to be decreased safely.
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue &gt; oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}


contract TelcoinSaleToken {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event Redeem(address indexed beneficiary, uint256 sacrificedValue, uint256 grantedValue);
    event Transfer(address indexed from, address indexed to, uint256 value);

    /// The owner of the contract.
    address public owner;

    /// The total number of minted tokens, excluding destroyed tokens.
    uint256 public totalSupply;

    /// The token balance and released amount of each address.
    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; uint256) redeemed;

    /// Whether the token is still mintable.
    bool public mintingFinished = false;

    /// Redeemable telcoin.
    Telcoin telcoin;
    uint256 public totalRedeemed;

    /// Vesting period.
    uint256 vestingStart;
    uint256 vestingDuration;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function TelcoinSaleToken(
        Telcoin _telcoin,
        uint256 _vestingStart,
        uint256 _vestingDuration
    )
        public
    {
        owner = msg.sender;
        telcoin = _telcoin;
        vestingStart = _vestingStart;
        vestingDuration = _vestingDuration;
    }

    function finishMinting() onlyOwner public returns (bool) {
        require(!mintingFinished);

        mintingFinished = true;
        MintFinished();

        return true;
    }

    function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
        require(_to != 0x0);
        require(!mintingFinished);
        require(_amount &gt; 0);

        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        Transfer(0x0, _to, _amount);

        return true;
    }

    function redeemMany(address[] _beneficiaries) public {
        for (uint256 i = 0; i &lt; _beneficiaries.length; i++) {
            redeem(_beneficiaries[i]);
        }
    }

    function redeem(address _beneficiary) public returns (uint256) {
        require(mintingFinished);
        require(_beneficiary != 0x0);

        uint256 balance = redeemableBalance(_beneficiary);
        if (balance == 0) {
            return 0;
        }

        uint256 totalDistributable = telcoin.balanceOf(this).add(totalRedeemed);

        // Avoid loss of precision by multiplying and later dividing by
        // a large value.
        uint256 amount = balance.mul(10 ** 18).div(totalSupply).mul(totalDistributable).div(10 ** 18);

        balances[_beneficiary] = balances[_beneficiary].sub(balance);
        redeemed[_beneficiary] = redeemed[_beneficiary].add(balance);
        balances[telcoin] = balances[telcoin].add(balance);
        totalRedeemed = totalRedeemed.add(amount);

        Transfer(_beneficiary, telcoin, balance);
        Redeem(_beneficiary, balance, amount);

        telcoin.transfer(_beneficiary, amount);

        return amount;
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != address(0));
        OwnershipTransferred(owner, _to);
        owner = _to;
    }

    function balanceOf(address _owner) public constant returns (uint256) {
        return balances[_owner];
    }

    function redeemableBalance(address _beneficiary) public constant returns (uint256) {
        return vestedBalance(_beneficiary).sub(redeemed[_beneficiary]);
    }

    function vestedBalance(address _beneficiary) public constant returns (uint256) {
        uint256 currentBalance = balances[_beneficiary];
        uint256 totalBalance = currentBalance.add(redeemed[_beneficiary]);

        if (now &lt; vestingStart) {
            return 0;
        }

        if (now &gt;= vestingStart.add(vestingDuration)) {
            return totalBalance;
        }

        return totalBalance.mul(now.sub(vestingStart)).div(vestingDuration);
    }
}


contract TelcoinSale {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event WalletChanged(address indexed previousWallet, address indexed newWallet);
    event TokenPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount,
        uint256 bonusAmount
    );
    event TokenAltPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount,
        uint256 bonusAmount,
        string symbol,
        string transactionId
    );
    event Pause();
    event Unpause();
    event Withdrawal(address indexed wallet, uint256 weiAmount);
    event Extended(uint256 until);
    event Finalized();
    event Refunding();
    event Refunded(address indexed beneficiary, uint256 weiAmount);
    event Whitelisted(
        address indexed participant,
        uint256 minWeiAmount,
        uint256 maxWeiAmount,
        uint32 bonusRate
    );
    event CapFlexed(uint32 flex);

    /// The owner of the contract.
    address public owner;

    /// The temporary token we&#39;re selling. Sale tokens can be converted
    /// immediately upon successful completion of the sale. Bonus tokens
    /// are on a separate vesting schedule.
    TelcoinSaleToken public saleToken;
    TelcoinSaleToken public bonusToken;

    /// The token we&#39;ll convert to after the sale ends.
    Telcoin public telcoin;

    /// The minimum and maximum goals to reach. If the soft cap is not reached
    /// by the end of the sale, the contract will enter refund mode. If the
    /// hard cap is reached, the contract can be finished early.
    ///
    /// Due to our actual soft cap being tied to USD and the assumption that
    /// the value of Ether will continue to increase during the ICO, we
    /// implement a fixed minimum softcap that accounts for a 2.5x value
    /// increase. The capFlex is a scale factor that allows us to scale the
    /// caps above the fixed minimum values. Initially the scale factor will
    /// be set so that our effective soft cap is ~10M USD.
    uint256 public softCap;
    uint256 public hardCap;
    uint32 public capFlex;

    /// The sale period.
    uint256 public startTime;
    uint256 public endTime;
    uint256 public timeExtension;

    /// The numnber of tokens to mint per wei.
    uint256 public rate;

    /// The total number of wei raised. Note that the contract&#39;s balance may
    /// differ from this value if someone has decided to forcefully send us
    /// ether.
    uint256 public weiRaised;

    /// The wallet that will receive the contract&#39;s balance once the sale
    /// finishes and the soft cap is reached.
    address public wallet;

    /// The list of addresses that are allowed to participate in the sale,
    /// up to what amount, and any special rate they may have, provided
    /// that they do in fact participate with at least the minimum value
    /// they agreed to.
    mapping(address =&gt; uint256) public whitelistedMin;
    mapping(address =&gt; uint256) public whitelistedMax;
    mapping(address =&gt; uint32) public bonusRates;

    /// The amount of wei and wei equivalents invested by each investor.
    mapping(address =&gt; uint256) public deposited;
    mapping(address =&gt; uint256) public altDeposited;

    /// An enumerable list of investors.
    address[] public investors;

    /// Whether the sale is paused.
    bool public paused = false;

    /// Whether the sale has finished, and when.
    bool public finished = false;
    uint256 public finishedAt;

    /// Whether we&#39;re accepting refunds.
    bool public refunding = false;

    /// The total number of wei refunded.
    uint256 public weiRefunded;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier saleOpen() {
        require(!finished);
        require(!paused);
        require(now &gt;= startTime);
        require(now &lt;= endTime + timeExtension);
        _;
    }

    function TelcoinSale(
        uint256 _softCap,
        uint256 _hardCap,
        uint32 _capFlex,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _rate,
        address _wallet,
        Telcoin _telcoin,
        uint256 _bonusVestingStart,
        uint256 _bonusVestingDuration
    )
        public
        payable
    {
        require(msg.value &gt; 0);
        require(_softCap &gt; 0);
        require(_hardCap &gt;= _softCap);
        require(_startTime &gt;= now);
        require(_endTime &gt;= _startTime);
        require(_rate &gt; 0);
        require(_wallet != 0x0);

        owner = msg.sender;
        softCap = _softCap;
        hardCap = _hardCap;
        capFlex = _capFlex;
        startTime = _startTime;
        endTime = _endTime;
        rate = _rate;
        wallet = _wallet;
        telcoin = _telcoin;

        saleToken = new TelcoinSaleToken(telcoin, 0, 0);
        bonusToken = new TelcoinSaleToken(
            telcoin,
            _bonusVestingStart,
            _bonusVestingDuration
        );

        wallet.transfer(msg.value);
    }

    function () public payable {
        buyTokens(msg.sender);
    }

    function buyTokens(address _beneficiary) saleOpen public payable {
        require(_beneficiary != address(0));

        uint256 weiAmount = msg.value;
        require(weiAmount &gt; 0);
        require(weiRaised.add(weiAmount) &lt;= hardCap);

        uint256 totalPrior = totalDeposited(_beneficiary);
        uint256 totalAfter = totalPrior.add(weiAmount);
        require(totalAfter &lt;= whitelistedMax[_beneficiary]);

        uint256 saleTokens;
        uint256 bonusTokens;

        (saleTokens, bonusTokens) = tokensForPurchase(_beneficiary, weiAmount);

        uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
        deposited[_beneficiary] = newDeposited;
        investors.push(_beneficiary);

        weiRaised = weiRaised.add(weiAmount);

        saleToken.mint(_beneficiary, saleTokens);
        if (bonusTokens &gt; 0) {
            bonusToken.mint(_beneficiary, bonusTokens);
        }

        TokenPurchase(
            msg.sender,
            _beneficiary,
            weiAmount,
            saleTokens,
            bonusTokens
        );
    }

    function changeWallet(address _wallet) onlyOwner public payable {
        require(_wallet != 0x0);
        require(msg.value &gt; 0);

        WalletChanged(wallet, _wallet);
        wallet = _wallet;

        wallet.transfer(msg.value);
    }

    function extendTime(uint256 _timeExtension) onlyOwner public {
        require(!finished);
        require(now &lt; endTime + timeExtension);
        require(_timeExtension &gt; 0);

        timeExtension = timeExtension.add(_timeExtension);
        require(timeExtension &lt;= 7 days);

        Extended(endTime.add(timeExtension));
    }

    function finish() onlyOwner public {
        require(!finished);
        require(hardCapReached() || now &gt; endTime + timeExtension);

        finished = true;
        finishedAt = now;
        saleToken.finishMinting();
        bonusToken.finishMinting();

        uint256 distributableCoins = telcoin.balanceOf(this);

        if (softCapReached()) {
            uint256 saleTokens = saleToken.totalSupply();
            uint256 bonusTokens = bonusToken.totalSupply();
            uint256 totalTokens = saleTokens.add(bonusTokens);

            // Avoid loss of precision by multiplying and later dividing by
            // a large value.
            uint256 bonusPortion = bonusTokens.mul(10 ** 18).div(totalTokens).mul(distributableCoins).div(10 ** 18);
            uint256 salePortion = distributableCoins.sub(bonusPortion);

            saleToken.transferOwnership(owner);
            bonusToken.transferOwnership(owner);

            telcoin.transfer(saleToken, salePortion);
            telcoin.transfer(bonusToken, bonusPortion);

            withdraw();
        } else {
            refunding = true;
            telcoin.transfer(wallet, distributableCoins);
            Refunding();
        }

        Finalized();
    }

    function pause() onlyOwner public {
        require(!paused);
        paused = true;
        Pause();
    }

    function refundMany(address[] _investors) public {
        for (uint256 i = 0; i &lt; _investors.length; i++) {
            refund(_investors[i]);
        }
    }

    function refund(address _investor) public {
        require(finished);
        require(refunding);
        require(deposited[_investor] &gt; 0);

        uint256 weiAmount = deposited[_investor];
        deposited[_investor] = 0;
        weiRefunded = weiRefunded.add(weiAmount);
        Refunded(_investor, weiAmount);

        _investor.transfer(weiAmount);
    }

    function registerAltPurchase(
        address _beneficiary,
        string _symbol,
        string _transactionId,
        uint256 _weiAmount
    )
        saleOpen
        onlyOwner
        public
    {
        require(_beneficiary != address(0));
        require(totalDeposited(_beneficiary).add(_weiAmount) &lt;= whitelistedMax[_beneficiary]);

        uint256 saleTokens;
        uint256 bonusTokens;

        (saleTokens, bonusTokens) = tokensForPurchase(_beneficiary, _weiAmount);

        uint256 newAltDeposited = altDeposited[_beneficiary].add(_weiAmount);
        altDeposited[_beneficiary] = newAltDeposited;
        investors.push(_beneficiary);

        weiRaised = weiRaised.add(_weiAmount);

        saleToken.mint(_beneficiary, saleTokens);
        if (bonusTokens &gt; 0) {
            bonusToken.mint(_beneficiary, bonusTokens);
        }

        TokenAltPurchase(
            msg.sender,
            _beneficiary,
            _weiAmount,
            saleTokens,
            bonusTokens,
            _symbol,
            _transactionId
        );
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != address(0));
        OwnershipTransferred(owner, _to);
        owner = _to;
    }

    function unpause() onlyOwner public {
        require(paused);
        paused = false;
        Unpause();
    }

    function updateCapFlex(uint32 _capFlex) onlyOwner public {
        require(!finished);
        capFlex = _capFlex;
        CapFlexed(capFlex);
    }

    function whitelistMany(
        address[] _participants,
        uint256 _minWeiAmount,
        uint256 _maxWeiAmount,
        uint32 _bonusRate
    )
        onlyOwner
        public
    {
        for (uint256 i = 0; i &lt; _participants.length; i++) {
            whitelist(
                _participants[i],
                _minWeiAmount,
                _maxWeiAmount,
                _bonusRate
            );
        }
    }

    function whitelist(
        address _participant,
        uint256 _minWeiAmount,
        uint256 _maxWeiAmount,
        uint32 _bonusRate
    )
        onlyOwner
        public
    {
        require(_participant != 0x0);
        require(_bonusRate &lt;= 400);

        whitelistedMin[_participant] = _minWeiAmount;
        whitelistedMax[_participant] = _maxWeiAmount;
        bonusRates[_participant] = _bonusRate;
        Whitelisted(
            _participant,
            _minWeiAmount,
            _maxWeiAmount,
            _bonusRate
        );
    }

    function withdraw() onlyOwner public {
        require(softCapReached() || (finished &amp;&amp; now &gt; finishedAt + 14 days));

        uint256 weiAmount = this.balance;

        if (weiAmount &gt; 0) {
            wallet.transfer(weiAmount);
            Withdrawal(wallet, weiAmount);
        }
    }

    function hardCapReached() public constant returns (bool) {
        return weiRaised &gt;= hardCap.mul(1000 + capFlex).div(1000);
    }

    function tokensForPurchase(
        address _beneficiary,
        uint256 _weiAmount
    )
        public
        constant
        returns (uint256, uint256)
    {
        uint256 baseTokens = _weiAmount.mul(rate);
        uint256 totalPrior = totalDeposited(_beneficiary);
        uint256 totalAfter = totalPrior.add(_weiAmount);

        // Has the beneficiary passed the assigned minimum purchase level?
        if (totalAfter &lt; whitelistedMin[_beneficiary]) {
            return (baseTokens, 0);
        }

        uint32 bonusRate = bonusRates[_beneficiary];
        uint256 baseBonus = baseTokens.mul(1000 + bonusRate).div(1000).sub(baseTokens);

        // Do we pass the minimum purchase level with this purchase?
        if (totalPrior &lt; whitelistedMin[_beneficiary]) {
            uint256 balancePrior = totalPrior.mul(rate);
            uint256 accumulatedBonus = balancePrior.mul(1000 + bonusRate).div(1000).sub(balancePrior);
            return (baseTokens, accumulatedBonus.add(baseBonus));
        }

        return (baseTokens, baseBonus);
    }

    function totalDeposited(address _investor) public constant returns (uint256) {
        return deposited[_investor].add(altDeposited[_investor]);
    }

    function softCapReached() public constant returns (bool) {
        return weiRaised &gt;= softCap.mul(1000 + capFlex).div(1000);
    }
}


contract TelcoinSaleKYCEscrow {
    using SafeMath for uint256;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ValuePlaced(address indexed purchaser, address indexed beneficiary, uint256 amount);
    event Approved(address indexed participant);
    event Rejected(address indexed participant);
    event Closed();

    /// The owner of the contract.
    address public owner;

    /// The actual sale.
    TelcoinSale public sale;

    /// Whether the escrow has closed.
    bool public closed = false;

    /// The amount of wei and wei equivalents invested by each investor.
    mapping(address =&gt; uint256) public deposited;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier escrowOpen() {
        require(!closed);
        _;
    }

    function TelcoinSaleKYCEscrow(TelcoinSale _sale) public {
        require(_sale != address(0));

        owner = msg.sender;
        sale = _sale;
    }

    function () public payable {
        placeValue(msg.sender);
    }

    function approve(address _participant) onlyOwner public {
        uint256 weiAmount = deposited[_participant];
        require(weiAmount &gt; 0);

        deposited[_participant] = 0;
        Approved(_participant);
        sale.buyTokens.value(weiAmount)(_participant);
    }

    function approveMany(address[] _participants) onlyOwner public {
        for (uint256 i = 0; i &lt; _participants.length; i++) {
            approve(_participants[i]);
        }
    }

    function close() onlyOwner public {
        require(!closed);

        closed = true;
        Closed();
    }

    function placeValue(address _beneficiary) escrowOpen public payable {
        require(_beneficiary != address(0));

        uint256 weiAmount = msg.value;
        require(weiAmount &gt; 0);

        uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
        deposited[_beneficiary] = newDeposited;

        ValuePlaced(
            msg.sender,
            _beneficiary,
            weiAmount
        );
    }

    function reject(address _participant) onlyOwner public {
        uint256 weiAmount = deposited[_participant];
        require(weiAmount &gt; 0);

        deposited[_participant] = 0;
        Rejected(_participant);
        require(_participant.call.value(weiAmount)());
    }

    function rejectMany(address[] _participants) onlyOwner public {
        for (uint256 i = 0; i &lt; _participants.length; i++) {
            reject(_participants[i]);
        }
    }

    function transferOwnership(address _to) onlyOwner public {
        require(_to != address(0));
        OwnershipTransferred(owner, _to);
        owner = _to;
    }
}