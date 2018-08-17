pragma solidity ^0.4.4;

contract BountyHunt {
  mapping(address =&gt; uint) public bountyAmount;
  uint public totalBountyAmount;

  modifier preventTheft {
    _;  
    if (this.balance &lt; totalBountyAmount) throw;
  }

  function grantBounty(address beneficiary, uint amount) payable preventTheft {
    bountyAmount[beneficiary] += amount;
    totalBountyAmount += amount;
  }

  function claimBounty() preventTheft {
    uint balance = bountyAmount[msg.sender];
    if (msg.sender.call.value(balance)()) {
      totalBountyAmount -= balance;
      bountyAmount[msg.sender] = 0;
    }   
  }

  function transferBounty(address to, uint value) preventTheft {
    if (bountyAmount[msg.sender] &gt;= value) {
      bountyAmount[to] += value;
      bountyAmount[msg.sender] -= value;
    }   
  }
}