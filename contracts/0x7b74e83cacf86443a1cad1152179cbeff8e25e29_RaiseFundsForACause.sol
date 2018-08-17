pragma solidity ^0.4.17;

contract RaiseFundsForACause {

    // Base definitions
    address public owner;
    address public receiver;
    string public cause;
    uint256 public expirationInSeconds;
    bool public hasBeenClaimed;
    uint256 public timeStarted;

    // Dynamic data
    uint256 public minimumAmountRequired;
    uint256 public numPayments;
    uint256 public totalAmountRaised;
    mapping(address =&gt; uint256) donationData;

    function RaiseFundsForACause(address beneficiary, string message, uint256 secondsUntilExpiration)
        public
    {
        require(beneficiary != 0x0);
        require(secondsUntilExpiration &gt; 0);

        owner = msg.sender;
        receiver = beneficiary;
        cause = message;
        expirationInSeconds = secondsUntilExpiration;
        hasBeenClaimed = false;

        minimumAmountRequired = 0;
        numPayments = 0;
        totalAmountRaised = 0;
        timeStarted = block.timestamp;
    }

    function ()
        public
    {
        throw;
    }

    function donate()
        public
        payable
    {
        require(msg.sender != receiver);
        require(block.timestamp &lt; (timeStarted + expirationInSeconds));
        require(msg.value &gt; 0);
        require(minimumAmountRequired != 0);
        require(hasBeenClaimed == false);

        assert(donationData[msg.sender] + msg.value &gt;= donationData[msg.sender]);
        assert(totalAmountRaised + msg.value &gt;= totalAmountRaised);
        assert(numPayments + 1 &gt;= numPayments);

        donationData[msg.sender] += msg.value;
        totalAmountRaised += msg.value;
        numPayments += 1;
    }

    // Note: can only be set once
    function receiverSetAmountRequired(uint256 minimum)
        public
    {
        require(msg.sender == receiver);
        require(minimumAmountRequired == 0);
        require(minimum &gt; 0);

        minimumAmountRequired = minimum;
    }

    function receiverWithdraw()
        public
    {
        require(msg.sender == receiver);
        require(totalAmountRaised &gt;= minimumAmountRequired);
        require(this.balance &gt; 0);
        require(block.timestamp &lt; (timeStarted + expirationInSeconds));
        require(hasBeenClaimed == false);

        hasBeenClaimed = true;
        receiver.transfer(this.balance);
        // Expecting transfer to throw on error
        // assert(this.balance == 0);
    }

    function withdraw()
        public
    {
        require(donationData[msg.sender] &gt; 0);
        require(block.timestamp &gt; (timeStarted + expirationInSeconds));
        require(hasBeenClaimed == false);

        var value = donationData[msg.sender];
        donationData[msg.sender] = 0;
        msg.sender.transfer(value);
        // Expecting transfer to throw on error
        // assert(donationData[donor] == 0);
    }

    function currentTotalExcess()
        public
        constant returns (uint256)
    {
        if (totalAmountRaised &gt; minimumAmountRequired) {
            return totalAmountRaised - minimumAmountRequired;
        }
        else {
            return 0;
        }
    }

    function expirationTimestamp()
        public
        constant returns (uint256)
    {
        assert((timeStarted + expirationInSeconds) &gt;= timeStarted);
        return (timeStarted + expirationInSeconds);
    }
}