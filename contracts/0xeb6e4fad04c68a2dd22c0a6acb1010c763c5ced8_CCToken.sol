pragma solidity ^0.4.8;
contract Token{
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);
    function transfer(address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
contract StandardToken is Token {
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    function transfer(address _to, uint256 _value) returns (bool success) {
        require(balances[msg.sender] &gt;= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) returns (bool success)   
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value; 
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}

contract CCToken is StandardToken { 

    string public name;                   
    uint8 public decimals;               
    string public symbol;             

    function CCToken() {
        balances[msg.sender] = 10000000000000000; 
        totalSupply = 10000000000000000;         
        name = &quot;Coin Coming Token&quot;;                  
        decimals = 8;          
        symbol = &quot;CCT&quot;;            
    }
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        if(!_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))),  
            msg.sender, _value, this, _extraData)) { throw; }
        return true;
    }
    function () {
        //if ether is sent to this address, send it back.
        throw;
    }
}