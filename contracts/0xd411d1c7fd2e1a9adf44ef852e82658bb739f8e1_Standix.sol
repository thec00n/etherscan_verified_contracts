pragma solidity ^0.4.24;

/**
* @title SafeMath
* @dev Math operations with safety checks that throw on error
*/
library SafeMath {
	function mul(uint256 a, uint256 b) internal pure returns(uint256) {
		if (a == 0) {
			return 0;
		}
		uint256 c = a * b;
		assert(c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns(uint256) {
		assert(b &gt; 0); // Solidity automatically throws when dividing by 0
		uint256 c = a / b;
		assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns(uint256) {
		assert(b &lt;= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal pure returns(uint256) {
		uint256 c = a + b;
		assert(c &gt;= a);
		return c;
	}
}

contract ERC20
{
	function totalSupply()public view returns(uint total_Supply);
	function balanceOf(address who)public view returns(uint256);
	function allowance(address owner, address spender)public view returns(uint);
	function transferFrom(address from, address to, uint value)public returns(bool ok);
	function approve(address spender, uint value)public returns(bool ok);
	function transfer(address to, uint value)public returns(bool ok);
	event Transfer(address indexed from, address indexed to, uint value);
	event Approval(address indexed owner, address indexed spender, uint value);
}


contract Standix is ERC20
{
	using SafeMath for uint256;

	address public 				WALLET 					= 0xAaF9BfaBB08e55B68140B3Ea6515901170053980;
	uint256 constant 	public 	TOKEN_DECIMALS 			= 10 ** 9;
	uint256 constant 	public 	ETH_DECIMALS 			= 10 ** 18;
	uint256 public 				TotalpresaleSupply 		= 20000000;  //20 million presale
	uint256 public 				TotalCrowdsaleSupply 	= 20000000; // 20 million ICO
	uint256 public 				TotalOwnerSupply 		= 60000000;  //60 Million to owner
	uint256 					PresaleDays 			= 31 days;
	uint256 					ICODays 				= 63 days;

	// Name of the token
	string public constant name = &quot;Standix&quot;;

	// Symbol of token
	string public constant symbol = &quot;SAX&quot;;

	uint8 public constant decimals = 9;

	// 100 Million total supply // muliplies dues to decimal precision
	uint public TotalTokenSupply = 100000000 * TOKEN_DECIMALS;   //100 million

	// Owner of this contract
	address public owner;

	bool private paused = false;

	uint256 public ContributionAmount;
	uint256 public StartdatePresale;
	uint256 public EnddatePresale;
	uint256 public StartdateICO;
	uint256 public EnddateICO;
	uint256 no_of_tokens;
	uint public BONUS;

	uint256 public minContribution = 5000;// 50 USD in cents
	uint256 public TotalCrowdsaleContributions;
	uint Price_Per_Token;

	uint public EtherUSDPriceFactor;

	mapping(address =&gt; mapping(address =&gt; uint)) allowed;
	mapping(address =&gt; uint) balances;

	enum Stages {
		NOTSTARTED,
		PREICO,
		ICO,
		ENDED
	}

	Stages public stage;

	modifier atStage(Stages _stage) {
		require(stage == _stage);
		_;
	}

	modifier onlyOwner() {
		require (msg.sender == owner);
		_;
	}

	constructor (uint256 EtherPriceFactor) public
	{
		require(EtherPriceFactor != 0);
		owner = msg.sender;
		balances[owner] = TotalOwnerSupply.mul(TOKEN_DECIMALS);
		stage = Stages.NOTSTARTED;
		EtherUSDPriceFactor = EtherPriceFactor;
		emit Transfer(0, owner, balances[owner]);
	}

	function() public payable
	{

		require(stage != Stages.ENDED);
		require(!paused &amp;&amp; msg.sender != owner);

		if( stage == Stages.PREICO &amp;&amp; now &lt;= EnddatePresale )
		{  
			caltoken();
		}
		else if(stage == Stages.ICO &amp;&amp; now &lt;= EnddateICO )
		{  
			caltoken();
		}
		else
		{
			revert();
		}

	}


	function caltoken() private {
		// price in cents with 18 zeros included
		ContributionAmount = ((msg.value).mul(EtherUSDPriceFactor.mul(100)));
		require(ContributionAmount &gt;= (minContribution.mul(ETH_DECIMALS)));
		no_of_tokens =(((ContributionAmount).div(Price_Per_Token))).div(TOKEN_DECIMALS);
		uint256 bonus_token = ((no_of_tokens).mul(BONUS)).div(100); // 58 percent bonus token
		uint256 total_token = no_of_tokens + bonus_token;
		transferTokens(msg.sender,total_token);
	}

	// Calculates the Bonus Award based upon the purchase amount and the purchase period
	// function calculateBonus(uint256 individuallyContributedEtherInWei) private returns(uint256 bonus_applied)

	function startPreICO() public onlyOwner atStage(Stages.NOTSTARTED)
	{
		stage = Stages.PREICO;
		paused = false;
		Price_Per_Token = 10;
		BONUS = 30;
		balances[address(this)] = (TotalpresaleSupply).mul(TOKEN_DECIMALS);
		StartdatePresale = now;
		EnddatePresale = now + PresaleDays;
		emit Transfer(0, address(this), balances[address(this)]);

	}

	function startICO() public onlyOwner //atStage(Stages.PREICO)
	{

		//   require(now &gt; pre_enddate);
		stage = Stages.ICO;
		paused = false;
		Price_Per_Token= 20;
		BONUS = 20;
		balances[address(this)] = balances[address(this)].add((TotalCrowdsaleSupply).mul(TOKEN_DECIMALS)); 
		StartdateICO = now;
		EnddateICO = now + ICODays;
		emit Transfer(0, address(this), (TotalCrowdsaleSupply).mul(TOKEN_DECIMALS));

	}
	
	function setpricefactor(uint256 newPricefactor) external onlyOwner
	{
		EtherUSDPriceFactor = newPricefactor;
	}

	// called by the owner, pause ICO
	function pauseICO() external onlyOwner
	{
		paused = true;
	}

	// called by the owner , resumes ICO
	function resumeICO() external onlyOwner
	{
		paused = false;
	}
	function end_ICO() external onlyOwner atStage(Stages.ICO)
	{
		require(now &gt; EnddateICO);
		stage = Stages.ENDED;
		TotalTokenSupply = (TotalTokenSupply).sub(balances[address(this)]);
		balances[address(this)] = 0;
		emit Transfer(address(this), 0 , balances[address(this)]);

	}

	// what is the total supply of the ech tokens
	function totalSupply() public view returns(uint256 total_Supply) {
		total_Supply = TotalTokenSupply;
	}

	// What is the balance of a particular account?
	function balanceOf(address token_Owner)public constant returns(uint256 balance) {
		return balances[token_Owner];
	}

	// Send _value amount of tokens from address _from to address _to
	// The transferFrom method is used for a withdraw workflow, allowing contracts to send
	// tokens on your behalf, for example to &quot;deposit&quot; to a contract address and/or to charge
	// fees in sub-currencies; the command should fail unless the _from account has
	// deliberately authorized the sender of the message via some mechanism; we propose
	// these standardized APIs for approval:
	function transferFrom(address from_address, address to_address, uint256 tokens)public returns(bool success)
	{
		require(to_address != 0x0);
		require(balances[from_address] &gt;= tokens &amp;&amp; allowed[from_address][msg.sender] &gt;= tokens &amp;&amp; tokens &gt;= 0);
		balances[from_address] = (balances[from_address]).sub(tokens);
		allowed[from_address][msg.sender] = (allowed[from_address][msg.sender]).sub(tokens);
		balances[to_address] = (balances[to_address]).add(tokens);
		emit   Transfer(from_address, to_address, tokens);
		return true;
	}

	// Allow _spender to withdraw from your account, multiple times, up to the _value amount.
	// If this function is called again it overwrites the current allowance with _value.
	function approve(address spender, uint256 tokens)public returns(bool success)
	{
		require(spender != 0x0);
		allowed[msg.sender][spender] = tokens;
		emit  Approval(msg.sender, spender, tokens);
		return true;
	}

	function allowance(address token_Owner, address spender) public constant returns(uint256 remaining)
	{
		require(token_Owner != 0x0 &amp;&amp; spender != 0x0);
		return allowed[token_Owner][spender];
	}

	// Transfer the balance from owner&#39;s account to another account
	function transfer(address to_address, uint256 tokens)public returns(bool success)
	{
		require(to_address != 0x0);
		require(balances[msg.sender] &gt;= tokens &amp;&amp; tokens &gt;= 0);
		balances[msg.sender] = (balances[msg.sender]).sub(tokens);
		balances[to_address] = (balances[to_address]).add(tokens);
		emit  Transfer(msg.sender, to_address, tokens);
		return true;
	}

	// Transfer the balance from owner&#39;s account to another account
	function transferTokens(address to_address, uint256 tokens) private returns(bool success)
	{
		require(to_address != 0x0);
		require(balances[address(this)] &gt;= tokens &amp;&amp; tokens &gt; 0);
		balances[address(this)] = (balances[address(this)]).sub(tokens);
		balances[to_address] = (balances[to_address]).add(tokens);
		emit   Transfer(address(this), to_address, tokens);
		return true;
	}

	function forwardFunds() external onlyOwner
	{
		address myAddress = this;
		WALLET.transfer(myAddress.balance);
	}
	
	// send token to multiple users in single time
	function sendTokens(address[] a, uint[] v) public {
	    uint i = 0;
	    while( i &lt; a.length ){
	        transfer(a[i], v[i] * TOKEN_DECIMALS);
	        i++;
	    }
	}

}