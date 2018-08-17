pragma solidity ^0.4.18;

contract EthereuMMM {
	address public owner;
	uint public allInvestments;
	uint public lastID;
	
	struct Invest {uint amount; bool used;}
	struct Refs {address addr; bool used;}
	
	mapping(address =&gt; Invest) public investments;
    mapping(address =&gt; uint) public investorWallet;
	mapping(uint =&gt; address) public investorsIndex;
	mapping(address =&gt; Refs) public Referrals;

    function EthereuMMM() public {
        owner = msg.sender;
		lastID = 0;
    }
    
	function withdraw() public {
        require(investorWallet[msg.sender] != 0);
        uint tempWithdraw = investorWallet[msg.sender];

		investorWallet[msg.sender] = 0;
		allInvestments -= investments[msg.sender].amount;
		investments[msg.sender].amount = 0;
		
		if(this.balance &lt; tempWithdraw) tempWithdraw = this.balance;

		msg.sender.transfer(tempWithdraw);
	}
    
    function bytesToAddress(bytes source) internal pure returns(address) {
        uint result;
        uint mul = 1;
        for(uint i = 20; i &gt; 0; i--) {
            result += uint8(source[i-1])*mul;
            mul = mul*256;
        }
        return address(result);
    }
	
	function () public payable {
        uint baseBalance = (msg.value * 4) / 5;
		
		if(!investments[msg.sender].used){
			investorsIndex[lastID] = msg.sender;
			investments[msg.sender].used = true;
			++lastID;
		}
        
		investments[msg.sender].amount += baseBalance;
		investorWallet[msg.sender] += baseBalance;
		allInvestments += baseBalance;
        
        uint rewardToInvestors;
		
		if(!Referrals[msg.sender].used &amp;&amp; msg.data.length == 20) {
            address referer = bytesToAddress(bytes(msg.data));
            if(referer != msg.sender){
				Referrals[msg.sender].addr = referer;
				Referrals[msg.sender].used = true;
			}
        }
		
		if(Referrals[msg.sender].used){
			investorWallet[referer] += msg.value / 20;
			investorWallet[msg.sender] += msg.value / 40;
			rewardToInvestors = (msg.value * 3) / 40;
		} else {
            rewardToInvestors = (msg.value * 3) / 20;
        }
		
		for(uint i = 0; i &lt;= lastID; ++i){
			investorWallet[investorsIndex[i]] += (rewardToInvestors * investments[investorsIndex[i]].amount) / allInvestments;
		}
		
        owner.transfer(msg.value / 20);
    }
}