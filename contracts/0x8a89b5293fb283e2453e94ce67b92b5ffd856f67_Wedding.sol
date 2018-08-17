pragma solidity ^0.4.24;

contract Wedding {
    string bride = &quot;Taja&quot;;
    string groom = &quot;Matej&quot;;
    string date = &quot;29th July 2017&quot;;
    
    function getWeddingData() returns (string) {
        return string(abi.encodePacked(bride, &quot; &amp; &quot;, groom, &quot;, happily married on &quot;, date, &quot;. :)&quot;));
    }
    
    function myWishes() returns (string) {
        return &quot;May today be the beginning of a long, happy life together!&quot;;
    }
}