pragma solidity 0.4.21;


contract Token {

    mapping (address =&gt; uint) balances;
    mapping (address =&gt; mapping (address =&gt; uint)) allowed;
    uint public totalSupply;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    function transfer(address _to, uint _value) public returns (bool) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt;= balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt;= balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant public returns (uint) {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint) {
        return allowed[_owner][_spender];
    }

    
}

contract ParisToken is Token {

    uint public totalSupply = 1*10**27;
    uint8 constant public decimals = 18;
    string constant public name = &quot;ParisToken&quot;;
    string constant public symbol = &quot;PT&quot;;
    uint constant MAX_UINT = 2**256 - 1;

    function ParisToken() public {
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transferFrom(address _from, address _to, uint _value)
        public
        returns (bool)
    {
        uint allowance = allowed[_from][msg.sender];
        if (balances[_from] &gt;= _value
            &amp;&amp; allowance &gt;= _value
            &amp;&amp; balances[_to] + _value &gt;= balances[_to]
        ) {
            balances[_to] += _value;
            balances[_from] -= _value;
            if (allowance &lt; MAX_UINT) {
                allowed[_from][msg.sender] -= _value;
            }
            emit Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }
}