pragma solidity ^0.4.21;


library StringUtils {
    // Tests for uppercase characters in a given string
    function allLower(string memory _string) internal pure returns (bool) {
        bytes memory bytesString = bytes(_string);
        for (uint i = 0; i &lt; bytesString.length; i++) {
            if ((bytesString[i] &gt;= 65) &amp;&amp; (bytesString[i] &lt;= 90)) {  // Uppercase characters
                return false;
            }
        }
        return true;
    }
}