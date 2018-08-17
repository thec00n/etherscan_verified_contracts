pragma solidity ^0.4.15;
contract SafeMath {
  //internals

  function safeMul(uint a, uint b) internal pure returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal pure returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }
}

/**
 * 
 * ERC 20 token
 *
 */
contract Token {

    uint256 public totalSupply;

    function balanceOf(address _owner) public view returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);

    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * ERC 20 token
 *
 * https://github.com/ethereum/EIPs/issues/20
 */
contract StandardToken is Token {

    function transfer(address _to, uint256 _value) public returns (bool success) {
        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn&#39;t wrap.
        //Replace the if with this one instead.
        if (balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
        //if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
        //if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) view public returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping(address =&gt; uint256) balances;

    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalSupply;

}

contract DogecoinAlphaToken is StandardToken, SafeMath {

    string public name = &quot;Dogecoin Alpha Token&quot;;
    string public symbol = &quot;DCA&quot;;
    uint public decimals = 18;
    
    address public team = 0x0;
    address public airdrop = 0x0;

    function DogecoinAlphaToken(address teamAddress, address airDropAddress) public {
        team = teamAddress;
        airdrop = airDropAddress;
        uint totalSupplyQuarter = 5 * (10 ** 23);
        totalSupply = totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter;
        balances[team] = totalSupplyQuarter;
        balances[airdrop] = totalSupplyQuarter + totalSupplyQuarter + totalSupplyQuarter;
    }

}