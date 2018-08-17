pragma solidity ^0.4.18;

/*
* SmartEtherMining
*/

contract SmartEtherMining{
    
    mapping (address =&gt; uint256) public investedETH;
    mapping (address =&gt; uint256) public lastInvest;
    
    mapping (address =&gt; uint256) public affiliateCommision;
    
    address dev = 0xbbe810596f6b9dc9713e9393b79599a6a54ec2d5;
    address promoter = 0xE6f43c670CC8a366bBcf6677F43B02754BFB5855;
    
    function investETH(address referral) public payable {
        
        require(msg.value &gt;= 0.01 ether);
        
        if(getProfit(msg.sender) &gt; 0){
            uint256 profit = getProfit(msg.sender);
            lastInvest[msg.sender] = now;
            msg.sender.transfer(profit);
        }
        
        uint256 amount = msg.value;
        uint256 commision = SafeMath.div(amount, 20);
        if(referral != msg.sender &amp;&amp; referral != 0x1 &amp;&amp; referral != dev &amp;&amp; referral != promoter){
            affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
        }
        
        affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
        affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
        
        investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
        lastInvest[msg.sender] = now;
    }
    
    function divestETH() public {
        uint256 profit = getProfit(msg.sender);
        lastInvest[msg.sender] = now;
        
        //20% fee on taking capital out
        uint256 capital = investedETH[msg.sender];
        uint256 fee = SafeMath.div(capital, 5);
        capital = SafeMath.sub(capital, fee);
        
        uint256 total = SafeMath.add(capital, profit);
        require(total &gt; 0);
        investedETH[msg.sender] = 0;
        msg.sender.transfer(total);
    }
    
    function withdraw() public{
        uint256 profit = getProfit(msg.sender);
        require(profit &gt; 0);
        lastInvest[msg.sender] = now;
        msg.sender.transfer(profit);
    }
    
    function getProfitFromSender() public view returns(uint256){
        return getProfit(msg.sender);
    }

    function getProfit(address customer) public view returns(uint256){
        uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
        return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 4320000);
    }
    
    function reinvestProfit() public {
        uint256 profit = getProfit(msg.sender);
        require(profit &gt; 0);
        lastInvest[msg.sender] = now;
        investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
    }
    
    function getAffiliateCommision() public view returns(uint256){
        return affiliateCommision[msg.sender];
    }
    
    function withdrawAffiliateCommision() public {
        require(affiliateCommision[msg.sender] &gt; 0);
        uint256 commision = affiliateCommision[msg.sender];
        affiliateCommision[msg.sender] = 0;
        msg.sender.transfer(commision);
    }
    
    function getInvested() public view returns(uint256){
        return investedETH[msg.sender];
    }
    
    function getBalance() public view returns(uint256){
        return this.balance;
    }

    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a &lt; b ? a : b;
    }
    
    function max(uint256 a, uint256 b) private pure returns (uint256) {
        return a &gt; b ? a : b;
    }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}