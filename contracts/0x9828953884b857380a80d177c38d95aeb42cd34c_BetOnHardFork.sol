pragma solidity ^0.4.1;


contract butttoken {
    function butttoken () {}
    function transfer(address _to, uint256 _value) {}
}

contract BetOnHardFork {
    uint hardForkTimeStamp;
    uint betsOverTimeStamp;
    uint weekAfterHardFork;
    uint twoWeeksAfterHardFork;
    
    uint buttcoinBalance = 500 * 1000;
    uint buttcoinReward = 500 * 1000 / 100;
    uint gasLimitThreshold = 2 * 1000 * 1000;
    
    struct Bet {
        bool didBet;
        bool bet;
    }
    
    mapping(address=&gt;Bet) bets;
    uint numYesBets;
    uint numNoBets;
    
    function BetOnHardFork() {
        hardForkTimeStamp = now + 1 days;
        betsOverTimeStamp = hardForkTimeStamp + 2 days;
        weekAfterHardFork = hardForkTimeStamp +  1 weeks;
        twoWeeksAfterHardFork = weekAfterHardFork + 2 weeks;
        
        numYesBets = 0;
        numNoBets = 0;
    }
    
    function isBetPossible( bool willSucceed ) constant returns(bool) {
        if( now &gt; betsOverTimeStamp ) return false;
        
        uint numPossibleBets = buttcoinBalance / buttcoinReward;
        if( willSucceed ) {
            if( numYesBets &lt; numNoBets ) return true;
            if( 1 + numYesBets - numNoBets &gt;= numPossibleBets ) return false;
        }
        else {
            if( numNoBets &lt; numYesBets ) return true;
            if( 1 + numNoBets - numYesBets &gt;= numPossibleBets ) return false;
        }
        
        return (! bets[msg.sender].didBet);
    }
    
    function makeBet( bool willSucceed ) {
        if( ! isBetPossible( willSucceed ) ) throw;
        bets[msg.sender].didBet = true;
        bets[msg.sender].bet = willSucceed;
        if( willSucceed ) numYesBets++;
        else numNoBets++;
    }
    
    function claimReward( ) {
        if( now &gt; twoWeeksAfterHardFork ) throw;
        if( now &lt; weekAfterHardFork ) throw;
        if( ! bets[msg.sender].didBet ) throw;
        bool succ = (block.gaslimit &gt;= gasLimitThreshold );
        bool shouldPay = false;
        if( succ &amp;&amp; bets[msg.sender].bet ) shouldPay = true;
        if( ! succ &amp;&amp; ! bets[msg.sender].bet ) shouldPay = true;
        
        if( ! shouldPay ) throw;
        
        butttoken token = butttoken(0x2a106E06cD26FAD93f732dAa4218fCE4eAC6d6D8);
        token.transfer(msg.sender,buttcoinReward);
    }
    
}