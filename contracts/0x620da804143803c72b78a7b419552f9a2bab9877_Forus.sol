pragma solidity ^0.4.13;

library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns(uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns(uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }
}
contract Forus{
     string public constant symbol = &quot;FRS&quot;;
     string public constant name = &quot;Forus&quot;;
     uint8 public constant decimals = 12;
     uint256 _totalSupply = 220000000000000000000;
     event Transfer(address indexed from, address indexed to, uint256 value);
     event Approval(address indexed _owner, address indexed spender, uint256 value);
   
       address public owner;
  
     mapping(address =&gt; uint256) balances;
  
     mapping(address =&gt; mapping (address =&gt; uint256)) allowed;
     
  
     function Forus() {
         owner = msg.sender;
         balances[owner] = 220000000000000000000;
     }
     
     modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
     
     function totalSupply() constant returns (uint256 totalSupply) {
         totalSupply = _totalSupply;
     }
  

     function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
     }
 
     function transfer(address _to, uint256 _amount) returns (bool success) {
         if (balances[msg.sender] &gt;= _amount 
            &amp;&amp; _amount &gt; 0
             &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
             balances[msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(msg.sender, _to, _amount);
            return true;
         } else {
             return false;
         }
     }
     
     
     function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) returns (bool success) {
         if (balances[_from] &gt;= _amount
             &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
             &amp;&amp; _amount &gt; 0
             &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(_from, _to, _amount);
             return true;
         } else {
            return false;
         }
     }
 
     function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
    }
}