pragma solidity ^0.4.13;

contract token { function transfer(address receiver, uint amount); }

contract SchmeckleTokenSale {
  int public currentStage;
  uint public priceInWei;
  uint public availableTokensOnCurrentStage;

  address beneficiary;
  uint decimalBase;
  uint totalAmount;
  token public tokenReward;
  event SaleStageUp(int newSaleStage, uint newTokenPrice);

  function SchmeckleTokenSale() {
      beneficiary = msg.sender;
      priceInWei = 700 szabo;
      decimalBase = 1000000000000000000;
      tokenReward = token(0x0bB664f7b6FC928B2d1e5aA32182Ae07023Ed4aA);
      availableTokensOnCurrentStage = 2000000;
      totalAmount = 0;
      currentStage = -3;
  }

  function () payable {
      uint amount = msg.value;

      if (amount &lt; 1 finney) revert();

      uint tokens = amount * decimalBase / priceInWei;

      if (tokens &gt; availableTokensOnCurrentStage * decimalBase) revert();

      if (currentStage &gt; 21) revert();

      totalAmount += amount;
      availableTokensOnCurrentStage -= tokens / decimalBase + 1;
      if (totalAmount &gt;= 21 ether &amp;&amp; currentStage == -3) {
          currentStage = -2;
          priceInWei = 800 szabo;
          SaleStageUp(currentStage, priceInWei);
      }
      if (totalAmount &gt;= 333 ether &amp;&amp; currentStage == -2) {
          currentStage = -1;
          priceInWei = 1000 szabo;
          SaleStageUp(currentStage, priceInWei);
      }
      if (availableTokensOnCurrentStage &lt; 1000 &amp;&amp; currentStage &gt;= 0) {
          currentStage++;
          priceInWei = priceInWei * 2;
          availableTokensOnCurrentStage = 1000000;
          SaleStageUp(currentStage, priceInWei);
      }

      tokenReward.transfer(msg.sender, tokens);
  }

  modifier onlyBeneficiary {
      if (msg.sender != beneficiary) revert();
      _;
  }

 function withdraw(address recipient, uint amount) onlyBeneficiary {
      if (recipient == 0x0) revert();
      recipient.transfer(amount);
 }

 function launchSale() onlyBeneficiary () {
      if (currentStage &gt; -1) revert();
      currentStage = 0;
      priceInWei = priceInWei * 2;
      availableTokensOnCurrentStage = 2100000;
      SaleStageUp(currentStage, priceInWei);
 }
}