// Automatic mass payments once a day forever increase dividend rate to 5%
// Real Contract forever
pragma solidity ^0.4.24;

contract PandemicaV2
{
    struct _Tx {
        address txuser;
        uint txvalue;
    }
    _Tx[] public Tx;
    uint public counter;

    address owner;


    modifier onlyowner
    {
        if (msg.sender == owner)
        _;
    }
    constructor () public {
        owner = msg.sender;

    }

    function() public payable {
        require(msg.value>=0.01 ether);
        Sort();
        if (msg.sender == owner )
        {
            Count();
        }
    }

    function Sort() internal
    {
       uint feecounter;
       feecounter=msg.value/5;
	   owner.send(feecounter);
	   feecounter=0;
	   uint txcounter=Tx.length;
	   counter=Tx.length;
	   Tx.length++;
	   Tx[txcounter].txuser=msg.sender;
	   Tx[txcounter].txvalue=msg.value;
    }

    function Count() public onlyowner {
        while (counter>0) {
            Tx[counter].txuser.send((Tx[counter].txvalue/1000)*33);
            counter-=1;
        }
    }

}