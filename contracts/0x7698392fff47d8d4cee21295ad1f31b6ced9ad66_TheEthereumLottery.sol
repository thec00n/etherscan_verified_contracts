contract TheEthereumLottery {
 /*
    Brief introduction:
    
    To play you need to pick 4 numbers (range 0-255) and provide them sorted to Play() function.
    To win you need to hit at least 1 number out of 4 WinningNums which will be announced once every week
    (or more often if the lottery will become more popular). If you hit all of the 4 numbers you will win
    about 50 milion times more than you payed fot lottery ticket. The exact values are provided as GuessXOutOf4
    entries in Ledger - notice that they are provided in Wei, not Ether (10^18 Wei = Ether).
    Use Withdraw() function to pay out.


    The advantage of TheEthereumLottery is that it is not using any pseudo-random numbers.
    The winning numbers are known from the announcement of next draw - at this moment the values of GuessXOutOf4,
    and ticket price is publically available. 
    To unable cheating of contract owner there a hash (called &quot;TheHash&quot; in contract ledger) 
    equal to sha3(WinningNums, TheRand) is provided.
    While announcing WinningNums the owner has to provide also a valid &quot;TheRand&quot; value, which satisfy 
    following expression: TheHash == sha3(WinningNums, TheRand). 
    If hashes do not match - the player can refund his Ether used for lottery ticket.
    As by default all non existing values equal to 0, from the perspective of blockchain 
    the hashes do not match at the moment of announcing next draw from the perspective of blockchain. 
    This is why refund is possible only after 2 weeks of announcing next draw,
    this moment is called ExpirencyTime on contract Ledger.
 */
/*
  Name:
  TheEthereumLottery

  Contract Address:
  0x7698392fff47d8d4cee21295ad1f31b6ced9ad66

  JSON interface:

[{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;MyNum1&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;MyNum2&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;MyNum3&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;MyNum4&quot;,&quot;type&quot;:&quot;uint8&quot;}],&quot;name&quot;:&quot;Play&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;DrawNumber&quot;,&quot;type&quot;:&quot;uint32&quot;}],&quot;name&quot;:&quot;Withdraw&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;Announcements&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;DrawNumber&quot;,&quot;type&quot;:&quot;uint32&quot;}],&quot;name&quot;:&quot;Refund&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;IndexOfCurrentDraw&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;ledger&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;WinningNum1&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;WinningNum2&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;WinningNum3&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;WinningNum4&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;TheRand&quot;,&quot;type&quot;:&quot;bytes32&quot;},{&quot;name&quot;:&quot;TheHash&quot;,&quot;type&quot;:&quot;bytes32&quot;},{&quot;name&quot;:&quot;Guess4OutOf4&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;Guess3OutOf4&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;Guess2OutOf4&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;Guess1OutOf4&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;PriceOfTicket&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;name&quot;:&quot;ExpirencyTime&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;DrawNumber&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;PlayerAddress&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;MyBet&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;Nums&quot;,&quot;type&quot;:&quot;uint8[4]&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;type&quot;:&quot;constructor&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:true,&quot;name&quot;:&quot;IndexOfDraw&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;TheHash&quot;,&quot;type&quot;:&quot;bytes32&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;PriceOfTicketInWei&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;WeiToWin&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;NewDrawReadyToPlay&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:true,&quot;name&quot;:&quot;IndexOfDraw&quot;,&quot;type&quot;:&quot;uint32&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;WinningNumber1&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;WinningNumber2&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;WinningNumber3&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;WinningNumber4&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;TheRand&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;name&quot;:&quot;DrawReadyToPayout&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;Wei&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;PlayerWon&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;Num1&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;Num2&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;Num3&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;Num4&quot;,&quot;type&quot;:&quot;uint8&quot;},{&quot;name&quot;:&quot;TheRandomValue&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;name&quot;:&quot;CheckHash&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;TheHash&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;type&quot;:&quot;function&quot;}]
*/


  
//constructor
function TheEthereumLottery()
{
  owner=msg.sender;
  ledger.length=0;
}
modifier OnlyOwner()
{ // Modifier
  if (msg.sender != owner) throw;
  _
}
address owner;
string public Announcements;//just additional feature
uint public IndexOfCurrentDraw;//starting from 0
struct bet_t {
  uint8[4] Nums;
  bool can_withdraw;//default==false
}
struct ledger_t {
  uint8 WinningNum1;
  uint8 WinningNum2;
  uint8 WinningNum3;
  uint8 WinningNum4;
  bytes32 TheRand;
  bytes32 TheHash;
  mapping(address=&gt;bet_t) bets;
  uint Guess4OutOf4;
  uint Guess3OutOf4;
  uint Guess2OutOf4;
  uint Guess1OutOf4;
  uint PriceOfTicket;
  uint ExpirencyTime;//for eventual refunds only, approx 2 weeks after draw announced
}
ledger_t[] public ledger;
 
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@ Here begines what probably you want to analise @@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
function next_draw(bytes32 new_hash,
	  uint priceofticket,
	  uint guess4outof4,
	  uint guess3outof4,
	  uint guess2outof4,
	  uint guess1outof4
	  )
OnlyOwner
{
  ledger.length++;
  IndexOfCurrentDraw=ledger.length-1;
  ledger[IndexOfCurrentDraw].TheHash = new_hash;
  ledger[IndexOfCurrentDraw].Guess4OutOf4=guess4outof4;
  ledger[IndexOfCurrentDraw].Guess3OutOf4=guess3outof4;
  ledger[IndexOfCurrentDraw].Guess2OutOf4=guess2outof4;
  ledger[IndexOfCurrentDraw].Guess1OutOf4=guess1outof4;
  ledger[IndexOfCurrentDraw].PriceOfTicket=priceofticket;
  ledger[IndexOfCurrentDraw].ExpirencyTime=now + 2 weeks;//You can refund after ExpirencyTime if owner will not announce winningnums+TheRand satisfying TheHash 

  NewDrawReadyToPlay(IndexOfCurrentDraw, new_hash, priceofticket, guess4outof4);//event
}
function announce_numbers(uint8 no1,
			  uint8 no2,
			  uint8 no3,
			  uint8 no4,
			  uint32 index,
			  bytes32 the_rand
			  )
OnlyOwner
{
  ledger[index].WinningNum1 = no1;
  ledger[index].WinningNum2 = no2;
  ledger[index].WinningNum3 = no3;
  ledger[index].WinningNum4 = no4;
  ledger[index].TheRand = the_rand;

  DrawReadyToPayout(index,
		    no1, no2, no3, no4,
		    the_rand);//event
}
function Play(uint8 MyNum1,
	      uint8 MyNum2,
	      uint8 MyNum3,
	      uint8 MyNum4
	      )
{
  if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket ||//to play you need to pay 
     ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3] != 0)//if your bet already exist
    throw;

  //if numbers are sorted
  if(MyNum1 &gt;= MyNum2 ||
     MyNum2 &gt;= MyNum3 ||
     MyNum3 &gt;= MyNum4
     )
    throw;//because you should sort the values yourself

  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[0]=MyNum1;
  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[1]=MyNum2;
  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[2]=MyNum3;
  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums[3]=MyNum4;
  ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;


  //##########################################################################3
  //another approach - with non-sorted input 
  /*
  if(msg.value != ledger[IndexOfCurrentDraw].PriceOfTicket)
    throw;

  uint8[4] memory InputData;
  (InputData[0],InputData[1],InputData[2],InputData[3])
    =(MyNum1,MyNum2,MyNum3,MyNum4);
  for(uint8 n=4;n&gt;1;n--)//check if input is sorted / bubble sort
    {
      bool sorted=true; 
      for(uint8 i=0;i&lt;n-1;i++)
	if(InputData[i] &gt; InputData[i+1])//then mark array as not sorted &amp; swap
	  {
	    sorted=false;
	    (InputData[i], InputData[i+1])=(InputData[i+1], InputData[i]);
	  }
      if(sorted) break;//breaks as soon as the array is sorted
    }
  //now we can assign
  ledger[IndexOfCurrentDraw].bets[msg.sender].Nums=InputData;
  ledger[IndexOfCurrentDraw].bets[msg.sender].can_withdraw=true;
  */

  
}
	
function Withdraw(uint32 DrawNumber)
{
  if(msg.value!=0)
    throw;//this function is free

  if(ledger[DrawNumber].bets[msg.sender].can_withdraw==false)
    throw;//throw if player didnt played

  //by default, every non existing value is equal to 0
  //so if there was no announcement WinningNums are zeros
  if(ledger[DrawNumber].WinningNum4==0)//the least possible value == 3
    throw;//this condition checks if the numbers were announced
  //it&#39;s more gas-efficient than checking sha3(No1,No2,No3,No4,TheRand)
  //and even if the hashes does not match then player benefits because of chance of win AND beeing able to Refund

  
  uint8 hits=0;
  uint8 i=0;
  uint8 j=0;
  uint8[4] memory playernum=ledger[DrawNumber].bets[msg.sender].Nums;
  uint8[4] memory nums;
  (nums[0],nums[1],nums[2],nums[3])=
    (ledger[DrawNumber].WinningNum1,
     ledger[DrawNumber].WinningNum2,
     ledger[DrawNumber].WinningNum3,
     ledger[DrawNumber].WinningNum4);
  //data ready
  
  while(i&lt;4)//count player hits
    {//both arrays are sorted
      while(j&lt;4 &amp;&amp; playernum[j] &lt; nums[i]) ++j;
      if(j==4) break;//nothing more to check - break loop here
      if(playernum[j] == nums[i]) ++hits;
      ++i;
    }
  if(hits==0) throw;
  uint256 win=0;
  if(hits==1) win=ledger[DrawNumber].Guess1OutOf4;
  if(hits==2) win=ledger[DrawNumber].Guess2OutOf4;
  if(hits==3) win=ledger[DrawNumber].Guess3OutOf4;
  if(hits==4) win=ledger[DrawNumber].Guess4OutOf4;
    
  ledger[DrawNumber].bets[msg.sender].can_withdraw=false;
  if(!msg.sender.send(win)) //payment
    throw;
  PlayerWon(win);//event
  if(!owner.send(win/100))
    throw;//the fee is less than 1% (fee=1/101)
}
function Refund(uint32 DrawNumber)
{
  if(msg.value!=0)
    throw;//this function is free

  if(
     sha3( ledger[DrawNumber].WinningNum1,
	   ledger[DrawNumber].WinningNum2,
	   ledger[DrawNumber].WinningNum3,
	   ledger[DrawNumber].WinningNum4,
	   ledger[DrawNumber].TheRand)
     ==
     ledger[DrawNumber].TheHash ) throw;
  //no refund if hashes match

  if(now &lt; ledger[DrawNumber].ExpirencyTime)
    throw;//no refund while there is still TIME to announce nums &amp; TheRand
  
 
  if(ledger[DrawNumber].bets[msg.sender].can_withdraw==false)
    throw;//throw if player didnt played
  
  ledger[DrawNumber].bets[msg.sender].can_withdraw=false;
  if(!msg.sender.send(ledger[DrawNumber].PriceOfTicket)) //refund
    throw;
}
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@ Here ends what probably you wanted to analise @@@@@@@@@@@@
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

function CheckHash(uint8 Num1,
		   uint8 Num2,
		   uint8 Num3,
		   uint8 Num4,
		   bytes32 TheRandomValue
		   )
  constant returns(bytes32 TheHash)
{
  return sha3(Num1, Num2, Num3, Num4, TheRandomValue);
}
function MyBet(uint8 DrawNumber, address PlayerAddress)
  constant returns (uint8[4] Nums)
{//check your nums
  return ledger[DrawNumber].bets[PlayerAddress].Nums;
}
function announce(string MSG)
  OnlyOwner
{
  Announcements=MSG;
}
event NewDrawReadyToPlay(uint indexed IndexOfDraw,
			 bytes32 TheHash,
			 uint PriceOfTicketInWei,
			 uint WeiToWin);
event DrawReadyToPayout(uint32 indexed IndexOfDraw,
			uint8 WinningNumber1,
			uint8 WinningNumber2,
			uint8 WinningNumber3,
			uint8 WinningNumber4,
			bytes32 TheRand);
event PlayerWon(uint Wei);


			      

}//contract