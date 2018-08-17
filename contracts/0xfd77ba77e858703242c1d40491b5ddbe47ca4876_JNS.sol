pragma solidity 0.4.24;

contract JNS {
    mapping (string =&gt; address) strToAddr;
    mapping (address =&gt; string) addrToStr;
    
    function registerAddress (string _nickname, address _address) public returns (bool) {
        require (strToAddr[_nickname] == address(0), &quot;Name already registered&quot;);
        require (keccak256(addrToStr[_address]) == keccak256(&quot;&quot;), &quot;Address already registered&quot;);
        
        strToAddr[_nickname] = _address;
        addrToStr[_address] = _nickname;
        
        return true;
    }
    
    function getAddress (string _nickname) public view returns (address _address) {
        _address = strToAddr[_nickname];
    }
    
    function getNickname (address _address) public view returns (string _nickname) {
        _nickname = addrToStr[_address];
    }
    
}