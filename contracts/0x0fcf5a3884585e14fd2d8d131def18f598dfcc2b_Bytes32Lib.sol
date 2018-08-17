/// @title Token Register Contract
/// @author Kongliang Zhong - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e08b8f8e878c89818e87a08c8f8f9092898e87ce8f9287">[email&#160;protected]</a>&gt;,
/// @author Daniel Wang - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="0165606f68646d416d6e6e7173686f662f6e7366">[email&#160;protected]</a>&gt;.
library Bytes32Lib {

    function xorReduce(
        bytes32[]   arr,
        uint        len
        )
        public
        constant
        returns (bytes32 res) {

        res = arr[0];
        for (uint i = 1; i &lt; len; i++) {
            res = _xor(res, arr[i]);
        }
    }

    function _xor(
        bytes32 bs1,
        bytes32 bs2
        )
        public
        constant
        returns (bytes32 res) {

        bytes memory temp = new bytes(32);
        for (uint i = 0; i &lt; 32; i++) {
            temp[i] = bs1[i] ^ bs2[i];
        }
        string memory str = string(temp);
        assembly {
            res := mload(add(str, 32))
        }
    }
}