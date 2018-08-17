pragma solidity ^0.4.18;

contract PrivateBank
{
    mapping (address =&gt; uint) balances;
    
    function GetBal() 
    public
    constant
    returns(uint) 
    {
        return balances[msg.sender];
    }
    
    uint public MinDeposit = 1 ether;
    
    Log TransferLog;
    
    function PrivateBank(address _lib)
    {
        TransferLog = Log(_lib);
    }
    
    function Deposit()
    public
    payable
    {
        if(msg.value &gt;= MinDeposit)
        {
            balances[msg.sender]+=msg.value;
            TransferLog.AddMessage(msg.sender,msg.value,&quot;Deposit&quot;);
        }
    }
    
    function CashOut(uint _am)
    {
        if(_am&lt;=balances[msg.sender])
        {
            if(msg.sender.call.value(_am)())
            {
                balances[msg.sender]-=_am;
                TransferLog.AddMessage(msg.sender,_am,&quot;CashOut&quot;);
            }
        }
    }
    
    function() public payable{}
    
    function bal()
    public
    constant
    returns(uint)
    {
         return this.balance;
    }
}

contract Log 
{
   
    struct Message
    {
        address Sender;
        string  Data;
        uint Val;
        uint  Time;
    }
    
    Message[] public History;
    
    Message public LastMsg;
    
    function AddMessage(address _adr,uint _val,string _data)
    public
    {
        LastMsg.Sender = _adr;
        LastMsg.Time = now;
        LastMsg.Val = _val;
        LastMsg.Data = _data;
        History.push(LastMsg);
    }
}