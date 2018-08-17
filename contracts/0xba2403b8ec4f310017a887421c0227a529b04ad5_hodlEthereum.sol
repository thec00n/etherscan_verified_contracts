pragma solidity ^0.4.11;
contract hodlEthereum {
    event Hodl(address indexed hodler, uint indexed amount);
    event Party(address indexed hodler, uint indexed amount);
    mapping (address =&gt; uint) hodlers;
    uint constant partyTime = 1596067200; // 30th July 2020
    function() payable {
        hodlers[msg.sender] += msg.value;
        Hodl(msg.sender, msg.value);
    }
    function party() {
        require (block.timestamp &gt; partyTime &amp;&amp; hodlers[msg.sender] &gt; 0);
        uint value = hodlers[msg.sender];
        hodlers[msg.sender] = 0;
        msg.sender.transfer(value);
        Party(msg.sender, value);
    }
}