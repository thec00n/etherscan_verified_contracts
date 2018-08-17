pragma solidity ^0.4.16;
contract GHK{

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address =&gt; uint256) public balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract &amp; in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    uint256 public totalSupply;
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
   
    function GHK() public {
        balances[msg.sender] = 3600000000000;               // Give the creator all initial tokens
        totalSupply = 3600000000000;                        // Update total supply
        name = &quot;GHK&quot;;                                   // Set the name for display purposes
        decimals =4;                            // Amount of decimals for display purposes
        symbol = &quot;GHK&quot;;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] &gt;= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] &gt;= _value &amp;&amp; allowance &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance &lt; MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }   
}