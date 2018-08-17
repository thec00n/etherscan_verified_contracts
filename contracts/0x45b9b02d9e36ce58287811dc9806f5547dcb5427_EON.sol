pragma solidity 0.4.23;

contract ERC20 {
    
    //functions
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);
    function burn(uint _value) public returns (bool success);
    
    //events
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Burn(address indexed _from, uint _value);
}

contract RegularToken is ERC20 {

    function transfer(address _to, uint _value) public returns (bool) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt;= balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function burn(uint _value) public returns (bool success) {
        if (balances[msg.sender] &gt;= _value) {
            balances[msg.sender] -= _value;
            totalSupply -= _value;
            emit Burn(msg.sender, _value);
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

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return allowed[_owner][_spender];
    }

    mapping (address =&gt; uint) balances;
    mapping (address =&gt; mapping (address =&gt; uint)) allowed;
    uint public totalSupply;
}

contract UnboundedRegularToken is RegularToken {

    uint constant MAX_UINT = 2**256 - 1;
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
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

contract EON is UnboundedRegularToken {

    uint8 public constant decimals = 18;
    string public constant name = &quot;entertainment open network&quot;;
    string public constant symbol = &quot;EON&quot;;

    constructor() public {
        totalSupply = 21*10**26;
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
}