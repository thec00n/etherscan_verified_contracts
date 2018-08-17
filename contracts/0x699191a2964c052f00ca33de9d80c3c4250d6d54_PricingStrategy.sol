pragma solidity ^0.4.18;

// File: contracts/IPricingStrategy.sol

interface IPricingStrategy {

    function isPricingStrategy() public view returns (bool);

    /** Calculate the current price for buy in amount. */
    function calculateTokenAmount(uint weiAmount, uint tokensSold) public view returns (uint tokenAmount);

}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

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

// File: contracts/PricingStrategy.sol

contract PricingStrategy is IPricingStrategy {

    using SafeMath for uint;

    uint public rate;

    function PricingStrategy(
        uint _rate
    ) public 
    {
        require(_rate &gt;= 0);
        rate = _rate;
    }

    /** Interface declaration. */
    function isPricingStrategy() public view returns (bool) {
        return true;
    }

    /** Calculate the current price for buy in amount. */
    function calculateTokenAmount(uint weiAmount, uint tokensSold) public view returns (uint tokenAmount) {
        return weiAmount.mul(rate);
    }

}