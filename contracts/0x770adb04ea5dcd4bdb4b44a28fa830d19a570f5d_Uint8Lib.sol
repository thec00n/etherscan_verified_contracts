/// @title Token Register Contract
/// @author Kongliang Zhong - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b9d2d6d7ded5d0d8d7def9d5d6d6c9cbd0d7de97d6cbde">[email&#160;protected]</a>&gt;,
/// @author Daniel Wang - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="771316191e121b371b181807051e191059180510">[email&#160;protected]</a>&gt;.
library Uint8Lib {
    function xorReduce(
        uint8[] arr,
        uint    len
        )
        public
        constant
        returns (uint8 res) {

        res = arr[0];
        for (uint i = 1; i &lt; len; i++) {
           res ^= arr[i];
        }
    }
}