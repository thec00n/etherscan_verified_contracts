pragma solidity ^0.4.19;

contract mortal {
    /* Define variable owner of the type address */
    address owner;

    /* This function is executed at initialization and sets the owner of the contract */
    function mortal() { owner = msg.sender; }

    /* Function to recover the funds on the contract */
    function kill() { if (msg.sender == owner) selfdestruct(owner); }
}

contract ObjectiveStorage is mortal {
    address creator;
    string objective;
    
    function ObjectiveStorage(string _objective) public
    {
        creator = msg.sender;
        objective = _objective;
    }
    /* Main function */
    function getObjective() public constant returns (string) {
        return objective;
    }
}