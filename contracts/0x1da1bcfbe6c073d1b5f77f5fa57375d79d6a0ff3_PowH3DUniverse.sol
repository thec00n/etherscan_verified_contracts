pragma solidity ^0.4.21;

/*                  PowH3D Universe Token
/   Send ETH to the Contract and receive ERC20 Token in exchange.
/
/      _____  __          ___    _ ____  _____  
/     |  __ \ \ \        / / |  | |___ \|  __ \ 
/     | |__) |_\ \  /\  / /| |__| | __) | |  | |
/     |  ___/ _ \ \/  \/ / |  __  ||__ &lt;| |  | |
/     | |  | (_) \  /\  /  | |  | |___) | |__| |
/     |_|   \___/ \/_ \/   |_|  |_|____/|_____/ 
/     | |  | |     (_)                          
/     | |  | |_ __  ___   _____ _ __ ___  ___   
/     | |  | | &#39;_ \| \ \ / / _ \ &#39;__/ __|/ _ \  
/     | |__| | | | | |\ V /  __/ |  \__ \  __/ 
/      \____/|_| |_|_| \_/ \___|_|  |___/\___|  
/                                           
/
/   Fan of PowH3D ? Don&#39;t miss out on Universe ERC20 Token!
*/


contract PowH3DUniverse {

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalContribution = 0;
    uint256 public totalBonusTokensIssued = 0;

    uint256 public totalSupply = 0;
    bool public purchasingAllowed = true;
    address owner = msg.sender;
    function name() constant returns (string) { return &quot;PowH3D Universe&quot;; }
    function symbol() constant returns (string) { return &quot;UNIV&quot;; }
    function decimals() constant returns (uint8) { return 18; }
    
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
        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
    }

    function() payable {
        if (!purchasingAllowed) { throw; }
        
        if (msg.value == 0) { return; }

        owner.transfer(msg.value);
        totalContribution += msg.value;

        uint256 tokensIssued = (msg.value * 100);

        if (msg.value &gt;= 10 finney) {
            tokensIssued += totalContribution;

            bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
            if (bonusHash[0] == 0) {
                uint8 bonusMultiplier =
                    ((bonusHash[1] &amp; 0x01 != 0) ? 1 : 0) + ((bonusHash[1] &amp; 0x02 != 0) ? 1 : 0) +
                    ((bonusHash[1] &amp; 0x04 != 0) ? 1 : 0) + ((bonusHash[1] &amp; 0x08 != 0) ? 1 : 0) +
                    ((bonusHash[1] &amp; 0x10 != 0) ? 1 : 0) + ((bonusHash[1] &amp; 0x20 != 0) ? 1 : 0) +
                    ((bonusHash[1] &amp; 0x40 != 0) ? 1 : 0) + ((bonusHash[1] &amp; 0x80 != 0) ? 1 : 0);
                
                uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
                tokensIssued += bonusTokensIssued;

                totalBonusTokensIssued += bonusTokensIssued;
            }
        }

        totalSupply += tokensIssued;
        balances[msg.sender] += tokensIssued;
        
        Transfer(address(this), msg.sender, tokensIssued);
    }
}
contract ForeignToken {
    function balanceOf(address _owner) constant returns (uint256);
    function transfer(address _to, uint256 _value) returns (bool);
}