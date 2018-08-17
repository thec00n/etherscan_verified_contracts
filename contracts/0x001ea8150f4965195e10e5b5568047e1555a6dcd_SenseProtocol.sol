pragma solidity ^0.4.11;

interface IERC20{
   function totalSupply() constant returns (uint256 totalSupply);
   function balanceOf(address _owner) constant returns (uint256 balance);
   function transfer(address _to, uint256 _value) returns (bool success);
   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
   function approve(address _spender, uint256 _value) returns (bool success);
   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
   event Transfer(address indexed _from, address indexed _to, uint256 _value);
   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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


contract SenseProtocol is IERC20 {

using SafeMath for uint256;

uint public _totalSupply = 0;

string public constant symbol = &quot;SENSE&quot;;
string public constant name = &quot;Sense&quot;;
uint8 public constant decimals = 18;

// 1 ETH = 1000 Simple
uint256 public constant RATE = 500;

// Sets Maximum Tokens to be Created
uint256 public constant maxTokens = 40000000000000000000000000;

address public owner;

mapping (address =&gt; uint256) public balances;
mapping(address =&gt; mapping(address =&gt; uint256)) allowed;

function () payable{
    createTokens();
}

function SenseProtocol(){
    owner = msg.sender;
}

function createTokens() payable{
    require(msg.value &gt; 0);
    uint256 tokens = msg.value.mul(RATE);
    require(_totalSupply.add(tokens) &lt;= maxTokens);
    balances[msg.sender] = balances[msg.sender].add(tokens);
    _totalSupply = _totalSupply.add(tokens);
    owner.transfer(msg.value);
}

function totalSupply() public constant returns (uint256 totalSupply) {
    return _totalSupply;
}

function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
}

function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
}

function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[_from] &gt;= _value &amp;&amp; _value &gt; 0);
    balances[_from] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
}

function approve(address _spender, uint256 _value) public returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}

function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
}

event Transfer(address indexed _from, address indexed _to, uint256 _value);

event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}