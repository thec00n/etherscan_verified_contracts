contract COSHACNY {
    string public standard = &#39;CCNY 2.0&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public initialSupply;
    uint256 public totalSupply;

    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

  
    function COSHACNY() {

         initialSupply = 100000000000000;
         name =&quot;COSHACNY&quot;;
         decimals = 4;
         symbol = &quot;CCNY&quot;;
        
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