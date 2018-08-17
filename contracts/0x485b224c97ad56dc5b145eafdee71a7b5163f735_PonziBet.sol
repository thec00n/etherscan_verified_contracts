pragma solidity ^0.4.18;

library SafeMath {
  function mul(uint a, uint b) pure internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a,uint b) pure internal returns (uint) {
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) pure internal returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint a, uint b) pure internal returns (uint) {
    uint c = a + b;
    assert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }
}

contract EthPyramid {
  function buyPrice() public constant returns (uint) {}   
}

contract PonziBet {
    
  using SafeMath for uint;

  EthPyramid public pyramid;

  address public admin;
  address public contractAddress;

  uint public minBet;
  uint public roundTime;
  uint public startPrice;  
  uint public endPrice;
  
  uint[] public upBetRecords; 
  uint[] public downBetRecords;
  
  mapping (address =&gt; uint) lastBet;
  mapping (address =&gt; bool) userBet;
  mapping (bool =&gt; uint) totalBalance;
  mapping (address =&gt; uint) feeBalance;
  mapping (address =&gt; mapping (bool =&gt; uint)) userBalances;
  
  function PonziBet() public {
    admin = msg.sender;      
  }       
  
  modifier onlyAdmin() {
    require(msg.sender == admin);
    _;
  }  

  function changeContractAddress(address _contract) 
     external
     onlyAdmin
  {
     contractAddress = _contract;
     pyramid = EthPyramid(contractAddress);
  }

  function changeMinBet(uint _minBet)
     external
     onlyAdmin
  {
     minBet = _minBet;
  }

  function withdrawFromFeeBalance() 
     external
     onlyAdmin
  {
    if(!msg.sender.send(feeBalance[msg.sender])) revert();  
  } 

  function recordBet(bool _bet,uint _userAmount)
    private
  {
    userBalances[msg.sender][_bet] = _userAmount;
    totalBalance[_bet] = totalBalance[_bet].add(_userAmount);
    userBet[msg.sender] = _bet;
    _bet ? upBetRecords.push(_userAmount) : downBetRecords.push(_userAmount);      
  }

  function enterRound(bool _bet) 
     external 
     payable 
  {
    require(msg.value &gt;= 10000000000000000);
    if(roundTime == uint(0) || roundTime + 30 minutes &lt;= now) {
      endPrice = uint(0);
      upBetRecords.length = uint(0);
      downBetRecords.length = uint(0);
      startPrice = pyramid.buyPrice();
      roundTime = now;    
    }
    if(roundTime + 15 minutes &gt; now) {
      uint fee = msg.value.div(20);
      uint userAmount = msg.value.sub(fee);
      feeBalance[admin] =  feeBalance[admin].add(fee);
      if(_bet == true) {
        recordBet(true,userAmount);
      }
      else if(_bet == false) {
        recordBet(false,userAmount);
      }   
      lastBet[msg.sender] = now;
    }
    else {
      revert();
    }
  }    
  
  function settleBet(bool _bet)
    private
  {
      uint reward = (userBalances[msg.sender][_bet].mul(totalBalance[!_bet])).div(totalBalance[_bet]);
      uint totalWithdrawal = reward.add(userBalances[msg.sender][_bet]);
      totalBalance[!_bet] = totalBalance[!_bet].sub(reward);
      totalBalance[_bet] = totalBalance[_bet].sub(userBalances[msg.sender][_bet]);
      msg.sender.transfer(totalWithdrawal);
  }
  
  function placeBet() 
     external
  {
    require(lastBet[msg.sender] &lt; roundTime + 15 minutes &amp;&amp; roundTime + 15 minutes &lt; now &amp;&amp; roundTime + 30 minutes &gt; now);
    if(endPrice == uint(0)) {
      endPrice = pyramid.buyPrice();    
    }
    if(startPrice &gt;= endPrice &amp;&amp; userBet[msg.sender] == true ) {
      settleBet(true);
    }
    else if(startPrice &lt; endPrice &amp;&amp; userBet[msg.sender] == false ) {
      settleBet(false);
    }
    else {
      revert();
    }
  }
  
  function totalBalanceUp() view external returns(uint) {
      return totalBalance[true];
  }
  
  function totalBalanceDown() view external returns(uint) {
      return totalBalance[false];
  }
  
  function getUserBet() view external returns(bool) {
    return userBet[msg.sender];
  }

  function getUserBalances() view external returns(uint) {
    return userBalances[msg.sender][userBet[msg.sender]];
  }
  
  function getUserBalancesLastBet() view external returns(uint) {
    return lastBet[msg.sender];
  }

}