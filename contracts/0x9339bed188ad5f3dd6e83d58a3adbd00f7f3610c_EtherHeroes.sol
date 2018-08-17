pragma solidity ^0.4.19;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}


contract EtherHeroes {
  //ETHEREUM SOLIDITY VERSION 4.19
  //CRYPTOCOLLECTED LTD
  
  //INITIALIZATION VALUES
  address ceoAddress = 0xC0c8Dc6C1485060a72FCb629560371fE09666500;
  struct Hero {
    address currentHeroOwner;
    uint256 currentValue;
   
  }
  Hero[16] data;
  
  //No-Arg Constructor initializes basic low-end values.
  function EtherHeroes() public {
    for (uint i = 0; i &lt; 16; i++) {
     
      data[i].currentValue = 10000000000000000;
      data[i].currentHeroOwner = msg.sender;
    }
  }

  // Function to pay the previous owner.
  //     Neccesary for contract integrity
  function payPreviousOwner(address previousHeroOwner, uint256 currentValue) private {
    previousHeroOwner.transfer(currentValue);
  }
  //Sister function to payPreviousOwner():
  //   Addresses wallet-to-wallet payment totality
  function transactionFee(address, uint256 currentValue) private {
    ceoAddress.transfer(currentValue);
  }
  // Function that handles logic for setting prices and assigning heroes to addresses.
  // Doubles instance value  on purchase.
  // Verify  correct amount of ethereum has been received
  function purchaseHeroForEth(uint uniqueHeroID) public payable returns (uint, uint) {
    require(uniqueHeroID &gt;= 0 &amp;&amp; uniqueHeroID &lt;= 15);
    // Set initial price to .02 (ETH)
    if ( data[uniqueHeroID].currentValue == 10000000000000000 ) {
      data[uniqueHeroID].currentValue = 20000000000000000;
    } else {
      // Double price
      data[uniqueHeroID].currentValue = data[uniqueHeroID].currentValue * 2;
    }
    
    require(msg.value &gt;= data[uniqueHeroID].currentValue * uint256(1));
    // Call payPreviousOwner() after purchase.
    payPreviousOwner(data[uniqueHeroID].currentHeroOwner,  (data[uniqueHeroID].currentValue / 10) * (9)); 
    transactionFee(ceoAddress, (data[uniqueHeroID].currentValue / 10) * (1));
    // Assign owner.
    data[uniqueHeroID].currentHeroOwner = msg.sender;
    // Return values for web3js display.
    return (uniqueHeroID, data[uniqueHeroID].currentValue);

  }
  // Gets the current list of heroes, their owners, and prices. 
  function getCurrentHeroOwners() external view returns (address[], uint256[]) {
    address[] memory currentHeroOwners = new address[](16);
    uint256[] memory currentValues =  new uint256[](16);
    for (uint i=0; i&lt;16; i++) {
      currentHeroOwners[i] = (data[i].currentHeroOwner);
      currentValues[i] = (data[i].currentValue);
    }
    return (currentHeroOwners,currentValues);
  }
  
}