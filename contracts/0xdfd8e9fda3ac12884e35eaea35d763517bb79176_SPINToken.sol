pragma solidity ^0.4.10;

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

contract SPINToken is StandardToken, SafeMath {

    string public constant name = &quot;ETHERSPIN&quot;;
    string public constant symbol = &quot;SPIN&quot;;
    uint256 public constant decimals = 18;
    string public version = &quot;2.0&quot;;

    address public ethFundDeposit;
    address public SPINFundDeposit;

    bool public isFinalized;
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public constant SPINFund = 2000 * (10**3) * 10**decimals;

    function tokenRate() constant returns(uint) {
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+250) return 1300;
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+33600) return 1000;
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+67200) return 750;
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+100800) return 600;
        return 500;
    }

    // Total Cap is 10M
    uint256 public constant tokenCreationCap =  10 * (10**6) * 10**decimals;


    // events
    event CreateSPIN(address indexed _to, uint256 _value);

    // constructor
    function SPINToken(
        address _ethFundDeposit,
        address _SPINFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock)
    {
      isFinalized = false;
      ethFundDeposit = _ethFundDeposit;
      SPINFundDeposit = _SPINFundDeposit;
      fundingStartBlock = _fundingStartBlock;
      fundingEndBlock = _fundingEndBlock;
      totalSupply = SPINFund;
      balances[SPINFundDeposit] = SPINFund;
      CreateSPIN(SPINFundDeposit, SPINFund);
    }


    function makeTokens() payable  {
      if (isFinalized) throw;
      if (block.number &lt; fundingStartBlock) throw;
      if (block.number &gt; fundingEndBlock) throw;
      if (msg.value == 0) throw;

      uint256 tokens = safeMult(msg.value, tokenRate());

      uint256 checkedSupply = safeAdd(totalSupply, tokens);

      if (tokenCreationCap &lt; checkedSupply) throw;

      totalSupply = checkedSupply;
      balances[msg.sender] += tokens;
      CreateSPIN(msg.sender, tokens);
    }

    function() payable {
        makeTokens();
    }

    function finalize() external {
      if (isFinalized) throw;
      if (msg.sender != ethFundDeposit) throw;

      if(block.number &lt;= fundingEndBlock &amp;&amp; totalSupply != tokenCreationCap) throw;

      isFinalized = true;
      if(!ethFundDeposit.send(this.balance)) throw;
    }



}