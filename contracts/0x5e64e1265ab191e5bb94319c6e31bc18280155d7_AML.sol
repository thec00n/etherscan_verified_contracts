pragma solidity ^0.4.13;

contract AML {
  string public constant name = &quot;AML Token&quot;;
  string public constant symbol = &quot;AML&quot;;
  uint8 public constant decimals = 18;
  
  uint256 public totalSupply;
  mapping(address =&gt; uint256) balances;
  mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  
  function AML() {
    balances[msg.sender] = 51000000000000000000000000;
    totalSupply = 51000000000000000000000000;
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


  function balanceOf(address _owner) constant returns (uint256 balance) {
    return balances[_owner];
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
  
  function approve(address _spender, uint256 _value) returns (bool) {
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }
  
  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}