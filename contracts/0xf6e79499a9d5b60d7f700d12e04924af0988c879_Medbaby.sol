contract Medbaby {
  
    /* Public variables of the token */
    string public standard;
    string public name = &quot;Medbaby&quot;;
    string public symbol = &quot;MDBY&quot;;
    uint8 public decimals = 3;
    uint256 public initialSupply = 300000000000;
    uint256 public totalSupply = 200000000000;
    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function Medbaby() {

         initialSupply = 300000000000;
         name =&quot;Medbaby&quot;;
        decimals = 2;
         symbol = &quot;MDBY&quot;;
        
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
        totalSupply = initialSupply;                        // Update total supply
                                   
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;           // Check if the sender has enough
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw; // Check for overflows
        balanceOf[msg.sender] -= _value;                     // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
      
    }

   

    

   

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}