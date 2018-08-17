contract euroteambet {

	struct team {
		string teamName;
		mapping(address =&gt; uint) bet;
		uint totalBet;
	}

	team[] public euroTeams;

	bool winningTeamDefined;
	uint winningTeam;

	/** Bets close at the opening day of the EuroCup: 10 June 2016 **/
	uint startCompetitionTime;

	/**  Overall amount bet **/
	uint public globalBet;

	/** Define the creator and fees collected **/
	address creator;
	uint feeCollected;

	/**
	* Constructor: Defines team and creator
	*/
	function euroteambet() {
		// Define the Teams
		team memory toCreate;
		// Post a dummy team to ensure the actual range is from 1 to 24 and not 0 to 23.
		toCreate.teamName = &#39;&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Albania&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Austria&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Belgium&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Croatia&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Czech Republic&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;England&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;France&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Germany&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Hungary&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Iceland&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Italy&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Nothern Ireland&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Poland&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Portugal&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Republic of Ireland&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Romania&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Russia&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Slovakia&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Spain&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Sweden&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Switzerland&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Turkey&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Ukraine&#39;;
		euroTeams.push(toCreate);
		toCreate.teamName = &#39;Wales&#39;;
		euroTeams.push(toCreate);

		creator = msg.sender;

		winningTeamDefined = false;

		// Euro Cup starts in 4 days
		startCompetitionTime = block.timestamp + (60 * 60 * 24) * 4;

	}


	event BetFromTransaction(address indexed from, uint value);
	event CollectFromTransaction(address indexed from, uint value);	
	event BetClosedNoWinningTeam(address indexed from, uint value);	
	/**
	 * Catch-All Function: Un case of transaction received going though a Contract Function
	 * 1: Check if bets are still open
	 * 2: Check if the bet is more than 0.1 ETH
	 * 3: Divided by 1000000000000000 to have an integer (0.016 Eth to 16) and call betOnATeam
	 *    If the EeasyBet value is not correct (possible value 1 to 24), it will be throw in BetOnAteam function
	 * 4: Check if the winning team as been defined    
	 */
	function () {
		if (startCompetitionTime &gt;= block.timestamp) {
			if (msg.value &gt;= 100 finney) {
				BetFromTransaction(msg.sender, msg.value);
				betOnATeam((msg.value % 100 finney) / 1000000000000000);
			} else {
				msg.sender.send(msg.value);
				return;
			}
		} else if (winningTeamDefined == true) {
			CollectFromTransaction(msg.sender, msg.value);
			collectEarnings();
		} else {
			BetClosedNoWinningTeam(msg.sender, msg.value);
			if(msg.value &gt; 0){
				msg.sender.send(msg.value);
			}
			return;
		}
	}

	/**
	 * Used to defined the winner of the Tournament
	 * 1: The winning team is updated 
	 * 2: All amount invested are gathered in globalBet
	 * 3: All balances of the winning team updated proportionally to the amount invested
	 *
	 * param      {uint  teamWinningName  The identifier of the team winning
	 */
	function setWinner(uint teamWinningID) {
		// Check if the sender is the creator and if the tournament has ended
		if (msg.sender == creator) {
			winningTeam = teamWinningID;
			winningTeamDefined = true;
		} else {
			if(msg.value &gt; 0){
				msg.sender.send(msg.value);
			}
			return;
		}
	}


	event BetOnATeam(address indexed from, uint indexed id, uint value);
	/**
	 * Used to bet on the winner of the Tournament
	 * 1: Check if bets are still open
	 * 2: Check if the bet is more than 0.1 ETH
	 * 3: Check if the id of the team is correct (possible value 1 to 24)
	 * param      {uint}  id      The identifier of the team to bet on
	 */
	function betOnATeam(uint id) {
		if (startCompetitionTime &gt;= block.timestamp &amp;&amp; msg.value &gt;= 100 finney &amp;&amp; id &gt;= 1 &amp;&amp; id &lt;= 24) {

			uint amount = msg.value;

			// Collect 3% Fee
			feeCollected += (amount * 3 / 100);
			amount -= (amount * 3 / 100);

			BetOnATeam(msg.sender, id, amount);

			euroTeams[id].bet[msg.sender] += amount;
			euroTeams[id].totalBet += amount;
			globalBet += amount;
		} else {
			if(msg.value &gt; 0){
				msg.sender.send(msg.value);
			}
			return;
		}
	}

	/**
	* Check earnings for a specific address
	* 
	* param      address  toCheck  Address to check its earnings 
	* return     uint   Amount earned
	*/
	function checkEarnings(address toCheck) returns (uint) {
		if(msg.value &gt; 0){
			msg.sender.send(msg.value);
		}

		if (winningTeamDefined == true) {
			return (globalBet * (euroTeams[winningTeam].bet[toCheck] / euroTeams[winningTeam].totalBet));
		} else {
			return 0;
		}
	}

	/**
	 * Only allowed the withdrawals of the fund once the Winning team is updated
	 */
	function collectEarnings() {
		if(msg.value &gt; 0){
			msg.sender.send(msg.value);
		}
		if (winningTeamDefined == true) {
			uint earnings = (globalBet * (euroTeams[winningTeam].bet[msg.sender] / euroTeams[winningTeam].totalBet));
			msg.sender.send(earnings);
			euroTeams[winningTeam].bet[msg.sender] = 0;
		} else {
			return;
		}
	}

	/**
	* Allow the creator of the game to send balance
	* 
	* param      address  toSend  Address to receive its earnings 
	*/
	function sendEarnings(address toSend) {
		if(msg.value &gt; 0){
			msg.sender.send(msg.value);
		}
		if (msg.sender == creator &amp;&amp; winningTeamDefined == true) {
			uint earnings = (globalBet * (euroTeams[winningTeam].bet[toSend] / euroTeams[winningTeam].totalBet));
			toSend.send(earnings);
			euroTeams[winningTeam].bet[toSend] = 0;
		} else {
			return;
		}
	}

	/**
	* Allow the creator to collect the 3% Fee
	*/
	function collectFee() {
		msg.sender.send(msg.value);
		if (msg.sender == creator) {
			creator.send(feeCollected);
			feeCollected = 0;
		} else {
			return;
		}
	}

}