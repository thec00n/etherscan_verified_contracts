pragma solidity ^0.4.8;

contract SOA {
    /* Public variables of the token */
    string public name = &#39;SOA Test Token&#39;;
    string public symbol = &#39;SOA&#39;;
    uint8 public decimals = 2;
    uint256 public totalSupply = 10000; // 100 

    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function SOA() {
        balanceOf[msg.sender] = totalSupply;
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        assert(_to != 0x0);
        assert(balanceOf[msg.sender] &gt;= _value);
        assert(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balanceOf[_owner];
    }
}