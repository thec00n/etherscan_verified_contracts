/*
Copyright 2018 DeDev Pte Ltd

Author : Chongsoo Chung (Jones Chung), CEO of DeDev in Seoul, South Korea
 */

pragma solidity ^0.4.20;

contract ERC20Interface {
	function totalSupply() constant returns (uint supply);
	function balanceOf(address _owner) constant returns (uint balance);
	function transfer(address _to, uint _value) returns (bool success);
	function transferFrom(address _from, address _to, uint _value) returns (bool success);
	function approve(address _spender, uint _value) returns (bool success);
	function allowance(address _owner, address _spender) constant returns (uint remaining);
	event Transfer(address indexed _from, address indexed _to, uint _value);
	event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract Love is ERC20Interface {
	// ERC20 basic variables
	string public constant symbol = &quot;LOVE&quot;;
	string public constant name = &quot;LoveToken&quot;;
	uint8 public constant decimals = 0;
	uint256 public constant _totalSupply = (10 ** 10);
	mapping (address =&gt; uint) public balances;
	mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;

	mapping (address =&gt; uint256) public tokenSaleAmount;
	uint256 public saleStartEpoch;
	uint256 public tokenSaleLeft = 7 * (10 ** 9);
	uint256 public tokenAirdropLeft = 3 * (10 ** 9);

	uint256 public constant tokenSaleLowerLimit = 10 finney;
	uint256 public constant tokenSaleUpperLimit = 1 ether;
	uint256 public constant tokenExchangeRate = (10 ** 8); // 100m LOVE for each ether
	uint256 public constant devReward = 18; // in percent

	address private constant saleDepositAddress = 0x6969696969696969696969696969696969696969;
	address private constant airdropDepositAddress = 0x7474747474747474747474747474747474747474;

	address public devAddress;
	address public ownerAddress;

// constructor
	function Love(address _ownerAddress, address _devAddress, uint256 _saleStartEpoch) public {
		require(_ownerAddress != 0);
		require(_devAddress != 0);
		require(_saleStartEpoch &gt; now);

		balances[saleDepositAddress] = tokenSaleLeft;
		balances[airdropDepositAddress] = tokenAirdropLeft;

		ownerAddress = _ownerAddress;
		devAddress = _devAddress;
		saleStartEpoch = _saleStartEpoch;
	}

	function sendAirdrop(address[] to, uint256[] value) public {
		require(msg.sender == ownerAddress);
		require(to.length == value.length);
		for(uint256 i = 0; i &lt; to.length; i++){
			if(tokenAirdropLeft &gt; value[i]){
				Transfer(airdropDepositAddress, to[i], value[i]);

				balances[to[i]] += value[i];
				balances[airdropDepositAddress] -= value[i];
				tokenAirdropLeft -= value[i];
			}
			else{
				Transfer(airdropDepositAddress, to[i], tokenAirdropLeft);

				balances[to[i]] += tokenAirdropLeft;
				balances[airdropDepositAddress] -= tokenAirdropLeft;
				tokenAirdropLeft = 0;
				break;
			}
		}
	}

	function buy() payable public {
		require(tokenSaleLeft &gt; 0);
		require(msg.value + tokenSaleAmount[msg.sender] &lt;= tokenSaleUpperLimit);
		require(msg.value &gt;= tokenSaleLowerLimit);
		require(now &gt;= saleStartEpoch);
		require(msg.value &gt;= 1 ether / tokenExchangeRate);

		if(msg.value * tokenExchangeRate / 1 ether &gt; tokenSaleLeft){
			Transfer(saleDepositAddress, msg.sender, tokenSaleLeft);

			uint256 changeAmount = msg.value - tokenSaleLeft * 1 ether / tokenExchangeRate;
			balances[msg.sender] += tokenSaleLeft;
			balances[saleDepositAddress] -= tokenSaleLeft;
			tokenSaleAmount[msg.sender] += msg.value - changeAmount;
			tokenSaleLeft = 0;
			msg.sender.transfer(changeAmount);

			ownerAddress.transfer((msg.value - changeAmount) * (100 - devReward) / 100);
			devAddress.transfer((msg.value - changeAmount) * devReward / 100);
		}
		else{
			Transfer(saleDepositAddress, msg.sender, msg.value * tokenExchangeRate / 1 ether);

			balances[msg.sender] += msg.value * tokenExchangeRate / 1 ether;
			balances[saleDepositAddress] -= msg.value * tokenExchangeRate / 1 ether;
			tokenSaleAmount[msg.sender] += msg.value;
			tokenSaleLeft -= msg.value * tokenExchangeRate / 1 ether;

			ownerAddress.transfer(msg.value * (100 - devReward) / 100);
			devAddress.transfer(msg.value * devReward / 100);
		}
	}

// fallback function : send request to donate
	function () payable public {
		buy();
	}


// ERC20 FUNCTIONS
	//get total tokens
	function totalSupply() constant returns (uint supply){
		return _totalSupply;
	}
	//get balance of user
	function balanceOf(address _owner) constant returns (uint balance){
		return balances[_owner];
	}
	//transfer tokens
	function transfer(address _to, uint _value) returns (bool success){
		if(balances[msg.sender] &lt; _value)
			return false;
		balances[msg.sender] -= _value;
		balances[_to] += _value;
		Transfer(msg.sender, _to, _value);
		return true;
	}
	//transfer tokens if you have been delegated a wallet
	function transferFrom(address _from, address _to, uint _value) returns (bool success){
		if(balances[_from] &gt;= _value
			&amp;&amp; allowed[_from][msg.sender] &gt;= _value
			&amp;&amp; _value &gt;= 0
			&amp;&amp; balances[_to] + _value &gt; balances[_to]){
			balances[_from] -= _value;
			allowed[_from][msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(_from, _to, _value);
			return true;
		}
		else{
			return false;
		}
	}
	//delegate your wallet to someone, usually to a smart contract
	function approve(address _spender, uint _value) returns (bool success){
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}
	//get allowance that you can spend, from delegated wallet
	function allowance(address _owner, address _spender) constant returns (uint remaining){
		return allowed[_owner][_spender];
	}
	
	function change_owner(address new_owner){
	    require(msg.sender == ownerAddress);
	    ownerAddress = new_owner;
	}
	function change_dev(address new_dev){
	    require(msg.sender == devAddress);
	    devAddress = new_dev;
	}
}