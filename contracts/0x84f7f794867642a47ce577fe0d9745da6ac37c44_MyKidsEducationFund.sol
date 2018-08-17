pragma solidity ^0.4.16;

contract MyKidsEducationFund {
  string public constant symbol = &quot;MKEF&quot;;
  string public constant name = &quot;MyKidsEducationFund&quot;;
  uint8 public constant decimals = 18;

  address owner = 0x3755530e18033E3EDe5E6b771F1F583bf86EfD10;

  mapping (address =&gt; uint256) public balances;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  function MyKidsEducationFund() public {
    balances[msg.sender] = 1000;
  }

  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(balances[msg.sender] &gt;= _value);
    require(_value &gt; 0);
    require(balances[_to] + _value &gt;= balances[_to]);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function () payable public {
    require(msg.value &gt;= 0);
    uint tokens = msg.value / 10 finney;
    balances[msg.sender] += tokens;
    owner.transfer(msg.value);
  }
}