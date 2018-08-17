pragma solidity ^0.4.23;
/*

LIGO CrowdSale - Wave 1

*/

// interface to represent the LIGO token contract, so we can call functions on it
interface ligoToken {
    function transfer(address receiver, uint amount) external;
    function balanceOf(address holder) external returns(uint); 
}

contract Crowdsale {
	// Public visible variables
    address public beneficiary;
    uint public fundingGoal;
    uint public startTime;
    uint public deadline;
    ligoToken public tokenReward;
    uint public amountRaised;
    uint public buyerCount = 0;
    bool public fundingGoalReached = false;
	uint public withdrawlDeadline;
    // bool public hasStarted = false; // not needed, automatically start wave 1 when deployed
	// public array of buyers
    mapping(address =&gt; uint256) public balanceOf;
    mapping(address =&gt; uint256) public fundedAmount;
    mapping(uint =&gt; address) public buyers;
	// private variables
    bool crowdsaleClosed = false;
	// crowdsale settings
	uint constant minContribution  = 20000000000000000; // 0.02 ETH
	uint constant maxContribution = 100 ether; 
	uint constant fundsOnHoldAfterDeadline = 30 days; //Escrow period

    event GoalReached(address recipient, uint totalAmountRaised);
    event FundTransfer(address backer, uint amount, bool isContribution);

    /**
     * Constructor function
     *
     * Setup the owner
     */
    constructor(
        address ifSuccessfulSendTo,
        uint fundingGoalInEthers,
        uint startUnixTime,
        uint durationInMinutes,
        address addressOfTokenUsedAsReward
    ) public {
        beneficiary = ifSuccessfulSendTo;
        fundingGoal = fundingGoalInEthers * 1 ether;
        startTime = startUnixTime;
        deadline = startTime + durationInMinutes * 1 minutes;
		withdrawlDeadline = deadline + fundsOnHoldAfterDeadline;
        tokenReward = ligoToken(addressOfTokenUsedAsReward);
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function () public payable {
        require(!crowdsaleClosed);
        require(!(now &lt;= startTime));
		require(!(amountRaised &gt;= fundingGoal)); // stop accepting payments when the goal is reached.

		// get the total for this contributor so far
        uint totalContribution = balanceOf[msg.sender];
		// if total &gt; 0, this user already contributed
		bool exstingContributor = totalContribution &gt; 0;

        uint amount = msg.value;
        bool moreThanMinAmount = amount &gt;= minContribution; //&gt; 0.02 Ether
        bool lessThanMaxTotalContribution = amount + totalContribution &lt;= maxContribution; // &lt; 100 Ether total, including this amount

        require(moreThanMinAmount);
        require(lessThanMaxTotalContribution);

        if (lessThanMaxTotalContribution &amp;&amp; moreThanMinAmount) {
            // Add to buyer&#39;s balance
            balanceOf[msg.sender] += amount;
            // Add to tracking array
            fundedAmount[msg.sender] += amount;
            emit FundTransfer(msg.sender, amount, true);
			if (!exstingContributor) {
				// this is a new contributor, add to the count and the buyers array
				buyers[buyerCount] = msg.sender;
				buyerCount += 1;
			}
            amountRaised += amount;
		}
    }

    modifier afterDeadline() { if (now &gt;= deadline) _; }
    modifier afterWithdrawalDeadline() { if (now &gt;= withdrawlDeadline) _; }

    /**
     * Check if goal was reached
     *
     * Checks if the goal or time limit has been reached and ends the campaign
     */
    function checkGoalReached() public afterDeadline {
		if (beneficiary == msg.sender) {
			if (amountRaised &gt;= fundingGoal){
				fundingGoalReached = true;
				emit GoalReached(beneficiary, amountRaised);
			}
			crowdsaleClosed = true;
		}
    }

    /**
     * returns contract&#39;s LIGO balance
     */
    function getContractTokenBalance() public constant returns (uint) {
        return tokenReward.balanceOf(address(this));
    }
    
    /**
     * Withdraw the funds
     *
     * Checks to see if time limit has been reached, and if so, 
     * sends the entire amount to the beneficiary, and send LIGO to buyers. 
     */
    function safeWithdrawal() public afterWithdrawalDeadline {
		
		// Only the beneficiery can withdraw from Wave 1
		if (beneficiary == msg.sender) {

			// first send all the ETH to beneficiary
            if (beneficiary.send(amountRaised)) {
                emit FundTransfer(beneficiary, amountRaised, false);
            }

			// Read amount of total LIGO in this contract
			uint totalTokens = tokenReward.balanceOf(address(this));
			uint remainingTokens = totalTokens;

			// send the LIGO to each buyer
			for (uint i=0; i&lt;buyerCount; i++) {
				address buyerId = buyers[i];
				uint amount = ((balanceOf[buyerId] * 500) * 125) / 100; //Modifier is 100-&gt;125% so divide by 100.
				// Make sure there are enough remaining tokens in the contract before trying to send
				if (remainingTokens &gt;= amount) {
					tokenReward.transfer(buyerId, amount); 
					// subtract from the total
					remainingTokens -= amount;
					// clear out buyer&#39;s balance
					balanceOf[buyerId] = 0;
				}
			}

			// send unsold tokens back to contract init wallet
			if (remainingTokens &gt; 0) {
				tokenReward.transfer(beneficiary, remainingTokens);
			}
        }
    }
}