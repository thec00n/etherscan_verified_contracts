contract I {
    function transfer(address to, uint256 val) public returns (bool);
    function balanceOf(address who) constant public returns (uint256);
}

contract GenTokenAddress {
    function GenTokenAddress(address token, address to) {
        I(token).transfer(to, I(token).balanceOf(address(this)));
    }
}