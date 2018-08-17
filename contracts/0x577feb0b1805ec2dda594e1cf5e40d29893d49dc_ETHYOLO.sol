pragma solidity ^0.4.11;

interface IERC20 {
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
 * Math operations with safety checks
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
  
  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
      return a &gt;= b ? a : b;
  }
  
  function min64(uint64 a, uint64 b) internal constant returns (uint256) {
      return a &lt; b ? a : b;
  }
  
  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
      return a &gt;= b ? a : b;
  }
  
  function min256(uint256 a, uint256 b)  internal constant returns (uint256) {
      return a &lt; b ? a : b;
  }
  
}

contract ETHYOLO is IERC20 {
    
    using SafeMath for uint256;
    
    uint public constant _totalSupply = 99994138888;

    string public constant symbol = &quot;EYO&quot;;
    string public constant name = &quot;ETHYOLO COIN&quot;;
    uint8 public constant decimals = 18;
    // replace with your fund collection multisig address
    address public constant multisig = &quot;0xBAa21da3f332eBeAF33eB25412a8a82A160B4531&quot;;
    
    // 1 ether = 74138888 EYO
    uint256 public constant RATE = 74138888;
    
    address public owner;
    
    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
    
    function ETHYOLO() {
        owner = msg.sender;
    }
    
    function () payable {
        createTokens();
    }
    
    function createTokens() payable {
        require(msg.value &gt; 0);
        
        uint256 tokens= msg.value.mul(RATE);
        balances[msg.sender] = balances[msg.sender].add(tokens);
        
        
        owner.transfer(msg.value);
        
    }
    
    function totalSupply() constant returns (uint256 _totalSupply) {
        return _totalSupply;

    
    }
    
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(
            balances[msg.sender] &gt;= _value
            &amp;&amp; _value &gt; 0
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(
            allowed[_from][msg.sender] &gt;= _value
            &amp;&amp; balances[_from] &gt;= _value
            &amp;&amp; _value &gt; 0
        );
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed [_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event approval(address indexed _owner, address indexed _spender, uint256 _value);
}