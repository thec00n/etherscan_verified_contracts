contract ShinySquirrels {

// all the things
uint private minDeposit = 10 finney;
uint private maxDeposit = 5 ether;
uint private baseFee = 5;
uint private baseMultiplier = 100;
uint private maxMultiplier = 160;
uint private currentPosition = 0;
uint private balance = 0;
uint private feeBalance = 0;
uint private totalDeposits = 0;
uint private totalPaid = 0;
uint private totalSquirrels = 0;
uint private totalShinyThings = 0;
uint private totalSprockets = 0;
uint private totalStars = 0;
uint private totalHearts = 0;
uint private totalSkips = 0;
address private owner = msg.sender;
 
struct PlayerEntry {
    address addr;
    uint deposit;
    uint paid;
    uint multiplier;
    uint fee;
    uint skip;
    uint squirrels;
    uint shinyThings;
    uint sprockets;
    uint stars;
    uint hearts;
}
 
struct PlayerStat {
    address addr;
    uint entries;
    uint deposits;
    uint paid;
    uint skips;
    uint squirrels;
    uint shinyThings;
    uint sprockets;
    uint stars;
    uint hearts;
}

// player entries in the order received
PlayerEntry[] private players;

// The Line of players, keeping track as new players cut in...
uint[] theLine;

// individual player totals
mapping(address =&gt; PlayerStat) private playerStats;

// Shiny new contract, no copy &amp; paste here!
function ShinySquirrels() {
    owner = msg.sender;
}
 
function totals() constant returns(uint playerCount, uint currentPlaceInLine, uint playersWaiting, uint totalDepositsInFinneys, uint totalPaidOutInFinneys, uint squirrelFriends, uint shinyThingsFound, uint sprocketsCollected, uint starsWon, uint heartsEarned, uint balanceInFinneys, uint feeBalanceInFinneys) {
    playerCount             = players.length;
    currentPlaceInLine      = currentPosition;
    playersWaiting          = waitingForPayout();
    totalDepositsInFinneys  = totalDeposits / 1 finney;
    totalPaidOutInFinneys   = totalPaid / 1 finney;
    squirrelFriends         = totalSquirrels;
    shinyThingsFound        = totalShinyThings;
    sprocketsCollected      = totalSprockets;
    starsWon                = totalStars;
    heartsEarned            = totalHearts;
    balanceInFinneys        = balance / 1 finney;
    feeBalanceInFinneys     = feeBalance / 1 finney;
}

function settings() constant returns(uint minimumDepositInFinneys, uint maximumDepositInFinneys) {
    minimumDepositInFinneys = minDeposit / 1 finney;
    maximumDepositInFinneys = maxDeposit / 1 finney;
}

function playerByAddress(address addr) constant returns(uint entries, uint depositedInFinney, uint paidOutInFinney, uint skippedAhead, uint squirrels, uint shinyThings, uint sprockets, uint stars, uint hearts) {
    entries          = playerStats[addr].entries;
    depositedInFinney = playerStats[addr].deposits / 1 finney;
    paidOutInFinney  = playerStats[addr].paid / 1 finney;
    skippedAhead     = playerStats[addr].skips;
    squirrels        = playerStats[addr].squirrels;
    shinyThings      = playerStats[addr].shinyThings;
    sprockets        = playerStats[addr].sprockets;
    stars            = playerStats[addr].stars;
    hearts           = playerStats[addr].hearts;
}

// current number of players still waiting for their payout
function waitingForPayout() constant private returns(uint waiting) {
    waiting = players.length - currentPosition;
}

// the total payout this entry in line will receive
function entryPayout(uint index) constant private returns(uint payout) {
    payout = players[theLine[index]].deposit * players[theLine[index]].multiplier / 100;
}

// the payout amount still due to this entry in line
function entryPayoutDue(uint index) constant private returns(uint payoutDue) {
    // subtract the amount they&#39;ve been paid from the total they are to receive
    payoutDue = entryPayout(index) - players[theLine[index]].paid;
}
 
// public interface to the line of players
function lineOfPlayers(uint index) constant returns (address addr, uint orderJoined, uint depositInFinney, uint payoutInFinney, uint multiplierPercent, uint paid, uint skippedAhead, uint squirrels, uint shinyThings, uint sprockets, uint stars, uint hearts) {
    PlayerEntry player = players[theLine[index]];
    addr              = player.addr;
    orderJoined       = theLine[index];
    depositInFinney   = player.deposit / 1 finney;
    payoutInFinney    = depositInFinney * player.multiplier / 100;
    multiplierPercent = player.multiplier;
    paid              = player.paid / 1 finney;
    skippedAhead      = player.skip;
    squirrels         = player.squirrels;
    shinyThings       = player.shinyThings;
    sprockets         = player.sprockets;
    stars             = player.stars;
    hearts            = player.hearts;
}

function () {
    play();
}
 
function play() {
    uint deposit = msg.value; // in wei
     
    // validate deposit is in range
    if(deposit &lt; minDeposit || deposit &gt; maxDeposit) {
        msg.sender.send(deposit);
        return;
    }
     
    uint multiplier  = baseMultiplier; // percent
    uint fee         = baseFee; // percent
    uint skip        = 0;
    uint squirrels   = 0;
    uint shinyThings = 0;
    uint sprockets   = 0;
    uint stars       = 0;
    uint hearts      = 0;
     
    if(players.length % 5 == 0) {
        multiplier += 2;
        fee        += 1;
        stars      += 1;
         
        if(deposit &lt; 1 ether) {
            multiplier  -= multiplier &gt;= 7 ? 7 : multiplier;
            fee         -= fee        &gt;= 1 ? 1 : 0;
            shinyThings += 1;
        }
        if(deposit &gt;= 1 &amp;&amp; waitingForPayout() &gt;= 10) {
            // at least 10 players waiting
            skip += 4;
            fee  += 3;
        }
        if(deposit &gt;= 2 ether &amp;&amp; deposit &lt;= 3 ether) {
            multiplier += 3;
            fee        += 2;
            hearts     += 1;
        }
        if(deposit &gt;= 3 ether) {
            stars += 1;
        }

    } else if (players.length % 5 == 1) {
        multiplier += 4;
        fee        += 2;
        squirrels  += 1;

        if(deposit &lt; 1 ether) {
            multiplier += 6;
            fee        += 3;
            squirrels  += 1;
        }
        if(deposit &gt;= 2 ether) {
            if(waitingForPayout() &gt;= 20) {
                // at least 20 players waiting
                skip        += waitingForPayout() / 2; // skip half of them
                fee         += 2;
                shinyThings += 1;
            } 

            multiplier += 4;
            fee        += 4;
            hearts     += 1;
        }
        if(deposit &gt;= 4 ether) {
            multiplier += 1;
            fee       -= fee &gt;= 1 ? 1 : 0;
            skip      += 1;
            hearts    += 1;
            stars     += 1;
        }

    } else if (players.length % 5 == 2) {
        multiplier += 7;
        fee        += 6;
        sprockets  += 1;
         
        if(waitingForPayout() &gt;= 10) {
            // at least 10 players waiting
            multiplier -= multiplier &gt;= 8 ? 8 : multiplier;
            fee        -= fee &gt;= 1 ? 1 : 0;
            skip       += 1;
            squirrels  += 1;
        }
        if(deposit &gt;= 3 ether) {
            multiplier  += 2;
            skip        += 1;
            stars       += 1;
            shinyThings += 1;
        }
        if(deposit == maxDeposit) {
            multiplier += 2;
            skip       += 1;
            hearts     += 1;
            squirrels  += 1;
        }
     
    } else if (players.length % 5 == 3) {
        multiplier  -= multiplier &gt;= 5 ? 5 : multiplier; // on noes!
        fee         += 0;
        skip        += 3; // oh yay!
        shinyThings += 1;
         
        if(deposit &lt; 1 ether) {
            multiplier -= multiplier &gt;= 5 ? 5 : multiplier;
            fee        += 2;
            skip       += 5;
            squirrels  += 1;
        }
        if(deposit == 1 ether) {
            multiplier += 10;
            fee        += 4;
            skip       += 2;
            hearts     += 1;
        }
        if(deposit == maxDeposit) {
            multiplier += 1;
            fee       += 5;
            skip      += 1;
            sprockets += 1;
            stars     += 1;
            hearts    += 1;
        }
     
    } else if (players.length % 5 == 4) {
        multiplier += 2;
        fee        -= fee &gt;= 1 ? 1 : fee;
        squirrels  += 1;
         
        if(deposit &lt; 1 ether) {
            multiplier += 3;
            fee        += 2;
            skip       += 3;
        }
        if(deposit &gt;= 2 ether) {
            multiplier += 2;
            fee        += 2;
            skip       += 1;
            stars      += 1;
        }
        if(deposit == maxDeposit/2) {
            multiplier  += 2;
            fee         += 5;
            skip        += 3;
            shinyThings += 1;
            sprockets   += 1;
        }
        if(deposit &gt;= 3 ether) {
            multiplier += 1;
            fee        += 1;
            skip       += 1;
            sprockets  += 1;
            hearts     += 1;
        }
    }

    // track the accumulated bonus goodies!
    playerStats[msg.sender].hearts      += hearts;
    playerStats[msg.sender].stars       += stars;
    playerStats[msg.sender].squirrels   += squirrels;
    playerStats[msg.sender].shinyThings += shinyThings;
    playerStats[msg.sender].sprockets   += sprockets;
    
    // track cummulative awarded goodies
    totalHearts      += hearts;
    totalStars       += stars;
    totalSquirrels   += squirrels;
    totalShinyThings += shinyThings;
    totalSprockets   += sprockets;

    // got squirrels? skip in front of that many players!
    skip += playerStats[msg.sender].squirrels;
     
    // one squirrel ran away!
    playerStats[msg.sender].squirrels -= playerStats[msg.sender].squirrels &gt;= 1 ? 1 : 0;
     
    // got stars? 2% multiplier bonus for every star!
    multiplier += playerStats[msg.sender].stars * 2;
     
    // got hearts? -2% fee for every heart!
    fee -= playerStats[msg.sender].hearts;
     
    // got sprockets? 1% multiplier bonus and -1% fee for every sprocket!
    multiplier += playerStats[msg.sender].sprockets;
    fee        -= fee &gt; playerStats[msg.sender].sprockets ? playerStats[msg.sender].sprockets : fee;
     
    // got shiny things? skip 1 more player and -1% fee!
    if(playerStats[msg.sender].shinyThings &gt;= 1) {
        skip += 1;
        fee  -= fee &gt;= 1 ? 1 : 0;
    }
     
    // got a heart, star, squirrel, shiny thin, and sprocket?!? 50% bonus multiplier!!!
    if(playerStats[msg.sender].hearts &gt;= 1 &amp;&amp; playerStats[msg.sender].stars &gt;= 1 &amp;&amp; playerStats[msg.sender].squirrels &gt;= 1 &amp;&amp; playerStats[msg.sender].shinyThings &gt;= 1 &amp;&amp; playerStats[msg.sender].sprockets &gt;= 1) {
        multiplier += 30;
    }
     
    // got a heart and a star? trade them for +20% multiplier!!!
    if(playerStats[msg.sender].hearts &gt;= 1 &amp;&amp; playerStats[msg.sender].stars &gt;= 1) {
        multiplier                     += 15;
        playerStats[msg.sender].hearts -= 1;
        playerStats[msg.sender].stars  -= 1;
    }
     
    // got a sprocket and a shiny thing? trade them for 5 squirrels!
    if(playerStats[msg.sender].sprockets &gt;= 1 &amp;&amp; playerStats[msg.sender].shinyThings &gt;= 1) {
        playerStats[msg.sender].squirrels   += 5;
        playerStats[msg.sender].sprockets   -= 1;
        playerStats[msg.sender].shinyThings -= 1;
    }

    // stay within profitable and safe limits
    if(multiplier &gt; maxMultiplier) {
        multiplier == maxMultiplier;
    }
    
    // keep power players in check so regular players can still win some too
    if(waitingForPayout() &gt; 15 &amp;&amp; skip &gt; waitingForPayout()/2) {
        // limit skip to half of waiting players
        skip = waitingForPayout() / 2;
    }

    // ledgers within ledgers     
    feeBalance += deposit * fee / 100;
    balance    += deposit - deposit * fee / 100;
    totalDeposits += deposit;

    // prepare players array for a new entry    
    uint playerIndex = players.length;
    players.length += 1;

    // make room in The Line for one more
    uint lineIndex = theLine.length;
    theLine.length += 1;

    // skip ahead if you should be so lucky!
    (skip, lineIndex) = skipInLine(skip, lineIndex);

    // record the players entry
    players[playerIndex].addr        = msg.sender;
    players[playerIndex].deposit     = deposit;
    players[playerIndex].multiplier  = multiplier;
    players[playerIndex].fee         = fee;
    players[playerIndex].squirrels   = squirrels;
    players[playerIndex].shinyThings = shinyThings;
    players[playerIndex].sprockets   = sprockets;
    players[playerIndex].stars       = stars;
    players[playerIndex].hearts      = hearts;
    players[playerIndex].skip        = skip;
    
    // add the player to The Line at whatever position they snuck in at    
    theLine[lineIndex] = playerIndex;

    // track players cumulative stats
    playerStats[msg.sender].entries  += 1;
    playerStats[msg.sender].deposits += deposit;
    playerStats[msg.sender].skips    += skip;
    
    // track total game skips
    totalSkips += skip;
    
    // issue payouts while the balance allows
    // rolling payouts occur as long as the balance is above zero
    uint nextPayout = entryPayoutDue(currentPosition);
    uint payout;
    while(balance &gt; 0) {
        if(nextPayout &lt;= balance) {
            // the balance is great enough to pay the entire next balance due
            // pay the balance due
            payout = nextPayout;
        } else {
            // the balance is above zero, but less than the next balance due
            // send them everything available
            payout = balance;
        }
        // issue the payment
        players[theLine[currentPosition]].addr.send(payout);
        // mark the amount paid
        players[theLine[currentPosition]].paid += payout;
        // keep a global tally
        playerStats[players[theLine[currentPosition]].addr].paid += payout;
        balance    -= payout;
        totalPaid  += payout;
        // move to the next position in line if the last entry got paid out completely
        if(balance &gt; 0) {
            currentPosition++;
            nextPayout = entryPayoutDue(currentPosition);
        }
    }
}
 
// jump in line, moving entries back towards the end one at a time
// presumes the line length has already been increased to accomodate the newcomer
// return the the number of positions skipped and the index of the vacant position in line
function skipInLine(uint skip, uint currentLineIndex) private returns (uint skipped, uint newLineIndex) {
    // check for at least 1 player in line plus this new entry
    if(skip &gt; 0 &amp;&amp; waitingForPayout() &gt; 2) {
        // -2 because we don&#39;t want to count the new empty slot at the end of the list
        if(skip &gt; waitingForPayout()-2) {
            skip = waitingForPayout()-2;
        }

        // move entries forward one by one
        uint i = 0;
        while(i &lt; skip) {
            theLine[currentLineIndex-i] = theLine[currentLineIndex-1-i];
            i++;
        }
        
        // don&#39;t leave a duplicate copy of the last entry processed
        delete(theLine[currentLineIndex-i]);
        
        // the newly vacant position is i slots from the end
        newLineIndex = currentLineIndex-i;
    } else {
        // no change
        newLineIndex = currentLineIndex;
        skip = 0;
    }
    skipped = skip;
}

function DynamicPyramid() {
    // Rubixi god-code, j/k :-P
    playerStats[msg.sender].squirrels    = 0;
    playerStats[msg.sender].shinyThings  = 0;
    playerStats[msg.sender].sprockets    = 0;
    playerStats[msg.sender].stars        = 0;
    playerStats[msg.sender].hearts       = 0;
}
 
function collectFees() {
    if(msg.sender != owner) {
        throw;
    }
    // game balance will always be zero due to automatic rolling payouts
    if(address(this).balance &gt; balance + feeBalance) {
        // collect any funds outside of the game balance
        feeBalance = address(this).balance - balance;
    }
    owner.send(feeBalance);
    feeBalance = 0;
}

function updateSettings(uint newMultiplier, uint newMaxMultiplier, uint newFee, uint newMinDeposit, uint newMaxDeposit, bool collect) {
    // adjust the base settings within a small and limited range as the game matures and ether prices change
    if(msg.sender != owner) throw;
    if(newMultiplier &lt; 80 || newMultiplier &gt; 120) throw;
    if(maxMultiplier &lt; 125 || maxMultiplier &gt; 200) throw;
    if(newFee &lt; 0 || newFee &gt; 15) throw;
    if(minDeposit &lt; 1 finney || minDeposit &gt; 1 ether) throw;
    if(maxDeposit &lt; 1 finney || maxDeposit &gt; 25 ether) throw;
    if(collect) collectFees();
    baseMultiplier = newMultiplier;
    maxMultiplier = newMaxMultiplier;
    baseFee = newFee;
    minDeposit = newMinDeposit;
    maxDeposit = newMaxDeposit;
}


}