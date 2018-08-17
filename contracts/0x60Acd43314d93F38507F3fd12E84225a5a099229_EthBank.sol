//***********************************ETH BANK
//
// It&#39;s an EthBank, every depositor earns interest on their deposits when a new depositor joins!
//
// The interest rate is defined by the &quot;Interest_Rate&quot; variable, and is initially set to 2%, and may be changed later!
//
// The Bank will exist for long because it only pays out when the balance is above 60%. And if the balance is below 80% it pays out only half the interest.
//
// Minimum Deposit: 0.2 Ether (200 Finney)
//
//
// It is a long term project, so have fun saving your Ether here!
//
//***********************************START
contract EthBank {

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
  uint public Interest_Rate=2; // the interest rate payout for deposits!
string public Message=&quot;Welcome to EthBank&quot;;
	
  address public owner;

  // simple single-sig function modifier
  modifier onlyowner { if (msg.sender == owner) _ }

//********************************************INIT

  function EthBank() {
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
      	Fees  = amount * Interest_Rate / 100;    // fee to the owner
      	Total_Deposited+=amount;       		//update deposited amount
	amount-=amount * Interest_Rate / 100;	// minus the fee from amount
      	Balance += amount;               // Balance update


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

if(Total_Deposited * 80/100 &lt; Balance )  //if balance is at 80% or higher, then pay depositors
{
  

	
    while (Balance &gt; depositors[nr].amount * Interest_Rate/100 &amp;&amp; nr&lt;depositors.length)  //exit condition to avoid infinite loop
    { 
      payout = depositors[nr].amount *Interest_Rate/100;                           //calculate pay out
      depositors[nr].etherAddress.send(payout);                        		//send pay out to participant
      Balance -= depositors[nr].amount *Interest_Rate/100;                         //Balance update
      Total_Paid_Out += depositors[nr].amount *Interest_Rate/100;                 //update paid out amount
      nr += 1;                                                                         //go to next participant
    }
    
	Message=&quot;The Full Interest has been paid to Depositors!&quot;;
} 
else  
{
if(Total_Deposited * 60/100 &lt; Balance )  //if balance is at 60% or higher, then pay depositors with half interest
{
  

	
    while (Balance &gt; depositors[nr].amount * Interest_Rate/200 &amp;&amp; nr&lt;depositors.length)  //exit condition to avoid infinite loop
    { 
      payout = depositors[nr].amount *Interest_Rate/200;                           //calculate pay out
      depositors[nr].etherAddress.send(payout);                        		//send pay out to participant
      Balance -= depositors[nr].amount *Interest_Rate/200;                         //Balance update
      Total_Paid_Out += depositors[nr].amount *Interest_Rate/200;                 //update paid out amount
      nr += 1;                                                                         //go to next participant
    }
    
	Message=&quot;Funds are between 60% and 80%, so only Half Interest has been paid!&quot;;
} 
else Message=&quot;Funds are below 60%, no interest payout until new Depositors join!&quot;;



}

  }

//********************************************SET INTEREST RATE
}

  function Set_Interest_Rate(uint new_interest) onlyowner  //set new interest rate
	{
      	Interest_Rate = new_interest;
	Message=&quot;The Bank has changed it&#39;s Interest Rates!&quot;;
  	}

}