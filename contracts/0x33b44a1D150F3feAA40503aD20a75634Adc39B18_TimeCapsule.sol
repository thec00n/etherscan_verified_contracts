pragma solidity ^0.4.17;

contract Ownable {
    address public Owner;
    
    function Ownable() { Owner = msg.sender; }
    function isOwner() internal constant returns (bool) { return( Owner == msg.sender); }
}

contract TimeCapsule is Ownable {
    address public Owner;
    mapping (address=&gt;uint) public deposits;
    uint public openDate;
    
    function initCapsule(uint open) {
        Owner = msg.sender;
        openDate = open;
    }

    function() payable { deposit(); }
    
    function deposit() {
        if( msg.value &gt;= 0.5 ether )
            deposits[msg.sender] += msg.value;
        else throw;
    }
    
    function withdraw(uint amount) {
        if( isOwner() &amp;&amp; now &gt;= openDate ) {
            uint max = deposits[msg.sender];
            if( amount &lt;= max &amp;&amp; max &gt; 0 )
                msg.sender.send( amount );
        }
    }

    function kill() {
        if( isOwner() &amp;&amp; this.balance == 0 )
            suicide( msg.sender );
	}
}