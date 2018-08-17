contract check {
    function add(address _add, uint _req) {
        _add.callcode(bytes4(keccak256(&quot;changeRequirement(uint256)&quot;)), _req);
    }
}