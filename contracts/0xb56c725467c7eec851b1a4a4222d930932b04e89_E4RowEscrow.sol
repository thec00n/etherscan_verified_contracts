pragma solidity ^0.4.11;

// version (LAVA-Q)
contract E4RowEscrow {

event StatEvent(string msg);
event StatEventI(string msg, uint val);
event StatEventA(string msg, address addr);

        uint constant MAX_PLAYERS = 5;

        enum EndReason  {erWinner, erTimeOut, erCancel}
        enum SettingStateValue  {debug, release, lockedRelease}

        struct gameInstance {
                bool active;           // active
                bool allocd;           // allocated already. 
                EndReason reasonEnded; // enum reason of ended
                uint8 numPlayers;
                uint128 totalPot;      // total of all bets
                uint128[5] playerPots; // individual deposits
                address[5] players;    // player addrs
                uint lastMoved;        // time game last moved
        }

        struct arbiter {
                mapping (uint =&gt; uint)  gameIndexes; // game handles
                bool registered; 
                bool locked;
                uint8 numPlayers;
                uint16 arbToken;         // 2 bytes
                uint16 escFeePctX10;     // escrow fee -- frac of 1000
                uint16 arbFeePctX10;     // arbiter fee -- frac of 1000
                uint32 gameSlots;        // a counter of alloc&#39;d game structs (they can be reused)
                uint128 feeCap;          // max fee (escrow + arb) in wei
                uint128 arbHoldover;     // hold accumulated gas credits and arbiter fees
        }


        address public  owner;  // owner is address that deployed contract
        address public  tokenPartner;   // the address of partner that receives rake fees
        uint public numArbiters;        // number of arbiters

        int numGamesStarted;    // total stats from all arbiters

        uint public numGamesCompleted; // ...
        uint public numGamesCanceled;   // tied and canceled
        uint public numGamesTimedOut;   // ...
        uint public houseFeeHoldover;   // hold fee till threshold
        uint public lastPayoutTime;     // timestamp of last payout time

        // configurables
        uint public gameTimeOut;
        uint public registrationFee;
        uint public houseFeeThreshold;
        uint public payoutInterval;

        uint acctCallGas;  // for payments to simple accts
        uint tokCallGas;   // for calling token contract. eg fee payout
        uint public startGameGas; // gas consumed by startGame
        uint public winnerDecidedGas; // gas consumed by winnerDecided

        SettingStateValue public settingsState = SettingStateValue.debug; 


        mapping (address =&gt; arbiter)  arbiters;
        mapping (uint =&gt; address)  arbiterTokens;
        mapping (uint =&gt; address)  arbiterIndexes;
        mapping (uint =&gt; gameInstance)  games;


        function E4RowEscrow() public
        {
                owner = msg.sender;
        }


        function applySettings(SettingStateValue _state, uint _fee, uint _threshold, uint _timeout, uint _interval, uint _startGameGas, uint _winnerDecidedGas)
        {
                if (msg.sender != owner) 
                        throw;

                // ----------------------------------------------
                // these items are tweakable for game optimization
                // ----------------------------------------------
                houseFeeThreshold = _threshold;
                gameTimeOut = _timeout;
                payoutInterval = _interval;

                if (settingsState == SettingStateValue.lockedRelease) {
                        StatEvent(&quot;Settings Tweaked&quot;);
                        return;
                }

                settingsState = _state;
                registrationFee = _fee;

                // set default op gas -  any futher settings done in set up gas
                acctCallGas = 21000; 
                tokCallGas = 360000;

                // set gas consumption - these should never change (except gas price)
                startGameGas = _startGameGas;
                winnerDecidedGas = _winnerDecidedGas;
                StatEvent(&quot;Settings Changed&quot;);

        }


        //-----------------------------
        // return an arbiter token from an hGame
        //-----------------------------
        function ArbTokFromHGame(uint _hGame) returns (uint _tok)
        { 
                _tok =  (_hGame / (2 ** 48)) &amp; 0xffff;
        }


        //-----------------------------
        // suicide the contract, not called for release
        //-----------------------------
        function HaraKiri()
        {
                if ((msg.sender == owner) &amp;&amp; (settingsState != SettingStateValue.lockedRelease))
                          suicide(tokenPartner);
                else
                        StatEvent(&quot;Kill attempt failed&quot;);
        }


        //-----------------------------
        // default function
        // who are we to look a gift-horse in the mouth?
        //-----------------------------
        function() payable  {
                StatEvent(&quot;thanks!&quot;);
                houseFeeHoldover += msg.value;
        }
        function blackHole() payable  {
                StatEvent(&quot;thanks!#2&quot;);
        }

        //------------------------------------------------------
        // check active game and valid player, return player index
        //-------------------------------------------------------
        function validPlayer(uint _hGame, address _addr)  internal returns( bool _valid, uint _pidx)
        {
                _valid = false;

                if (activeGame(_hGame)) {
                        for (uint i = 0; i &lt; games[_hGame].numPlayers; i++) {
                                if (games[_hGame].players[i] == _addr) {
                                        _valid=true;
                                        _pidx = i;
                                        break;
                                }
                        }
                }
        }


        //------------------------------------------------------
        // check the arbiter is valid by comparing token
        //------------------------------------------------------
        function validArb(address _addr, uint _tok) internal  returns( bool _valid)
        {
                _valid = false;

                if ((arbiters[_addr].registered)
                        &amp;&amp; (arbiters[_addr].arbToken == _tok)) 
                        _valid = true;
        }

        //------------------------------------------------------
        // check the arbiter is valid without comparing token
        //------------------------------------------------------
        function validArb2(address _addr) internal  returns( bool _valid)
        {
                _valid = false;
                if (arbiters[_addr].registered)
                        _valid = true;
        }

        //------------------------------------------------------
        // check if arbiter is locked out
        //------------------------------------------------------
        function arbLocked(address _addr) internal  returns( bool _locked)
        {
                _locked = false;
                if (validArb2(_addr)) 
                        _locked = arbiters[_addr].locked;
        }

        //------------------------------------------------------
        // return if game is active
        //------------------------------------------------------
        function activeGame(uint _hGame) internal  returns( bool _valid)
        {
                _valid = false;
                if ((_hGame &gt; 0)
                        &amp;&amp; (games[_hGame].active))
                        _valid = true;
        }


        //------------------------------------------------------
        // register game arbiter, max players of 5, pass in exact registration fee
        //------------------------------------------------------
        function registerArbiter(uint _numPlayers, uint _arbToken, uint _escFeePctX10, uint _arbFeePctX10, uint _feeCap) public payable 
        {

                if (msg.value != registrationFee) {
                        throw;  //Insufficient Fee
                }

                if (_arbToken == 0) {
                        throw; // invalid token
                }

                if (arbTokenExists(_arbToken &amp; 0xffff)) {
                        throw; // Token Already Exists
                }

                if (arbiters[msg.sender].registered) {
                        throw; // Arb Already Registered
                }

                if (_numPlayers &gt; MAX_PLAYERS) {
                        throw; // Exceeds Max Players
                }

                if (_escFeePctX10 &lt; 20) {
                        throw; // less than 2% min escrow fee
                }

                if (_arbFeePctX10 &gt; 10) {
                        throw; // more than than 1% max arbiter fee
                }

                arbiters[msg.sender].locked = false;
                arbiters[msg.sender].numPlayers = uint8(_numPlayers);
                arbiters[msg.sender].escFeePctX10 = uint8(_escFeePctX10);
                arbiters[msg.sender].arbFeePctX10 = uint8(_arbFeePctX10);
                arbiters[msg.sender].arbToken = uint16(_arbToken &amp; 0xffff);
                arbiters[msg.sender].feeCap = uint128(_feeCap);
                arbiters[msg.sender].registered = true;

                arbiterTokens[(_arbToken &amp; 0xffff)] = msg.sender;
                arbiterIndexes[numArbiters++] = msg.sender;

                if (tokenPartner != address(0)) {
                        if (!tokenPartner.call.gas(tokCallGas).value(msg.value)()) {
                                //Statvent(&quot;Send Error&quot;); // event never registers
                                throw;
                        }
                } else {
                        houseFeeHoldover += msg.value;
                }
                StatEventI(&quot;Arb Added&quot;, _arbToken);
        }


        //------------------------------------------------------
        // start game.  pass in valid hGame containing token in top two bytes
        //------------------------------------------------------
        function startGame(uint _hGame, int _hkMax, address[] _players) public 

        {
                uint ntok = ArbTokFromHGame(_hGame);
                if (!validArb(msg.sender, ntok )) {
                        StatEvent(&quot;Invalid Arb&quot;);
                        return;
                }


                if (arbLocked(msg.sender)) {
                        StatEvent(&quot;Arb Locked&quot;);
                        return; 
                }

                arbiter xarb = arbiters[msg.sender];
                if (_players.length != xarb.numPlayers) { 
                        StatEvent(&quot;Incorrect num players&quot;);
                        return; 
                }

                gameInstance xgame = games[_hGame];
                if (xgame.active) {
                        // guard-rail. just in case to return funds
                        abortGame(_hGame, EndReason.erCancel);

                } else if (_hkMax &gt; 0) {
                        houseKeep(_hkMax, ntok); 
                }

                if (!xgame.allocd) {
                        xgame.allocd = true;
                        xarb.gameIndexes[xarb.gameSlots++] = _hGame;
                } 
                numGamesStarted++; // always inc this one

                xgame.active = true;
                xgame.lastMoved = now;
                xgame.totalPot = 0;
                xgame.numPlayers = xarb.numPlayers;
                for (uint i = 0; i &lt; _players.length; i++) {
                        xgame.players[i] = _players[i];
                        xgame.playerPots[i] = 0;
                }
                //StatEventI(&quot;Game Added&quot;, _hGame);
        }

        //------------------------------------------------------
        // clean up game, set to inactive, refund any balances
        // called by housekeep ONLY
        //------------------------------------------------------
        function abortGame(uint  _hGame, EndReason _reason) private returns(bool _success)
        {
                gameInstance xgame = games[_hGame];
             
                // find game in game id, 
                if (xgame.active) {
                        _success = true;
                        for (uint i = 0; i &lt; xgame.numPlayers; i++) {
                                if (xgame.playerPots[i] &gt; 0) {
                                        address a = xgame.players[i];
                                        uint nsend = xgame.playerPots[i];
                                        xgame.playerPots[i] = 0;
                                        if (!a.call.gas(acctCallGas).value(nsend)()) {
                                                houseFeeHoldover += nsend; // cannot refund due to error, give to the house
                                                StatEventA(&quot;Cannot Refund Address&quot;, a);
                                        }
                                }
                        }
                        xgame.active = false;
                        xgame.reasonEnded = _reason;
                        if (_reason == EndReason.erCancel) {
                                numGamesCanceled++;
                                StatEvent(&quot;Game canceled&quot;);
                        } else if (_reason == EndReason.erTimeOut) {
                                numGamesTimedOut++;
                                StatEvent(&quot;Game timed out&quot;);
                        } else 
                                StatEvent(&quot;Game aborted&quot;);
                }
        }


        //------------------------------------------------------
        // called by arbiter when winner is decided
        // *pass in high num for winnerbal for tie games
        //------------------------------------------------------
        function winnerDecided(uint _hGame, address _winner, uint _winnerBal) public
        {
                if (!validArb(msg.sender, ArbTokFromHGame(_hGame))) {
                        StatEvent(&quot;Invalid Arb&quot;);
                        return; // no throw no change made
                }

                var (valid, pidx) = validPlayer(_hGame, _winner);
                if (!valid) {
                        StatEvent(&quot;Invalid Player&quot;);
                        return;
                }

                arbiter xarb = arbiters[msg.sender];
                gameInstance xgame = games[_hGame];

                if (xgame.playerPots[pidx] &lt; _winnerBal) {
                    abortGame(_hGame, EndReason.erCancel);
                    return;
                }

                xgame.active = false;
                xgame.reasonEnded = EndReason.erWinner;
                numGamesCompleted++;

                if (xgame.totalPot &gt; 0) {
                        // calc payouts: escrowFee, arbiterFee, gasCost, winner payout
                        uint _escrowFee = (xgame.totalPot * xarb.escFeePctX10) / 1000;
                        uint _arbiterFee = (xgame.totalPot * xarb.arbFeePctX10) / 1000;
                        if ((_escrowFee + _arbiterFee) &gt; xarb.feeCap) {
                                _escrowFee = xarb.feeCap * xarb.escFeePctX10 / (xarb.escFeePctX10 + xarb.arbFeePctX10);
                                _arbiterFee = xarb.feeCap * xarb.arbFeePctX10 / (xarb.escFeePctX10 + xarb.arbFeePctX10);
                        }
                        uint _payout = xgame.totalPot - (_escrowFee + _arbiterFee);
                        uint _gasCost = tx.gasprice * (startGameGas + winnerDecidedGas);
                        if (_gasCost &gt; _payout)
                                _gasCost = _payout;
                        _payout -= _gasCost;

                        // do payouts
                        xarb.arbHoldover += uint128(_arbiterFee + _gasCost);
                        houseFeeHoldover += _escrowFee;

                        if ((houseFeeHoldover &gt; houseFeeThreshold)
                            &amp;&amp; (now &gt; (lastPayoutTime + payoutInterval))) {
                                uint ntmpho = houseFeeHoldover;
                                houseFeeHoldover = 0;
                                lastPayoutTime = now; // reset regardless of succeed/fail
                                if (!tokenPartner.call.gas(tokCallGas).value(ntmpho)()) {
                                        houseFeeHoldover = ntmpho; // put it back
                                        StatEvent(&quot;House-Fee Error1&quot;);
                                } 
                        }

                        if (_payout &gt; 0) {
                                if (!_winner.call.gas(acctCallGas).value(uint(_payout))()) {
                                        // if you cant pay the winner - very bad
                                        // StatEvent(&quot;Send Error&quot;);
                                        // add funds to houseFeeHoldover to avoid acounting errs
                                        //throw;
                                        houseFeeHoldover += _payout;
                                        StatEventI(&quot;Payout Error!&quot;, _hGame);
                                } else {
                                        //StatEventI(&quot;Winner Paid&quot;, _hGame);
                                }
                        }
                }
        }


        //------------------------------------------------------
        // handle a bet made by a player, validate the player and game
        // add to players balance
        //------------------------------------------------------
        function handleBet(uint _hGame) public payable 
        {
                address _arbAddr = arbiterTokens[ArbTokFromHGame(_hGame)];
                if (_arbAddr == address(0)) {
                        throw; // &quot;Invalid hGame&quot;
                }

                var (valid, pidx) = validPlayer(_hGame, msg.sender);
                if (!valid) {
                        throw; // &quot;Invalid Player&quot;
                }

                gameInstance xgame = games[_hGame];
                xgame.playerPots[pidx] += uint128(msg.value);
                xgame.totalPot += uint128(msg.value);
                //StatEventI(&quot;Bet Added&quot;, _hGame);
        }


        //------------------------------------------------------
        // return if arb token exists
        //------------------------------------------------------
        function arbTokenExists(uint _tok) constant returns (bool _exists)
        {
                _exists = false;
                if ((_tok &gt; 0)
                        &amp;&amp; (arbiterTokens[_tok] != address(0))
                        &amp;&amp; arbiters[arbiterTokens[_tok]].registered)
                        _exists = true;

        }


        //------------------------------------------------------
        // return arbiter game stats
        //------------------------------------------------------
        function getArbInfo(uint _tok) constant  returns (address _addr, uint _escFeePctX10, uint _arbFeePctX10, uint _feeCap, uint _holdOver) 
        {
                // if (arbiterTokens[_tok] != address(0)) {
                        _addr = arbiterTokens[_tok]; 
                         arbiter xarb = arbiters[arbiterTokens[_tok]];
                        _escFeePctX10 = xarb.escFeePctX10;
                        _arbFeePctX10 = xarb.arbFeePctX10;
                        _feeCap = xarb.feeCap;
                        _holdOver = xarb.arbHoldover; 
                // }
        }

        //------------------------------------------------------
        // scan for a game 10 minutes old
        // if found abort the game, causing funds to be returned
        //------------------------------------------------------
        function houseKeep(int _max, uint _arbToken) public
        {
                uint gi;
                address a;
                int aborted = 0;

                arbiter xarb = arbiters[msg.sender];// have to set it to something
                
         
                if (msg.sender == owner) {
                        for (uint ar = 0; (ar &lt; numArbiters) &amp;&amp; (aborted &lt; _max) ; ar++) {
                            a = arbiterIndexes[ar];
                            xarb = arbiters[a];    

                            for ( gi = 0; (gi &lt; xarb.gameSlots) &amp;&amp; (aborted &lt; _max); gi++) {
                                gameInstance ngame0 = games[xarb.gameIndexes[gi]];
                                if ((ngame0.active)
                                    &amp;&amp; ((now - ngame0.lastMoved) &gt; gameTimeOut)) {
                                        abortGame(xarb.gameIndexes[gi], EndReason.erTimeOut);
                                        ++aborted;
                                }
                            }
                        }

                } else {
                        if (!validArb(msg.sender, _arbToken))
                                StatEvent(&quot;Housekeep invalid arbiter&quot;);
                        else {
                            a = msg.sender;
                            xarb = arbiters[a];    
                            for (gi = 0; (gi &lt; xarb.gameSlots) &amp;&amp; (aborted &lt; _max); gi++) {
                                gameInstance ngame1 = games[xarb.gameIndexes[gi]];
                                if ((ngame1.active)
                                    &amp;&amp; ((now - ngame1.lastMoved) &gt; gameTimeOut)) {
                                        abortGame(xarb.gameIndexes[gi], EndReason.erTimeOut);
                                        ++aborted;
                                }
                            }

                        }
                }
        }


        //------------------------------------------------------
        // return game info
        //------------------------------------------------------
        function getGameInfo(uint _hGame)  constant  returns (EndReason _reason, uint _players, uint _totalPot, bool _active)
        {
                gameInstance xgame = games[_hGame];
                _active = xgame.active;
                _players = xgame.numPlayers;
                _totalPot = xgame.totalPot;
                _reason = xgame.reasonEnded;

        }

        //------------------------------------------------------
        // return arbToken and low bytes from an HGame
        //------------------------------------------------------
        function checkHGame(uint _hGame) constant returns(uint _arbTok, uint _lowWords)
        {
                _arbTok = ArbTokFromHGame(_hGame);
                _lowWords = _hGame &amp; 0xffffffffffff;

        }

        //------------------------------------------------------
        // get operation gas amounts
        //------------------------------------------------------
        function getOpGas() constant returns (uint _ag, uint _tg) 
        {
                _ag = acctCallGas; // winner paid
                _tg = tokCallGas;     // token contract call gas
        }


        //------------------------------------------------------
        // set operation gas amounts for forwading operations
        //------------------------------------------------------
        function setOpGas(uint _ag, uint _tg) 
        {
                if (msg.sender != owner)
                        throw;

                acctCallGas = _ag;
                tokCallGas = _tg;
        }


        //------------------------------------------------------
        // set a micheivous arbiter to locked
        //------------------------------------------------------
        function setArbiterLocked(address _addr, bool _lock)  public 
        {
                if (owner != msg.sender)  {
                        throw; 
                } else if (!validArb2(_addr)) {
                        StatEvent(&quot;invalid arb&quot;);
                } else {
                        arbiters[_addr].locked = _lock;
                }

        }

        //------------------------------------------------------
        // flush the house fees whenever commanded to.
        // ignore the threshold and the last payout time
        // but this time only reset lastpayouttime upon success
        //------------------------------------------------------
        function flushHouseFees()
        {
                if (msg.sender != owner) {
                        StatEvent(&quot;only owner calls this function&quot;);
                } else if (houseFeeHoldover &gt; 0) {
                        uint ntmpho = houseFeeHoldover;
                        houseFeeHoldover = 0;
                        if (!tokenPartner.call.gas(tokCallGas).value(ntmpho)()) {
                                houseFeeHoldover = ntmpho; // put it back
                                StatEvent(&quot;House-Fee Error2&quot;); 
                        } else {
                                lastPayoutTime = now;
                                StatEvent(&quot;House-Fee Paid&quot;);
                        }
                }
        }


        // ----------------------------
        // withdraw expense funds to arbiter
        // ----------------------------
        function withdrawArbFunds() public
        {
                if (!validArb2(msg.sender)) {
                        StatEvent(&quot;invalid arbiter&quot;);
                } else {
                        arbiter xarb = arbiters[msg.sender];
                        if (xarb.arbHoldover == 0) { 
                                StatEvent(&quot;0 Balance&quot;);
                                return;
                        } else {
                                uint _amount = xarb.arbHoldover; 
                                xarb.arbHoldover = 0; 
                                if (!msg.sender.call.gas(acctCallGas).value(_amount)())
                                        throw;
                        }
                }
        }


        //------------------------------------------------------
        // set the token partner
        //------------------------------------------------------
        function setTokenPartner(address _addr) public
        {
                if (msg.sender != owner) {
                        throw;
                } 

                if ((settingsState == SettingStateValue.lockedRelease) 
                        &amp;&amp; (tokenPartner == address(0))) {
                        tokenPartner = _addr;
                        StatEvent(&quot;Token Partner Final!&quot;);
                } else if (settingsState != SettingStateValue.lockedRelease) {
                        tokenPartner = _addr;
                        StatEvent(&quot;Token Partner Assigned!&quot;);
                }

        }

        // ----------------------------
        // swap executor
        // ----------------------------
        function changeOwner(address _addr) 
        {
                if (msg.sender != owner
                        || settingsState == SettingStateValue.lockedRelease)
                         throw;

                owner = _addr;
        }

}