pragma solidity ^0.4.10;

// A simple decentralized guestbook.
contract Guestbook {
  address creator;

  event Post(address indexed _from, string _name, string _body);

  function Guestbook() {
    creator = msg.sender;
  }

  function post(string _name, string _body) {
    require(bytes(_name).length &gt; 0);
    require(bytes(_body).length &gt; 0);

    Post(msg.sender, _name, _body);
  }

  function destroy() {
    require(msg.sender == creator);

    selfdestruct(creator);
  }
}