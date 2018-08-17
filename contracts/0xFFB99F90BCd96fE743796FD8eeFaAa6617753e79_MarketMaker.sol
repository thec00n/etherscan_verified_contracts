pragma solidity ^0.4.11;

	contract MarketMaker {

	string public name;
	string public symbol;
	uint256 public decimals;
	
	uint256 public totalSupply;

	mapping (address =&gt; uint256) public balanceOf;
	mapping (address =&gt; mapping(address=&gt;uint256)) public allowance;

	event Transfer(address from, address to, uint256 value);
	event Approval(address from, address to, uint256 value);

	function MarketMaker(){
		
		decimals = 0;
		totalSupply = 1000000;

		balanceOf[msg.sender] = totalSupply;
		name = &quot;MarketMaker&quot;;
		symbol = &quot;MMC2&quot;;

	}




	function _transfer(address _from, address _to, uint256 _value) internal {
		require(_to != 0x0);
		require(balanceOf[_from] &gt;= _value);
		require(balanceOf[_to] + _value &gt;= balanceOf[_to]);

		balanceOf[_to] += _value;
		balanceOf[_from] -= _value;

		Transfer(_from, _to, _value);	

	}

	function transfer(address _to, uint256 _value) public {
		_transfer(msg.sender, _to, _value);

	}
	
	function transferFrom(address _from, address _to, uint256 _value) public {
		require(_value &lt;= allowance[_from] [_to]);
		allowance[_from] [_to] -= _value;
		_transfer(_from, _to, _value);
	}
	
	function approve(address _to, uint256 _value){
		allowance [msg.sender] [_to] = _value;
		Approval(msg.sender, _to, _value);
	}
}