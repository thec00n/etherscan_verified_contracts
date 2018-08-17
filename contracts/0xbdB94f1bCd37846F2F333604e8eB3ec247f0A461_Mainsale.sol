pragma solidity ^0.4.19;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract Mainsale {

  using SafeMath for uint256;

  address public owner;
  address public multisig;
  uint256 public endTimestamp;
  uint256 public totalRaised;
  uint256 public constant hardCap = 16318 ether;
  uint256 public constant MIN_CONTRIBUTION = 0.1 ether;
  uint256 public constant MAX_CONTRIBUTION = 1000 ether;
  uint256 public constant TWO_DAYS = 60 * 60 * 24 * 2;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier belowCap() {
    require(totalRaised &lt; hardCap);
    _;
  }

  modifier withinTimeLimit() {
    require(block.timestamp &lt;= endTimestamp);
    _;
  }

  function Mainsale(address _multisig, uint256 _endTimestamp) {
    require (_multisig != 0 &amp;&amp; _endTimestamp &gt;= (block.timestamp + TWO_DAYS));
    owner = msg.sender;
    multisig = _multisig;
    endTimestamp = _endTimestamp;
  }
  
  function() payable belowCap withinTimeLimit {
    require(msg.value &gt;= MIN_CONTRIBUTION &amp;&amp; msg.value &lt;= MAX_CONTRIBUTION);
    totalRaised = totalRaised.add(msg.value);
    uint contribution = msg.value;
    if (totalRaised &gt; hardCap) {
      uint refundAmount = totalRaised.sub(hardCap);
      msg.sender.transfer(refundAmount);
      contribution = contribution.sub(refundAmount);
      refundAmount = 0;
      totalRaised = hardCap;
    }
    multisig.transfer(contribution);
  }

  function withdrawStuck() onlyOwner {
    multisig.transfer(this.balance);
  }

}