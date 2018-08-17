pragma solidity ^0.4.18;

contract ConsultingServices {

  address public owner;
  uint256 public yearlyFee = 500 ether;
  mapping(address =&gt; Retainer) public retainers;

  event Retained(address);

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  struct Retainer {
    uint256 startDate;
    uint256 paidFee;
  }

  function ConsultingServices() public {
    owner = msg.sender;
  }

  function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }

  function withdraw() public onlyOwner {
    owner.transfer(this.balance);
  }

  function changeFee(uint256 _newFee) public onlyOwner {
    yearlyFee = _newFee;
  }

  function createRetainer() public payable {
    require(msg.value &gt;= yearlyFee);
    require(retainers[msg.sender].startDate &lt; now - 1 years);
    retainers[msg.sender] = Retainer(now, msg.value);
    Retained(msg.sender);
  }

  function() public payable {
    createRetainer();
  }
}