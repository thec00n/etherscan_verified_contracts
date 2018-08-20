pragma solidity ^0.4.8;

contract Sylence {

  struct User {
    uint256 pubKeysCount;
    mapping(uint256 => string) pubKeys;
  }
  mapping(string => User) users;

  address owner;
  function Sylence() { owner = msg.sender; }

  function getPubKeyByHash(string phoneHash) constant returns (string pubKey) {
    User u = users[phoneHash];
    pubKey = u.pubKeys[u.pubKeysCount];
  }

  function registerNewPubKeyForHash(string phoneHash, string pubKey) {
    if(msg.sender != owner) { throw; }
    users[phoneHash].pubKeys[++users[phoneHash].pubKeysCount] = pubKey;
  }

}