pragma solidity ^0.4.17;

contract Ownable {
    address public Owner;
    
    function Ownable() { Owner = msg.sender; }

    modifier onlyOwner() {
        if( Owner == msg.sender )
            _;
    }
    
    function transferOwner(address _owner) onlyOwner {
        if( this.balance == 0 ) {
            Owner = _owner;
        }
    }
}

contract TimeCapsuleEvent is Ownable {
    address public Owner;
    mapping (address=&gt;uint) public deposits;
    uint public openDate;
    
    event Initialized(address indexed owner, uint openOn);
    
    function initCapsule(uint open) {
        Owner = msg.sender;
        openDate = open;
        Initialized(Owner, openDate);
    }

    event Deposit(address indexed depositor, uint amount);
    event Withdrawal(address indexed withdrawer, uint amount);

    function() payable { deposit(); }
    
    function deposit() payable {
        if( msg.value &gt;= 0.25 ether ) {
            deposits[msg.sender] += msg.value;
            Deposit(msg.sender, msg.value);
        } else throw;
    }
    
    function withdraw(uint amount) onlyOwner {
        if( now &gt;= openDate ) {
            uint max = deposits[msg.sender];
            if( amount &lt;= max &amp;&amp; max &gt; 0 ) {
                msg.sender.send( amount );
                Withdrawal(msg.sender, amount);
            }
        }
    }

    function kill() onlyOwner {
        if( this.balance == 0 )
            suicide( msg.sender );
	}
}