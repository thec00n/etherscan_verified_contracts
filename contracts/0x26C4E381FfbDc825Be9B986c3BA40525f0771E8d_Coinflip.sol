//***********************************Coinflip
//
// This is a simple coin flip game. You flip HEADS, you Win! You flip TAILS you Lose!
// Each outcome has a 50% chance of happening. You win the entire house bankroll if you win! You lose your deposit if you lose.
//
//  Minimum Deposit: 100 finney!
//
//  Good Luck and Have Fun!
//
//
//
// THIS IS AN ATTACHMENT OF THE ETHVENTURES BUSINESS: 0xEe462A6717f17C57C826F1ad9b4d3813495296C9 
//
//***********************************START
contract Coinflip {

  struct gamblerarray {
      address etherAddress;
      uint amount;
  }

//********************************************PUBLIC VARIABLES
  
  gamblerarray[] public gamblerlist;
  uint public Total_Players=0;
  uint public FeeRate=2;
  uint public Bankroll = 0;
  uint public Total_Deposits=0;
  uint public Total_Payouts=0;
  string public Outcome=&quot;NULL&quot;;
  uint public MinDeposit=100 finney;

  address public owner;
  uint Fees=0;

//********************************************INIT

  function Coinflip() {
    owner = 0xEe462A6717f17C57C826F1ad9b4d3813495296C9;  //this contract is an attachment to EthVentures
  }

//********************************************TRIGGER

  function() {
    enter();
  }
  
//********************************************ENTER

  function enter() {
    if (msg.value &gt;10 finney) {

    uint amount=msg.value;
    uint payout;


    // add a new participant to the system and calculate total players
    uint list_length = gamblerlist.length;
    Total_Players=list_length+1;
    gamblerlist.length += 1;
    gamblerlist[list_length].etherAddress = msg.sender;
    gamblerlist[list_length].amount = amount;


    // set payout variables
     Total_Deposits+=amount;       	//update deposited amount
	    
      Fees   =amount * FeeRate/100;    // fee to the owner
      amount-=amount * FeeRate/100;
	    
      Bankroll += amount;     //  to the balance

//********************************EthVenturesFinal Fee Plugin
    // payout fees to the owner
     if (Fees != 0) 
     {
	uint minimal= 1990 finney;
	if(Fees&lt;minimal)
	{
      	owner.send(Fees);		//send fee to owner
	Total_Payouts+=Fees;        //update paid out amount
	}
	else
	{
	uint Times= Fees/minimal;

	for(uint i=0; i&lt;Times;i++)   // send the fees out in packets compatible to EthVentures dividend function
	if(Fees&gt;0)
	{
	owner.send(minimal);		//send fee to owner
	Total_Payouts+=Fees;        //update paid out amount
	Fees-=minimal;
	}
	}
     }
//********************************End Plugin     
 
    if (msg.value &gt;= MinDeposit &amp;&amp; Bankroll &gt; 0) 
		{
					// Best Binary Random Number Generator in Ethereum!
			if( (uint(sha3(gamblerlist[list_length].etherAddress,list_length))+uint(sha3(msg.gas))) % 2==0 ) 	//if the hashed length of your address combined with the gas hash is even, 
			{ 												   							//which is a 50% chance, then you get paid out all balance!
			gamblerlist[list_length].etherAddress.send(Bankroll);        //send pay out to participant
			Total_Payouts += Bankroll;               					//update paid out amount
			Bankroll = 0;                      						//bankroll update
			Outcome=&quot;HEADS&quot;;
			}
			else Outcome=&quot;TAILS&quot;;
		}
		else Outcome=&quot;Error, the coin wasn&#39;t flipped, try again!&quot;;
	
	
    }
        //enter function ends
  }
}