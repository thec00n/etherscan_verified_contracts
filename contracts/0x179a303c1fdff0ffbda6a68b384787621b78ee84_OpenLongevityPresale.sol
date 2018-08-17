/*
This file is part of the Open Longevity Contract.

The Open Longevity Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Open Longevity Contract is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the Open Longevity Contract. If not, see &lt;http://www.gnu.org/licenses/&gt;.

@author Ilya Svirin &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="9cf5b2efeaf5eef5f2dcf2f3eef8fdeaf5f2f8b2eee9">[email&#160;protected]</a>&gt;
*/


pragma solidity ^0.4.10;

contract owned {

    address public owner;
    address public newOwner;

    function owned() public payable {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address _owner) onlyOwner public {
        require(_owner != 0);
        newOwner = _owner;
    }
    
    function confirmOwner() public {
        require(newOwner == msg.sender);
        owner = newOwner;
        delete newOwner;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
    uint public totalSupply;
    function balanceOf(address who) public constant returns (uint);
    function transfer(address to, uint value) public ;
    function allowance(address owner, address spender) public constant returns (uint);
    function transferFrom(address from, address to, uint value) public;
    function approve(address spender, uint value) public;
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
}

contract PresaleOriginal is owned, ERC20 {

    uint    public totalLimitUSD;
    uint    public collectedUSD;
    uint    public presaleStartTime;

    struct Investor {
        uint256 amountTokens;
        uint    amountWei;
    }
    mapping (address =&gt; Investor) public investors;
    mapping (uint =&gt; address)     public investorsIter;
    uint                          public numberOfInvestors;
}

contract Presale is PresaleOriginal {

    uint    public etherPrice;
    address public presaleOwner;

    enum State { Disabled, Presale, Finished }
    event NewState(State state);
    State   public state;
    uint    public presaleFinishTime;

    uint    public migrationCounter;

    function migrate(address _originalContract, uint n) public onlyOwner {
        require(state == State.Disabled);
        
        // migrate tokens with x2 bonus
        numberOfInvestors = PresaleOriginal(_originalContract).numberOfInvestors();
        uint limit = migrationCounter + n;
        if(limit &gt; numberOfInvestors) {
            limit = numberOfInvestors;
        }
        for(; migrationCounter &lt; limit; ++migrationCounter) {
            address a = PresaleOriginal(_originalContract).investorsIter(migrationCounter);
            investorsIter[migrationCounter] = a;
            uint256 amountTokens;
            uint amountWei;
            (amountTokens, amountWei) = PresaleOriginal(_originalContract).investors(a);
            amountTokens *= 2;
            investors[a].amountTokens = amountTokens;
            investors[a].amountWei = amountWei;
            totalSupply += amountTokens;
            Transfer(_originalContract, a, amountTokens);
        }
        if(limit &lt; numberOfInvestors) {
            return;
        }

        // migrate main parameters
        presaleStartTime = PresaleOriginal(_originalContract).presaleStartTime();
        collectedUSD = PresaleOriginal(_originalContract).collectedUSD();
        totalLimitUSD = PresaleOriginal(_originalContract).totalLimitUSD();

        // add extra tokens for bounty
        address bountyAddress = 0x59B95A5e0268Cc843e6308FEf723544BaA6676c6;
        if(investors[bountyAddress].amountWei == 0 &amp;&amp; investors[bountyAddress].amountTokens == 0) {
            investorsIter[numberOfInvestors++] = bountyAddress;
        }
        uint bountyTokens = 5 * PresaleOriginal(_originalContract).totalSupply() / 100;
        investors[bountyAddress].amountTokens += bountyTokens;
        totalSupply += bountyTokens;
    }

    function () payable public {
        require(state == State.Presale);
        require(now &lt; presaleFinishTime);

        uint valueWei = msg.value;
        uint valueUSD = valueWei * etherPrice / 1000000000000000000;
        if (collectedUSD + valueUSD &gt; totalLimitUSD) { // don&#39;t need so much ether
            valueUSD = totalLimitUSD - collectedUSD;
            valueWei = valueUSD * 1000000000000000000 / etherPrice;
            require(msg.sender.call.gas(3000000).value(msg.value - valueWei)());
            collectedUSD = totalLimitUSD; // to be sure!
        } else {
            collectedUSD += valueUSD;
        }

        uint256 tokensPer10USD = 130;
        if (valueUSD &gt;= 100000) {
            tokensPer10USD = 150;
        }

        uint256 tokens = tokensPer10USD * valueUSD / 10;
        require(tokens &gt; 0);

        Investor storage inv = investors[msg.sender];
        if (inv.amountWei == 0) { // new investor
            investorsIter[numberOfInvestors++] = msg.sender;
        }
        require(inv.amountTokens + tokens &gt; inv.amountTokens); // overflow
        inv.amountTokens += tokens;
        inv.amountWei += valueWei;
        totalSupply += tokens;
        Transfer(this, msg.sender, tokens);
    }
    
    function startPresale(address _presaleOwner, uint _etherPrice) public onlyOwner {
        require(state == State.Disabled);
        presaleOwner = _presaleOwner;
        etherPrice = _etherPrice;
        presaleFinishTime = 1526342400; // (GMT) 15 May 2018, 00:00:00
        state = State.Presale;
        totalLimitUSD = 500000;
        NewState(state);
    }

    function setEtherPrice(uint _etherPrice) public onlyOwner {
        require(state == State.Presale);
        etherPrice = _etherPrice;
    }
    
    function timeToFinishPresale() public constant returns(uint t) {
        require(state == State.Presale);
        if (now &gt; presaleFinishTime) {
            t = 0;
        } else {
            t = presaleFinishTime - now;
        }
    }
    
    function finishPresale() public onlyOwner {
        require(state == State.Presale);
        require(now &gt;= presaleFinishTime || collectedUSD == totalLimitUSD);
        require(presaleOwner.call.gas(3000000).value(this.balance)());
        state = State.Finished;
        NewState(state);
    }
    
    function withdraw() public onlyOwner {
        require(presaleOwner.call.gas(3000000).value(this.balance)());
    }
}

contract PresaleToken is Presale {
    
    string  public standard    = &#39;Token 0.1&#39;;
    string  public name        = &#39;OpenLongevity&#39;;
    string  public symbol      = &quot;YEAR&quot;;
    uint8   public decimals    = 0;

    mapping (address =&gt; mapping (address =&gt; uint)) public allowed;

    // Fix for the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        require(msg.data.length &gt;= size + 4);
        _;
    }

    function PresaleToken() payable public Presale() {}

    function balanceOf(address _who) constant public returns (uint) {
        return investors[_who].amountTokens;
    }

    function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) {
        require(investors[msg.sender].amountTokens &gt;= _value);
        require(investors[_to].amountTokens + _value &gt;= investors[_to].amountTokens);
        investors[msg.sender].amountTokens -= _value;
        if(investors[_to].amountTokens == 0 &amp;&amp; investors[_to].amountWei == 0) {
            investorsIter[numberOfInvestors++] = _to;
        }
        investors[_to].amountTokens += _value;
        Transfer(msg.sender, _to, _value);
    }
    
    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
        require(investors[_from].amountTokens &gt;= _value);
        require(investors[_to].amountTokens + _value &gt;= investors[_to].amountTokens); // overflow
        require(allowed[_from][msg.sender] &gt;= _value);
        investors[_from].amountTokens -= _value;
        if(investors[_to].amountTokens == 0 &amp;&amp; investors[_to].amountWei == 0) {
            investorsIter[numberOfInvestors++] = _to;
        }
        investors[_to].amountTokens += _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
    }

    function approve(address _spender, uint _value) public {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public constant
        returns (uint remaining) {
        return allowed[_owner][_spender];
    }
}

contract OpenLongevityPresale is PresaleToken {

    function OpenLongevityPresale() payable public PresaleToken() {}

    function killMe() public onlyOwner {
        selfdestruct(owner);
    }
}