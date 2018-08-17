pragma solidity ^0.4.16;

contract VaraToken {

    string public name = &quot;Vara&quot;;
    string public symbol = &quot;VAR&quot;;
    uint8 public decimals = 18;
    uint256 public initialSupply = 100000000;

    uint256 totalSupply;
    address public owner;

    mapping (address =&gt; uint256) public balanceOf;

    function VaraToken() public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        owner = 0x86f8001374eeCA3530158334198637654B81f702;
        balanceOf[owner] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] &gt;= _value);
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

    function () payable public {
        require(msg.value &gt; 0 ether);
        require(now &gt; 1514678400);              // 12/12/2017
        require(now &lt; 1519776000);              // 28/2/2018
        uint256 amount = msg.value * 750;
        require(balanceOf[owner] &gt;= amount);
        require(balanceOf[msg.sender] &lt; balanceOf[msg.sender] + amount);
        balanceOf[owner] -= amount;
        balanceOf[msg.sender] += amount;
        owner.transfer(msg.value);
    }
}