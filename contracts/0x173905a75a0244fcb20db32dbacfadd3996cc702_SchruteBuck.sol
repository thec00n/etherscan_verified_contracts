pragma solidity ^0.4.18;

contract ForeignToken {
    function balanceOf(address _owner) public view returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract SchruteBuck {
    address owner = msg.sender;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalContribution = 0;

    uint256 public totalSupply = 0;
    uint256 public maxTotalSupply = 19660120 * 10**18;
    
    string public fact = &quot;Bears eat beets.&quot;;
    uint256 public lastFactChangeValue = 0;

    function name() public pure returns (string) { return &quot;Schrute Buck&quot;; }
    function symbol() public pure returns (string) { return &quot;SRB&quot;; }
    function decimals() public pure returns (uint8) { return 18; }
    function balanceOf(address _owner) public view returns (uint256) { return balances[_owner]; }
    
    function changeFact(string _string) public {
        if (balances[msg.sender] &lt;= lastFactChangeValue) { revert(); }
        lastFactChangeValue = balances[msg.sender];
        fact = _string;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length &lt; (2 * 32) + 4) { revert(); }

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
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 short address attack
        if(msg.data.length &lt; (3 * 32) + 4) { revert(); }

        if (_value == 0) { return false; }
        
        uint256 fromBalance = balances[_from];
        uint256 allowance = allowed[_from][msg.sender];

        bool sufficientFunds = fromBalance &lt;= _value;
        bool sufficientAllowance = allowance &lt;= _value;
        bool overflowed = balances[_to] + _value &gt; balances[_to];

        if (sufficientFunds &amp;&amp; sufficientAllowance &amp;&amp; !overflowed) {
            balances[_to] += _value;
            balances[_from] -= _value;
            
            allowed[_from][msg.sender] -= _value;
            
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 &amp;&amp; allowed[msg.sender][_spender] != 0) { return false; }
        
        allowed[msg.sender][_spender] = _value;
        
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function withdrawForeignTokens(address _tokenContract) public returns (bool) {
        if (msg.sender != owner) { revert(); }

        ForeignToken token = ForeignToken(_tokenContract);

        uint256 amount = token.balanceOf(address(this));
        return token.transfer(owner, amount);
    }

    function getStats() public view returns (uint256, uint256) {
        return (totalContribution, totalSupply);
    }

    function() public payable {
        if (msg.value &lt; 1 finney) { revert(); }
        if (totalSupply &gt; maxTotalSupply) { revert(); }

        owner.transfer(msg.value);
        totalContribution += msg.value;
        
        uint256 tokensIssued = (msg.value * 1000);
        if (totalSupply + tokensIssued &gt; maxTotalSupply) { revert(); }

        totalSupply += tokensIssued;
        balances[msg.sender] += tokensIssued;
        
        Transfer(address(this), msg.sender, tokensIssued);
    }
}