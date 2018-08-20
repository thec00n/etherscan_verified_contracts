pragma solidity ^0.4.6;
contract BalanceReader {
    BalanceHolder public presale;

	function BalanceReader(){
	    presale = BalanceHolder(0xe3c61a3bff7cb03ddd422258006fddd5ba1ed0fe);
	}
	
	function attach(BalanceHolder _presale) public {
	    presale = _presale;
	}
	
	function balance(address addr) public constant returns (uint) {
		return presale.balances(addr);
	}
}

contract BalanceHolder {
    function balances(address) returns (uint);
}