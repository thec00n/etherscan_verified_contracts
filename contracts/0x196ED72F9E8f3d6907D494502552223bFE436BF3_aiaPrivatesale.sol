pragma solidity ^0.4.15;

contract myOwned {
    address public owner;
    function myOwned() public { owner = msg.sender; }
    modifier onlyOwner { require(msg.sender == owner); _;}
    function exOwner(address newOwner) onlyOwner public { owner = newOwner;}
}


interface token {
    function transfer(address receiver, uint amount);
}

contract aiaPrivatesale is myOwned {
    uint public startDate;
    uint public stopDate;
    uint public fundingGoal;
    uint public amountRaised;
    uint public exchangeRate;
    token public tokenReward;
    address public beneficiary;
    mapping(address =&gt; uint256) public balanceOf;
    event GoalReached(address receiver, uint amount);
    event FundTransfer(address backer, uint amount, bool isContribution);

    function aiaPrivatesale (
        uint _startDate,
        uint _stopDate,
        uint _fundingGoal,
        address _beneficiary,
        address _tokenReward
    ) {
        startDate = _startDate;
        stopDate = _stopDate;
        fundingGoal = _fundingGoal * 1 ether;
        beneficiary = _beneficiary;
        tokenReward = token(_tokenReward);
    }

    function saleActive() public constant returns (bool) {
        return (now &gt;= startDate &amp;&amp; now &lt;= stopDate &amp;&amp; amountRaised &lt; fundingGoal);
    }
    
    function getCurrentTimestamp() internal returns (uint256) {
        return now;    
    }

    function getRateAt(uint256 at) constant returns (uint256) {
        if (at &lt; startDate) {return 0;} 
        else if (at &lt;= stopDate) {return 6500;} 
        else if (at &gt; stopDate) {return 0;}
    }

    function () payable {
        require(saleActive());
        require(amountRaised &lt; fundingGoal);
        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        exchangeRate = getRateAt(getCurrentTimestamp());
        uint price =  0.0001 ether / getRateAt(getCurrentTimestamp());
        tokenReward.transfer(msg.sender, amount / price);
        FundTransfer(msg.sender, amount, true);
        beneficiary.transfer(msg.value);
    }

    function saleEnd() onlyOwner {
        require(!saleActive());
        require(now &gt; stopDate );
        beneficiary.transfer(this.balance);
        tokenReward.transfer(beneficiary, this.balance);

    }

    function destroy() { 
        if (msg.sender == beneficiary) { 
        suicide(beneficiary);
        tokenReward.transfer(beneficiary, this.balance);
        }
    }    
}