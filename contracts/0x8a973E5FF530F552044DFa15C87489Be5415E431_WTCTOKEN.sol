pragma solidity ^0.4.11;

contract WTCTOKEN {
    /* variables */
    string public standard = &#39;WTCTOKEN&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function WTCTOKEN() {

         initialSupply = 100000000000000;
         name =&quot;WTCTOKEN&quot;;
        decimals = 6;
         symbol = &quot;WTCT&quot;;
        
        balanceOf[msg.sender] = initialSupply;             
        totalSupply = initialSupply;                         
                                   
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;           
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw; 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                            
      
    }

   

    

   

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}