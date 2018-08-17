pragma solidity ^0.4.11;

contract MichaelCoin {


  mapping (address =&gt; uint256) balances;
  mapping (address =&gt; mapping (address =&gt; uint256)) allowed;


  string public name = &quot;Michael Coin&quot;;
  string public symbol = &quot;MC&quot;;
  uint8 public decimals = 18;
  uint256 public totalAmount = 1000000 ether;

  event Transfer (address indexed _from, address indexed _to, uint256 _value);
  event Approval (address indexed _owner, address indexed _spender, uint256 _value);

  function MichaelCoin() {
    // constructor
    balances[msg.sender] = totalAmount;
  }
  function totalSupply() constant returns(uint) {
        return totalAmount;
    }
  function transfer (address _to, uint256 _value) returns (bool success) {
    if (balances[msg.sender] &gt;= _value
        &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      Transfer(msg.sender, _to, _value);
      return true;
    } else { return false; }
  }

  function transferFrom(address _from, address _to, uint _value) returns (bool success) {
    if(balances[_from] &gt;= _value
        &amp;&amp; _value &gt; 0
        &amp;&amp; balances[_to] + _value &gt; balances[_to]
        &amp;&amp; allowed[_from][msg.sender] &gt;= _value) {

        balances[_from] -= _value;
        balances[_to] += _value;
        Transfer(_from, _to, _value);

        return true;
    }
    return false;
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

  function() {
    revert();
  }
}