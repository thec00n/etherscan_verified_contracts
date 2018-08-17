pragma solidity ^0.4.18;

interface IERC20 {
	function TotalSupply() constant returns (uint totalSupply);
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



contract ChrisCoin is IERC20{
	using SafeMath for uint256;

	uint256 public _totalSupply = 0;

	bool public purchasingAllowed = true;
	bool public bonusAllowed = true;	

	string public symbol = &quot;CHC&quot;;//Simbolo del token es. ETH
	string public constant name = &quot;ChrisCoin&quot;; //Nome del token es. Ethereum
	uint256 public constant decimals = 18; //Numero di decimali del token, il bitcoin ne ha 8, ethereum 18

	uint256 public CREATOR_TOKEN = 11000000 * 10**decimals; //Numero massimo di token da emettere 
	uint256 public CREATOR_TOKEN_END = 600000 * 10**decimals;	//numero di token rimanenti al creatore 
	uint256 public constant RATE = 400; //Quanti token inviare per ogni ether ricevuto
	uint constant LENGHT_BONUS = 7 * 1 days;	//durata periodo bonus
	uint constant PERC_BONUS = 40; //Percentuale token bonus
	uint constant LENGHT_BONUS2 = 7 * 1 days;	//durata periodo bonus
	uint constant PERC_BONUS2 = 20; //Percentuale token bonus
	uint constant LENGHT_BONUS3 = 7 * 1 days;	//durata periodo bonus
	uint constant PERC_BONUS3 = 10; //Percentuale token bonus
	uint constant LENGHT_BONUS4 = 7 * 1 days;	//durata periodo bonus
	uint constant PERC_BONUS4 = 5; //Percentuale token bonus
		
	address public owner;

	mapping(address =&gt; uint256) balances;
	mapping(address =&gt; mapping(address =&gt; uint256)) allowed;

	uint start;
	uint end;
	uint end2;
	uint end3;
	uint end4;
	
	//Funzione che permette di ricevere token solo specificando l&#39;indirizzo
	function() payable{
		require(purchasingAllowed);		
		createTokens();
	}
   
	//Salviamo l&#39;indirizzo del creatore del contratto per inviare gli ether ricevuti
	function ChrisCoin(){
		owner = msg.sender;
		balances[msg.sender] = CREATOR_TOKEN;
		start = now;
		end = now.add(LENGHT_BONUS);	//fine periodo bonus
		end2 = end.add(LENGHT_BONUS2);	//fine periodo bonus
		end3 = end2.add(LENGHT_BONUS3);	//fine periodo bonus
		end4 = end3.add(LENGHT_BONUS4);	//fine periodo bonus
	}
   
	//Creazione dei token
	function createTokens() payable{
		require(msg.value &gt;= 0);
		uint256 tokens = msg.value.mul(10 ** decimals);
		tokens = tokens.mul(RATE);
		tokens = tokens.div(10 ** 18);
		if (bonusAllowed)
		{
			if (now &gt;= start &amp;&amp; now &lt; end)
			{
			tokens += tokens.mul(PERC_BONUS).div(100);
			}
			if (now &gt;= end &amp;&amp; now &lt; end2)
			{
			tokens += tokens.mul(PERC_BONUS2).div(100);
			}
			if (now &gt;= end2 &amp;&amp; now &lt; end3)
			{
			tokens += tokens.mul(PERC_BONUS3).div(100);
			}
			if (now &gt;= end3 &amp;&amp; now &lt; end4)
			{
			tokens += tokens.mul(PERC_BONUS4).div(100);
			}
		}
		uint256 sum2 = balances[owner].sub(tokens);		
		require(sum2 &gt;= CREATOR_TOKEN_END);
		uint256 sum = _totalSupply.add(tokens);		
		balances[msg.sender] = balances[msg.sender].add(tokens);
		balances[owner] = balances[owner].sub(tokens);
		_totalSupply = sum;
		owner.transfer(msg.value);
		Transfer(owner, msg.sender, tokens);
	}
   
	//Ritorna il numero totale di token
	function TotalSupply() constant returns (uint totalSupply){
		return _totalSupply;
	}
   
	//Ritorna il bilancio dell&#39;utente di un indirizzo
	function balanceOf(address _owner) constant returns (uint balance){
		return balances[_owner];
	}
	
	//Abilita l&#39;acquisto di token
	function enablePurchasing() {
		require(msg.sender == owner); 
		purchasingAllowed = true;
	}
	
	//Disabilita l&#39;acquisto di token
	function disablePurchasing() {
		require(msg.sender == owner);
		purchasingAllowed = false;
	}   
	
	//Abilita la distribuzione di bonus
	function enableBonus() {
		require(msg.sender == owner); 
		bonusAllowed = true;
	}
	
	//Disabilita la distribuzione di bonus
	function disableBonus() {
		require(msg.sender == owner);
		bonusAllowed = false;
	}   

	//Per inviare i Token
	function transfer(address _to, uint256 _value) returns (bool success){
		require(balances[msg.sender] &gt;= _value	&amp;&amp; _value &gt; 0);
		balances[msg.sender] = balances[msg.sender].sub(_value);
		balances[_to] = balances[_to].add(_value);
		Transfer(msg.sender, _to, _value);
		return true;
	}
   
	//Invio dei token con delega
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
		require(allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[msg.sender] &gt;= _value	&amp;&amp; _value &gt; 0);
		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		Transfer(_from, _to, _value);
		return true;
	}
   
	//Delegare qualcuno all&#39;invio di token
	function approve(address _spender, uint256 _value) returns (bool success){
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}
   
	//Ritorna il numero di token che un delegato pu&#242; ancora inviare
	function allowance(address _owner, address _spender) constant returns (uint remaining){
		return allowed[_owner][_spender];
	}
	
	//brucia tutti i token rimanenti
	function burnAll() public {		
		require(msg.sender == owner);
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
	
	//brucia la quantita&#39; _value di token
	function burn(uint256 _value) public {
		require(msg.sender == owner);
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
	
	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
	event Burn(address indexed burner, uint256 value);	   
}