pragma solidity ^0.4.8;

contract testingToken {
    /* Public variables of the token */
    string public standard = &quot;Token 0.1&quot;;
    string public name = &quot;Testing Token&quot;;
    string public symbol = &quot;TT&quot;;
    uint8 public decimals = 2;
    uint256 public totalSupply = 10000;
    
    /*other vars*/
	mapping (address =&gt; uint256) public balanceOf;
	mapping (address =&gt; uint256) public weiWantedOf;
	mapping (address =&gt; uint256) public tokensOfferedOf;
	mapping (address =&gt; bool) public tradeActive;
	address public bank;
	uint256 public ethTaxRate = 10;
	uint256 public tokenTaxRate = 5;
	function testingToken() {
		bank = msg.sender;
		balanceOf[msg.sender] = 100000;
	}
	
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	
	function balanceOf(address _owner) constant returns (uint256 balance) {
	    return balanceOf[_owner];
	}
	
	function transfer(address _to, uint256 _value) returns (bool success) { //give tokens to someone
		if (balanceOf[msg.sender]&lt;_value) return false;
		if (balanceOf[_to]+_value&lt;balanceOf[_to]) return false;
		if (_value&lt;0) return false;
		balanceOf[msg.sender] -= _value;
		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
		balanceOf[bank] += (_value*tokenTaxRate)/100;
		//now check for rounding down which would result in permanent loss of coins
		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
		Transfer(msg.sender,_to,_value);
		return true;
	}
	
	mapping (address =&gt; mapping (address=&gt;uint256)) approvalList;
	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
		if (balanceOf[_from]&lt;_value) return false;
		if (balanceOf[_to]+_value&lt;balanceOf[_to]) return false;
		if (_value&lt;0) return false;
		if (approvalList[_from][msg.sender]&lt;_value) return false;
		approvalList[_from][msg.sender]-=_value;
		balanceOf[_from] -= _value;
		balanceOf[_to] += (_value*(100-tokenTaxRate))/100;
		balanceOf[bank] += (_value*tokenTaxRate)/100;
		//now check for rounding down which would result in permanent loss of coins
		if ((_value*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
		Transfer(_from,_to,_value);
		return true;
	}
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	function approve(address _spender, uint256 _value) returns (bool success) {
	    approvalList[msg.sender][_spender]=_value;
	    Approval(msg.sender,_spender,_value);
	    return true;
	}
	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
	    return approvalList[_owner][_spender];
	}
	
	function offerTrade(uint256 _weiWanted, uint256 _tokensOffered) { //offer the amt of ether you want and the amt of tokens youd give
	    weiWantedOf[msg.sender] = _weiWanted;
	    tokensOfferedOf[msg.sender] = _tokensOffered;
	    tradeActive[msg.sender] = true;
	}
	function agreeToTrade(address _from) payable { //choose a trade to agree to and execute it
	    if (!tradeActive[_from]) throw;
	    if (weiWantedOf[_from]!=msg.value) throw;
	    if (balanceOf[_from]&lt;tokensOfferedOf[_from]) throw;
	    if (!_from.send((msg.value*(100-ethTaxRate))/100)) throw;
	    balanceOf[_from] -= tokensOfferedOf[_from];
	    balanceOf[msg.sender] += (tokensOfferedOf[_from]*(100-tokenTaxRate))/100;
		balanceOf[bank] += (tokensOfferedOf[_from]*tokenTaxRate)/100;
		tradeActive[_from] = false;
		Transfer(_from,msg.sender,tokensOfferedOf[_from]);
		//now check for rounding down which would result in permanent loss of coins
		if ((tokensOfferedOf[_from]*tokenTaxRate)%100 != 0) balanceOf[bank]+=1;
	}
	
	modifier bankOnly {
		if (msg.sender != bank) throw;
		_;
	}
	
	function setTaxes(uint256 _ethTaxRate, uint256 _tokenTaxRate) bankOnly { //the bank can change the tax rates
		ethTaxRate = _ethTaxRate;
		tokenTaxRate = _tokenTaxRate;
	}
	function extractWei(uint256 _wei) bankOnly { //withdraw money from the contract
		if (!msg.sender.send(_wei)) throw;
	}
	function transferOwnership(address _bank) bankOnly { //change owner
		bank = _bank;
	}
	
	function () {
	    throw;
	}
}