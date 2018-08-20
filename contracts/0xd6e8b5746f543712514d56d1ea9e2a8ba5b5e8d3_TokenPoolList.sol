pragma solidity ^0.4.10;

contract TokenPoolList {
  address[] public list;

  event Added(address x);

  function add(address x) {
    list.push(x);
    Added(x);
  }

  function getCount() public constant returns(uint) {
    return list.length;
  }

  function getAddress(uint index) public constant returns(address) {
    return list[index];
  }
}