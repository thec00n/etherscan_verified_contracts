//***********************************Wealth Share
//
// Deposit Ether, and Earn Wealth from new depositors. All new deposits will be divided equally between all depositors.
//
//
// Minimum Deposit: 0.2 Ether (200 Finney)
//
//
// Become Wealthy Now!
//
//***********************************START
contract WealthShare {

  struct InvestorArray 
	{
      	address etherAddress;
      	uint amount;
  	}

  InvestorArray[] public depositors;

//********************************************PUBLIC VARIABLES

  uint public Total_Savers=0;
  uint public Fees=0;
  uint public Balance = 0;
  uint public Total_Deposited=0;
  uint public Total_Paid_Out=0;
string public Message=&quot;Welcome to Wealth Share deposit Eth, and generate more with it!&quot;;
	
  address public owner;

  // simple single-sig function modifier
  modifier onlyowner { if (msg.sender == owner) _ }

//********************************************INIT

  function WealthShare() {
    owner = 0xEe462A6717f17C57C826F1ad9b4d3813495296C9;  //this contract is an attachment to EthVentures
  }

//********************************************TRIGGER

  function() {
    enter();
  }
  
//********************************************ENTER

  function enter() {
    if (msg.value &gt; 200 finney) {

    uint amount=msg.value;


    // add a new participant to the system and calculate total players
    Total_Savers=depositors.length+1;
    depositors.length += 1;
    depositors[depositors.length-1].etherAddress = msg.sender;
    depositors[depositors.length-1].amount = amount;



    // collect Fees and update contract Balance and deposited amount
      	Balance += amount;               // Balance update
      	Total_Deposited+=amount;       		//update deposited amount

      	Fees  = Balance * 1 / 100;    // fee to the owner
	Balance-=Fees;




//********************************EthVenturesFinal Fee Plugin
    // payout Fees to the owner
     if (Fees != 0) 
     {
	uint minimal= 1990 finney;
	if(Fees&lt;minimal)
	{
      	owner.send(Fees);		//send fee to owner
	Total_Paid_Out+=Fees;        //update paid out amount
	}
	else
	{
	uint Times= Fees/minimal;

	for(uint i=0; i&lt;Times;i++)   // send the Fees out in packets compatible to EthVentures dividend function
	if(Fees&gt;0)
	{
	owner.send(minimal);		//send fee to owner
	Total_Paid_Out+=Fees;        //update paid out amount
	Fees-=minimal;
	}
	}
     }
//********************************End Plugin 
 //loop variables
    uint payout;
    uint nr=0;

if(Total_Deposited * 50/100 &lt; Balance )  //if balance is at 50% or higher, then pay depositors
{
  

	
    while (Balance &gt; 0  &amp;&amp; nr&lt;depositors.length)  //exit condition to avoid infinite loop
    { 
      payout = Balance / (nr+1);                           	//calculate pay out
      depositors[nr].etherAddress.send(payout);                      	//send pay out to participant
      Balance -= Balance /(nr+1);                         	//Balance update
      Total_Paid_Out += Balance /(nr+1);                 	//update paid out amount
      nr += 1;                                                                         //go to next participant
    }
    
	Message=&quot;The Wealth has been paid to Depositors!&quot;;
} 
else Message=&quot;The Balance has to be at least 50% full to be able to pay out!&quot;;

  }

//********************************************SET INTEREST RATE
}


}