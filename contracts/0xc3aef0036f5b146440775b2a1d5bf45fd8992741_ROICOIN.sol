pragma solidity ^0.4.18;


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

contract ROICOIN is Token {

    
    mapping (address =&gt; uint256) public balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;
   
    string public name;                   
    uint8 public decimals;               
    string public symbol;                

    function ROICOIN(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
    ) public {
        name = _tokenName;                                   
        decimals = _decimalUnits;                            
        symbol = _tokenSymbol;  
        totalSupply = _initialAmount * 10 ** uint256(decimals); 
        balances[msg.sender] = totalSupply; 
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        if (balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to] &amp;&amp; _value &gt; 0)
        {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        }
        else
        {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
       if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value  &amp;&amp; balances[_to] + _value &gt; balances[_to] &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        
       if (balances[msg.sender] &gt;= _value &amp;&amp; balances[msg.sender] &gt;= allowed[msg.sender][_spender] + _value &amp;&amp; _value &gt; 0)
        {
             allowed[msg.sender][_spender] += _value;
             Approval(msg.sender, _spender, _value);
             return true;
        }
          else
        {
            return false;
        }
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
            return allowed[_owner][_spender];
    }   
}