pragma solidity ^0.4.18;

contract ForeignToken {
    function balanceOf(address _owner) constant returns (uint256);
    function transfer(address _to, uint256 _value) returns (bool);
}

contract XmasToken {
    address owner = msg.sender;

    bool public purchasingAllowed = false;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalContribution = 0;

    uint256 public totalSupply = 0;
    uint256 public hardCap = 1000000;
    
    function name() constant returns (string) { return &quot;XmasToken Limited Edition&quot;; }
    function symbol() constant returns (string) { return &quot;XMAS&quot;; }
    function decimals() constant returns (uint8) { return 0; }

    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }

    function transfer(address _to, uint256 _value) returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length &lt; (2 * 32) + 4) { throw; }

        if (_value == 0) { return false; }

        uint256 fromBalance = balances[msg.sender];

        bool sufficientFunds = fromBalance &gt;= _value;
        bool overflowed = balances[_to] + _value &lt; balances[_to];

        if (sufficientFunds &amp;&amp; !overflowed) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;

            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length &lt; (3 * 32) + 4) { throw; }

        if (_value == 0) { return false; }

        uint256 fromBalance = balances[_from];
        uint256 allowance = allowed[_from][msg.sender];

        bool sufficientFunds = fromBalance &gt;= _value;
        bool sufficientAllowance = allowance &gt;= _value;
        bool overflowed = balances[_to] + _value &gt; balances[_to];

        if (sufficientFunds &amp;&amp; sufficientAllowance &amp;&amp; !overflowed) {
            balances[_to] += _value;
            balances[_from] -= _value;

            allowed[_from][msg.sender] -= _value;

            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 &amp;&amp; allowed[msg.sender][_spender] != 0) { return false; }

        allowed[msg.sender][_spender] = _value;

        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256) {
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function enablePurchasing() {
        if (msg.sender != owner) { throw; }

        purchasingAllowed = true;
    }

    function disablePurchasing() {
        if (msg.sender != owner) { throw; }

        purchasingAllowed = false;
    }

    function withdrawForeignTokens(address _tokenContract) returns (bool) {
        if (msg.sender != owner) { throw; }

        ForeignToken token = ForeignToken(_tokenContract);

        uint256 amount = token.balanceOf(address(this));
        return token.transfer(owner, amount);
    }

    function getStats() constant returns (uint256, uint256, uint256, bool) {
        return (totalContribution, totalSupply, hardCap, purchasingAllowed);
    }

    function() payable {
        if (!purchasingAllowed) { throw; }

        if (msg.value == 0) { return; }

        uint256 tokensIssued = (msg.value / 10000000000000000 + 2 * (msg.value / uint256(100000000000000000)) + 5 * (msg.value / uint256(1000000000000000000)));

        if (totalSupply + tokensIssued &gt; hardCap || tokensIssued == 0) {return; }
        
        owner.transfer(msg.value);
        totalContribution += msg.value;
        
        totalSupply += tokensIssued;
        
        balances[msg.sender] += tokensIssued;

        Transfer(address(this), msg.sender, tokensIssued);
    }
}