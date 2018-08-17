contract NoxonFund {

    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply; //18160ddd for rpc call https://api.etherscan.io/api?module=proxy&amp;data=0x18160ddd&amp;to=0xContractAdress&amp;apikey={eserscan api}&amp;action=eth_call
    uint256 public Entropy;
    uint256 public ownbalance; //d9c7041b

	uint256 public sellPrice; //4b750334
    uint256 public buyPrice; //8620410b
    
    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    
    
    /* Initializes cont ract with initial supply tokens to the creator of the contract */
    function token()  {
    
        if (owner!=0) throw;
        buyPrice = msg.value;
        balanceOf[msg.sender] = 1;    // Give the creator all initial tokens
        totalSupply = 1;              // Update total supply
        Entropy = 1;
        name = &#39;noxonfund.com&#39;;       // Set the name for display purposes
        symbol = &#39;? SHARE&#39;;             // Set the symbol for display purposes
        decimals = 0;                 // Amount of decimals for display purposes
        owner = msg.sender;
        setPrices();
    }
    

    
     /* Send shares function */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;    
        balanceOf[_to] += _value;                            // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }
	

    function setPrices() {
        ownbalance = this.balance; //own contract balance
        sellPrice = ownbalance/totalSupply;
        buyPrice = sellPrice*2; 
    }
    
    
   function () returns (uint buyreturn) {
       
        uint256 amount = msg.value / buyPrice;                // calculates the amount
        balanceOf[msg.sender] += amount;                   // adds the amount to buyer&#39;s balance
       
        totalSupply += amount;
        Entropy += amount;
        
        Transfer(0, msg.sender, amount);
        
        owner.send(msg.value/2);
        //set next price
        setPrices();
        return buyPrice;
   }
   

    
    function sell(uint256 amount) {
        setPrices();
        if (balanceOf[msg.sender] &lt; amount ) throw;        // checks if the sender has enough to sell
        Transfer(msg.sender, this, amount);                 //return shares to contract
        totalSupply -= amount;
        balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller&#39;s balance
        msg.sender.send(amount * sellPrice);               // sends ether to the seller
        setPrices();

    }
	
	//All incomse will send using newIncome method
	event newincomelog(uint amount,string description);
	function newIncome(
        string JobDescription
    )
        returns (string result)
    {
        if (msg.value &lt;= 1 ether/100) throw;
        newincomelog(msg.value,JobDescription);
        return JobDescription;
    }
    
    
    
    //some democracy
    
    uint votecount;
    uint voteno; 
    uint voteyes;
    
    mapping (address =&gt; uint256) public voters;
    
    function newProposal(
        string JobDescription
    )
        returns (string result)
    {
        if (msg.sender == owner) {
            votecount = 0;
            newProposallog(JobDescription);
            return &quot;ok&quot;;
        } else {
            return &quot;Only admin can do this&quot;;
        }
    }
    

    
    
    function ivote(bool myposition) returns (uint result) {
        votecount += balanceOf[msg.sender];
        
        if (voters[msg.sender]&gt;0) throw;
        voters[msg.sender]++;
        votelog(myposition,msg.sender,balanceOf[msg.sender]);
        return votecount;
    }

    
    event newProposallog(string description);
    event votelog(bool position, address voter, uint sharesonhand);
   
    
}