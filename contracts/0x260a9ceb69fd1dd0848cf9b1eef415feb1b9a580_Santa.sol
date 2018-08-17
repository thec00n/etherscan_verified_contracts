pragma solidity ^0.4.18;

library SafeMath {
    function mul(uint256 a, uint256 b) internal returns(uint256) {
		uint256 c = a * b;
		assert(a == 0 || c / a == b);
		return c;
    }
    
    function div(uint256 a, uint256 b) internal returns(uint256) {
		uint256 c = a / b;
		return c;
    }

    function sub(uint256 a, uint256 b) internal returns(uint256) {
		assert(b &lt;= a);
		return a - b;
    }

    function add(uint256 a, uint256 b) internal returns(uint256) {
		uint256 c = a + b;
		assert(c &gt;= a &amp;&amp; c &gt;= b);
		return c;
    }
}

contract Santa {
    
    using SafeMath for uint256; 

    string constant public standard = &quot;ERC20&quot;;
    string constant public symbol = &quot;SANTA&quot;;
    string constant public name = &quot;Santa&quot;;
    uint8 constant public decimals = 18;

    uint256 constant public initialSupply = 1000000 * 1 ether;
    uint256 constant public tokensForIco = 600000 * 1 ether;
    uint256 constant public tokensForBonus = 200000 * 1 ether;

    uint256 constant public startAirdropTime = 1514073600;
    uint256 public startTransferTime;
    uint256 public tokensSold;
    bool public burned;

    mapping(address =&gt; uint256) public balanceOf;
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;
    
    uint256 constant public start = 1513728000;
    uint256 constant public end = 1514678399;
    uint256 constant public tokenExchangeRate = 310;
    uint256 public amountRaised;
    bool public crowdsaleClosed = false;
    address public santaFundWallet;
    address ethFundWallet;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed spender, uint256 value);
    event FundTransfer(address backer, uint amount, bool isContribution, uint _amountRaised);
    event Burn(uint256 amount);

    function Santa(address _ethFundWallet) {
		ethFundWallet = _ethFundWallet;
		santaFundWallet = msg.sender;
		balanceOf[santaFundWallet] = initialSupply;
		startTransferTime = end;
    }

    function() payable {
		uint256 amount = msg.value;
		uint256 numTokens = amount.mul(tokenExchangeRate); 
		require(numTokens &gt;= 10 * 1 ether);
		require(!crowdsaleClosed &amp;&amp; now &gt;= start &amp;&amp; now &lt;= end &amp;&amp; tokensSold.add(numTokens) &lt;= tokensForIco);
		ethFundWallet.transfer(amount);
		balanceOf[santaFundWallet] = balanceOf[santaFundWallet].sub(numTokens); 
		balanceOf[msg.sender] = balanceOf[msg.sender].add(numTokens);
		Transfer(santaFundWallet, msg.sender, numTokens);
		amountRaised = amountRaised.add(amount);
		tokensSold += numTokens;
		FundTransfer(msg.sender, amount, true, amountRaised);
    }

    function transfer(address _to, uint256 _value) returns(bool success) {
		require(now &gt;= startTransferTime); 
		balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value); 
		balanceOf[_to] = balanceOf[_to].add(_value); 
		Transfer(msg.sender, _to, _value); 
		return true;
    }

    function approve(address _spender, uint256 _value) returns(bool success) {
		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
		allowance[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
		if (now &lt; startTransferTime) {
		    require(_from == santaFundWallet);
		}
		var _allowance = allowance[_from][msg.sender];
		require(_value &lt;= _allowance);
		balanceOf[_from] = balanceOf[_from].sub(_value); 
		balanceOf[_to] = balanceOf[_to].add(_value); 
		allowance[_from][msg.sender] = _allowance.sub(_value);
		Transfer(_from, _to, _value);
		return true;
    }

    function burn() internal {
		require(now &gt; startTransferTime);
		require(burned == false);
		uint256 difference = balanceOf[santaFundWallet].sub(tokensForBonus);
		tokensSold = tokensForIco.sub(difference);
		balanceOf[santaFundWallet] = tokensForBonus;
		burned = true;
		Burn(difference);
    }

    function markCrowdsaleEnding() {
		require(now &gt; end);
		burn(); 
		crowdsaleClosed = true;
    }

    function sendGifts(address[] santaGiftList) returns(bool success)  {
		require(msg.sender == santaFundWallet);
		require(now &gt;= startAirdropTime);
	    
	    uint bonusRate = tokensForBonus.div(tokensSold); 
		for(uint i = 0; i &lt; santaGiftList.length; i++) {
		    if (balanceOf[santaGiftList[i]] &gt; 0) { 
				uint bonus = balanceOf[santaGiftList[i]].mul(bonusRate);
				transferFrom(santaFundWallet, santaGiftList[i], bonus);
		    }
		}
		return true;
    }
}