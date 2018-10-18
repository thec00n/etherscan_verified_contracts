pragma solidity ^0.4.0;

contract MultiEthSender {
    
    event Send (
        uint256 _amount,
        address indexed_receiver
    );

    function multiSendEth(uint256 amount, address[] list) public returns (bool) {
        uint listLength = list.length;
        for (uint i=0; i<listLength; i++) {
            list[i].transfer(amount);
            emit Send(amount, list[i]);
        }
        
        return true;
    }
    
    function () external payable {}

}