pragma solidity ^0.4.8;

contract Owned {

    address owner;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyowner() {
        if (msg.sender==owner) _;
    }

    function changeOwner(address newOwner) onlyowner {
        owner = newOwner;
    }
}

contract Token is Owned {

    uint256 public totalSupply;

    function balanceOf(address _owner) constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);

    function approve(address _spender, uint256 _value) returns (bool success);

    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract ERC20Token is Token
{

    function transfer(address _to, uint256 _value) returns (bool success)
    {
        if (balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
    {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining)
    {
      return allowed[_owner][_spender];
    }

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}

contract TEST is ERC20Token
{
    function ()
    {
        throw;
    }

    string public name;
    uint8 public decimals;
    string public symbol;
    string public version = &#39;1.0&#39;;

    function TEST ()
    {
        balances[msg.sender] = 10000000000000000000;
        totalSupply = 10000000000000000000;
        name = &#39;Test&#39;;
        decimals = 6;
        symbol = &#39;TST&#39;;
    }

    function add(uint256 _value) onlyowner  returns (bool success)
    {
        totalSupply += _value;
        balances[msg.sender] += _value;
        return true;
    }

    function burn(uint256 _value) onlyowner  returns (bool success)
    {
        if (balances[msg.sender] &lt; _value) {
            return false;
        }
        totalSupply -= _value;
        balances[msg.sender] -= _value;
        return true;
    }
}