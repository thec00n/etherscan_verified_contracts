pragma solidity ^0.4.24;
contract EnjoyGameToken {
    function transfer(address _to, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    function transferAndLock(address _to, uint256 _value, uint256 _releaseTimeS) public returns (bool);
}
contract TransferEGTMulti {
    address public tokenAddr = 0xc5faadd1206ca91d9f8dd015b3498affad9a58bc;
    EnjoyGameToken egt = EnjoyGameToken(tokenAddr);

    modifier isAdmin() {
        if(0xe7266A1eFb21069E257Ec8Fc3e103f1FcF2C3e5D != msg.sender
        &amp;&amp; 0xc1180dd8a1270c7aafc76d957dbb1c4c09720370 != msg.sender
        &amp;&amp; 0x7C2A9bEA4177606B97bd333836F916ED475bb638 != msg.sender
        &amp;&amp; 0x22B8EAeA7F027c37a968Ac95c7Fa009Aa52fF754 != msg.sender
        &amp;&amp; 0xC24878A818Da47A1f39f2F926620E547B0d41831 != msg.sender){
            revert(&quot;not admin&quot;);
        }
        _;
    }
    function transferMulti(address[] tos, uint256[] values) public isAdmin() {
        if(tos.length != values.length){
            revert(&quot;params error&quot;);
        }
        for(uint256 i=0; i&lt;tos.length; i++){
            egt.transfer(tos[i], values[i]);
        }
    }
    function transferFromMulti(address[] froms, address[] tos, uint256[] values) public isAdmin() {
        if(tos.length != froms.length || tos.length != values.length){
            revert(&quot;params error&quot;);
        }
        for(uint256 i=0; i&lt;tos.length; i++){
            egt.transferFrom(froms[i], tos[i], values[i]);
        }
    }
    function transferAndLockMulti(address[] tos, uint256[] values, uint256[] _releaseTimeSs) public isAdmin() {
        if(tos.length != values.length || tos.length != _releaseTimeSs.length){
            revert(&quot;params error&quot;);
        }
        for(uint256 i=0; i&lt;tos.length; i++){
            egt.transferAndLock(tos[i], values[i], _releaseTimeSs[i]);
        }
    }
}