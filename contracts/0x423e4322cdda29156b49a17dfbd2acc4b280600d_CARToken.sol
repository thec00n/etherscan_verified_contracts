pragma solidity ^0.4.11;

contract SafeMath {
    function safeMul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
        require(b &lt;= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        require(c&gt;=a &amp;&amp; c&gt;=b);
        return c;
    }

    function safeDiv(uint a, uint b) internal returns (uint) {
        require(b &gt; 0);
        uint c = a / b;
        require(a == b * c + a % b);
        return c;
    }
}

contract Token {
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/* ERC 20 token */
contract ERC20Token is Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address =&gt; uint256) balances;

    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalSupply;
}


/**
 * CAR ICO contract.
 *
 */
contract CARToken is ERC20Token, SafeMath {

    string public name = &quot;CAR SHARING&quot;;
    string public symbol = &quot;CAR&quot;;
	uint public decimals = 9;

    address public tokenIssuer = 0x0;
	
    // Unlock time
	uint public month12Unlock = 1546387199;
	uint public month24Unlock = 1577923199;
	uint public month30Unlock = 1593647999;
    uint public month48Unlock = 1641081599;
	uint public month60Unlock = 1672617599;
	
	// End token sale
	uint public endTokenSale = 1577836799;
	
	// Allocated
    bool public month12Allocated = false;
	bool public month24Allocated = false;
	bool public month30Allocated = false;
    bool public month48Allocated = false;
	bool public month60Allocated = false;
	

    // Token count
	uint totalTokenSaled = 0;
    uint public totalTokensCrowdSale = 95000000 * 10**decimals;
    uint public totalTokensReserve = 95000000 * 10**decimals;

	event TokenMint(address newTokenHolder, uint amountOfTokens);
    event AllocateTokens(address indexed sender);

    function CARToken() {
        tokenIssuer = msg.sender;
    }
	
	/* Change issuer address */
    function changeIssuer(address newIssuer) {
        require(msg.sender==tokenIssuer);
        tokenIssuer = newIssuer;
    }

    /* Allocate Tokens */
    function allocateTokens()
    {
        require(msg.sender==tokenIssuer);
        uint tokens = 0;
     
		if(block.timestamp &gt; month12Unlock &amp;&amp; !month12Allocated)
        {
			month12Allocated = true;
			tokens = safeDiv(totalTokensReserve, 5);
			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
			totalSupply = safeAdd(totalSupply, tokens);
            
        }
        else if(block.timestamp &gt; month24Unlock &amp;&amp; !month24Allocated)
        {
			month24Allocated = true;
			tokens = safeDiv(totalTokensReserve, 5);
			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
			totalSupply = safeAdd(totalSupply, tokens);
			
        }
		if(block.timestamp &gt; month30Unlock &amp;&amp; !month30Allocated)
        {
			month30Allocated = true;
			tokens = safeDiv(totalTokensReserve, 5);
			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
			totalSupply = safeAdd(totalSupply, tokens);
            
        }
        else if(block.timestamp &gt; month48Unlock &amp;&amp; !month48Allocated)
        {
			month48Allocated = true;
			tokens = safeDiv(totalTokensReserve, 5);
			balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
			totalSupply = safeAdd(totalSupply, tokens);
        }
		else if(block.timestamp &gt; month60Unlock &amp;&amp; !month60Allocated)
        {
            month60Allocated = true;
            tokens = safeDiv(totalTokensReserve, 5);
            balances[tokenIssuer] = safeAdd(balances[tokenIssuer], tokens);
            totalSupply = safeAdd(totalSupply, tokens);
        }
        else revert();

        AllocateTokens(msg.sender);
    }
    
	/* Mint Token */
    function mintTokens(address tokenHolder, uint256 amountToken) 
    returns (bool success) 
    {
		require(msg.sender==tokenIssuer);
		
		if(totalTokenSaled + amountToken &lt;= totalTokensCrowdSale &amp;&amp; block.timestamp &lt;= endTokenSale)
		{
			balances[tokenHolder] = safeAdd(balances[tokenHolder], amountToken);
			totalTokenSaled = safeAdd(totalTokenSaled, amountToken);
			totalSupply = safeAdd(totalSupply, amountToken);
			TokenMint(tokenHolder, amountToken);
			return true;
		}
		else
		{
		    return false;
		}
    }
}