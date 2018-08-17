pragma solidity ^0.4.4;

contract Token {

    
    function totalSupply() constant returns (uint256 supply) {}

    
    function balanceOf(address _owner) constant returns (uint256 balance) {}

    
    function transfer(address _to, uint256 _value) returns (bool success) {}

    
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}

    
    function approve(address _spender, uint256 _value) returns (bool success) {}

    
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}

contract Owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

contract StandardToken is Token, Owned {

    function transfer(address _to, uint256 _value) returns (bool success) {
       
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }
    
    function distributeToken(address[] addresses, uint256 _value) {
     for (uint i = 0; i &lt; addresses.length; i++) {
         balances[msg.sender] -= _value;
         balances[addresses[i]] += _value;
         Transfer(msg.sender, addresses[i], _value);
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
    
    
    uint256 public totalSupply;
}



contract B2X is StandardToken {

    function () {
        
        throw;
    }

    
    string public name;                   
    uint8 public decimals;                
    string public symbol;                 
           

    function B2X(
        ) {
        totalSupply = 21 * 10 ** 14;
        balances[msg.sender] = totalSupply;              
        name = &quot;BTC2X&quot;;                                   
        decimals = 8;                            
        symbol = &quot;B2X&quot;;                               
    }


    
}