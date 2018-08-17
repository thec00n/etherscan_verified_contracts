pragma solidity ^0.4.18;


    contract ERC20 {
    function totalSupply() public constant returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function allowance(address owner, address spender) public view returns (uint256);
    function approve(address spender, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    }

    library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c; 
    }
    }


    contract Bitway is ERC20 {
    
    using SafeMath for uint256;
    
    
    uint256 public totalSupply = 0;
    uint256 public maxSupply = 22000000 * 10 ** uint256(decimals);
    
    string public constant symbol = &quot;BTW&quot;;
    string public constant name = &quot;Bitway&quot;;
    uint256 public constant decimals = 18;
    
    
    
    uint256 public constant RATE = 10000;
    address public owner;
    
   
    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
    
    
    
    function () public payable {
        createTokens();
        
    }
    
    function Bitway() public {
        owner = msg.sender;
        
    }
    
   
    function createTokens() public payable {
        require(msg.value &gt; 0);
        require(totalSupply &lt; maxSupply);
        uint256 tokens = msg.value.mul(RATE);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        totalSupply = totalSupply.add(tokens);
        
    }
    
    
    
    function totalSupply() public constant returns (uint256){
        return totalSupply;
    }

  
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[msg.sender]);

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(
        allowed[_from][msg.sender] &gt;= _value
        &amp;&amp; balances[_from] &gt;= _value
        &amp;&amp; _value &gt; 0
        );

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
   
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}