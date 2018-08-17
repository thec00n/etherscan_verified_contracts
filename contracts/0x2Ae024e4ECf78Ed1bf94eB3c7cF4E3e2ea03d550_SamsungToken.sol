pragma solidity ^0.4.11;
contract SamsungToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    /* This creates an array with all balances */
    mapping(address =&gt; uint256) public balanceOf;

    function SamsungToken() {
        name = &quot;SamsungToken&quot;;
        symbol = &quot;SamsungToken&quot;;
        decimals = 2;
        balanceOf[msg.sender] = 88800000000000;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
}