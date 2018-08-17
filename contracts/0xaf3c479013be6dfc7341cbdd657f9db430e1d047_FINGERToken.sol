contract FINGERToken {
    string public standard = &#39;FINGER 2.0&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    function FINGERToken() {

         initialSupply = 2100000000000000;
         name =&quot;FINGERToken&quot;;
         decimals = 8;
         symbol = &quot;FINGER&quot;;
        
        balanceOf[msg.sender] = initialSupply;
        totalSupply = initialSupply;
                                   
    }

    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
      
    }

    function () {
        throw;
    }
}