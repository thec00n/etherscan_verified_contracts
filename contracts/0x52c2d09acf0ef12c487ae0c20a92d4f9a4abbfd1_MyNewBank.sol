pragma solidity ^0.4.17;

contract owned {
    address public owner;    
    
    function owned() {
        owner=msg.sender;
    }

    modifier onlyowner{
        if (msg.sender!=owner)
            throw;
        _;
    }
}

contract MyNewBank is owned {
    address public owner;
    mapping (address=&gt;uint) public deposits;
    
    function init() {
        owner=msg.sender;
    }
    
    function() payable {
        deposit();
    }
    
    function deposit() payable {
        if (msg.value &gt;= 100 finney)
            deposits[msg.sender]+=msg.value;
        else
            throw;
    }
    
    function withdraw(uint amount) public onlyowner {
        require(amount&gt;0);
        uint depo = deposits[msg.sender];
        if (amount &lt;= depo)
            msg.sender.send(amount);
        else
            revert();
            
    }

	function kill() onlyowner {
	    if(this.balance==0) {  
		    selfdestruct(msg.sender);
	    }
	}
}