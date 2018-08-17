/**
Contract interface:
- Standars ERC20 methods: balanceOf, totalSupply, transfer, transferFrom, approve, allowance
- Function issue, argument amount
    issue new amount coins to totalSupply
- Function destroy, argument amount
    remove amount coins from totalSupply if available in contract
    used only by contract owner
- Function sell - argument amount, to
    Used only by contract owner
    Send amount coins to address to
- Function kill
    Used only by contract owner
    destroy cantract
    Contract can be destroyed if totalSupply is empty and all wallets are empty
- Function setTransferFee arguments numinator, denuminator
    Used only by contract owner
    set transfer fee to numinator/denuminator
- Function changeTransferFeeOwner, argument address 
    Used only by contract owner
    change transfer fees recipient to address
- Function sendDividends, arguments address, amount
    Used only by contract owner
    address - ERC20 address
    issue dividends to investors - amount is tokens
- Function sendDividendsEthers
    Used only by contract owner
    issue ether dividends to investors
- Function addInvestor, argument - address
    Used only by contract owner
    add address to investors list (to paying dividends in future)
- Function removeInvestor, argument - address
    Used only by contract owner
    remove address from investors list (to not pay dividends in future)
- Function getDividends
    Used by investor to actual receive dividend coins
- Function changeRate, argument new_rate
    Change coin/eth rate for autosell
- Function changeMinimalWei, argument new_wei
    Used only by contract owner
    Change minimal wei amount to sell coins wit autosell
*/

pragma solidity ^0.4.11;

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

//contract PDT is PDT {
contract PDT {
    using SafeMath for uint256;

    // totalSupply is zero by default, owner can issue and destroy coins any amount any time
    uint constant totalSupplyDefault = 0;

    string public constant symbol = &quot;PDT&quot;;
    string public constant name = &quot;Prime Donor Token&quot;;
    uint8 public constant decimals = 5;

    uint public totalSupply = 0;

    // minimum fee is 0.00001
    uint32 public constant minFee = 1;
    // transfer fee default = 0.17% (0.0017)
    uint32 public transferFeeNum = 17;
    uint32 public transferFeeDenum = 10000;

    uint32 public constant minTransfer = 10;

    // coin exchange rate to eth for automatic sell
    uint256 public rate = 1000;

    // minimum ether amount to buy
    uint256 public minimalWei = 1 finney;

    // wei raised in automatic sale
    uint256 public weiRaised;

    //uint256 public payedDividends;
    //uint256 public dividends;
    address[] tokens;

    // Owner of this contract
    address public owner;
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
    address public transferFeeOwner;

    function notOwner(address addr) internal view returns (bool) {
        return addr != address(this) &amp;&amp; addr != owner &amp;&amp; addr != transferFeeOwner;
    }


    // ---------------------------- dividends related definitions --------------------
    // investors white list
    // dividends can be send only investors from list
    mapping(address =&gt; bool) public investors;

    // minimal coin balance to pay dividends
    uint256 public constant investorMinimalBalance = uint256(10000)*(uint256(10)**decimals);

    uint256 public investorsTotalSupply;

    uint constant MULTIPLIER = 10e18;

    // dividends for custom coins
    mapping(address=&gt;mapping(address=&gt;uint256)) lastDividends;
    mapping(address=&gt;uint256) totalDividendsPerCoin;

    // dividends for custom ethers
    mapping(address=&gt;uint256) lastEthers;
    uint256 divEthers;

/*
    function balanceEnough(uint256 amount) internal view returns (bool) {
        return balances[this] &gt;= dividends &amp;&amp; balances[this] - dividends &gt;= amount;
    }
    */

    function activateDividendsCoins(address account) internal {
        for (uint i = 0; i &lt; tokens.length; i++) {
            address addr = tokens[i];
            if (totalDividendsPerCoin[addr] != 0 &amp;&amp; totalDividendsPerCoin[addr] &gt; lastDividends[addr][account]) {
                if (investors[account] &amp;&amp; balances[account] &gt;= investorMinimalBalance) {
                    var actual = totalDividendsPerCoin[addr] - lastDividends[addr][account];
                    var divs = (balances[account] * actual) / MULTIPLIER;
                    Debug(divs, account, &quot;divs&quot;);

                    ERC20 token = ERC20(addr);
                    if (divs &gt; 0 &amp;&amp; token.balanceOf(this) &gt;= divs) {
                        token.transfer(account, divs);
                        lastDividends[addr][account] = totalDividendsPerCoin[addr];
                    }
                }
                lastDividends[addr][account] = totalDividendsPerCoin[addr];
            }
        }
    }

    function activateDividendsEthers(address account) internal {
        if (divEthers != 0 &amp;&amp; divEthers &gt; lastEthers[account]) {
            if (investors[account] &amp;&amp; balances[account] &gt;= investorMinimalBalance) {
                var actual = divEthers - lastEthers[account];
                var divs = (balances[account] * actual) / MULTIPLIER;
                Debug(divs, account, &quot;divsEthers&quot;);

                require(divs &gt; 0 &amp;&amp; this.balance &gt;= divs);
                account.transfer(divs);
                lastEthers[account] = divEthers;
            }
            lastEthers[account] = divEthers;
        }
    }

    function activateDividends(address account) internal {
        activateDividendsCoins(account);
        activateDividendsEthers(account);
    }

    function activateDividends(address account1, address account2) internal {
        activateDividends(account1);
        activateDividends(account2);
    }

    function addInvestor(address investor) public onlyOwner {
        activateDividends(investor);
        investors[investor] = true;
        if (balances[investor] &gt;= investorMinimalBalance) {
            investorsTotalSupply = investorsTotalSupply.add(balances[investor]);
        }
    }
    function removeInvestor(address investor) public onlyOwner {
        activateDividends(investor);
        investors[investor] = false;
        if (balances[investor] &gt;= investorMinimalBalance) {
            investorsTotalSupply = investorsTotalSupply.sub(balances[investor]);
        }
    }

    function sendDividends(address token_address, uint256 amount) public onlyOwner {
        require (token_address != address(this)); // do not send this contract for dividends
        require(investorsTotalSupply &gt; 0); // investor capital must exists to pay dividends
        ERC20 token = ERC20(token_address);
        require(token.balanceOf(this) &gt; amount);

        totalDividendsPerCoin[token_address] = totalDividendsPerCoin[token_address].add(amount.mul(MULTIPLIER).div(investorsTotalSupply));

        // add tokens to the set
        uint idx = tokens.length;
        for(uint i = 0; i &lt; tokens.length; i++) {
            if (tokens[i] == token_address || tokens[i] == address(0x0)) {
                idx = i;
                break;
            }
        }
        if (idx == tokens.length) {
            tokens.length += 1;
        }
        tokens[idx] = token_address;
    }

    function sendDividendsEthers() public payable onlyOwner {
        require(investorsTotalSupply &gt; 0); // investor capital must exists to pay dividends
        divEthers = divEthers.add((msg.value).mul(MULTIPLIER).div(investorsTotalSupply));
    }

    function getDividends() public {
        // Any investor can call this function in a transaction to receive dividends
        activateDividends(msg.sender);
    }
    // -------------------------------------------------------------------------------
 
    // Balances for each account
    mapping(address =&gt; uint) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping(address =&gt; mapping (address =&gt; uint)) allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from , address indexed to , uint256 value);
    event TransferFee(address indexed to , uint256 value);
    event TokenPurchase(address indexed from, address indexed to, uint256 value, uint256 amount);
    event Debug(uint256 from, address to, string value);

    function transferBalance(address from, address to, uint256 amount) internal {
        if (from != address(0x0)) {
            require(balances[from] &gt;= amount);
            if (notOwner(from) &amp;&amp; investors[from] &amp;&amp; balances[from] &gt;= investorMinimalBalance) {
                if (balances[from] - amount &gt;= investorMinimalBalance) {
                    investorsTotalSupply = investorsTotalSupply.sub(amount);
                } else {
                    investorsTotalSupply = investorsTotalSupply.sub(balances[from]);
                }
            }
            balances[from] = balances[from].sub(amount);
        }
        if (to != address(0x0)) {
            balances[to] = balances[to].add(amount);
            if (notOwner(to) &amp;&amp; investors[to] &amp;&amp; balances[to] &gt;= investorMinimalBalance) {
                if (balances[to] - amount &gt;= investorMinimalBalance) {
                    investorsTotalSupply = investorsTotalSupply.add(amount);
                } else {
                    investorsTotalSupply = investorsTotalSupply.add(balances[to]);
                }
            }
        }
    }

    // if supply provided is 0, then default assigned
    function PDT(uint supply) public {
        if (supply &gt; 0) {
            totalSupply = supply;
        } else {
            totalSupply = totalSupplyDefault;
        }
        owner = msg.sender;
        transferFeeOwner = owner;
        balances[this] = totalSupply;
    }

    function changeTransferFeeOwner(address addr) onlyOwner public {
        transferFeeOwner = addr;
    }
 
    function balanceOf(address addr) constant public returns (uint) {
        return balances[addr];
    }

    // fee is not applied to owner and transferFeeOwner
    function chargeTransferFee(address addr, uint amount)
        internal returns (uint) {
        activateDividends(addr);
        if (notOwner(addr) &amp;&amp; balances[addr] &gt; 0) {
            var fee = amount * transferFeeNum / transferFeeDenum;
            if (fee &lt; minFee) {
                fee = minFee;
            } else if (fee &gt; balances[addr]) {
                fee = balances[addr];
            }
            amount = amount - fee;

            transferBalance(addr, transferFeeOwner, fee);
            Transfer(addr, transferFeeOwner, fee);
            TransferFee(addr, fee);
        }
        return amount;
    }
 
    function transfer(address to, uint amount)
        public returns (bool) {
        activateDividends(msg.sender, to);
        //activateDividendsFunc(to);
        if (amount &gt;= minTransfer
            &amp;&amp; balances[msg.sender] &gt;= amount
            &amp;&amp; balances[to] + amount &gt; balances[to]
            ) {
                if (balances[msg.sender] &gt;= amount) {
                    amount = chargeTransferFee(msg.sender, amount);

                    transferBalance(msg.sender, to, amount);
                    Transfer(msg.sender, to, amount);
                }
                return true;
          } else {
              return false;
          }
    }
 
    function transferFrom(address from, address to, uint amount)
        public returns (bool) {
        activateDividends(from, to);
        //activateDividendsFunc(to);
        if ( amount &gt;= minTransfer
            &amp;&amp; allowed[from][msg.sender] &gt;= amount
            &amp;&amp; balances[from] &gt;= amount
            &amp;&amp; balances[to] + amount &gt; balances[to]
            ) {
                allowed[from][msg.sender] -= amount;

                if (balances[from] &gt;= amount) {
                    amount = chargeTransferFee(from, amount);

                    transferBalance(from, to, amount);
                    Transfer(from, to, amount);
                }
                return true;
        } else {
            return false;
        }
    }
 
    function approve(address spender, uint amount) public returns (bool) {
        allowed[msg.sender][spender] = amount;
        Approval(msg.sender, spender, amount);
        return true;
    }
 
    function allowance(address addr, address spender) constant public returns (uint) {
        return allowed[addr][spender];
    }

    function setTransferFee(uint32 numinator, uint32 denuminator) onlyOwner public {
        require(denuminator &gt; 0 &amp;&amp; numinator &lt; denuminator);
        transferFeeNum = numinator;
        transferFeeDenum = denuminator;
    }

    // Manual sell
    function sell(address to, uint amount) onlyOwner public {
        activateDividends(to);
        //require(amount &gt;= minTransfer &amp;&amp; balanceEnough(amount));
        require(amount &gt;= minTransfer);

        transferBalance(this, to, amount);
        Transfer(this, to, amount);
    }

    // issue new coins
    function issue(uint amount) onlyOwner public {
        totalSupply = totalSupply.add(amount);
        balances[this] = balances[this].add(amount);
    }

    function changeRate(uint256 new_rate) public onlyOwner {
        require(new_rate &gt; 0);
        rate = new_rate;
    }

    function changeMinimalWei(uint256 new_wei) public onlyOwner {
        minimalWei = new_wei;
    }

    // buy for ethereum
    function buyTokens(address addr)
        public payable {
        activateDividends(msg.sender);
        uint256 weiAmount = msg.value;
        require(weiAmount &gt;= minimalWei);
        //uint256 tkns = weiAmount.mul(rate) / 1 ether * (uint256(10)**decimals);
        uint256 tkns = weiAmount.mul(rate).div(1 ether).mul(uint256(10)**decimals);
        require(tkns &gt; 0);

        weiRaised = weiRaised.add(weiAmount);

        transferBalance(this, addr, tkns);
        TokenPurchase(this, addr, weiAmount, tkns);
        owner.transfer(msg.value);
    }

    // destroy existing coins
    // TOD: not destroy dividends tokens
    function destroy(uint amount) onlyOwner public {
          //require(amount &gt; 0 &amp;&amp; balanceEnough(amount));
          require(amount &gt; 0);
          transferBalance(this, address(0x0), amount);
          totalSupply -= amount;
    }

    function () payable public {
        buyTokens(msg.sender);
    }

    // kill contract only if all wallets are empty
    function kill() onlyOwner public {
        require (totalSupply == 0);
        selfdestruct(owner);
    }
}