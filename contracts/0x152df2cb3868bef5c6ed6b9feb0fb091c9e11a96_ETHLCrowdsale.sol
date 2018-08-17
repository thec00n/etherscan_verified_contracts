pragma solidity ^0.4.16;

interface Token {
    function transfer(address _to, uint256 _value) external;
}

contract ETHLCrowdsale {
    
    Token public tokenReward;
    address public creator;
    address public owner = 0x0;

    uint256 private tokenSold;

    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    event FundTransfer(address backer, uint amount, bool isContribution);

    function ETHLCrowdsale() public {
        creator = msg.sender;
        tokenReward = Token(0x813a823F35132D822708124e01759C565AB4331d);
    }

    function setOwner(address _owner) isCreator public {
        owner = _owner;      
    }

    function setCreator(address _creator) isCreator public {
        creator = _creator;      
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
        uint256 amount;
        
        // stage 1
        if (now &gt; 1525129200 &amp;&amp; now &lt; 1525734000 &amp;&amp; tokenSold &lt; 350001) {
            amount = msg.value * 2500;
        }

        // stage 2
        if (now &gt; 1525733999 &amp;&amp; now &lt; 1526252400 &amp;&amp; tokenSold &gt; 350000 &amp;&amp; tokenSold &lt; 700001) {
            amount = msg.value * 1250;
        }

        // stage 3
        if (now &gt; 1526252399 &amp;&amp; now &lt; 1526857200 &amp;&amp; tokenSold &gt; 700000 &amp;&amp; tokenSold &lt; 1150001) {
            amount = msg.value * 833;
        }

        // stage 4
        if (now &gt; 1526857199 &amp;&amp; now &lt; 1527721200 &amp;&amp; tokenSold &gt; 1150000 &amp;&amp; tokenSold &lt; 2000001) {
            amount = msg.value * 416;
        }

        // stage 5
        if (now &gt; 1527721199 &amp;&amp; now &lt; 1528671600 &amp;&amp; tokenSold &gt; 2000000 &amp;&amp; tokenSold &lt; 3000001) {
            amount = msg.value * 357;
        }

        // stage 6
        if (now &gt; 1528671599 &amp;&amp; now &lt; 1530399600 &amp;&amp; tokenSold &gt; 3000000 &amp;&amp; tokenSold &lt; 4000001) {
            amount = msg.value * 333;
        }

        tokenSold += amount / 1 ether;
        tokenReward.transfer(msg.sender, amount);
        FundTransfer(msg.sender, amount, true);
        owner.transfer(msg.value);
    }
}