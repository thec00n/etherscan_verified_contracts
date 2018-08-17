pragma solidity ^0.4.23;

contract TokenReclaim{
    mapping (address=&gt;string) internal _ethToSphtx;
    mapping (string =&gt;string) internal _accountToPubKey;
    event AccountRegister (address ethAccount, string sphtxAccount, string pubKey);

    function register(string name, string pubKey) public{
        require(bytes(name).length &gt;= 3 &amp;&amp; bytes(name).length &lt;= 16);
        bytes memory b = bytes(name);
        require( (b[0] &gt;=&#39;a&#39; &amp;&amp; b[0] &lt;=&#39;z&#39;) || (b[0] &gt;=&#39;0&#39; &amp;&amp; b[0] &lt;= &#39;9&#39;));
        for(uint i=1;i&lt; bytes(name).length; i++){
            require( (b[i] &gt;=&#39;a&#39; &amp;&amp; b[i] &lt;=&#39;z&#39;) || (b[i] &gt;=&#39;0&#39; &amp;&amp; b[i] &lt;= &#39;9&#39;) || b[i] == &#39;-&#39; || b[i] ==&#39;.&#39;  );
        }
        require(bytes(pubKey).length &lt;= 64 &amp;&amp; bytes(pubKey).length &gt;= 50 );

        require(bytes(_ethToSphtx[msg.sender]).length == 0 || keccak256(bytes((_ethToSphtx[msg.sender]))) ==  keccak256(bytes(name)));//check that the address is not yet registered;

        require(bytes(_accountToPubKey[name]).length == 0 || keccak256(bytes((_ethToSphtx[msg.sender]))) ==  keccak256(bytes(name))); //check that the name is not yet used
        _accountToPubKey[name] = pubKey;
        _ethToSphtx[msg.sender] = name;
        emit AccountRegister(msg.sender, name, pubKey);
    }

    function account(address addr) constant public returns (string){
        return _ethToSphtx[addr];
    }

    function keys(address addr) constant public returns (string){
        return _accountToPubKey[_ethToSphtx[addr]];
    }

    function nameAvailable(string name) constant public returns (bool){
        if( bytes(_accountToPubKey[name]).length != 0 )
           return false;
        if(bytes(name).length &lt; 3 &amp;&amp; bytes(name).length &gt; 16)
           return false;
        bytes memory b = bytes(name);
        if( (b[0] &lt; &#39;a&#39; || b[0] &gt; &#39;z&#39;) &amp;&amp; ( b[0] &lt; &#39;0&#39; || b[0] &gt; &#39;9&#39; ) )
           return false;
        for(uint i=1;i&lt; bytes(name).length; i++)
           if( (b[0] &lt; &#39;a&#39; || b[0] &gt; &#39;z&#39;) &amp;&amp; ( b[0] &lt; &#39;0&#39; || b[0] &gt; &#39;9&#39; ) &amp;&amp; b[i] != &#39;-&#39; &amp;&amp; b[i] != &#39;.&#39; )
              return false;
        return true;
    }


}