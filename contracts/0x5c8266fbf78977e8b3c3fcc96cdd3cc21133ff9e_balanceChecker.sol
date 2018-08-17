contract ERC20 {
    mapping(address =&gt; uint) public balanceOf;
}


contract balanceChecker {
    function checkBals(ERC20 _location, address[] addrs) public view returns(uint[]) {
        uint[] memory bals = new uint[](addrs.length);
        for (uint i=0; i &lt; addrs.length; i++) {
            bals[i] = _location.balanceOf(addrs[i]);
        }
        return bals;
    }
}