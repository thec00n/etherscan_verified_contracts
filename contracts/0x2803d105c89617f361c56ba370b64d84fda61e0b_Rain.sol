pragma solidity ^0.4.11;

/* RAIN Token */

contract Rain {

    string public standard = &#39;RAINToken&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public sellPrice;
    uint256 public buyPrice;

    function Rain() {
        totalSupply = 1000000000;
        balanceOf[this] = totalSupply;
        name = &#39;Rain&#39;;
        symbol = &#39;RAIN&#39;;
        decimals = 0;
        sellPrice = 1000000000;
        buyPrice = 1000000000;
    }

    mapping (address =&gt; uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) revert();
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) revert();
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function buy() payable {
        uint amount = msg.value / buyPrice;
        if (balanceOf[this] &lt; amount) revert();
        balanceOf[msg.sender] += amount;
        balanceOf[this] -= amount;
        Transfer(this, msg.sender, amount);
    }

    function sell(uint256 amount) {
        if (balanceOf[msg.sender] &lt; amount ) revert();
        balanceOf[this] += amount;
        balanceOf[msg.sender] -= amount;
        if (!msg.sender.send(amount * sellPrice)) {
            revert();
        } else {
            Transfer(msg.sender, this, amount);
        }
    }

    function () {
        revert();
    }
}