pragma solidity ^0.4.18;

contract WorldCryptoCup {

	address ceoAddress = 0x46d9112533ef677059c430E515775e358888e38b;
    address cfoAddress = 0x23a49A9930f5b562c6B1096C3e6b5BEc133E8B2E;

	struct Team {
		string name;
		address ownerAddress;
		uint256 curPrice;
	}
	Team[] teams;

	modifier onlyCeo() {
        require (msg.sender == ceoAddress);
        _;
    }

    bool teamsAreInitiated;
    bool isPaused;
    
    /*
    We use the following functions to pause and unpause the game.
    */
    function pauseGame() public onlyCeo {
        isPaused = true;
    }
    function unPauseGame() public onlyCeo {
        isPaused = false;
    }
    function GetIsPauded() public view returns(bool) {
       return(isPaused);
    }

    /*
    This function allows players to purchase countries from other players. 
    The price is automatically multiplied by 2 after each purchase.
    Players can purchase multiple coutries
    */
	function purchaseCountry(uint _countryId) public payable {
		require(msg.value == teams[_countryId].curPrice);
		require(isPaused == false);

		// Calculate the 5% value
		uint256 commission5percent = ((msg.value / 10)/2);

		// Calculate the owner commission on this sale &amp; transfer the commission to the owner.		
		uint256 commissionOwner = msg.value - commission5percent; // =&gt; 95%
		teams[_countryId].ownerAddress.transfer(commissionOwner);

		// Transfer the 5% commission to the developer
		cfoAddress.transfer(commission5percent); // =&gt; 5% (25% remains in the Jackpot)						

		// Update the team owner and set the new price
		teams[_countryId].ownerAddress = msg.sender;
		teams[_countryId].curPrice = mul(teams[_countryId].curPrice, 2);
	}
	
	/*
	This function can be used by the owner of a team to modify the price of its team.
	He can make the price smaller than the current price but never bigger.
	*/
	function modifyPriceCountry(uint _teamId, uint256 _newPrice) public {
	    require(_newPrice &gt; 0);
	    require(teams[_teamId].ownerAddress == msg.sender);
	    require(_newPrice &lt; teams[_teamId].curPrice);
	    teams[_teamId].curPrice = _newPrice;
	}
	
	// This function will return all of the details of our teams
	function getTeam(uint _teamId) public view returns (
        string name,
        address ownerAddress,
        uint256 curPrice
    ) {
        Team storage _team = teams[_teamId];

        name = _team.name;
        ownerAddress = _team.ownerAddress;
        curPrice = _team.curPrice;
    }
    
    // This function will return only the price of a specific team
    function getTeamPrice(uint _teamId) public view returns(uint256) {
        return(teams[_teamId].curPrice);
    }
    
    // This function will return only the addess of a specific team
    function getTeamOwner(uint _teamId) public view returns(address) {
        return(teams[_teamId].ownerAddress);
    }
    
    /**
    @dev Multiplies two numbers, throws on overflow. =&gt; From the SafeMath library
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
          return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    @dev Integer division of two numbers, truncating the quotient. =&gt; From the SafeMath library
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

	// We run this function once to create all the teams and set the initial price.
	function InitiateTeams() public onlyCeo {
		require(teamsAreInitiated == false);
        teams.push(Team(&quot;Brazil&quot;, cfoAddress, 700000000000000000)); 
        teams.push(Team(&quot;Russia&quot;, cfoAddress, 195000000000000000)); 
        teams.push(Team(&quot;Saudi Arabia&quot;, cfoAddress, 15000000000000000)); 
        teams.push(Team(&quot;Egypt&quot;, cfoAddress, 60000000000000000)); 
        teams.push(Team(&quot;Portugal&quot;, cfoAddress, 350000000000000000)); 
        teams.push(Team(&quot;Spain&quot;, cfoAddress, 650000000000000000)); 
        teams.push(Team(&quot;Iran&quot;, cfoAddress, 30000000000000000)); 
        teams.push(Team(&quot;Germany&quot;, cfoAddress, 750000000000000000)); 
        teams.push(Team(&quot;Mexico&quot;, cfoAddress, 125000000000000000)); 
        teams.push(Team(&quot;Sweden&quot;, cfoAddress, 95000000000000000)); 
        teams.push(Team(&quot;South Korea&quot;, cfoAddress, 30000000000000000)); 
        teams.push(Team(&quot;France&quot;, cfoAddress, 750000000000000000)); 
        teams.push(Team(&quot;Australia&quot;, cfoAddress, 40000000000000000)); 
        teams.push(Team(&quot;Peru&quot;, cfoAddress, 60000000000000000)); 
        teams.push(Team(&quot;Denmark&quot;, cfoAddress, 95000000000000000)); 
        teams.push(Team(&quot;Belgium&quot;, cfoAddress, 400000000000000000)); 
        teams.push(Team(&quot;Panama&quot;, cfoAddress, 25000000000000000)); 
        teams.push(Team(&quot;Tunisia&quot;, cfoAddress, 30000000000000000)); 
        teams.push(Team(&quot;England&quot;, cfoAddress, 500000000000000000)); 
        teams.push(Team(&quot;Argentina&quot;, cfoAddress, 650000000000000000)); 
        teams.push(Team(&quot;Iceland&quot;, cfoAddress, 75000000000000000)); 
        teams.push(Team(&quot;Croatia&quot;, cfoAddress, 125000000000000000)); 
        teams.push(Team(&quot;Nigeria&quot;, cfoAddress, 75000000000000000)); 
        teams.push(Team(&quot;Poland&quot;, cfoAddress, 125000000000000000)); 
        teams.push(Team(&quot;Senegal&quot;, cfoAddress, 70000000000000000)); 
        teams.push(Team(&quot;Colombia&quot;, cfoAddress, 195000000000000000)); 
        teams.push(Team(&quot;Japan&quot;, cfoAddress, 70000000000000000)); 
        teams.push(Team(&quot;Uruguay&quot;, cfoAddress, 225000000000000000));
        teams.push(Team(&quot;Morocco&quot;, cfoAddress, 50000000000000000));
        teams.push(Team(&quot;Switzerland&quot;, cfoAddress, 125000000000000000));
        teams.push(Team(&quot;Costa Rica&quot;, cfoAddress, 50000000000000000));
        teams.push(Team(&quot;Serbia&quot;, cfoAddress, 75000000000000000));
	}
}