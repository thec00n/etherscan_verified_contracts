pragma solidity ^0.4.8;
contract Token{
    
    uint256 public totalSupply;
    
    function balanceOf(address _owner) constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) returns (bool success);

    function transferFrom(address _from, address _to, uint256 _value) returns   
    (bool success);

    function approve(address _spender, uint256 _value) returns (bool success);

    function allowance(address _owner, address _spender) constant returns 
    (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 
    _value);
}

contract StandardToken is Token {
    function transfer(address _to, uint256 _value) returns (bool success) {
        
    //    require(balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]);
        require(balances[msg.sender] &gt;= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }


    function transferFrom(address _from, address _to, uint256 _value) returns 
    (bool success) {
        //require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= 
        // _value &amp;&amp; balances[_to] + _value &gt; balances[_to]);
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value; 
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }


    function approve(address _spender, uint256 _value) returns (bool success)   
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }


    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}

contract SixDomainAsset is StandardToken { 

    /* Public variables of the token */
    string public  name;                    //name: eg Six Domain Asset
    uint8  public  decimals;               
    string public  symbol;                  
    string public  version = &#39;v0.1&#39;;        
    string public  officialWebsite = &#39;https://sdchain.io&#39;;

    function SixDomainAsset(
        uint256 _initialAmount,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol
        ) {
        totalSupply = _initialAmount * 10 ** uint256(_decimalUnits);
        balances[msg.sender] = totalSupply;                         // Give the creator all initial tokens
        name = _tokenName;                                          // Set the name for display purposes
        decimals = _decimalUnits;                                   // Amount of decimals for display purposes
        symbol = _tokenSymbol;                                      // Set the symbol for display purposes
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn&#39;t have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        require(_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData));
        return true;
    }

}