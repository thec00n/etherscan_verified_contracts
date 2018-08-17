pragma solidity ^0.4.11;

contract Bills
{
    string public name          = &quot;Bills&quot;;
    string public symbol        = &quot;BLS&quot;;
    uint public totalSupply     = 3000000;
    uint public decimals        = 0;
    uint public tokenPrice;
    
    address private Owner;
    
    uint ICOTill   = 1523145601;
	uint ICOStart  = 1520467201;
    
    mapping (address =&gt; uint) public balanceOf;
    
    event Transfer(address indexed from, address indexed to, uint value);
    
    modifier onlyModerator()
    {
        require(msg.sender == moderators[msg.sender].Address || msg.sender == Owner);
        _;
    }
    
    modifier onlyOwner()
    {
        require(msg.sender == Owner);
        _;
    }
    
    modifier isICOend()
    {
        require(now &gt;= ICOTill);
        _;
    }
    
    function Bills() public
    {
        name                    = name;
        symbol                  = symbol;
        totalSupply             = totalSupply;
        decimals                = decimals;
        
        balanceOf[this]         = 2800000;
		balanceOf[msg.sender]   = 200000;
        Owner                   = msg.sender;
    }
    
    struct Advert
    {
        uint BoardId;
        uint PricePerDay;
        uint MaxDays;
        address Advertiser;
        string AdvertSrc;
        uint Till;
        uint AddTime;
        uint SpentTokens;
        string Status;
        bool AllowLeasing;
    }
    
    struct Moderator
    {
        address Address;
    }
    
    mapping (uint =&gt; Advert) info;
    
    mapping (address =&gt; Moderator) moderators;
    
    uint[] Adverts;
    address[] Moderators;
    
    function() public payable
    {
        require(now &gt;= ICOStart || now &gt;= ICOTill);
        
        if(now &gt;= ICOStart &amp;&amp; now &lt;= ICOTill)
        {
            require(
                msg.value == 100000000000000000 || msg.value == 300000000000000000 || msg.value == 500000000000000000 || msg.value == 800000000000000000 || 
                msg.value == 1000000000000000000 || msg.value == 3000000000000000000 || msg.value == 5000000000000000000
            );
            
            if(msg.value == 100000000000000000)
            {
                require(balanceOf[this] &gt;= 31);
                balanceOf[msg.sender] += 31;
                balanceOf[this] -= 31;
                Transfer(this, msg.sender, 31);
            }
            if(msg.value == 300000000000000000)
            {
                require(balanceOf[this] &gt;= 95);
                balanceOf[msg.sender] += 95;
                balanceOf[this] -= 95;
                Transfer(this, msg.sender, 95);
            }
            if(msg.value == 500000000000000000)
            {
                require(balanceOf[this] &gt;= 160);
                balanceOf[msg.sender] += 160;
                balanceOf[this] -= 160;
                Transfer(this, msg.sender, 160);
            }
            if(msg.value == 800000000000000000)
            {
                require(balanceOf[this] &gt;= 254);
                balanceOf[msg.sender] += 254;
                balanceOf[this] -= 254;
                Transfer(this, msg.sender, 254);
            }
            if(msg.value == 1000000000000000000)
            {
                require(balanceOf[this] &gt;= 317);
                balanceOf[msg.sender] += 317;
                balanceOf[this] -= 317;
                Transfer(this, msg.sender, 317);
            }
            if(msg.value == 3000000000000000000)
            {
                require(balanceOf[this] &gt;= 938);
                balanceOf[msg.sender] += 938;
                balanceOf[this] -= 938;
                Transfer(this, msg.sender, 938);
            }
            if(msg.value == 5000000000000000000)
            {
                require(balanceOf[this] &gt;= 1560);
                balanceOf[msg.sender] += 1560;
                balanceOf[this] -= 1560;
                Transfer(this, msg.sender, 1560);
            }
        }
        
        if(now &gt;= ICOTill)
        {
            require(msg.sender.balance &gt;= msg.value);
            
            uint _Amount = msg.value / tokenPrice;
            
            require(balanceOf[this] &gt;= _Amount);
            
            balanceOf[msg.sender] += _Amount;
            balanceOf[this] -= _Amount;
            
            Transfer(this, msg.sender, _Amount);
        }
    }
    
    function ContractBalance() public view returns (uint)
    {
        return balanceOf[this];
    }
    
    function LeaseBill(uint BoardId, uint Days, string AdvertSrc) isICOend public 
    {
        var Advr = info[BoardId];
        
        uint Price = Days * Advr.PricePerDay;
        
        require(Advr.BoardId == BoardId &amp;&amp; BoardId &gt; 0);
        require(bytes(AdvertSrc).length &gt; 0);
        require(Days &lt;= Advr.MaxDays &amp;&amp; Days &gt; 0);
        require(balanceOf[msg.sender] &gt;= Price);
        require(Advr.Till &lt;= now);
        require(Advr.AllowLeasing == true);
        require(keccak256(Advr.Status) == keccak256(&quot;Free&quot;) || keccak256(Advr.Status) == keccak256(&quot;Published&quot;));
        
        require(balanceOf[this] + Price &gt;= balanceOf[this]);
        balanceOf[msg.sender] -= Price;
        balanceOf[this] += Price;
        Transfer(msg.sender, this, Price);
        
        Advr.Advertiser         = msg.sender;
        Advr.AdvertSrc          = AdvertSrc;
        Advr.Till               = now + 86399 * Days;
        Advr.AddTime            = now;
        Advr.SpentTokens        = Price;
        Advr.Status             = &quot;Moderate&quot;;
    }
    
    function ModerateBill(uint BoardIdToModerate, bool Published) onlyModerator isICOend public
    {
        var Advr = info[BoardIdToModerate];
        
        require(Advr.BoardId == BoardIdToModerate &amp;&amp; BoardIdToModerate &gt; 0);
        
        if(Published == true)
        {
            require(keccak256(Advr.Status) == keccak256(&quot;Moderate&quot;));
        
            uint CompensateTime   = now - Advr.AddTime;
            
            Advr.Till             = Advr.Till + CompensateTime;
            Advr.Status           = &quot;Published&quot;;
        }
        
        if(Published == false)
        {
            require(keccak256(Advr.Status) == keccak256(&quot;Moderate&quot;));
            
			require(balanceOf[this] &gt;= Advr.SpentTokens);
			
            balanceOf[Advr.Advertiser] += Advr.SpentTokens;
            balanceOf[this] -= Advr.SpentTokens;
            Transfer(this, Advr.Advertiser, Advr.SpentTokens);
            
            delete Advr.Advertiser;
            delete Advr.AdvertSrc;
            delete Advr.Till;
            delete Advr.AddTime;
            delete Advr.SpentTokens;
            
            Advr.Status = &quot;Free&quot;;
        }
    }
    
    function ChangeBillLeasingInfo(uint _BillToEdit, uint _NewPricePerDay, uint _NewMaxDays, bool _AllowLeasing) onlyOwner isICOend public
    {
        var Advr = info[_BillToEdit];
        
        require(Advr.BoardId == _BillToEdit &amp;&amp; _BillToEdit &gt; 0 &amp;&amp; _NewPricePerDay &gt; 0 &amp;&amp; _NewMaxDays &gt; 0);
        
        Advr.BoardId          = _BillToEdit;
        Advr.PricePerDay      = _NewPricePerDay;
        Advr.MaxDays          = _NewMaxDays;
        Advr.AllowLeasing     = _AllowLeasing;
    }
    
    function AddBill(uint NewBoardId, uint PricePerDay, uint MaxDays, bool _AllowLeasing) onlyOwner isICOend public
    {
        var Advr              = info[NewBoardId];
        
        require(Advr.BoardId  != NewBoardId &amp;&amp; NewBoardId &gt; 0 &amp;&amp; PricePerDay &gt; 0 &amp;&amp; MaxDays &gt; 0);
        
        Advr.BoardId          = NewBoardId;
        Advr.PricePerDay      = PricePerDay;
        Advr.MaxDays          = MaxDays;
        Advr.Status           = &quot;Free&quot;;
        Advr.AllowLeasing     = _AllowLeasing;
        
        Adverts.push(NewBoardId);
    }
    
    function AddBillModerator(address Address) onlyOwner isICOend public
    {
        var Modr = moderators[Address];
        
        require(Modr.Address != Address);
        
        Modr.Address = Address;
        
        Moderators.push(Address);
    }
    
    function DeleteBillModerator(address _Address) onlyOwner isICOend public
    {
        delete moderators[_Address];
    }
    
    function AboutBill(uint _BoardId) public view returns (uint BoardId, uint PricePerDay, uint MaxDays, string AdvertSource, uint AddTime, uint Till, string Status, bool AllowLeasing)
    {
        var Advr = info[_BoardId];
        
        return (Advr.BoardId, Advr.PricePerDay, Advr.MaxDays, Advr.AdvertSrc, Advr.AddTime, Advr.Till, Advr.Status, Advr.AllowLeasing);
    }
    
    function SetTokenPrice(uint _Price) onlyOwner isICOend public
    {
        tokenPrice = _Price;
    }
	
	function transfer(address _to, uint _value) public
	{
        require(balanceOf[msg.sender] &gt;= _value);
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }
    
    function WithdrawEther() onlyOwner public
    {
        Owner.transfer(this.balance);
    }
    
    function ChangeOwner(address _Address) onlyOwner public
    {
        Owner = _Address;
    }
}