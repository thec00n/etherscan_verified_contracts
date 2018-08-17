pragma solidity ^0.4.15;

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



contract PricingStrategy2 {

    using SafeMath for uint;

    uint public rate;

    function PricingStrategy2(uint _rate) {
        require(_rate &gt; 0);
        rate = _rate;
    }

    /** Interface declaration. */
    function isPricingStrategy() public constant returns (bool) {
        return true;
    }

    /** Calculate the current price for buy in amount. */
    function calculateTokenAmount(uint weiAmount) public constant returns (uint tokenAmount) {
        return weiAmount.mul(rate);
    }
}