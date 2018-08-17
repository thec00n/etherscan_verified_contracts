pragma solidity ^0.4.13;

library WyvernAtomicizer {

    function atomicize (address[] addrs, uint[] values, uint[] calldataLengths, bytes calldatas)
        public
    {
        require(addrs.length == values.length &amp;&amp; addrs.length == calldataLengths.length);

        uint j = 0;
        for (uint i = 0; i &lt; addrs.length; i++) {
            bytes memory calldata = new bytes(calldataLengths[i]);
            for (uint k = 0; k &lt; calldataLengths[i]; k++) {
                calldata[k] = calldatas[j];
                j++;
            }
            require(addrs[i].call.value(values[i])(calldata));
        }
    }

}