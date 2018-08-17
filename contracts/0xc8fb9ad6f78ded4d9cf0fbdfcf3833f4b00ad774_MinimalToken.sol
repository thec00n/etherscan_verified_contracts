pragma solidity ^0.4.18;

contract Token {
    uint256 public totalSupply;

    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}

contract MinimalToken is StandardToken {
    string public name;                     // Full token name
    uint8 public decimals;                  // Number of decimal places (usually 18)
    string public symbol;                   // Token ticker symbol
    string public version = &quot;MTV0.1&quot;;       // Arbitrary versioning scheme
    address public peg;                     // Address of peg contract (to reject direct transfers)

    function MinimalToken(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol,
        address _peg
        ) public {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
        peg = _peg;
    }

    function () public {
        revert();
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; _to != peg) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balances[_from] &gt;= _value &amp;&amp; (allowed[_from][msg.sender] &gt;= _value || (msg.sender == peg &amp;&amp; _to == peg)) &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else if (balances[_from] &gt;= _value &amp;&amp; (msg.sender == peg &amp;&amp; _to == peg) &amp;&amp; _value &gt; 0) { 
            balances[_to] += _value;
            balances[_from] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }
}