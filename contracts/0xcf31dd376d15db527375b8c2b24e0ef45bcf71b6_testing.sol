pragma solidity ^0.4.0;


contract testing {
  mapping (address =&gt; uint256) public balanceOf;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event LogB(bytes32 h);

	  
  	function buy() payable returns (uint amount){
        amount = msg.value ;                     // calculates the amount
        if (balanceOf[this] &lt; amount) throw;               // checks if it has enough to sell
        balanceOf[msg.sender] += amount;                   // adds the amount to buyer&#39;s balance
        balanceOf[this] -= amount;                         // subtracts amount from seller&#39;s balance
        Transfer(this, msg.sender, amount);                // execute an event reflecting the change
        return amount;                                     // ends function and returns
    }
	  

}