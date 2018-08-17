pragma solidity ^0.4.16;

interface Token {
    function transfer(address _to, uint256 _value) external;
}

contract AZTCrowdsale {
    
    Token public tokenReward;
    address public creator;
    address public owner = 0x0;

    uint256 private tokenSold;

    modifier isCreator() {
        require(msg.sender == creator);
        _;
    }

    event FundTransfer(address backer, uint amount, bool isContribution);

    function AZTCrowdsale() public {
        creator = msg.sender;
        tokenReward = Token(0x2e9f2A3c66fFd47163b362987765FD8857b1f3F9);
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
        
        // private sale
        if (now &gt; 1526342400 &amp;&amp; now &lt; 1527811200 &amp;&amp; tokenSold &lt; 1250001) {
            amount = msg.value * 10000;
        }

        // pre-sale
        if (now &gt; 1527811199 &amp;&amp; now &lt; 1528416000 &amp;&amp; tokenSold &gt; 1250000 &amp;&amp; tokenSold &lt; 3250001) {
            amount = msg.value * 10000;
        }

        // stage 1
        if (now &gt; 1528415999 &amp;&amp; now &lt; 1529107200 &amp;&amp; tokenSold &gt; 3250000 &amp;&amp; tokenSold &lt; 5250001) {
            amount = msg.value * 10000;
        }

        // stage 2
        if (now &gt; 1529107199 &amp;&amp; now &lt; 1529622000 &amp;&amp; tokenSold &gt; 5250000 &amp;&amp; tokenSold &lt; 7250001) {
            amount = msg.value * 2500;
        }

        // stage 3
        if (now &gt; 1529621999 &amp;&amp; now &lt; 1530226800 &amp;&amp; tokenSold &gt; 7250000 &amp;&amp; tokenSold &lt; 9250001) {
            amount = msg.value * 1250;
        }

        // stage 4
        if (now &gt; 1530226799 &amp;&amp; now &lt; 1530831600 &amp;&amp; tokenSold &gt; 9250000 &amp;&amp; tokenSold &lt; 11250001) {
            amount = msg.value * 833;
        }

        // stage 5
        if (now &gt; 1530831599 &amp;&amp; now &lt; 1531609199 &amp;&amp; tokenSold &gt; 11250000 &amp;&amp; tokenSold &lt; 13250001) {
            amount = msg.value * 417;
        }

        tokenSold += amount / 1 ether;
        tokenReward.transfer(msg.sender, amount);
        FundTransfer(msg.sender, amount, true);
        owner.transfer(msg.value);
    }
}