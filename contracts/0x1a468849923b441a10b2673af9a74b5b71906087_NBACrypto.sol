pragma solidity ^0.4.18;

contract NBACrypto {

	address ceoAddress = 0xD2f0e35EB79789Ea24426233336DDa6b13E2fA1f;
    address cfoAddress = 0x831a278fF506bf4dAa955359F9c5DA9B9Be18f3A;

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
		uint256 commission5percent = (msg.value / 10);

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
        teams.push(Team(&quot;Cavaliers&quot;, cfoAddress, 800000000000000000)); 
		teams.push(Team(&quot;Warriors&quot;, cfoAddress, 800000000000000000)); 
		teams.push(Team(&quot;Celtics&quot;, cfoAddress, 400000000000000000)); 
        teams.push(Team(&quot;Rockets&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Raptors&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Spurs&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Wizards&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Timberwolves&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Pacers&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Thunder&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Bucks&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Lakers&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;76ers&quot;, cfoAddress, 400000000000000000));
        teams.push(Team(&quot;Blazers&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Heat&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Pelicans&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Pistons&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Clippers&quot;, cfoAddress, 200000000000000000)); 
        teams.push(Team(&quot;Hornets&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Jazz&quot;, cfoAddress, 200000000000000000)); 
        teams.push(Team(&quot;Knicks&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Nuggets&quot;, cfoAddress, 200000000000000000)); 
        teams.push(Team(&quot;Bulls&quot;, cfoAddress, 200000000000000000)); 
        teams.push(Team(&quot;Grizzlies&quot;, cfoAddress, 200000000000000000));
        teams.push(Team(&quot;Nets&quot;, cfoAddress, 100000000000000000));
        teams.push(Team(&quot;Kings&quot;, cfoAddress, 100000000000000000));
        teams.push(Team(&quot;Magic&quot;, cfoAddress, 100000000000000000));
        teams.push(Team(&quot;Mavericks&quot;, cfoAddress, 100000000000000000));
        teams.push(Team(&quot;Hawks&quot;, cfoAddress, 100000000000000000)); 		
        teams.push(Team(&quot;Suns&quot;, cfoAddress, 100000000000000000)); 
        			
        		
	}

}