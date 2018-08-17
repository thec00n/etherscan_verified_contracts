pragma solidity ^0.4.10;

contract Token {
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


/*  ERC 20 token */
contract StandardToken is Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
      if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
      } else {
        return false;
      }
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

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}


// requires 550000000 INDI deposited here
contract INDISafe {
  mapping (address =&gt; uint256) allocations;
  uint256 public unlockDate;
  address public INDI;
  uint256 public constant exponent = 10**18;

  function INDISafe() {
    INDI = 0xC0661B1fCe0e77Ea21a3268c5d42A5442Dd96817; //INDI token smart contract address
    unlockDate = 1522540800; //APRIL 1, 2018
    allocations[0xA03b1F2ada0ad1aF349CdE1e0875690245CA54C2] = 550000000;
    
  }

  function unlock() external {
    if(now &lt; unlockDate) throw;
    uint256 entitled = allocations[msg.sender];
    allocations[msg.sender] = 0;
    if(!StandardToken(INDI).transfer(msg.sender, entitled * exponent)) throw;
  }

}