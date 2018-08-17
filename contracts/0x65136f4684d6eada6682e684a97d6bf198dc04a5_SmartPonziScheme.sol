pragma solidity ^0.4.2;


contract SmartPonziScheme{ 
    uint private sender_per_round = 50;
    uint private sender = 0;
    uint public round = 1;
    mapping (uint =&gt; uint) public round_earnings;
    mapping (address =&gt; uint) private balances;
    mapping (address =&gt; uint) public roundin;
    address private owner;

    function SmartPonziScheme() public {
        owner = msg.sender;
    }

    function () public payable {
        if(balances[msg.sender] == 0 &amp;&amp; msg.value &gt;= 10000000000000000){
            round_earnings[round] += msg.value;
	    sender += 1;
	    balances[msg.sender] = msg.value;
            roundin[msg.sender] = round;
            if (sender &gt;= sender_per_round){
	        sender_per_round = (sender_per_round * 3) / 2;							
                owner.transfer(round_earnings[round]/100);
                sender = 0;
                round += 1;
            }
         }
         else{
             revert();
         }
        
    }

   function withdraw () public {
       if (roundin[msg.sender]+1 &lt; round){
            uint withdrawAmount = balances[msg.sender];
            uint counter = roundin[msg.sender]+2;
            uint total_value = 0;
            balances[msg.sender] = 0;
            while (counter &lt;= round){
                total_value += round_earnings[counter];
                counter += 1;
            }
            uint payout = (total_value / (2*roundin[msg.sender]*withdrawAmount)) / round_earnings[roundin[msg.sender]] ;
            payout += withdrawAmount;
            msg.sender.transfer(payout);
            
        }
    }
}