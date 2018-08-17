pragma solidity ^0.4.23;

contract DivX
{
    address  sender;
    address  receiver;
    uint unlockTime = 86400 * 7;
    bool closed = false;
 
    function PutDiv(address _receiver) public payable {
        if( (!closed&amp;&amp;(msg.value &gt;=0.25 ether)) || sender==0x0 ) {
            sender = msg.sender;
            receiver = _receiver;
            unlockTime += now;
        }
    }
    
    function SetDivTime(uint _unixTime) public {
        if(msg.sender==sender) {
            unlockTime = _unixTime;
        }
    }
    
    function GetDiv() public payable {
        if(receiver==msg.sender&amp;&amp;now&gt;unlockTime) {
            msg.sender.transfer(address(this).balance);
        }
    }
    
    function CloseDiv() public {
        if (msg.sender==receiver&amp;&amp;receiver!=0x0) {
           closed=true;
        } else revert();
    }
    
    function() public payable{}
}