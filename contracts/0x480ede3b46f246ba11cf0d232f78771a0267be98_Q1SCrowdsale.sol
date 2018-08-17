pragma solidity ^0.4.16;

interface Token {
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
}

contract Q1SCrowdsale {
    
    Token public tokenReward;
    address public creator;
    address public owner =  0xc02E86c673DD62F8Bb1927e16820Ae09D6744da7;

    uint256 public price;
    uint256 public startDate;
    uint256 public endDate;

    event FundTransfer(address backer, uint amount, bool isContribution);

    function Q1SCrowdsale() public {
        creator = msg.sender;
        startDate = 1517184000;
        endDate = 1520035200;
        price = 1000;
        tokenReward = Token(0xBeEbcFe2fbb3c72884341BE2B73aE0FC6559B8Fc);
    }

    function setOwner(address _owner) public {
        require(msg.sender == creator);
        owner = _owner;      
    }

    function setCreator(address _creator) public {
        require(msg.sender == creator);
        creator = _creator;      
    }

    function setStartDate(uint256 _startDate) public {
        require(msg.sender == creator);
        startDate = _startDate;      
    }

    function setEndtDate(uint256 _endDate) public {
        require(msg.sender == creator);
        endDate = _endDate;      
    }
    
    function setPrice(uint256 _price) public {
        require(msg.sender == creator);
        price = _price;      
    }

    function setToken(address _token) public {
        require(msg.sender == creator);
        tokenReward = Token(_token);      
    }
    
    function kill() public {
        require(msg.sender == creator);
        selfdestruct(owner);
    }

    function () payable public {
        require(msg.value &gt; 0);
        require(now &gt; startDate);
        require(now &lt; endDate);
	    uint amount = msg.value * price;
        uint _amount = amount / 20;

        // period 1 : 40%
        if(now &gt; 1517184000 &amp;&amp; now &lt; 1517529601) {
            amount += _amount * 8;
        }
        
        // period 1 : 20%
        if(now &gt; 1517529600 &amp;&amp; now &lt; 1518134401) {
            amount += _amount * 4;
        }

        // Pperiod 2 : 15%
        if(now &gt; 1518134400 &amp;&amp; now &lt; 1518652801) {
            amount += _amount * 3;
        }

        // period 3 : 10%
        if(now &gt; 1518652800 &amp;&amp; now &lt; 1519257601) {
            amount += _amount * 2;
        }

        // period 4 : 5%
        if(now &gt; 1519257600 &amp;&amp; now &lt; 1519862401) {
            amount += _amount;
        }

        // period 5 : 0%
        if(now &gt; 1519862400 &amp;&amp; now &lt; 1520035200) {
            amount += _amount;
        }

        tokenReward.transferFrom(owner, msg.sender, amount);
        FundTransfer(msg.sender, amount, true);
        owner.transfer(msg.value);
    }
}