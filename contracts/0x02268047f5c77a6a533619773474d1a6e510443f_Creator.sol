contract Creator {
    function newContract(bytes data) public returns (address) {
        address theNewContract;
        uint s = data.length;

        assembly {
            calldatacopy(mload(0x40), 68, s)
            theNewContract := create(callvalue, mload(0x40), s)
        }

        return theNewContract;
    }
}