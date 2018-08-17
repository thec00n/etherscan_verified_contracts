/* 
MicroDAO V0.0.2 - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="701d153004181f020304151e5d0a1f15021e15025e131f1d">[email&#160;protected]</a>&gt;
===========================================================
Simplified DAO allowing to do initial funding.
- Funders are able to specify how long to keep funds in.
- If funding is not closed by this time fundes returned
- Close funding is a manual taken by the director

Single Director
- Has the possibility to file SpendingRequest
- allowed to change fundamental parameters
- allowed to move directorship forward
- deadman switch prevents lost DAO.

Each Spending needs to be approved by share holders (Vote)
- spendings have a time to vote
- spendings require to be executed in a given number of days

- Checked for recursive withdraw bug (DAO Hack) 
*/

contract SpendingRequest {
	string public name=&quot;SpendingRequest 4 MicroDAO&quot;;
	 address public creator;
	 string public description;
	 uint256 public request_until;
	 uint256 public vote_until;
		
	 option[] public  options;
 	 address public dao;
	 mapping(address=&gt;bool) public voted;
	 bool public voting_started;
	 bool public executed;
	 address public result_payto;
	 uint256 public result_amount;
	 uint256 public result_votes;
	
	struct option {
		string description;
		address payout_to;
		uint256 eth_amount;		
		uint256 votes_pro;
		uint256 votes_veto;
	}
	
	function SpendingRequest () {
		creator=msg.sender;
	}
	
	function setDescription(string _description) {
		if(voting_started) throw;
		description=_description;		
	}
	
	function setDAO(address _dao) {
		if(msg.sender!=creator) throw;
		if(voting_started) throw;
 		if(dao!=0) throw;
		MicroDAO d = MicroDAO(_dao);
		if(d.balanceOf(creator)&lt;1) throw;
		dao=_dao;		
	}
	
	function execute(){
		if(vote_until&gt;now) return;
		if(request_until&lt;now) return;
		if((msg.sender!=dao)&amp;&amp;(msg.sender!=creator)) throw;
		for(var i=0;i&lt;options.length;i++) {
			if(options[i].votes_pro-options[i].votes_veto&gt;result_votes) {
				result_payto=options[i].payout_to;
				result_amount=options[i].eth_amount;
				if(options[i].votes_veto&gt;options[i].votes_pro) result_votes=0; else 
				result_votes=options[i].votes_pro-options[i].votes_veto;
			}
		}
		executed=true;		
	}
	
	function vote(uint256 option,bool veto) {		
		if(voted[msg.sender]) throw;
		if(now&lt;vote_until) throw;
		voting_started=true;
		MicroDAO d = MicroDAO(dao);
		if(!veto) options[option].votes_pro+=d.balanceOf(msg.sender);	else options[option].votes_veto+=d.balanceOf(msg.sender);
		
		d.blockTransfer(msg.sender,vote_until);
	}
	function setRequestUntil(uint8 days_from_now) {
		if(msg.sender!=creator) throw;
		if(voting_started) throw;
		request_until=now+(86400*days_from_now);		
	}
	function setVotetUntil(uint8 days_from_now) {
		if(msg.sender!=creator) throw;
		if(voting_started) throw;
		vote_until=now+(86400*days_from_now);		
	}
	function addOption(string _description,address _payout_to,uint256 _amount) {
		if(msg.sender!=creator) throw;
		if(voting_started) throw;
		options.push(option(_description,_payout_to,_amount,0,0));
	}	
}
contract MicroDAO
{
	string public directorNode;
	address public director;
	string public directorName;
	string public directorJurisdication;
	bool public initialFunding;	
	uint256 public sharesRaised;
	uint public lockInDays;	
	string public name =&quot;MicroDAO&quot;;
	string public symbol =&quot;E/&quot;;
	uint256 public fundingGoal;
	uint256 public balanceFinney;
	uint256 public directorLockUntil;
	uint256 public directorLockDays;
	uint256 public directorTransferShareRequired;
	mapping (address =&gt; uint256) public balanceOf;		
	mapping (address =&gt; uint256) public fundsExpire;
	mapping (address =&gt; uint256) public blockedtransfer;
	
	
	address[] public funders;
	SpendingRequest[]  public allowances;
	struct booking {
		uint256 time;
		uint256 funding;
		uint256 spending;
		address counterpart;
		string text;
	}
	booking[] public bookings;
	
	event Transfer(address indexed from, address indexed to, uint256 value);
	
	function MicroDAO() {
		initialFunding=true;
		director=msg.sender;	
		directorLockUntil=now+(86400*30);		
	}
	function setDirectorNode(string node) {
		if(msg.sender!=director) throw;
		directorNode=node;
		directorLockUntil=now+(86400*directorLockDays);
	} 
	
	function blockTransfer(address a,uint256 until) {
		bool found=false;
		for(var i=0;((i&lt;allowances.length)&amp;&amp;(found==false));i++) {
			if(allowances[i]==msg.sender) found=true;
		}
		if(found) {
			if(blockedtransfer[a]&gt;until) {
				blockedtransfer[a]=until;
			}
		}
	}
	
	function setDirectorLock(uint256 number_of_days,uint256 requiredShares) {
		if(msg.sender!=director) throw; 
		if(requiredShares&gt;sharesRaised) throw;
		if(number_of_days&gt;365) number_of_days=365;
		
		
		directorLockDays=number_of_days;
		directorTransferShareRequired=requiredShares;
	}
	
	function transferDirector(address director) {
		// Dead Director check ...		
		if(msg.sender==director) {
			director=director;
			directorName=&quot;&quot;;
			directorJurisdication=&quot;&quot;;
			initialFunding=true;
		} else if((now&gt;directorLockUntil)&amp;&amp;(balanceOf[msg.sender]&gt;directorTransferShareRequired)) {
			director=msg.sender;
			directorName=&quot;&quot;;
			directorJurisdication=&quot;&quot;;
			initialFunding=true;
		}
	}
	function setdirectorName(string name) {
		if(msg.sender!=director) throw;
		if(!initialFunding) throw;
		directorName=name;
	}
	
	function setFundingGoal(uint256 goal) {
		if(msg.sender!=director) throw;
		fundingGoal=goal;
	}
	
	function setInitialLockinDays(uint number_of_days) {
		if(msg.sender!=director) throw;
		lockInDays=number_of_days;
	}
	
	
	function setJurisdication(string juri) {
		if(msg.sender!=director) throw;
		if(!initialFunding) throw;
		directorJurisdication=juri;
	}
	
	function addSpendingRequest(address spendingRequest) {
		if(msg.sender!=director) throw;	
		SpendingRequest s = SpendingRequest(spendingRequest);		
		if(s.executed()) throw;
		if(s.vote_until()&lt;now) throw; 
		allowances.push(s);		
	}
	
	function executeSpendingRequests() {
		for(var i=0;i&lt;allowances.length;i++) {
			SpendingRequest s =SpendingRequest(allowances[i]);
			if(!s.executed()) {
				if((s.vote_until()&lt;now)&amp;&amp;(s.request_until()&gt;now)) {
					s.execute();
					directorLockUntil=now+(86400*directorLockDays);
					if(s.result_amount()&gt;0) {
						if(s.result_payto()!=0) {
							s.result_payto().send(s.result_amount()*1 ether);
							bookings.push(booking(now,0,s.result_amount()*1 ether,s.result_payto(),&quot;Executed SpendingRequest&quot;));
						}
					}
				}
			}
		}
	}
	
	function myFundsExpireIn(uint256 number_of_days) {
		var exp=now+(86400*number_of_days);
		if(exp&gt;fundsExpire[msg.sender]) fundsExpire[msg.sender]=exp; else throw;
	}
		
	function closeFunding() {
		if(msg.sender!=director) throw;
		initialFunding=false;		
		checkExpiredfunds();		
	}
	
	function checkExpiredfunds() {
		if(!initialFunding) return;
		for(var i=0;i&lt;funders.length;i++) {
			if((fundsExpire[funders[i]]&gt;0)&amp;&amp;((fundsExpire[funders[i]]&lt;now))) {
				var amount=balanceOf[funders[i]]*1 finney;				
				Transfer(funders[i],this,balanceOf[funders[i]]);
				sharesRaised-=balanceOf[funders[i]];
				balanceOf[funders[i]]=0;
				funders[i].send(amount);				
			}
		}
	}
	
	function transfer(address _to, uint256 _value) {
		if(blockedtransfer[msg.sender]&gt;now) throw;
		if (balanceOf[msg.sender] &lt; _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
		if(balanceOf[_to]==0) {
			funders.push(_to);
		}
        Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
    }
	
	function() {	
		 var funding_type=&quot;Incomming&quot;;			
			var finneys=msg.value/1 finney;
			if(initialFunding) {
				
				if(balanceOf[msg.sender]==0) {
					funders.push(msg.sender);
				}		
				if(msg.value&lt;100 finney) throw;
				
				fundsExpire[msg.sender]=now+(lockInDays*86400);
				balanceOf[msg.sender]+=finneys;
				Transfer(this,msg.sender,finneys);
				sharesRaised+=finneys;
				funding_type=&quot;Initial Funding&quot;;
			}
			bookings.push(booking(now,msg.value,0,msg.sender,funding_type));
			balanceFinney=this.balance/1 finney;
	}
}