pragma solidity ^0.4.24;

/*
 * A smart contract to return funds to the creator after a hold period
 * 
 * Copyright 2018 Geoff Lamperd
 */
contract PayItBack {

    uint constant HOLD_TIME = 31 days;

    address public creator;
    uint public contributionTime = 0;
    uint public totalContributions = 0;
    bool public isDisabled = false;

	event Contribution(uint _amount, address _from);
	event OwnershipConfirmed();
	event PaidOut(uint _amount);
	event Warning(string _message);
	event Disabled();

    modifier ownerOnly() {
        require(msg.sender == creator, 
                &quot;Sorry, you&#39;re not the owner of this contract&quot;);

        _;
    }

    modifier nilBalance() {
        require(address(this).balance &lt;= 0, 
                &quot;Balance is not 0&quot;);

        _;
    }
    
    modifier afterHoldExpiry() {
        require(contributionTime &gt; 0, 
                &quot;No contributions have been received&quot;);
        require(now &gt; (contributionTime + HOLD_TIME), 
                &quot;Payments are on hold&quot;);

        _;
    }
    
    modifier enabled() {
        require(!isDisabled, 
                &quot;This contract has been disabled&quot;);

        _;
    }

    modifier wontOverflow() {
        require(totalContributions + msg.value &gt; totalContributions);

        _;
    }

    constructor() public {
        creator = msg.sender;
    }

    // Fallback function. If ETH has been transferred, call contribute()
    function () public payable {
        contribute();
    }

    function contribute() public payable enabled wontOverflow {
        // Hold time starts with first contribution
        // Don&#39;t allow subsequent contributions to reset the expiry
        if (contributionTime == 0 &amp;&amp; msg.value &gt; 0) {
            contributionTime = now;
        }

        totalContributions += msg.value;

        emit Contribution(msg.value, msg.sender);
    }

    // Pay the contract balance to the contract creator
    function payUp() public ownerOnly afterHoldExpiry {
        uint payment = address(this).balance;
        totalContributions -= payment;
        if (totalContributions != 0) {
            // something has gone wrong
            emit Warning(&quot;Balance is unexpectedly non-zero after payment&quot;);
        }
        contributionTime = 0; // Reset expiry
        emit PaidOut(payment);
        creator.transfer(payment);
    }

    function verifyOwnership() public ownerOnly returns(bool) {
        emit OwnershipConfirmed();

        return true;
    }

    // Owner can permanently disabled the contract. This will prevent
    // further contributions
    function disable() public ownerOnly nilBalance enabled {
        isDisabled = true;
        
        emit Disabled();
    }
    
    function expiryTime() public view returns(uint) {
        return contributionTime + HOLD_TIME;
    }
    
    function daysMinutesTilExpiryTime() public view returns(uint, uint) {
        uint secsLeft = (contributionTime + HOLD_TIME - now);
        uint daysLeft = secsLeft / 1 days;
        uint minsLeft = (secsLeft % 1 days) / 1 minutes;
        return (daysLeft, minsLeft);
    }
}