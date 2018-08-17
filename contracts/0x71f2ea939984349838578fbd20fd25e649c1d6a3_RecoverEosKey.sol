pragma solidity ^0.4.24;

contract RecoverEosKey {
    
    mapping (address =&gt; string) public keys;
    
    event LogRegister (address user, string key);
    
    function register(string key) public {
        assert(bytes(key).length &lt;= 64);
        keys[msg.sender] = key;
        emit LogRegister(msg.sender, key);
    }
}