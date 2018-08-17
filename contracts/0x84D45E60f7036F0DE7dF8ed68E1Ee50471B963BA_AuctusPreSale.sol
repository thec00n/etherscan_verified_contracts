pragma solidity ^0.4.16;


library SafeMath {
	function times(uint256 x, uint256 y) internal returns (uint256) {
		uint256 z = x * y;
		assert(x == 0 || (z / x == y));
		return z;
	}

	function minus(uint256 x, uint256 y) internal returns (uint256) {
		assert(y &lt;= x);
		return x - y;
	}

	function plus(uint256 x, uint256 y) internal returns (uint256) {
		uint256 z = x + y;
		assert(z &gt;= x &amp;&amp; z &gt;= y);
		return z;
	}
}


contract ERC20Simplified {
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 value) returns (bool);
}


contract AuctusPreSale {
	using SafeMath for uint256;
	
	struct TokenInfo {
		uint256 tokenAmount; 
		uint256 weiInvested;
	}
	
	address public owner;
	address public multiSigWallet = 0xed62dbc89f22dae81013e48928ef4395fa19e51b;
	
	uint256 public startTime = 1507039200; 
	uint256 public endTime = 1507298400; 
	
	uint256 public minimumCap = 400 ether;
	uint256 public maximumCap = 90000 ether;
	uint256 public maximumIndividualCap = 10 ether;
	
	uint256 public basicPricePerEth = 2500;
	
	uint256 public tokenSold;
	uint256 public weiRaised;
	
	bool public preSaleHalted;
	
	mapping(address =&gt; TokenInfo) public balances;
	mapping(address =&gt; uint256) public whitelist;
	
	event Buy(address indexed recipient, uint256 tokenAmount);
	event Revoke(address indexed recipient, uint256 weiAmount);
	event ListAddress(address indexed who, uint256 individualCap);
	event Drain(uint256 weiAmount);
	
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	modifier validPayload(uint256 size) { 
		require(msg.data.length &gt;= (size + 4));
		_;
	}
	
	modifier preSalePeriod() {
		require(now &gt;= startTime &amp;&amp; now &lt;= endTime &amp;&amp; weiRaised &lt; maximumCap);
		_;
	}
	
	modifier preSaleCompletedSuccessfully() {
		require(weiRaised &gt;= minimumCap &amp;&amp; (now &gt; endTime || weiRaised &gt;= maximumCap));
		_;
	}
	
	modifier preSaleFailed() {
		require(weiRaised &lt; minimumCap &amp;&amp; now &gt; endTime);
		_;
	}
	
	modifier isPreSaleNotHalted() {
		require(!preSaleHalted);
		_;
	}
	
	function AuctusPreSale() {
		owner = msg.sender;
	}
	
	function getTokenAmount(address who) constant returns (uint256) {
		return balances[who].tokenAmount;
	}
	
	function getWeiInvested(address who) constant returns (uint256) {
		return balances[who].weiInvested;
	}
	
	function() 
		payable 
		preSalePeriod 
		isPreSaleNotHalted 
	{
		require(balances[msg.sender].weiInvested &lt; whitelist[msg.sender]);
		
		var (weiToInvest, weiRemaining) = getValueToInvest();
		
		uint256 amountToReceive = weiToInvest.times(basicPricePerEth);
		balances[msg.sender].tokenAmount = balances[msg.sender].tokenAmount.plus(amountToReceive);
		balances[msg.sender].weiInvested = balances[msg.sender].weiInvested.plus(weiToInvest);
		
		tokenSold = tokenSold.plus(amountToReceive);
		weiRaised = weiRaised.plus(weiToInvest);
		
		if (weiRemaining &gt; 0) {
			msg.sender.transfer(weiRemaining);
		}
		
		Buy(msg.sender, amountToReceive);
	}
	
	function revoke() preSaleFailed {
		uint256 weiAmount = balances[msg.sender].weiInvested;
		assert(weiAmount &gt; 0);
		
		balances[msg.sender].weiInvested = 0;
		msg.sender.transfer(weiAmount);
		
		Revoke(msg.sender, weiAmount);
	}
	
	function setPreSaleHalt(bool halted) onlyOwner {
		preSaleHalted = halted;
	}
	
	function transferOwnership(address newOwner) 
		onlyOwner
		validPayload(32)
	{
        owner = newOwner;
    }
	
	function listAddress(address who, uint256 individualCap) 
		onlyOwner 
		validPayload(32 * 2)
	{
        whitelist[who] = individualCap;
        ListAddress(who, individualCap);
    }

    function listAddresses(address[] addresses) onlyOwner {
        for (uint256 i = 0; i &lt; addresses.length; i++) {
            listAddress(addresses[i], maximumIndividualCap);
        }
    }
	
	function drain() 
		onlyOwner 
		preSaleCompletedSuccessfully
	{
		uint256 weiAmount = this.balance;
		multiSigWallet.transfer(weiAmount);
		
		Drain(weiAmount);
	}
	
	function drainERC20(ERC20Simplified erc20Token) 
		onlyOwner 
		validPayload(32)
	{
		require(erc20Token.transfer(multiSigWallet, erc20Token.balanceOf(this)));
    }
	
	function getValueToInvest() internal returns (uint256, uint256) {
		uint256 newWeiInvested = balances[msg.sender].weiInvested.plus(msg.value);
		
		uint256 weiToInvest;
		uint256 weiRemaining;
		if (newWeiInvested &lt;= whitelist[msg.sender]) {
			weiToInvest = msg.value;
			weiRemaining = 0;
		} else {
			weiToInvest = whitelist[msg.sender].minus(balances[msg.sender].weiInvested);
			weiRemaining = msg.value.minus(weiToInvest);
		}
		
		return (weiToInvest, weiRemaining);
	}
}