pragma solidity ^0.4.11;
contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

contract MyToken {
    string public standard = &#39;Token 0.1&#39;;
    string public name = &#39;One Thousand Coin&#39;;
    string public symbol = &#39;1000&#39;;
    uint8 public decimals = 8;
    uint256 public totalSupply = 100000000000;

    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Burn(address indexed from, uint256 value);

     function MyToken() {
        balanceOf[msg.sender] = 100000000000;
        totalSupply = 100000000000;
        name = &#39;One Thousand Coin&#39;;
        symbol = &#39;1000&#39;;
        decimals = 8;
    }

    function transfer(address _to, uint256 _value) {
        if (_to == 0x0) throw;
        if (balanceOf[msg.sender] &lt; _value) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;          
        Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
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

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (_to == 0x0) throw;
        if (balanceOf[_from] &lt; _value) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        if (_value &gt; allowance[_from][msg.sender]) throw;
        balanceOf[_from] -= _value;   
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function burn(uint256 _value) returns (bool success) {
        if (balanceOf[msg.sender] &lt; _value) throw;
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) returns (bool success) {
        if (balanceOf[_from] &lt; _value) throw;
        if (_value &gt; allowance[_from][msg.sender]) throw;
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        Burn(_from, _value);
        return true;
    }
}