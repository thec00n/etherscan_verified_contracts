pragma solidity ^0.4.18;

contract Agencies {
  mapping (address =&gt; string) private agencyOfOwner;
  mapping (string =&gt; address) private ownerOfAgency;

  event Set (string indexed _agency, address indexed _owner);
  event Unset (string indexed _agency, address indexed _owner);

  function Agencies () public {
  }

  function agencyOf (address _owner) public view returns (string _agency) {
    return agencyOfOwner[_owner];
  }

  function ownerOf (string _agency) public view returns (address _owner) {
    return ownerOfAgency[_agency];
  }

  function set (string _agency) public {
    require(bytes(_agency).length &gt; 2);
    require(ownerOf(_agency) == address(0));

    address owner = msg.sender;
    string storage oldAgency = agencyOfOwner[owner];

    if (bytes(oldAgency).length &gt; 0) {
      Unset(oldAgency, owner);
      delete ownerOfAgency[oldAgency];
    }

    agencyOfOwner[owner] = _agency;
    ownerOfAgency[_agency] = owner;
    Set(_agency, owner);
  }

  function unset () public {
    require(bytes(agencyOfOwner[msg.sender]).length &gt; 0);

    address owner = msg.sender;
    string storage oldAgency = agencyOfOwner[owner];

    Unset(oldAgency, owner);

    delete ownerOfAgency[oldAgency];
    delete agencyOfOwner[owner];
  }
}