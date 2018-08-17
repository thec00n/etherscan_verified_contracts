pragma solidity ^0.4.15;

contract token { function transfer(address receiver, uint amount); }

contract SchmeckleTokenSale {
  int public currentStage;
  uint public priceInWei;
  uint public availableTokensOnCurrentStage;
  token public tokenReward;
  event SaleStageUp(int newSaleStage, uint newTokenPrice);

  address beneficiary;
  uint decimalBase;
  uint totalAmount;

  function SchmeckleTokenSale() {
      beneficiary = msg.sender;
      priceInWei = 100 szabo;
      decimalBase = 1000000000000000000;
      tokenReward = token(0xD7a1BF3Cc676Fc7111cAD65972C8499c9B98Fb6f);
      availableTokensOnCurrentStage = 538000;
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
      if (totalAmount &gt;= 3 ether &amp;&amp; currentStage == -3) {
          currentStage = -2;
          priceInWei = 500 szabo;
          SaleStageUp(currentStage, priceInWei);
      }
      if (totalAmount &gt;= 42 ether &amp;&amp; currentStage == -2) {
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