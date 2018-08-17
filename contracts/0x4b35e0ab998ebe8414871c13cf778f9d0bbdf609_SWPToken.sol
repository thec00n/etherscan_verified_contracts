pragma solidity ^0.4.16;

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

contract SWPToken is StandardToken, SafeMath {

    string public constant name = &quot;SWAP&quot;;
    string public constant symbol = &quot;SWP&quot;;
    uint256 public constant decimals = 18;
    string public version = &quot;1.0&quot;;

    address public ethFundDeposit;
    address public swpFundDeposit;

    bool public isFinalized;
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public constant swpFund = 75000000 * 10**decimals;

    function tokenRate() constant returns(uint) {
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+2 days) return 3500;
        if (block.number&gt;=fundingStartBlock &amp;&amp; block.number&lt;fundingStartBlock+5 days) return 2700;
        return 2200;
    }

    uint256 public constant tokenCreationCap =  150000000 * 10**decimals; /// 150M Tokens maximum


    // events
    event CreateSWP(address indexed _to, uint256 _value);

    // constructor
    function SWPToken(
        address _ethFundDeposit,
        address _swpFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock)
    {
      isFinalized = false;
      ethFundDeposit = _ethFundDeposit;
      swpFundDeposit = _swpFundDeposit;
      fundingStartBlock = _fundingStartBlock;
      fundingEndBlock = _fundingEndBlock;
      totalSupply = swpFund;
      balances[swpFundDeposit] = swpFund;
      CreateSWP(swpFundDeposit, swpFund);
    }


    function makeTokens() payable  {
      if (isFinalized) revert();
      if (block.number &lt; fundingStartBlock) revert();
      if (block.number &gt; fundingEndBlock) revert();
      if (msg.value == 0) revert();

      uint256 tokens = safeMult(msg.value, tokenRate());

      uint256 checkedSupply = safeAdd(totalSupply, tokens);

      if (tokenCreationCap &lt; checkedSupply) revert();

      totalSupply = checkedSupply;
      balances[msg.sender] += tokens;
      CreateSWP(msg.sender, tokens);
    }

    function() payable {
        makeTokens();
    }

    function finalize() external {
      if (isFinalized) revert();
      if (msg.sender != ethFundDeposit) revert();

      if(block.number &lt;= fundingEndBlock &amp;&amp; totalSupply != tokenCreationCap) revert();

      isFinalized = true;
      if(!ethFundDeposit.send(this.balance)) revert();
    }
    
}