pragma solidity ^0.4.11;

interface IERC20{
    
function totalSupply() constant returns (uint256 totalSupply);

function CirculatingSupply() constant returns (uint256 _CirculatingSupply);
    
function balanceOf(address _owner) constant returns (uint256 balance);
   
function transfer(address _to, uint256 _value) returns (bool success);
   
function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    
function approve(address _spender, uint256 _value) returns (bool success);
    
function allowance(address _owner, address _spender) constant returns (uint256 remaining);
   
event Transfer(address indexed _from, address indexed _to, uint256 _value);
  
event Approval(address indexed _owner, address indexed _spender, uint256 _value);
 

} 

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

contract NewYearToken is IERC20{
    
    using SafeMath for uint256;
    string public constant symbol = &quot;NYT&quot;;
    string public constant name = &quot;New Year Token&quot;;
    uint8 public constant decimals = 18;
    uint private supplay= 0;
    uint private _CirculatingSupply = 0;
    uint private _MaxSupply=1000000000000000000000000;
    
   
    uint256 private constant RATE1 = 2000;
    uint256 private constant RATE2 = 1000;
    address public owner=0xC6D3a0704c169344c758915ed406eBA707DB1e76;
    
    uint private constant preicot=1513765800;
    uint private constant preicote=1514242799;
    
    uint private constant icot=1514370600;
    uint private constant icote=1515020399;
    
    
    mapping(address=&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
    
    function () payable{
    
    if(now&lt;=preicote){
     createTokens();  
    }
    else {
        createTokens1();
    }
    
      
    }
   
    function NewYearToken(){
        supplay = supplay.add(200000000000000000000000);
    }
  
    function createTokens() payable{
         uint tokens = msg.value.mul(RATE1);
            require(msg.value &gt; 0 &amp;&amp; supplay+tokens&lt;=_MaxSupply &amp;&amp; now&gt;=preicot &amp;&amp; now&lt;=preicote);
           balances[msg.sender] = balances[msg.sender].add(tokens);
            _CirculatingSupply = _CirculatingSupply.add(tokens);
            supplay = supplay.add(tokens);
            owner.transfer(msg.value);
    }
    
    function createTokens1() payable{
         uint tokens = msg.value.mul(RATE2);
            require(msg.value &gt; 0 &amp;&amp; supplay+tokens&lt;=_MaxSupply &amp;&amp; now&gt;=icot &amp;&amp; now&lt;=icote);
           balances[msg.sender] = balances[msg.sender].add(tokens);
            _CirculatingSupply = _CirculatingSupply.add(tokens);
            supplay = supplay.add(tokens);
            owner.transfer(msg.value);
    }
    
    
    function totalSupply() constant returns (uint256 totalSupply){
       return _MaxSupply;  
     }
      function CirculatingSupply() constant returns (uint256 CirculatingSupply){
       return _CirculatingSupply;  
     }
    function balanceOf(address _owner) constant returns (uint256 balance){
        return balances[_owner];
    }
    function transfer(address _to, uint256 _value) returns (bool success){
        require(
            balances[msg.sender] &gt;= _value
            &amp;&amp; _value &gt; 0 &amp;&amp; now&gt;icote
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function withdrawfunds() returns (bool seccess){
        require(owner==msg.sender);
        balances[owner] = balances[owner].add(200000000000000000000000);
        _CirculatingSupply = _CirculatingSupply.add(200000000000000000000000);
        return true;
    }
    function burn() returns (bool seccess){
        require(owner==msg.sender);
        uint stevilo=_MaxSupply.sub(supplay);
        _MaxSupply=_MaxSupply.sub(stevilo);
        return true;
    }
     function newowner(address _owner) returns (bool seccess){
        require(owner==msg.sender);
        owner=_owner;
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
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
    function approve(address _spender, uint256 _value) returns (bool success){
       allowed[msg.sender][_spender] = _value;
       Approval(msg.sender, _spender, _value);
       return true;
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining){
        return allowed[_owner][_spender];
    }
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}