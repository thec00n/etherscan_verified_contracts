pragma solidity ^0.4.18;

contract GOLD {
    string public name = &quot;GOLD&quot;;
    string public symbol = &quot;GOLD&quot;;
    uint8 public decimals = 0;
    uint256 public totalSupply = 30000000;
    mapping (address =&gt; uint256) public balanceOf;
    event Transfer(address indexed from, address indexed to, uint256 value);
    function GOLD() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] &gt;= _value);
        require(balanceOf[_to] + _value &gt; balanceOf[_to]);
        uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
        assert(balanceOf[msg.sender] + balanceOf[_to] == previousBalances);
    }

}