pragma solidity ^0.4.18;

library SafeMath {
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b &gt; 0); // Solidity automatically throws when dividing by 0
		uint256 c = a / b;
		assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b &lt;= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		assert(c &gt;= a);
		return c;
	}
}

contract Ownable {
	address public owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	function transferOwnership(address newOwner) public onlyOwner {
		require(newOwner != address(0));
		OwnershipTransferred(owner, newOwner);
		owner = newOwner;
	}
}

contract ERC20 {
	uint public totalSupply;
	function balanceOf(address _owner) public constant returns (uint balance);
	function transfer(address _to,uint _value) public returns (bool success);
	function transferFrom(address _from,address _to,uint _value) public returns (bool success);
	function approve(address _spender,uint _value) public returns (bool success);
	function allownce(address _owner,address _spender) public constant returns (uint remaining);
	event Transfer(address indexed _from,address indexed _to,uint _value);
	event Approval(address indexed _owner,address indexed _spender,uint _value);
}

contract Option is ERC20,Ownable {
	using SafeMath for uint8;
	using SafeMath for uint256;
	
	event Burn(address indexed _from,uint256 _value);
	event Increase(address indexed _to, uint256 _value);
	event SetItemOption(address _to, uint256 _amount, uint256 _releaseTime);
	
	struct ItemOption {
		uint256 releaseAmount;
		uint256 releaseTime;
	}

	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public initial_supply;
	mapping (address =&gt; uint256) public balances;
	mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
	mapping (address =&gt; ItemOption[]) toMapOption;
	
	function Option (
		string Name,
		string Symbol,
		uint8 Decimals,
		uint256 initialSupply,
		address initOwner
	) public {
		require(initOwner != address(0));
		owner = initOwner;
		name = Name;
		symbol = Symbol;
		decimals = Decimals;
		initial_supply = initialSupply * (10 ** uint256(decimals));
		totalSupply = initial_supply;
		balances[initOwner] = totalSupply;
	}
	
	function itemBalance(address _to) public constant returns (uint amount) {
		require(_to != address(0));
		amount = 0;
		uint256 nowtime = now;
		for(uint256 i = 0; i &lt; toMapOption[_to].length; i++) {
			require(toMapOption[_to][i].releaseAmount &gt; 0);
			if(nowtime &gt;= toMapOption[_to][i].releaseTime) {
				amount = amount.add(toMapOption[_to][i].releaseAmount);
			}
		}
		return amount;
	}
	
	function balanceOf(address _owner) public constant returns (uint balance) {
		return balances[_owner].add(itemBalance(_owner));
	}
	
	function itemTransfer(address _to) public returns (bool success) {
		require(_to != address(0));
		uint256 nowtime = now;
		for(uint256 i = 0; i &lt; toMapOption[_to].length; i++) {
			require(toMapOption[_to][i].releaseAmount &gt;= 0);
			if(nowtime &gt;= toMapOption[_to][i].releaseTime &amp;&amp; balances[_to] + toMapOption[_to][i].releaseAmount &gt; balances[_to]) {
				balances[_to] = balances[_to].add(toMapOption[_to][i].releaseAmount);
				toMapOption[_to][i].releaseAmount = 0;
			}
		}
		return true;
	}
	
	function transfer(address _to,uint _value) public returns (bool success) {
		itemTransfer(_to);
		if(balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]){
			balances[msg.sender] = balances[msg.sender].sub(_value);
			balances[_to] = balances[_to].add(_value);
			Transfer(msg.sender,_to,_value);
			return true;
		} else {
			return false;
		}
	}

	function transferFrom(address _from,address _to,uint _value) public returns (bool success) {
		itemTransfer(_from);
		if(balances[_from] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
			if(_from != msg.sender) {
				require(allowed[_from][msg.sender] &gt; _value);
				allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
			}
			balances[_from] = balances[_from].sub(_value);
			balances[_to] = balances[_to].add(_value);
			Transfer(_from,_to,_value);
			return true;
		} else {
			return false;
		}
	}

	function approve(address _spender, uint _value) public returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender,_spender,_value);
		return true;
	}
	
	function allownce(address _owner,address _spender) public constant returns (uint remaining) {
		return allowed[_owner][_spender];
	}
	
	function burn(uint256 _value) public returns (bool success) {
		require(balances[msg.sender] &gt;= _value);
		balances[msg.sender] = balances[msg.sender].sub(_value);
		totalSupply = totalSupply.sub(_value);
		Burn(msg.sender,_value);
		return true;
	}

	function increase(uint256 _value) public onlyOwner returns (bool success) {
		if(balances[msg.sender] + _value &gt; balances[msg.sender]) {
			totalSupply = totalSupply.add(_value);
			balances[msg.sender] = balances[msg.sender].add(_value);
			Increase(msg.sender, _value);
			return true;
		}
	}

	function setItemOption(address _to, uint256 _amount, uint256 _releaseTime) public returns (bool success) {
		require(_to != address(0));
		uint256 nowtime = now;
		if(_amount &gt; 0 &amp;&amp; balances[msg.sender].sub(_amount) &gt;= 0 &amp;&amp; balances[_to].add(_amount) &gt; balances[_to]) {
			balances[msg.sender] = balances[msg.sender].sub(_amount);
			//Transfer(msg.sender, to, _amount);
			toMapOption[_to].push(ItemOption(_amount, _releaseTime));
			SetItemOption(_to, _amount, _releaseTime);
			return true;
		}
		return false;
	}
	
	function setItemOptions(address _to, uint256 _amount, uint256 _startTime, uint8 _count) public returns (bool success) {
		require(_to != address(0));
		require(_amount &gt; 0);
		require(_count &gt; 0);
		uint256 releaseTime = _startTime;
		for(uint8 i = 0; i &lt; _count; i++) {
			releaseTime = releaseTime.add(1 years);
			setItemOption(_to, _amount, releaseTime);
		}
		return true;
	}
}