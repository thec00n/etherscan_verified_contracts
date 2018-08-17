// sendlimiter
// limit funds held on a contract
// @authors:
// Cody Burns &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="4b2f24253f3b2a2522280b28242f323c293e39253865282426">[email&#160;protected]</a>&gt;
// license: Apache 2.0
// version:

pragma solidity ^0.4.19;

// Intended use:  
// cross deploy to limit funds on a chin identifier
// Status: functional
// still needs:
// submit pr and issues to https://github.com/realcodywburns/
//version 0.1.0


contract sendlimiter{
 function () public payable {
     require(this.balance + msg.value &lt; 100000000);}
}