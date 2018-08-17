pragma solidity ^0.4.19;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract Forgiveness {
    using SafeMath for uint256;
    
    uint constant forgivenessFee = 0.01 ether;
    uint public ownerBalance;
    address public owner;
    
    mapping (bytes32 =&gt; bool) forgiven;
    
    function Forgiveness () public {
        owner = msg.sender;
    }
    
    function askForgiveness (string transaction) public payable {
        require(msg.value &gt;= forgivenessFee);
        require(!isForgiven(transaction));
        ownerBalance += msg.value;
        forgiven[keccak256(transaction)] = true;
    }
    
    function isForgiven (string transaction) public view returns (bool) {
        return forgiven[keccak256(transaction)];
    }
    
    function withdrawFees () public {
        require(msg.sender == owner);
        uint toWithdraw = ownerBalance;
        ownerBalance = 0;
        msg.sender.transfer(toWithdraw);
    }
    
    function getBalance () public view returns (uint) {
        require(msg.sender == owner);
        return ownerBalance;
    }

    function () public payable {
    }
}