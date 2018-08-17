contract GradualPonzi {
    address[] public investors;
    mapping (address =&gt; uint) public balances;
    uint public constant MINIMUM_INVESTMENT = 1e15;

    function GradualPonzi () public {
        investors.push(msg.sender);
    }

    function () public payable {
        require(msg.value &gt;= MINIMUM_INVESTMENT);
        uint eachInvestorGets = msg.value / investors.length;
        for (uint i=0; i &lt; investors.length; i++) {
            balances[investors[i]] += eachInvestorGets;
        }
        investors.push(msg.sender);
    }

    function withdraw () public {
        uint payout = balances[msg.sender];
        balances[msg.sender] = 0;
        msg.sender.transfer(payout);
    }
}