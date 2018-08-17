pragma solidity ^0.4.18;

contract TopListICOToken {
    uint256 public totalSupply;
    mapping (address =&gt; uint256) public balances;
    address public owner;    
	
	event Transfer(address indexed from, address indexed to, uint256 value);

	string public name = &quot;Gems Protocol&quot;;              
    uint8 public decimals = 18;        
    string public symbol = &quot;GEM&quot;;
	
    function TopListICOToken() public {		
        totalSupply = 1000000000 * 10**uint256(decimals);
        balances[msg.sender] = totalSupply;
		owner = msg.sender;
		Transfer(0x0, owner, totalSupply);
    }	
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
        
    function changeToken(string cName, string cSymbol) onlyOwner public {
        name = cName;
        symbol = cSymbol;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[msg.sender]);
		balances[msg.sender] -= _value;
        balances[_to] += _value;
		Transfer(msg.sender, _to, _value);
        return true;
    }
	
	function withdrawEther(uint amount) onlyOwner public {
		owner.transfer(amount);
	}
	
	function buy() payable public {
	    balances[msg.sender] += msg.value * 1000 * 10**uint256(decimals);
	    Transfer(owner, msg.sender, msg.value * 1000 * 10**uint256(decimals));
    }	
}