pragma solidity ^0.4.18;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
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

contract Ownable {

  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract Races is Ownable {

  using SafeMath for uint256;

  mapping(address =&gt; uint256) public payments; 
  mapping( uint8 =&gt; address) public raceBet; 
  mapping(address =&gt; uint8) public jockeyLevel; 
  uint256 public gameCost = 20 finney; //0.02 eth
  uint32 public raceNum = 1; 
  uint8 public lastWinner = 0; 
  uint256 winTax = 2 finney; 
  uint8 betsNum = 0; 
  
  function newBet(uint8 horseNum) public payable {
  
     if (raceBet[horseNum]==0 &amp;&amp; horseNum&lt;7 &amp;&amp; horseNum&gt;0 &amp;&amp; msg.value==20 finney) {
		 payments[msg.sender] = payments[msg.sender].add(msg.value);
		 raceBet[horseNum]=msg.sender;
		 betsNum++;
		 
		 if (betsNum==6) {//start race
		 
		    uint random_number = uint(block.blockhash(block.number-1));

			//jockey has level from 0 to 5 (1 - 6 on web site)
			uint8 newWinner=uint8(random_number%77+1);
			if (jockeyLevel[raceBet[newWinner]]&lt;5) {
				newWinner=uint8(random_number%62+1);
				if (jockeyLevel[raceBet[newWinner]]&lt;4) {
					newWinner=uint8(random_number%47+1);
					if (jockeyLevel[raceBet[newWinner]]&lt;3) {
						newWinner=uint8(random_number%32+1);
						if (jockeyLevel[raceBet[newWinner]]&lt;2) {
							newWinner=uint8(random_number%17+1);
							if (jockeyLevel[raceBet[newWinner]]&lt;1) {
							   newWinner=uint8(random_number%6+1);
							}
						}
					}
				}
			}
			
			if (newWinner&gt;0 &amp;&amp; newWinner&lt;7) {
				raceNum++;
				racesInfo(raceNum, newWinner, raceBet[newWinner]); //save event in blockchain

				if (jockeyLevel[raceBet[newWinner]]&lt;5)
					jockeyLevel[raceBet[newWinner]]++;
				
				for (uint8 i=1;i&lt;7;i++) {
					if (i != newWinner) {
						payments[raceBet[i]]=payments[raceBet[i]].sub(gameCost);
						payments[raceBet[newWinner]]=payments[raceBet[newWinner]].add(gameCost).sub(winTax);
						payments[owner]=payments[owner].add(winTax);
						raceBet[i]=0;
					} 
				}
				raceBet[newWinner]=0;
				betsNum=0;	
				lastWinner=newWinner;
			}

		 }
	 } else {
	     require(this.balance &gt;= msg.value &amp;&amp; msg.value&gt;0);
	     address payee = msg.sender;
	     assert(payee.send(msg.value)); ///error bet, send eth back
	 }
  }
  
  function setGameCost(uint256 newGameCost) public onlyOwner {
	  assert(newGameCost&gt;0);
	  gameCost = newGameCost;
	  winTax = gameCost.div(10);
  }
  
  
  //current bets
  function getBetArr() public constant returns(address[6], uint8[6], uint32, uint8) {
     uint8[6] memory jockeyLvl;
     address[6] memory betArr;
	 
	 for (uint8 i=1;i&lt;7;i++) {
		 jockeyLvl[i-1] = jockeyLevel[raceBet[i]]; 
	     betArr[i-1] = raceBet[i];
	 }
	 return (betArr, jockeyLvl, raceNum, lastWinner);
  }  
  
  function getBalance() public constant returns(uint256) {
	 return payments[msg.sender];
  }    
  

  function withdrawPayments() public {
	address payee = msg.sender;
	uint256 payment = payments[payee];

	require(payment != 0);
	require(this.balance &gt;= payment);

	payments[payee] = 0;

	for (uint8 i=1;i&lt;7;i++) {
		if (raceBet[i]==payee) {
		   raceBet[i]=0; 
		   betsNum--;
		}
	}

	assert(payee.send(payment));
  }  
  
  event racesInfo(uint256 indexed raceNum, uint8 indexed winnerNum, address indexed whoWinner);  
}