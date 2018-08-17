pragma solidity ^0.4.19;


contract PharmCoin
{
 
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
    //using SafeMath for uint256;
    
    uint public _totalSupply = 2000000000.0;
    
    string public constant symbol = &quot;PHCX&quot;;
    string public constant name = &quot;PharmCoin&quot;;
    
    //How many decimal places token can be split up into
    uint public constant decimals = 18;

    //1 ether = 200 PharmCoinTokens
    uint256 public RATE = 200; 

    address public owner;

 
    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256) ) allowed;

 
    function () public payable{
        createTokens();
   }
    
    function PharmCoin() public
    {
     owner = msg.sender;  
     //uint256 initForPreSale =  mul(_totalSupply, RATE); 
     balances[owner] = _totalSupply;
    }
    
    function createTokens() public payable{
   
      //Workout tokens to recieve based on rate set
      uint256 tokensToSend =  mul(msg.value, RATE); 

      //Subtract amount from contract 
      //balances[owner] = sub(balances[owner], tokensToSend); 
      //Add tokens to buyer
      balances[msg.sender] = add(balances[msg.sender], tokensToSend ); 
      owner.transfer(msg.value);
    }

    function totalSupply() public constant returns (uint256 totalSupply){
        return _totalSupply;
    }
    
    function balanceOf(address _owner) public constant returns (uint256 balance){
        return balances[_owner];
    }
	
    //allow user to transfer pharmcoin tokens
    function transfer(address _to, uint256 _value) public returns (bool success){
    require
    (
        balances[msg.sender] &gt;= _value
        &amp;&amp; _value &gt; 0 &amp;&amp; _to != address(0)
    );
    balances[msg.sender] = sub(balances[msg.sender] , _value); 
    balances[_to] = add(balances[_to], _value); 
    Transfer(msg.sender, _to, _value);
    return true;
    }
    

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
    require(allowed[_from][msg.sender] &gt;= _value
           &amp;&amp; balances[_from] &gt;= _value
           &amp;&amp; _value &gt; 0 &amp;&amp; _to != address(0) );
    balances[_from] =  sub(balances[_from], _value);
    balances[_to] =  add (balances[_to], (_value) );
    allowed[_from][msg.sender] = sub(allowed[_from][msg.sender] , _value );
    Transfer(_from, _to, _value);
    return true;
    }

    //Check user is allowed to spend amount
    function approve(address _spender, uint256 _value) public returns (bool success){
    allowed[msg.sender][_spender] = _value;
    //Log Approval
    Approval(msg.sender, _spender, _value);
    return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
    return allowed[_owner][_spender];
    }

    function setRate(uint256 rate) external returns (bool success)
    {
        require(rate &gt; 0);
        RATE = rate; 
        return true;
    }

    function setSupply(uint256 supply) external returns (bool success)
    {
         //Check value to buy &gt; 0
         require(supply &gt; 0);
        _totalSupply = supply; 
        return true;
    }

  

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}