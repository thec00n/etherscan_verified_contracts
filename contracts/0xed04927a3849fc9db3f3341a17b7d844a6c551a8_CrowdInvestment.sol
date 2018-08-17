pragma solidity ^0.4.4;
// &quot;10000000000000000&quot;, &quot;60000000000&quot;, &quot;4000000000000000&quot;
// , 0.004 ETH
contract CrowdInvestment {
    uint private restAmountToInvest;
    uint private maxGasPrice;
    address private creator;
    mapping(address =&gt; uint) private perUserInvestments;
    mapping(address =&gt; uint) private additionalCaps;
    uint private limitPerInvestor;

    function CrowdInvestment(uint totalCap, uint maxGasPriceParam, uint capForEverybody) public {
        restAmountToInvest = totalCap;
        creator = msg.sender;
        maxGasPrice = maxGasPriceParam;
        limitPerInvestor = capForEverybody;
    }

    function () public payable {
        require(restAmountToInvest &gt;= msg.value); // общий лимит инвестиций
        require(tx.gasprice &lt;= maxGasPrice); // лимит на gas price
        require(getCap(msg.sender) &gt;= msg.value); // лимит на инвестора
        restAmountToInvest -= msg.value; // уменьшим общий лимит инвестиций
        perUserInvestments[msg.sender] += msg.value; // запишем инвестицию пользователя
    }

    function getCap (address investor) public view returns (uint) {
        return limitPerInvestor - perUserInvestments[investor] + additionalCaps[investor];
    }

    function getTotalCap () public view returns (uint) {
        return restAmountToInvest;
    }

    function addPersonalCap (address investor, uint additionalCap) public {
        require(msg.sender == creator);
        additionalCaps[investor] += additionalCap;
    }

    function addPersonalCaps (address[] memory investors, uint additionalCap) public {
        require(msg.sender == creator);
        for (uint16 i = 0; i &lt; investors.length; i++) {
            additionalCaps[investors[i]] += additionalCap;
        }
    }

    function withdraw () public {
        require(msg.sender == creator); // только создатель может писать
        creator.transfer(this.balance); // передадим все деньги создателю и только ему
    }
}