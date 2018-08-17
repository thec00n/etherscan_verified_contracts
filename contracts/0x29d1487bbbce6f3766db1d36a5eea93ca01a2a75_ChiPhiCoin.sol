pragma solidity ^0.4.19;

contract ChiPhiCoin {

    address owner;
    uint _totalSupply = 310000;
    
    mapping (address =&gt; uint) balances;
    mapping (address =&gt; mapping(address =&gt; uint)) allowed;
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    
    string public constant name = &quot;ChiPhi Coin&quot;;
    string public constant symbol = &quot;XPM&quot;;
    uint8 public constant decimals = 18;
    
    function ChiPhiCoin() public {
        owner = msg.sender;
        balances[owner] = 310000;
    }
    
    function totalSupply() public constant returns (uint256 tSupply) {
        return _totalSupply;
     }
    
    function balanceOf(address _owner) public constant returns (uint) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint _amount) public returns (bool success) {
        if (balances[msg.sender] &gt;= _amount
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
                balances[msg.sender] -= _amount;
                balances[_to] += _amount;
                Transfer(msg.sender, _to, _amount);
                return true;
        }
        else {
            return false;
        }
    }
    
    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        if (balances[_from] &gt;= _amount
            &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
            balances[_from] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        }
        else {
            return false;
        }
    }
    
    function approve(address _spender, uint _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
     }
}