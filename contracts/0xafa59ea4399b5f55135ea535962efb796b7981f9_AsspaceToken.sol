pragma solidity ^0.4.18;


contract ERC20 {
	//Sets events and functions for ERC20 token
	event Approval(address indexed _owner, address indexed _spender, uint _value);
	event Transfer(address indexed _from, address indexed _to, uint _value);
	
    function allowance(address _owner, address _spender) constant returns (uint remaining);
	function approve(address _spender, uint _value) returns (bool success);
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
}


contract Owned {
	//Public variable
    address public owner;

	//Sets contract creator as the owner
    function Owned() {
        owner = msg.sender;
    }
	
	//Sets onlyOwner modifier for specified functions
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

	//Allows for transfer of contract ownership
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}


library SafeMath {
    function add(uint256 a, uint256 b) internal returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }  

    function div(uint256 a, uint256 b) internal returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }
  
    function mul(uint256 a, uint256 b) internal returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b) internal returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }
}


contract BaseToken is ERC20, Owned {
    //Applies SafeMath library to uint256 operations 
    using SafeMath for uint256;

	//Public variables
	string public name; 
	string public symbol; 
	uint256 public decimals;  
    uint256 public initialTokens; 
	uint256 public totalSupply; 
	string public version;

	//Creates arrays for balances
    mapping (address =&gt; uint256) balance;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

	//Constructor
	function BaseToken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialAmount, string tokenVersion) {
		name = tokenName; 
		symbol = tokenSymbol; 
		decimals = decimalUnits; 
        initialTokens = initialAmount; 
		version = tokenVersion;
	}
	
	//Provides the remaining balance of approved tokens from function approve 
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

	//Allows for a certain amount of tokens to be spent on behalf of the account owner
    function approve(address _spender, uint256 _value) returns (bool success) { 
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

	//Returns the account balance 
    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
        return balance[_owner];
    }

	//Sends tokens from sender&#39;s account
    function transfer(address _to, uint256 _value) returns (bool success) {
        if ((balance[msg.sender] &gt;= _value) &amp;&amp; (balance[_to] + _value &gt; balance[_to])) {
            balance[msg.sender] -= _value;
            balance[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
	
	//Transfers tokens from an approved account 
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if ((balance[_from] &gt;= _value) &amp;&amp; (allowed[_from][msg.sender] &gt;= _value) &amp;&amp; (balance[_to] + _value &gt; balance[_to])) {
            balance[_to] += _value;
            balance[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
    
}

contract AsspaceToken is Owned, BaseToken {
    using SafeMath for uint256;

    uint256 public amountRaised; 
    uint256 public deadline; 
    uint256 public price;        
    uint256 public maxPreIcoAmount = 8000000;  
	bool preIco = true;
    
	function AsspaceToken() 
		BaseToken(&quot;ASSPACE Token&quot;, &quot;ASP&quot;, 0, 100000000000, &quot;1.0&quot;) {
            balance[msg.sender] = initialTokens;    
            setPrice(2500000);
            deadline = now - 1 days;
    }

    function () payable {
        require((now &lt; deadline) &amp;&amp; 
                 (msg.value.div(1 finney) &gt;= 100) &amp;&amp;
                ((preIco &amp;&amp; amountRaised.add(msg.value.div(1 finney)) &lt;= maxPreIcoAmount) || !preIco)); 

        address recipient = msg.sender; 
        amountRaised = amountRaised.add(msg.value.div(1 finney)); 
        uint256 tokens = msg.value.mul(getPrice()).div(1 ether);
        totalSupply = totalSupply.add(tokens);
        balance[recipient] = balance[recipient].add(tokens);
		balance[owner] = balance[owner].sub(tokens);
		
        require(owner.send(msg.value)); 
		
        Transfer(0, recipient, tokens);
    }   

    function setPrice(uint256 newPriceper) onlyOwner {
        require(newPriceper &gt; 0); 
        
        price = newPriceper; 
    }
	
	function getPrice() constant returns (uint256) {
		return price;
	}
		
    function startSale(uint256 lengthOfSale, bool isPreIco) onlyOwner {
        require(lengthOfSale &gt; 0); 
        
        preIco = isPreIco;
        deadline = now + lengthOfSale * 1 days; 
    }

    function stopSale() onlyOwner {
        deadline = now;
    }
    
}