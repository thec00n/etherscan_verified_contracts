pragma solidity ^0.4.13;

contract Privileges {
    // A person who owns the contract
    address public owner;
    // A person who can update the CENT price
    address public trusted;

    function Privileges() public payable {
        owner = msg.sender;
    }

    function setTrusted(address addr) onlyOwner public {
        trusted = addr;
    }

    function setNewOwner(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyTrusted {
        require(msg.sender == trusted || msg.sender == owner);
        _;
    }
}

contract SafeMath {
    function safeAdd(uint x, uint y) internal pure returns (uint) {
        uint256 z = x + y;
        assert((z &gt;= x) &amp;&amp; (z &gt;= y));
        return z;
    }

    function safeSub(uint x, uint y) internal pure returns (uint) {
        assert(x &gt;= y);
        uint256 z = x - y;
        return z;
    }

    function safeMul(uint x, uint y) internal pure returns (uint) {
        uint256 z = x * y;
        assert((x == 0)||(z/x == y));
        return z;
    }

    function safeDiv(uint a, uint b) internal pure returns (uint) {
        uint c = a / b;
        return c;
    }
}

contract Presale {

    uint numberOfPurchasers = 0;

    mapping (uint =&gt; address) presaleAddresses;
    mapping (address =&gt; uint) tokensToSend;

    function Presale() public {
        addPurchaser(0x41c8f018d10f500d231f723017389da5FF9F45F2, 191625 * ((1 ether / 1 wei) / 10));      
    }

    function addPurchaser(address addr, uint tokens) private {
        presaleAddresses[numberOfPurchasers] = addr;
        tokensToSend[addr] = tokens;
        numberOfPurchasers++;
    }

}

contract Casper is SafeMath, Privileges, Presale {    

    string public constant NAME = &quot;Casper Pre-ICO Token&quot;;
    string public constant SYMBOL = &quot;CSPT&quot;;
    uint public constant DECIMALS = 18;

    uint public constant MIN_PRICE = 750; // 600USD per Ether
    uint public constant MAX_PRICE = 1250; // 1000USD per Ether
    uint public price = 1040;  // 832USD per Ehter
    uint public totalSupply = 0;

    // PreICO hard cap
    uint public constant TOKEN_SUPPLY_LIMIT = 1300000 * (1 ether / 1 wei); // 1 300 000 CSPT

    // PreICO timings
    uint public beginTime;
    uint public endTime;

    uint public index = 0;

    bool sendPresale = true;

    mapping (address =&gt; uint) balances;
    mapping (uint =&gt; address) participants;


    function Casper() Privileges() public {
        beginTime = now;
        endTime = now + 2 weeks;
    }

    function() payable public {
        require (now &lt; endTime);
        require (totalSupply &lt; TOKEN_SUPPLY_LIMIT);
        uint newTokens = msg.value * price;
        if (newTokens + totalSupply &lt;= TOKEN_SUPPLY_LIMIT) {
            balances[msg.sender] = safeAdd(balances[msg.sender], newTokens);
            totalSupply = safeAdd(totalSupply, newTokens);    
        } else {
            uint tokens = safeSub(TOKEN_SUPPLY_LIMIT, totalSupply); 
            balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
            totalSupply = TOKEN_SUPPLY_LIMIT;
        }
        addParicipant(msg.sender);
    }

    function balanceOf(address addr) public constant returns (uint) {
        return balances[addr];
    }

    function setPrice(uint newPrice) onlyTrusted public {
        require (newPrice &gt; MIN_PRICE &amp;&amp; newPrice &lt; MAX_PRICE);
        price = newPrice;
    }

    function sendPresaleTokens() onlyOwner public {
        require(sendPresale);
        for (uint i = 0; i &lt; numberOfPurchasers; i++) {
            address addr = presaleAddresses[i];
            uint tokens = tokensToSend[addr];
            balances[addr] = tokens;
            totalSupply = safeAdd(totalSupply, tokens);  
        }
        index = safeAdd(index, numberOfPurchasers);
        sendPresale = false;
    }

    function withdrawEther(uint eth) onlyOwner public {
        owner.transfer(eth);
    }

    function addParicipant(address addr) private {
        participants[index] = addr;
        index++;
    }

}