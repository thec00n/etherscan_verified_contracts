pragma solidity ^0.4.18;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }  

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }
  
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }
}

contract BCE {
    
    using SafeMath for uint256;
    
    uint public _totalSupply = 0; 
    
    string public constant symbol = &quot;BCE&quot;;
    string public constant name = &quot;Bitcoin Ether&quot;;
    uint8 public constant decimals = 18;
	uint256 public totalSupply = _totalSupply * 10 ** uint256(decimals);
    
    // 1 ether = 500 bitcoin ethers
    uint256 public constant RATE = 500; 
    
    address public owner;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    
	function () public payable {
        createTokens();
    } 
    
    function BCEToken() public {
        owner = msg.sender;
    }
    
	function createTokens() public payable {
	    require(_totalSupply &lt;= 21000000); // Max Bitcoin Ethers in circulation = 21 mil. 
        require(msg.value &gt; 0);
        uint256 tokens = msg.value.mul(RATE);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        _totalSupply = _totalSupply.add(tokens);
        owner.transfer(msg.value);
    } 
    
    function balanceOf(address _owner) public constant returns (uint256 balance){
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) internal returns (bool success) {
		require(_to != 0x0);
        require(balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
		require(_to != 0x0);
        require(allowed [_from][msg.sender] &gt;= 0 &amp;&amp; balances[_from] &gt;= _value &amp;&amp; _value &gt; 0);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
}