pragma solidity ^0.4.23;

// File: contracts\crowdsale\PhaseCrowdsale.sol

/**
 * @title PhaseCrowdsale
 * @dev PhaseCrowdsale
 */
// solium-disable-next-line max-len
contract PhaseCrowdsale {

  // Phases conditions
  uint256[3] public phasesStartTime;
  uint256[3] public phasesTokenPrices = [23, 34, 58]; // price in USD cents
  uint256[3] public phasesBonuses = [50, 30, 0]; // bonuses in percentage

  /**
   * @param _phasesTime Crowdsale phases time [openingTime, closingTime, secondPhaseStartTime, thirdPhaseStartTime]
   */
  constructor(
    uint256[4] _phasesTime
  )
    public
  {
    phasesStartTime = [_phasesTime[0], _phasesTime[2], _phasesTime[3]];
  }

 /**
  * @dev Get phase number depending on the current time
  */
  function getPhaseNumber() public view returns (uint256) {
    if (now < phasesStartTime[1]) { // solium-disable-line security/no-block-members
      return 0;
    } else if (now < phasesStartTime[2]) { // solium-disable-line security/no-block-members
      return 1;
    } else {
      return 2;
    }
  }

  /**
  * @dev Returns the current token price in $ cents depending on the current time
  */
  function getCurrentTokenPriceInCents() public view returns (uint256) {
    return phasesTokenPrices[getPhaseNumber()];
  }

  /**
  * @dev Returns the token sale bonus percentage depending on the current time
  */
  function getCurrentBonusPercentage() public view returns (uint256) {
    return phasesBonuses[getPhaseNumber()];
  }

}