pragma solidity ^0.4.17;

// ----------------------------------------------------------------------------
// FIXED ERCX token contract
//
// Symbol      : ERCX
// Name        : Edel Rosten Coin
// Total supply: 122,000,000
// Decimals    : 18

// ----------------------------------------------------------------------------
// Safe math
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c &gt;= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b &lt;= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b &gt; 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERCX Token Standard #20 Interface
// ----------------------------------------------------------------------------
contract ERCX20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// ERCX20 Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------
contract EdelRostenCoin is ERCX20Interface {
    
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    address public owner;

    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function EdelRostenCoin() public {
        symbol = &quot;ERCX&quot;;
        name = &quot;Edel Rosten Coin&quot;;
        decimals = 18;
        _totalSupply = 122000000 * 10**uint(decimals);
        owner = 0xDeE7D782Fa2645070e3c15CabF8324A0ccceAC78;
        balances[owner] = _totalSupply;
        Transfer(address(0), owner, _totalSupply);
    }
    
    function() public payable {
        revert();
    }
    
    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner&#39;s account to `to` account
    // - Owner&#39;s account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        if(balances[msg.sender] &gt;= tokens &amp;&amp; tokens &gt; 0 &amp;&amp; to!=address(0)) {
            balances[msg.sender] = balances[msg.sender].sub(tokens);
            balances[to] = balances[to].add(tokens);
            Transfer(msg.sender, to, tokens);
            return true;
        } else { return false; }
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner&#39;s account
    //
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        if(tokens &gt; 0 &amp;&amp; spender != address(0)) {
            allowed[msg.sender][spender] = tokens;
            Approval(msg.sender, spender, tokens);
            return true;
        } else { return false; }
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        if (balances[from] &gt;= tokens &amp;&amp; allowed[from][msg.sender] &gt;= tokens &amp;&amp; tokens &gt; 0) {
            balances[from] = balances[from].sub(tokens);
            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
            balances[to] = balances[to].add(tokens);
            Transfer(from, to, tokens);
            return true;
        } else { return false; }
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender&#39;s account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

}