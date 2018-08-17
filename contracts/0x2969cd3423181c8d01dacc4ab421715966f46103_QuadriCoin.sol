pragma solidity ^0.4.18;

interface IERC20 {
	function totalSupply() constant returns (uint totalSupply);
	function balanceOf(address _owner) constant returns (uint balance);
	function transfer(address _to, uint _value) returns (bool success);
	function transferFrom(address _from, address _to, uint _value) returns (bool success);
	function approve(address _spender, uint _value) returns (bool success);
	function allowance(address _owner, address _spender) constant returns (uint remaining);
	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
}

/**
* @title SafeMath
* @dev Math operations with safety checks that throw on error
*/
library SafeMath {
	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
		uint256 c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal constant returns (uint256) {
		// assert(b &gt; 0); // Solidity automatically throws when dividing by 0
		uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
		return c;
	}

	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
		assert(b &lt;= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal constant returns (uint256) {
		uint256 c = a + b;
		assert(c &gt;= a);
		return c;
	}
}



contract QuadriCoin is IERC20{
	using SafeMath for uint256;

	uint256 private _totalSupply = 0;

	bool public purchasingAllowed = true;
	bool private bonusAllowed = true;	

	string public constant symbol = &quot;QDC&quot;;
	string public constant name = &quot;QuadriCoin&quot;;
	uint256 public constant decimals = 18;

	uint256 private CREATOR_TOKEN = 3100000000 * 10**decimals;
	uint256 private CREATOR_TOKEN_END = 465000000 * 10**decimals;
	uint256 private constant RATE = 100000;
	uint constant LENGHT_BONUS = 7 * 1 days;
	uint constant PERC_BONUS = 100;
	uint constant LENGHT_BONUS2 = 7 * 1 days;
	uint constant PERC_BONUS2 = 30;
	uint constant LENGHT_BONUS3 = 7 * 1 days;
	uint constant PERC_BONUS3 = 30;
	uint constant LENGHT_BONUS4 = 7 * 1 days;
	uint constant PERC_BONUS4 = 20;
	uint constant LENGHT_BONUS5 = 7 * 1 days;
	uint constant PERC_BONUS5 = 20;
	uint constant LENGHT_BONUS6 = 7 * 1 days;
	uint constant PERC_BONUS6 = 15;
	uint constant LENGHT_BONUS7 = 7 * 1 days;
	uint constant PERC_BONUS7 = 10;
	uint constant LENGHT_BONUS8 = 7 * 1 days;
	uint constant PERC_BONUS8 = 10;
	uint constant LENGHT_BONUS9 = 7 * 1 days;
	uint constant PERC_BONUS9 = 5;
	uint constant LENGHT_BONUS10 = 7 * 1 days;
	uint constant PERC_BONUS10 = 5;

		
	address private owner;

	mapping(address =&gt; uint256) balances;
	mapping(address =&gt; mapping(address =&gt; uint256)) allowed;

	uint private start;
	uint private end;
	uint private end2;
	uint private end3;
	uint private end4;
	uint private end5;
	uint private end6;
	uint private end7;
	uint private end8;
	uint private end9;
	uint private end10;
	
	struct Buyer{
	    address to;
	    uint256 value;
	}
	
	Buyer[] buyers;
	
	modifier onlyOwner {
	    require(msg.sender == owner);
	    _;
	}
	
	function() payable{
		require(purchasingAllowed);		
		createTokens();
	}
   
	function QuadriCoin(){
		owner = msg.sender;
		balances[msg.sender] = CREATOR_TOKEN;
		start = now;
		end = now.add(LENGHT_BONUS);
		end2 = end.add(LENGHT_BONUS2);
		end3 = end2.add(LENGHT_BONUS3);
		end4 = end3.add(LENGHT_BONUS4);
		end5 = end4.add(LENGHT_BONUS5);
		end6 = end5.add(LENGHT_BONUS6);
		end7 = end6.add(LENGHT_BONUS7);
		end8 = end7.add(LENGHT_BONUS8);
		end9 = end8.add(LENGHT_BONUS9);
		end10 = end9.add(LENGHT_BONUS10);
	}
   
	function createTokens() payable{
	    bool bSend = true;
		require(msg.value &gt;= 0);
		uint256 tokens = msg.value.mul(10 ** decimals);
		tokens = tokens.mul(RATE);
		tokens = tokens.div(10 ** 18);
		if (bonusAllowed)
		{
			if (now &gt;= start &amp;&amp; now &lt; end)
			{
			tokens += tokens.mul(PERC_BONUS).div(100);
			bSend = false;
			}
			if (now &gt;= end &amp;&amp; now &lt; end2)
			{
			tokens += tokens.mul(PERC_BONUS2).div(100);
			bSend = false;
			}
			if (now &gt;= end2 &amp;&amp; now &lt; end3)
			{
			tokens += tokens.mul(PERC_BONUS3).div(100);
			bSend = false;
			}
			if (now &gt;= end3 &amp;&amp; now &lt; end4)
			{
			tokens += tokens.mul(PERC_BONUS4).div(100);
			bSend = false;
			}
			if (now &gt;= end4 &amp;&amp; now &lt; end5)
			{
			tokens += tokens.mul(PERC_BONUS5).div(100);
			bSend = false;
			}
			if (now &gt;= end5 &amp;&amp; now &lt; end6)
			{
			tokens += tokens.mul(PERC_BONUS6).div(100);
			bSend = false;
			}
			if (now &gt;= end6 &amp;&amp; now &lt; end7)
			{
			tokens += tokens.mul(PERC_BONUS7).div(100);
			bSend = false;
			}
			if (now &gt;= end7 &amp;&amp; now &lt; end8)
			{
			tokens += tokens.mul(PERC_BONUS8).div(100);
			bSend = false;
			}
			if (now &gt;= end8 &amp;&amp; now &lt; end9)
			{
			tokens += tokens.mul(PERC_BONUS9).div(100);
			bSend = false;
			}
			if (now &gt;= end9 &amp;&amp; now &lt; end10)
			{
			tokens += tokens.mul(PERC_BONUS10).div(100);
			bSend = false;
			}
		}
		uint256 sum2 = balances[owner].sub(tokens);		
		require(sum2 &gt;= CREATOR_TOKEN_END);
		uint256 sum = _totalSupply.add(tokens);		
		_totalSupply = sum;
		owner.transfer(msg.value);
		if (!bSend){
    		buyers.push(Buyer(msg.sender, tokens));
	    	Transfer(msg.sender, owner, msg.value);
		} else {
	        balances[msg.sender] = balances[msg.sender].add(tokens);
		    balances[owner] = balances[owner].sub(tokens);		    
            Transfer(msg.sender, owner, msg.value);
		}
	}
   
	function totalSupply() constant returns (uint totalSupply){
		return _totalSupply;
	}
   
	function balanceOf(address _owner) constant returns (uint balance){
		return balances[_owner];
	}

	function enablePurchasing() onlyOwner {
		purchasingAllowed = true;
	}
	
	function disablePurchasing() onlyOwner {
		purchasingAllowed = false;
	}   
	
	function enableBonus() onlyOwner {
		bonusAllowed = true;
	}
	
	function disableBonus() onlyOwner {
		bonusAllowed = false;
	}   

	function transfer(address _to, uint256 _value) returns (bool success){
		require(balances[msg.sender] &gt;= _value	&amp;&amp; _value &gt; 0);
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		Transfer(msg.sender, _to, _value);
		return true;
	}
   
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
		require(allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[msg.sender] &gt;= _value	&amp;&amp; _value &gt; 0);
		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		Transfer(_from, _to, _value);
		return true;
	}
   
	function approve(address _spender, uint256 _value) returns (bool success){
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}
   
	function allowance(address _owner, address _spender) constant returns (uint remaining){
		return allowed[_owner][_spender];
	}
	
	function burnAll() onlyOwner public {		
		address burner = msg.sender;
		uint256 total = balances[burner];
		if (total &gt; CREATOR_TOKEN_END) {
			total = total.sub(CREATOR_TOKEN_END);
			balances[burner] = balances[burner].sub(total);
			if (_totalSupply &gt;= total){
				_totalSupply = _totalSupply.sub(total);
			}
			Burn(burner, total);
		}
	}
	
	function burn(uint256 _value) onlyOwner public {
        require(_value &gt; 0);
        require(_value &lt;= balances[msg.sender]);
		_value = _value.mul(10 ** decimals);
        address burner = msg.sender;
		uint t = balances[burner].sub(_value);
		require(t &gt;= CREATOR_TOKEN_END);
        balances[burner] = balances[burner].sub(_value);
        if (_totalSupply &gt;= _value){
			_totalSupply = _totalSupply.sub(_value);
		}
        Burn(burner, _value);
	}
		
    function mintToken(uint256 _value) onlyOwner public {
        require(_value &gt; 0);
		_value = _value.mul(10 ** decimals);
        balances[owner] = balances[owner].add(_value);
        _totalSupply = _totalSupply.add(_value);
        Transfer(0, this, _value);
    }
	
	function TransferTokens() onlyOwner public {
	    for (uint i = 0; i&lt;buyers.length; i++){
    		balances[buyers[i].to] = balances[buyers[i].to].add(buyers[i].value);
    		balances[owner] = balances[owner].sub(buyers[i].value);
	        Transfer(owner, buyers[i].to, buyers[i].value);
	    }
	    delete buyers;
	}
	
	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
	event Burn(address indexed burner, uint256 value);	   
}