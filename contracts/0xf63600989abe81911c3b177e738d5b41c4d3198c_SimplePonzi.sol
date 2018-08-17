contract SimplePonzi {
    address public currentInvestor;
    uint public currentInvestment = 0;
    
    function () payable public {
        require(msg.value &gt; currentInvestment);
        
        // payout previous investor
        currentInvestor.send(msg.value);

        // document new investment
        currentInvestor = msg.sender;
        currentInvestment = msg.value;

    }
}