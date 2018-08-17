library SafeMath {
    function add(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c &gt;= a);
    }
    function sub(uint a, uint b) public pure returns (uint c) {
        require(b &lt;= a);
        c = a - b;
    }
    function mul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) public pure returns (uint c) {
        require(b &gt; 0);
        c = a / b;
    }
}