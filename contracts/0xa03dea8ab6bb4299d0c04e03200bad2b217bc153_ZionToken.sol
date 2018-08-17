pragma solidity ^0.4.20;


contract ERC20 {
    uint public totalSupply;
    function balanceOf(address who) public constant returns (uint);
    function allowance(address owner, address spender) public constant returns (uint);
    function transfer(address to, uint value) public returns (bool ok);
    function transferFrom(address from, address to, uint value) public returns (bool ok);
    function approve(address spender, uint value) public returns (bool ok);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract SafeMath {
    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        assert1(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint a, uint b) internal pure returns (uint) {
        assert1(b &gt; 0);
        uint c = a / b;
        assert1(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        assert1(b &lt;= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert1(c &gt;= a &amp;&amp; c &gt;= b);
        return c;
    }

    function assert1(bool assertion) internal pure {
        require(assertion);
    }
}

contract ZionToken is SafeMath, ERC20 {
    string public constant name = &quot;Zion - The Next Generation Communication Paradigm&quot;;
    string public constant symbol = &quot;Zion&quot;;
    uint256 public constant decimals = 18;  

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    function ZionToken() public {
        totalSupply = 5000000000 * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address who) public constant returns (uint) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        uint256 senderBalance = balances[msg.sender];
        if (senderBalance &gt;= value &amp;&amp; value &gt; 0) {
            senderBalance = safeSub(senderBalance, value);
            balances[msg.sender] = senderBalance;
            balances[to] = safeAdd(balances[to], value);
            emit Transfer(msg.sender, to, value);
            return true;
        } else {
            revert();
        }
    }


    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        if (balances[from] &gt;= value &amp;&amp;
        allowed[from][msg.sender] &gt;= value &amp;&amp;
        safeAdd(balances[to], value) &gt; balances[to])
        {
            balances[to] = safeAdd(balances[to], value);
            balances[from] = safeSub(balances[from], value);
            allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
            emit Transfer(from, to, value);
            return true;
        } else {
            revert();
        }
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }


    function allowance(address owner, address spender) public constant returns (uint) {
        uint allow = allowed[owner][spender];
        return allow;
    }
}