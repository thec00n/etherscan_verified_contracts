pragma solidity ^0.4.18;


contract DraconeumToken {
    
    string public name = &quot;Draconeum&quot;;
    string public symbol = &quot;DRCM&quot;;
    uint8 public decimals = 8;
    
    uint256 public totalSupply = 14000000;
    uint256 public initialSupply = 14000000;

    
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function DraconeumToken
    (string tokenName, string tokenSymbol) 
        public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  
        balanceOf[msg.sender] = totalSupply;                
        name = tokenName =&quot;Draconeum&quot;;                                   
        symbol = tokenSymbol =&quot;DRCM&quot;;                               
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        require(balanceOf[_from] &gt;= _value);
        require(balanceOf[_to] + _value &gt; balanceOf[_to]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
     
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    
}