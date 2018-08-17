// sendblocker
// prevent any funds from incoming
// @authors:
// Cody Burns &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="187c77766c687976717b587b777c616f7a6d6a766b367b7775">[email&#160;protected]</a>&gt;
// license: Apache 2.0
// version:

pragma solidity ^0.4.19;

// Intended use:  
// cross deploy to prevent unintended chain getting funds
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/
//version 0.1.0

contract sendblocker{
 function () public {assert(0&gt;0);}
    
}