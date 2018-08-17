contract Daric {
    /* Public variables of the token */
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function Daric() {

         initialSupply = 110000000000000000000000000;
         name =&quot;Daric Coins&quot;;
        decimals = 18;
         symbol = &quot;Daric&quot;;
        
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
                                   
    }


     /* Send coins */
    function transfer(address _to, uint256 _value) {
        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        /* Check if sender has balance and for overflows */
        require(balanceOf[msg.sender] &gt;= _value &amp;&amp; balanceOf[_to] + _value &gt;= balanceOf[_to]);

        /* Add and subtract new balances */
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }

}