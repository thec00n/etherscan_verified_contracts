pragma solidity ^0.4.16;

contract CrowdsaleRC {
    uint public createdTimestamp; uint public start; uint public deadline;
    address public owner;
    address public beneficiary;
    uint public amountRaised;
    uint public maxAmount;
    mapping(address =&gt; uint256) public balanceOf;
    mapping (address =&gt; bool) public whitelist;
    event FundTransfer(address backer, uint amount, bool isContribution);

    function CrowdsaleRC () public {
        createdTimestamp = block.timestamp;
        start = 1529316000;
        deadline = 1532080800;
        amountRaised = 0;
        beneficiary = 0xD27eAD21C9564f122c8f84cD98a505efDf547665;
        owner = msg.sender;
        maxAmount = 2000 ether;
    }

    function () payable public {
        require( (msg.value &gt;= 0.1 ether) &amp;&amp;  block.timestamp &gt;= start &amp;&amp; block.timestamp &lt;= deadline &amp;&amp; amountRaised &lt; maxAmount
        &amp;&amp; ( (msg.value &lt;= 100 ether) || (msg.value &gt; 100 ether &amp;&amp; whitelist[msg.sender]==true) )
        );

        uint amount = msg.value;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        FundTransfer(msg.sender, amount, true);
        if (beneficiary.send(amount)) {
            FundTransfer(beneficiary, amount, false);
        }
    }

    function whitelistAddress (address uaddress) public {
        require (owner == msg.sender || beneficiary == msg.sender);
        whitelist[uaddress] = true;
    }

    function removeAddressFromWhitelist (address uaddress) public {
        require (owner == msg.sender || beneficiary == msg.sender);
        whitelist[uaddress] = false;
    }
}