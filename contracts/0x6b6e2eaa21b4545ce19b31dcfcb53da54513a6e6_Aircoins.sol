pragma solidity ^0.4.2;

contract token { function transfer(address receiver, uint amount){  } }

contract Aircoins{
	struct Coin{
		address addr;
	}
	address owner;
	function Aircoins(){
		owner = msg.sender;
	}

	modifier onlyOwner() {
		if (msg.sender != owner) throw;
		_;
	}

	function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }



	mapping (address =&gt; Coin) public coins;
	mapping (address =&gt; bool) public coinsAdded;
	mapping (address =&gt; bool) public userAddressAdded;
	mapping (address =&gt; string) public messages;


	address[] public coinsAddresses;
	address[] public userAddresses;

	function submitCoin(address _addr, string _msg){
		if(coinsAdded[_addr]) throw;
		Coin memory newCoin;
		newCoin.addr = _addr;
		coins[_addr] = newCoin;
		messages[_addr] = _msg;
		coinsAdded[_addr] = true;
		coinsAddresses.push(_addr);
	}

	function registerUser(address _addr){
		if(userAddressAdded[_addr]) return;
		userAddresses.push(_addr);
		userAddressAdded[_addr] = true;
	}

	function getAllCoins() constant returns (address[]){
		return coinsAddresses;
	}

	function getAllUsers() constant returns (address[]){
		return userAddresses;
	}

	function userCount() constant returns (uint){
		return userAddresses.length;
	}

	function coinsCount () constant returns(uint) {
		return coinsAddresses.length;
	}
	

	function registerUsers(address[] _users) onlyOwner {
		for(uint i = 0; i &lt; _users.length; ++i){
			registerUser(_users[i]);
		}
	}

	function withdrawCoins(address _coinAddr, uint _amount) onlyOwner {
		token tokenReward = token(_coinAddr);
		tokenReward.transfer(msg.sender,_amount);
	}

	function distributeCoins(
		address _coinAddress,
		uint _amountGivenToEachUser,
		uint startIndex,
		uint endIndex) onlyOwner {
		require(endIndex &gt; startIndex);
		token tokenReward = token(_coinAddress);
		for(uint i = startIndex; i &lt; endIndex;++i){
			tokenReward.transfer(userAddresses[i],_amountGivenToEachUser);
		}
	}
}