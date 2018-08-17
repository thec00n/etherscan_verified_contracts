pragma solidity ^0.4.18;
contract EtherealFoundationOwned {
	address private Owner;
    
	function IsOwner(address addr) view public returns(bool)
	{
	    return Owner == addr;
	}
	
	function TransferOwner(address newOwner) public onlyOwner
	{
	    Owner = newOwner;
	}
	
	function EtherealFoundationOwned() public
	{
	    Owner = msg.sender;
	}
	
	function Terminate() public onlyOwner
	{
	    selfdestruct(Owner);
	}
	
	modifier onlyOwner(){
        require(msg.sender == Owner);
        _;
    }
}

contract EtherealTipJar  is EtherealFoundationOwned{
    string public constant CONTRACT_NAME = &quot;EtherealTipJar&quot;;
    string public constant CONTRACT_VERSION = &quot;A&quot;;
    string public constant QUOTE = &quot;&#39;The universe never did make sense; I suspect it was built on government contract.&#39; -Robert A. Heinlein&quot;;
    
    
    event RecievedTip(address indexed from, uint256 value);
	function () payable public {
		RecievedTip(msg.sender, msg.value);		
	}
	
	event TransferedEth(address indexed to, uint256 value);
	function TransferEth(address to, uint256 value) public onlyOwner{
	    require(this.balance &gt;= value);
	    
        if(value &gt; 0)
		{
			to.transfer(value);
			TransferedEth(to, value);
		}   
	}
}