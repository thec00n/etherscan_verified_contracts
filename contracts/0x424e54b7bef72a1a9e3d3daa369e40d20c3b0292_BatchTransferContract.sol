pragma solidity ^0.4.11;

library Math {
  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &gt;= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &lt; b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &gt;= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &lt; b ? a : b;
  }
}

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

/// @title Loopring Refund Program
/// @author Kongliang Zhong - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="3b5054555c57525a555c7b5754544b4952555c1554495c">[email&#160;protected]</a>&gt;.
/// For more information, please visit https://loopring.org.
contract BatchTransferContract {
    using SafeMath for uint;
    using Math for uint;

    address public owner;

    function BatchTransferContract(address _owner) public {
        owner = _owner;
    }

    function () payable {
        // do nothing.
    }

    function batchRefund(address[] investors, uint[] ethAmounts) public payable {
        require(msg.sender == owner);
        require(investors.length &gt; 0);
        require(investors.length == ethAmounts.length);

        uint total = 0;
        for (uint i = 0; i &lt; investors.length; i++) {
            total += ethAmounts[i];
        }

        require(total &lt;= this.balance);

        for (i = 0; i &lt; investors.length; i++) {
            if (ethAmounts[i] &gt; 0) {
                investors[i].transfer(ethAmounts[i]);
            }
        }
    }

    function batchRefundzFixed(address[] investors, uint ethAmount) public payable {
        require(msg.sender == owner);
        require(investors.length &gt; 0);
        for (uint i = 0; i &lt; investors.length; i++) {
            investors[i].transfer(ethAmount);
        }
    }

    function drain(uint ethAmount) public payable {
        require(msg.sender == owner);

        uint amount = ethAmount.min256(this.balance);
        if (amount &gt; 0) {
          owner.transfer(amount);
        }
    }
}