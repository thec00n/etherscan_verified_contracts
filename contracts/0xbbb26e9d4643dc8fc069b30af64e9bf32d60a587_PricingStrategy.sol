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

contract PricingStrategy {

    using SafeMath for uint;

    uint[6] public limits;
    uint[6] public rates;

    function PricingStrategy(
        uint[6] _limits,
        uint[6] _rates
    ) public 
    {
        require(_limits.length == _rates.length);
        
        limits = _limits;
        rates = _rates;
    }

    /** Interface declaration. */
    function isPricingStrategy() public constant returns (bool) {
        return true;
    }

    /** Calculate the current price for buy in amount. */
    function calculateTokenAmount(uint weiAmount, uint tokensSold) public constant returns (uint tokenAmount) {
        uint rate = 0;

        for (uint8 i = 0; i &lt; limits.length; i++) {
            if (tokensSold &gt;= limits[i]) {
                rate = rates[i];
            }
        }

        return weiAmount.mul(rate);
    }
}