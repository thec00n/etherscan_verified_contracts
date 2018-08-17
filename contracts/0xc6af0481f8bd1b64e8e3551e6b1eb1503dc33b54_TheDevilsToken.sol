pragma solidity ^0.4.18;

interface IERC20 {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract TheDevilsToken is IERC20 {
    using SafeMath for uint;
    
    uint public _totalSupply = 0;
    uint public constant maxSupply = 666666000000000000000000;
    
    string public constant name = &#39;The Devil\&#39;s Token&#39;;
    string public constant symbol = &#39;DVL&#39;;
    uint8 public constant decimals = 18;
    
    // 1 ETH = 666 DVL
    uint public constant RATE = 666;
    
    address public owner;
    
    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;
    
    function () public payable {
        createTokens();
    }
    
    function TheDevilsToken() public {
        owner = msg.sender;
    }
    
    function createTokens() public payable {
        require(msg.value &gt; 0 &amp;&amp; _totalSupply &lt; maxSupply);
        
        uint requestedTokens = msg.value.mul(RATE);
        uint tokens = requestedTokens;
        uint newTokensCount = _totalSupply.add(requestedTokens);
        
        if (newTokensCount &gt; maxSupply) {
            tokens = maxSupply - _totalSupply;
        }
        
        balances[msg.sender] = balances[msg.sender].add(tokens);
        _totalSupply = _totalSupply.add(tokens);
        
        owner.transfer(msg.value);
    }
    
    function totalSupply() public constant returns(uint) {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public returns (bool success) {
        require(
            msg.data.length &gt;= (2 * 32) + 4 &amp;&amp;
            tokens &gt; 0 &amp;&amp;
            balances[msg.sender] &gt;= tokens
        );
        
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        
        Transfer(msg.sender, to, tokens);

        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(
            msg.data.length &gt;= (3 * 32) + 4 &amp;&amp;
            tokens &gt; 0 &amp;&amp;
            balances[from] &gt;= tokens &amp;&amp;
            allowed[from][msg.sender] &gt;= tokens
        );
        
        balances[from] = balances[from].sub(tokens);
        balances[to] = balances[to].add(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);

        Transfer(from, to, tokens);

        return true;
    }
    
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}