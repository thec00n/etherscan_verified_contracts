pragma solidity ^0.4.2;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
        if (newOwner != address(0)) {
          owner = newOwner;
        }
    }
}
contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }


contract RedTicket is owned {
    string public standard = &#39;RedTicket 1.0&#39;;
    string public constant name = &quot;RedTicket&quot;;
    string public constant symbol = &quot;RED&quot;;
    uint8 public constant decimals = 18; 
    uint256 public totalSupply;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    mapping (address =&gt; bool) public frozenAccount;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Burn(address indexed from, uint256 value);
    event FrozenFunds(address target, bool frozen);
    event Issuance(address indexed to, uint256 value);

    function RedTicket(
        uint256 initialSupply,
        address centralMinter
        ) {
        if(centralMinter != 0 ) owner = centralMinter;

        balances[msg.sender] = initialSupply;
        totalSupply = initialSupply;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] &gt;= _value 
            &amp;&amp; _value &gt; 0
            &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
                
                balances[msg.sender] -= _value;
                balances[_to] += _value;
                Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (!frozenAccount[msg.sender]
            &amp;&amp; balances[_from] &gt;= _value
            &amp;&amp; allowed[_from][msg.sender] &gt;= _value
            &amp;&amp; _value &gt; 0
            &amp;&amp; balances[_to] + _value &gt; balances[_to]) {

                balances[_from] -= _value;
                allowed[_from][msg.sender] -= _value;
                balances[_to] += _value;
                Transfer(_from, _to, _value);
            return true;

        } else {
            return false;
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

    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    function freezeAccount(address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }

    function () {
        revert();
    }

    function burn(uint256 _value) returns (bool success) {
        if (balances[msg.sender] &lt; _value) return false; 
        balances[msg.sender] -= _value;
        totalSupply -= _value;
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) returns (bool success) {
        if (balances[_from] &lt; _value) return false;
        if (_value &gt; allowed[_from][msg.sender]) return false;
        balances[_from] -= _value;
        totalSupply -= _value;
        Burn(_from, _value);
        return true;
    }

    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balances[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }
}