pragma solidity ^0.4.18;


contract BitcoinLowda {
    string public constant symbol = &quot;BCL&quot;;

    string public constant name = &quot;Bitcoin Lowda&quot;;

    uint public constant decimals = 18;

    uint public constant totalSupply = 100000000 * 10 ** decimals;

    address public owner;

    mapping (address =&gt; uint) balances;

    mapping (address =&gt; mapping (address =&gt; uint)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approval(address indexed _owner, address indexed _spender, uint _value);

    function BitcoinLowda() public {
        owner = msg.sender;
        balances[owner] = totalSupply;
        Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address _owner) public constant returns (uint balance)  {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint _amount) public returns (bool success)  {
        require(balances[msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0 &amp;&amp; balances[_to] + _amount &gt; balances[_to]);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        require(balances[_from] &gt;= _amount &amp;&amp; allowed[_from][msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0 &amp;&amp; balances[_to] + _amount &gt; balances[_to]);
        balances[_to] += _amount;
        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
}