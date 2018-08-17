pragma solidity ^0.4.13;


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
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    function transfer(address _to, uint256 _value) public returns (bool success) {       
        address sender = msg.sender;
        require(balances[sender] &gt;= _value);
        balances[sender] -= _value;
        balances[_to] += _value;
        Transfer(sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
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
}

contract GigaGivingToken is StandardToken {
    string public constant NAME = &quot;Giga Coin&quot;;
    string public constant SYMBOL = &quot;GC&quot;;
    uint256 public constant DECIMALS = 0;
    uint256 public constant TOTAL_TOKENS = 15000000;
    uint256 public constant  CROWDSALE_TOKENS = 12000000;  
    string public constant VERSION = &quot;GC.2&quot;;

    function GigaGivingToken () public {
        balances[msg.sender] = TOTAL_TOKENS; 
        totalSupply = TOTAL_TOKENS;
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        require(_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData));
        return true;
    }
}