pragma solidity ^0.4.11;

contract token {
    function transfer(address receiver, uint amount);
    function balanceOf( address _address )returns(uint256);
}

contract DragonCrowdsale {
    address public beneficiary;
    address public owner;
    address public charity;
  
    uint public amountRaised;
    uint public tokensSold;
    uint public deadline;
    uint public price;
    uint public preICOspecial;
    
    
    token public tokenReward;
    mapping( address =&gt; uint256 ) public contributions;
    mapping( address =&gt; bool )    public preICOparticipated;
    
    bool public crowdSaleStart;
    bool public crowdSalePause;
    bool public crowdSaleClosed;
    
    enum Package { Zero, Small, Large }
    
    Package package;
    

   
    event FundTransfer(address participant, uint amount);

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }

    function DragonCrowdsale() {
        beneficiary = msg.sender; //beneficiary is initially the contract deployer
        charity = msg.sender; //charity is initially the contract deployer
        owner = msg.sender;// owner is initially the contract deployer
        price =  .000000000033333333 ether;
        tokenReward = token( 0x1d1CF6cD3fE91fe4d1533BA3E0b7758DFb59aa1f );
        crowdSaleStart == false;
        preICOspecial = 3500000000000000;
        
    }

    function () payable {
        
        require(!crowdSaleClosed);
        require(!crowdSalePause);
        
        
        
        // only two purchase values acceptable due to ppre-ico packages
        if( msg.value != .3333333 ether &amp;&amp; msg.value != 3.3333333 ether  &amp;&amp; crowdSaleStart == false  ) throw;
        if ( crowdSaleStart == false &amp;&amp; preICOparticipated[msg.sender] == true ) throw;
        if ( crowdSaleStart == false ) {
            
            if ( msg.value ==  .3333333 ether ) package = Package.Small;
            if ( msg.value == 3.3333333 ether ) package = Package.Large;
        }
        
       
        if ( crowdSaleStart) require( now &lt; deadline );
        uint amount = msg.value;
        
        tokenReward.transfer( msg.sender, amount / price ); // what buyer purchases
        
        // only triggers before official launch
        if ( package == Package.Small  &amp;&amp; crowdSaleStart == false &amp;&amp; tokensSold &lt; preICOspecial ) { 
        
            tokenReward.transfer( charity    , 800000000  );  //charitable donation
            tokenReward.transfer( msg.sender , 800000000  );  // buyer&#39;s reward bonus
            preICOparticipated[ msg.sender ] = true; 
            tokensSold +=  1600000000;
            
        }
        
        // only triggers before official launch
        if ( package == Package.Large  &amp;&amp; crowdSaleStart == false &amp;&amp; tokensSold &lt; preICOspecial ) { 
        
            tokenReward.transfer( charity    , 8000000000 );  // charitable donation
            tokenReward.transfer( msg.sender , 8000000000 );  // buyer&#39;s reward bonus
            preICOparticipated[ msg.sender ] = true; 
            tokensSold += 16000000000;
            
        }
        
        contributions[msg.sender] += amount;
        tokensSold += amount / price;
        amountRaised += amount;
        FundTransfer( msg.sender, amount );
        beneficiary.transfer( amount );
        
        
    }

    // Start this October 27 and crowdsale will run for 60 days
    function startCrowdsale() onlyOwner  {
        
        crowdSaleStart = true;
        deadline = now + 60 days;
    }

    //terminates the crowdsale
    function endCrowdsale() onlyOwner  {
        
        
        crowdSaleClosed = true;
    }


    function pauseCrowdsale() onlyOwner {
        
        crowdSalePause = true;
        
        
    }

    function unpauseCrowdsale() onlyOwner {
        
        crowdSalePause = false;
        
        
    }
    
    function transferOwnership ( address _newowner ) onlyOwner {
        
        owner = _newowner;
        
    }
    
    // use this to set the crowdsale beneficiary address
    function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
        
        beneficiary = _newbeneficiary;
        
    }
    
    // use this to set the charity address
    function transferCharity ( address _newcharity ) onlyOwner {
        
        charity = _newcharity;
        
    }
    
    //empty the crowdsale contract and forward balance to beneficiary
    function withdrawDragons() onlyOwner{
        
        uint256 balance = tokenReward.balanceOf(address(this));
        
        tokenReward.transfer( beneficiary, balance );
        
        
    }
    
}