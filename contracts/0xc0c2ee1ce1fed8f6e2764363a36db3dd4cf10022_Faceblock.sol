pragma solidity ^0.4.11;

contract SafeMath {

function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
uint256 z = x + y;
      assert((z &gt;= x) &amp;&amp; (z &gt;= y));
      return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
      assert(x &gt;= y);
      uint256 z = x - y;
      return z;
    }

    function safeMult(uint256 x, uint256 y) internal returns(uint256) {
      uint256 z = x * y;
      assert((x == 0)||(z/x == y));
      return z;
    }

}

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

contract Faceblock is StandardToken, SafeMath {

    // metadata
    string public constant name = &quot;Faceblock&quot;;
    string public constant symbol = &quot;FBL&quot;;
    uint256 public constant decimals = 2;
    string public version = &quot;1.0&quot;;

    // contracts
    address ethFundDeposit;      // deposit address for ETH for FBL
    address FBLFounder;
    address FBLFundDeposit1;      // deposit address for depositing tokens for owners
    address FBLFundDeposit2;      // deposit address for depositing tokens for owners
    uint256 public constant FBLFund = 5 * (10**6) * 10**decimals;   // Faceblock reserved for Owners
    uint256 public constant FBLFounderFund = 5 * (10**6) * 10**decimals;   // Faceblock reserved for Owners
    uint256 public constant tokenCreationCap =  10 * (10**6) * 10**decimals;

    /// @dev Accepts ether and creates new FBL tokens.
    // events
    event CreateFBL(address indexed _to, uint256 _value);

    // constructor
    function Faceblock()
    {
      FBLFounder = &#39;0x3A1F12A15f3159903f2EEbe1a2949A780911f695&#39;;
      FBLFundDeposit1 = &#39;0x2E109b1c58625F0770d885ADA419Df16621350bB&#39;;
      FBLFundDeposit2 = &#39;0xAeD77852D6810E5c36ED85Ad1beC9c2368F5400F&#39;;
      totalSupply = safeMult(FBLFund,1);
      totalSupply = safeAdd(totalSupply,FBLFounderFund);
      balances[FBLFundDeposit1] = FBLFund;    // works with deposit
      balances[FBLFundDeposit2] = FBLFund;    // works with deposit
      transferFrom(0x0, 0x3A1F12A15f3159903f2EEbe1a2949A780911f695, 50 * (10**6) * 10**decimals);
      transferFrom(0x0, 0xAeD77852D6810E5c36ED85Ad1beC9c2368F5400F, 50 * (10**6) * 10**decimals);
    }
}