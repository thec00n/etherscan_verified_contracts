/*
 *  Crowdsale for Lympo Tokens.
 *  Raised Ether will be stored safely at the wallet and returned to the ICO in case the funding
 *  goal is not reached, allowing the token holders to withdraw their funds.
 *  Author: Justas Kregždė
 */
 
pragma solidity ^0.4.19;

contract token {
    function transferFrom(address sender, address receiver, uint amount) returns(bool success) {}
    function burn() {}
}

library SafeMath {
    function mul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint a, uint b) internal returns (uint) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c &gt;= a &amp;&amp; c &gt;= b);
        return c;
    }
}

contract LympoICO {
    using SafeMath for uint;

    // pre-ICO
    // The maximum amount of tokens to be sold during pre-ICO
    uint constant public pre_maxGoal = 265000000e18; // 265 Million LYM Tokens
    // There are different prices and amount available in each period
    uint[2] public pre_prices = [60000, 50000];
    uint[1] public pre_amount_stages = [90000000e18]; // the amount available in each stage
    // The start date of the pre-ICO crowdsale
    uint constant public pre_start = 1516618800; // Monday, 22 January 2018 11:00:00 GMT
    // The end date of the pre-ICO crowdsale
    uint constant public pre_end = 1517655600; // Saturday, 3 February 2018 11:00:00 GMT
    // The number of tokens already sold during pre-ICO
    uint public pre_tokensSold = 0;

    // ICO
    // The maximum amount of tokens to be sold
    uint constant public maxGoal = 385000000e18; // 385 Million LYM Tokens
    // There are different prices and amount available in each period
    uint[1] public prices = [40000];
    // The start date of the crowdsale
    uint constant public start = 1518865200; // Saturday, 17 February 2018 11:00:00 GMT
    // The end date of the crowdsale
    uint constant public end = 1519815600; // Wednesday, 28 February 2018 11:00:00 GMT
    // The number of tokens already sold during ICO
    uint public tokensSold = 0;

    // If the funding goal is not reached, token holders may withdraw their funds
    uint constant public fundingGoal = 150000000e18; // 15%
    // How much has been raised by crowdale (in ETH)
    uint public amountRaised;
    // The balances (in ETH) of all token holders
    mapping(address =&gt; uint) public balances;
    // Indicates if the crowdsale has been ended already
    bool public crowdsaleEnded = false;
    // Tokens will be transfered from this address
    address public tokenOwner;
    // The address of the token contract
    token public tokenReward;
    // The wallet on which the funds will be stored
    address wallet;
    // Notifying transfers and the success of the crowdsale
    event GoalReached(address _tokenOwner, uint _amountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);

    // Constructor/initialization
    function LympoICO(address tokenAddr, address walletAddr, address tokenOwnerAddr) {
        tokenReward = token(tokenAddr);
        wallet = walletAddr;
        tokenOwner = tokenOwnerAddr;
    }
    
    // Exchange by sending ether to the contract.
    function() payable {
        if (msg.sender != wallet) // Do not trigger exchange if the wallet is returning the funds
            exchange(msg.sender);
    }
    
    // Make an exchanegment. Only callable if the crowdsale started and hasn&#39;t been ended, also the maxGoal wasn&#39;t reached yet.
    // The current token price is looked up by available amount. Bought tokens is transfered to the receiver.
    // The sent value is directly forwarded to a safe wallet.
    function exchange(address receiver) payable {
        uint amount = msg.value;
        uint price = getPrice();
        uint numTokens = amount.mul(price);

        bool isPreICO = (now &gt;= pre_start &amp;&amp; now &lt;= pre_end);
        bool isICO = (now &gt;= start &amp;&amp; now &lt;= end);

        require(isPreICO || isICO);
        require(numTokens &gt; 0);
        if (isPreICO)
        {
            require(!crowdsaleEnded &amp;&amp; pre_tokensSold.add(numTokens) &lt;= pre_maxGoal);
            if (pre_tokensSold &lt; pre_amount_stages[0])
                require(numTokens &lt;= 6000000e18); // max threshold for pre-ICO: 6mil LYM tokens for stage-I
            else
                require(numTokens &lt;= 12500000e18); // max threshold for pre-ICO: 12.5mil LYM tokens for stage-II
        }
        if (isICO)
        {
            require(!crowdsaleEnded &amp;&amp; tokensSold.add(numTokens) &lt;= maxGoal);
        }

        wallet.transfer(amount);
        balances[receiver] = balances[receiver].add(amount);
        
        // Calculate how much raised and tokens sold
        amountRaised = amountRaised.add(amount);

        if (isPreICO)
            pre_tokensSold = pre_tokensSold.add(numTokens);
        if (isICO)
            tokensSold = tokensSold.add(numTokens);

        assert(tokenReward.transferFrom(tokenOwner, receiver, numTokens));
        FundTransfer(receiver, amount, true, amountRaised);
    }

    // Looks up the current token price
    function getPrice() constant returns (uint price) {
        // pre-ICO prices
        if (now &gt;= pre_start &amp;&amp; now &lt;= pre_end)
        {
            for(uint i = 0; i &lt; pre_amount_stages.length; i++) {
                if(pre_tokensSold &lt; pre_amount_stages[i])
                    return pre_prices[i];
            }
            return pre_prices[pre_prices.length-1];
        }
        // ICO prices
        return prices[prices.length-1];
    }

    modifier afterDeadline() { if (now &gt;= end) _; }

    // Checks if the goal or time limit has been reached and ends the campaign
    function checkGoalReached() afterDeadline {
        if (pre_tokensSold.add(tokensSold) &gt;= fundingGoal){
            tokenReward.burn(); // Burn remaining tokens but the reserved ones
            GoalReached(tokenOwner, amountRaised);
        }
        crowdsaleEnded = true;
    }

    // Allows the funders to withdraw their funds if the goal has not been reached.
    // Only works after funds have been returned from the wallet.
    function safeWithdrawal() afterDeadline {
        uint amount = balances[msg.sender];
        if (address(this).balance &gt;= amount) {
            balances[msg.sender] = 0;
            if (amount &gt; 0) {
                msg.sender.transfer(amount);
                FundTransfer(msg.sender, amount, false, amountRaised);
            }
        }
    }
}