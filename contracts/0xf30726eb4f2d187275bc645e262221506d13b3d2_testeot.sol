pragma solidity ^0.4.12;

contract testeot {
    
    // totalSupply = maximum 210000 Coins with 18 decimals;   
    uint256 public totalSupply = 210000000000000000000000;
    uint256 public availableSupply= 210000000000000000000000;
    uint256 public circulatingSupply = 0;  	
    uint8   public decimals = 18;
    //   
    string  public standard = &#39;ERC20 Token&#39;;
    string  public name = &#39;testeot&#39;;
    string  public symbol = &#39;testeot&#39;;            
    uint256 public crowdsalePrice = 100;                          	
    uint256 public crowdsaleClosed = 0;                 
    address public daoMultisig = msg.sender;
    address public owner = msg.sender;  

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;	
	
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);    
    
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
	
    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }
	
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }	
	
    function () payable {
        if (crowdsaleClosed &gt; 0) throw;		
        if (msg.value == 0) {
          throw;
        }		
        Transfer(msg.sender, daoMultisig, msg.value);		
        uint token = msg.value * crowdsalePrice;		
		availableSupply = totalSupply - circulatingSupply;
        if (token &gt; availableSupply) {
          throw;
        }		
        circulatingSupply += token;
        balances[msg.sender] += token;
    }
	
    function setPrice(uint256 newSellPrice) onlyOwner {
        crowdsalePrice = newSellPrice;
    }
	
    function stoppCrowdsale(uint256 newStoppSign) onlyOwner {
        crowdsaleClosed = newStoppSign;
    }		

    function setMultisigAddress(address newMultisig) onlyOwner {
        daoMultisig = newMultisig;
    }	
	
}