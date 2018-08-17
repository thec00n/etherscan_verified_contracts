contract owned {
    function owned() {
        owner = msg.sender;
    }
    modifier onlyowner() { 
        if (msg.sender == owner)
            _
    }
    address owner;
}
contract CoinLock is owned {
    uint public expiration; // Timestamp in # of seconds.
    
    function lock(uint _expiration) onlyowner returns (bool) {
        if (_expiration &gt; block.timestamp &amp;&amp; expiration == 0) {
            expiration = _expiration;
            return true;
        }
        return false;
    }
    function redeem() onlyowner {
        if (block.timestamp &gt; expiration) {
            suicide(owner);
        }
    }
}