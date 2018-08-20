pragma solidity ^0.4.2;
contract storer {
address public owner;
string public log;
function storer() {
    owner = msg.sender ;
}
modifier onlyOwner {
        if (msg.sender != owner)
            throw;
        _;
    }
function store(string _log) onlyOwner() {
    log = _log;
}
function kill() onlyOwner() {
  selfdestruct(owner); }
}