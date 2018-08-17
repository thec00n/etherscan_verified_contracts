pragma solidity ^0.4.16;

interface Token {
    function transfer(address _to, uint256 _value) external;
}

contract TBECrowdsale {
    
    Token public tokenReward;
    uint256 public price;
    address public creator;
    address public owner = 0x7a30DE07DC5469d7A5115b8b5F44305CDE9101D5;
    uint256 public startDate;
    uint256 public endDate;
    uint256 public bonusDate;
    uint256 public tokenCap;

    mapping (address =&gt; bool) public whitelist;
    mapping (address =&gt; uint256) public whitelistedMax;
    mapping (address =&gt; bool) public categorie1;
    mapping (address =&gt; bool) public categorie2;
    mapping (address =&gt; bool) public tokenAddress;
    mapping (address =&gt; uint256) public balanceOfEther;
    mapping (address =&gt; uint256) public balanceOf;

    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    event FundTransfer(address backer, uint amount, bool isContribution);

    function TBECrowdsale() public {
        creator = msg.sender;
        price = 8000;
        startDate = now;
        endDate = startDate + 30 days;
        bonusDate = startDate + 5 days;
        tokenCap = 2400000000000000000000;
        tokenReward = Token(0x647972c6A5bD977Db85dC364d18cC05D3Db70378);
    }



    function setOwner(address _owner) isCreator public {
        owner = _owner;      
    }

    function setCreator(address _creator) isCreator public {
        creator = _creator;      
    }

    function setStartDate(uint256 _startDate) isCreator public {
        startDate = _startDate;      
    }

    function setEndtDate(uint256 _endDate) isCreator public {
        endDate = _endDate;      
    }
    
    function setbonusDate(uint256 _bonusDate) isCreator public {
        bonusDate = _bonusDate;      
    }
    function setPrice(uint256 _price) isCreator public {
        price = _price;      
    }
     function settokenCap(uint256 _tokenCap) isCreator public {
        tokenCap = _tokenCap;      
    }

    function addToWhitelist(address _address) isCreator public {
        whitelist[_address] = true;
    }

    function addToCategorie1(address _address) isCreator public {
        categorie1[_address] = true;
    }

    function addToCategorie2(address _address) isCreator public {
        categorie2[_address] = true;
    }

    function setToken(address _token) isCreator public {
        tokenReward = Token(_token);      
    }

    function sendToken(address _to, uint256 _value) isCreator public {
        tokenReward.transfer(_to, _value);      
    }

    function kill() isCreator public {
        selfdestruct(owner);
    }

    function () payable public {
        require(msg.value &gt; 0);
        require(now &gt; startDate);
        require(now &lt; endDate);
        require(whitelist[msg.sender]);
        
        if (categorie1[msg.sender] == false) {
            require((whitelistedMax[msg.sender] +  msg.value) &lt;= 200000000000000000);
        }

        uint256 amount = msg.value * price;

        if (now &gt; startDate &amp;&amp; now &lt;= bonusDate) {
            uint256 _amount = amount / 10;
            amount += _amount * 3;
        }

        balanceOfEther[msg.sender] += msg.value / 1 ether;
        tokenReward.transfer(msg.sender, amount);
        whitelistedMax[msg.sender] = whitelistedMax[msg.sender] + msg.value;
        FundTransfer(msg.sender, amount, true);
        owner.transfer(msg.value);
    }
}