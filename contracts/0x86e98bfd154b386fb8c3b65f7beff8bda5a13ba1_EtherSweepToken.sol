pragma solidity ^0.4.19;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c &gt;= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b &lt;= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b &gt; 0);
        c = a / b;
    }
}

contract ERC20Token {
    using SafeMath for uint;

    string public constant symbol = &quot;EBT&quot;;
    string public constant name = &quot;EtherSweep Token&quot;;
    uint8 public constant decimals = 9;
    uint public totalSupply = 0;
    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;

    function balanceOf(address tokenOwner) public constant returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(from, to, tokens);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract ICO is ERC20Token, Owned {
    uint private constant icoPart = 40;
    uint private constant priceStart =  300000000000000 wei;
    uint private constant priceEnd   = 1000000000000000 wei;
    uint private icoBegin;
    uint public icoEnd;

    function ICO(uint duration) public {
        icoBegin = now;
        icoEnd = icoBegin.add(duration);
    }

    function icoTokenPrice() public constant returns (uint) {
        require(now &lt;= icoEnd);
        return priceStart.add(priceEnd.sub(priceStart).mul(now.sub(icoBegin)).div(icoEnd.sub(icoBegin)));
    }

    function () public payable {
        require(now &lt;= icoEnd &amp;&amp; msg.value &gt; 0);
        uint coins = msg.value.mul(uint(10)**decimals).div(icoTokenPrice());
        totalSupply = totalSupply.add(coins.mul(100).div(icoPart));
        balances[msg.sender] = balances[msg.sender].add(coins);
        Transfer(address(0), msg.sender, coins);
        coins = coins.mul(100 - icoPart).div(icoPart);
        balances[owner] = balances[owner].add(coins);
        Transfer(address(0), owner, coins);
    }
}

contract EtherSweepToken is ICO {
    enum Winner {
        First, Draw, Second, Cancelled, None
    }

    struct BetEvent {
        uint from;
        uint until;
        string category;
        string tournament;
        string player1;
        string player2;
        bool drawAllowed;
        Winner winner;
    }

    struct Bet {
        address user;
        Winner winner;
        uint amount;
    }

    uint8 public constant comission = 5;
    uint public reserved = 0;
    BetEvent[] public betEvents;
    mapping(uint =&gt; Bet[]) public bets;

    function EtherSweepToken() public ICO(60*60*24*30) {
    }

    function availableBalance() public constant returns (uint) {
        return this.balance.sub(reserved);
    }

    function withdraw(uint amount) public {
        require(amount &gt; 0);
        var toTransfer = amount.mul(availableBalance()).div(totalSupply);
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply = totalSupply.sub(amount);
        msg.sender.transfer(toTransfer);
    }

    function betOpen(uint duration, string category, string tournament, string player1, string player2, bool drawAllowed) public onlyOwner {
        betEvents.push(BetEvent(now, now.add(duration), category, tournament, player1, player2, drawAllowed, Winner.None));
    }

    function getEventBanks(uint eventId) public constant returns (uint[3] banks) {
        require(eventId &lt; betEvents.length);
        for (uint i = 0; i &lt; bets[eventId].length; i++) {
            Bet storage bet = bets[eventId][i];
            banks[uint(bet.winner)] = banks[uint(bet.winner)].add(bet.amount);
        }
    }

    function betFinalize(uint eventId, Winner winner) public onlyOwner {
        BetEvent storage betEvent = betEvents[eventId];
        require(winner &lt; Winner.None &amp;&amp; betEvent.winner == Winner.None &amp;&amp; ((winner != Winner.Draw) || betEvent.drawAllowed) &amp;&amp; eventId &lt; betEvents.length &amp;&amp; now &gt; betEvent.until);
        betEvent.winner = winner;
        uint[3] memory banks = getEventBanks(eventId);
        reserved = reserved.sub(banks[0]).sub(banks[1]).sub(banks[2]);
        if (winner == Winner.Cancelled) {
            for (uint i = 0; i &lt; bets[eventId].length; i++) {
                Bet storage bet = bets[eventId][i];
                bet.user.transfer(bet.amount);
            }
        } else {
            uint loserBank = banks[0].add(banks[1]).add(banks[2]).sub(banks[uint(winner)]).mul(100 - comission).div(100);
            uint winnerBank = banks[uint(winner)];
    
            for (i = 0; i &lt; bets[eventId].length; i++) {
                bet = bets[eventId][i];
                if (bet.winner == winner) {
                    bet.user.transfer(bet.amount.add(bet.amount.mul(loserBank).div(winnerBank)));
                }
            }
        }
    }

    function betMake(uint eventId, Winner winner) public payable {
        require(winner != Winner.Cancelled &amp;&amp; winner &lt; Winner.None &amp;&amp; ((winner != Winner.Draw) || betEvents[eventId].drawAllowed) &amp;&amp; msg.value &gt; 0 &amp;&amp; eventId &lt; betEvents.length &amp;&amp; now &lt;= betEvents[eventId].until);
        bets[eventId].push(Bet(msg.sender, winner, msg.value));
        reserved = reserved.add(msg.value);
    }

    function getEvents(uint from, string category, uint mode) public constant returns (uint cnt, uint[20] res) {
        require(mode &lt; 3 &amp;&amp; from &lt;= betEvents.length);
        bytes32 categoryHash = keccak256(category);
        cnt = 0;
        for (int i = int(from == 0 ? betEvents.length : from)-1; i &gt;= 0; i--) {
            uint index = uint(i);
            if ((mode == 0 ? betEvents[index].until &gt;= now : (mode == 1 ? betEvents[index].until &lt; now &amp;&amp; betEvents[index].winner == Winner.None : (mode == 2 ? betEvents[index].winner != Winner.None : false))) &amp;&amp; (keccak256(betEvents[index].category) == categoryHash)) {
                res[cnt++] = index;
                if (cnt == res.length) break;
            }
        }
    }

    function getEventsCount() public constant returns (uint) {
        return betEvents.length;
    }
}