pragma solidity ^0.4.11;

contract SafeMath {

    function safeMul(uint a, uint b) internal pure returns (uint) {
        uint c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint a, uint b) internal pure returns (uint) {
        require(b &gt; 0);
        uint c = a / b;
        require(a == b * c + a % b);
        return c;
    }

    function safeSub(uint a, uint b) internal pure returns (uint) {
        require(b &lt;= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c &gt;= a &amp;&amp; c &gt;= b);
        return c;
    }
}

contract AlsToken {
    function balanceOf(address _owner) public constant returns (uint256);
    function transfer(address receiver, uint amount) public;
}

contract Owned {

    address internal owner;

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function getOwner() public constant returns (address currentOwner) {
        return owner;
    }
}

contract AlsIco is Owned, SafeMath {

    // Crowdsale start time in seconds since epoch.
    // Equivalent to Wednesday, December 20th 2017, 3 pm London time.
    uint256 public constant crowdsaleStartTime = 1513782000;

    // Crowdsale end time in seconds since epoch.
    // Equivalent to Tuesday, February 20th 2018, 3 pm London time.
    uint256 public constant crowdsaleEndTime = 1519138800;

    // One thousand ALS with 18 decimals [10 to the power of 21 (3 + 18) tokens].
    uint256 private constant oneThousandAls = uint256(10) ** 21;

    uint public amountRaised;
    uint public tokensSold;
    AlsToken public alsToken;

    event FundTransfer(address backer, uint amount, bool isContribution);

    function AlsIco() public {
        alsToken = AlsToken(0xbCeC57361649E5dA917efa9F992FBCA0a2529350);
    }

    modifier onlyAfterStart() {
        require(now &gt;= crowdsaleStartTime);
        _;
    }

    modifier onlyBeforeEnd() {
        require(now &lt;= crowdsaleEndTime);
        _;
    }

    // Returns how many ALS are given in exchange for 1 ETH.
    function getPrice() public constant onlyAfterStart onlyBeforeEnd returns (uint256) {
        if (tokensSold &lt; 1600 * oneThousandAls) {
            // Firs 2% (equivalent to first 1.600.000 ALS) get 70% bonus (equivalent to 17000 ALS per 1 ETH).
            return 17000;
        } else if (tokensSold &lt; 8000 * oneThousandAls) {
            // Firs 10% (equivalent to first 8.000.000 ALS) get 30% bonus (equivalent to 13000 ALS per 1 ETH).
            return 13000;
        } else if (tokensSold &lt; 16000 * oneThousandAls) {
            // Firs 20% (equivalent to first 16.000.000 ALS) get 10% bonus (equivalent to 11000 ALS per 1 ETH).
            return 11000;
        } else if (tokensSold &lt; 40000 * oneThousandAls) {
            // Firs 50% (equivalent to first 40.000.000 ALS) get 5% bonus (equivalent to 10500 ALS per 1 ETH).
            return 10500;
        } else {
            // The rest of the tokens (after 50%) will be sold without a bonus.
            return 10000;
        }
    }

    function () payable public onlyAfterStart onlyBeforeEnd {
        uint256 availableTokens = alsToken.balanceOf(this);
        require (availableTokens &gt; 0);

        uint256 etherAmount = msg.value;
        require(etherAmount &gt; 0);

        uint256 price = getPrice();
        uint256 tokenAmount = safeMul(etherAmount, price);

        if (tokenAmount &lt;= availableTokens) {
            amountRaised = safeAdd(amountRaised, etherAmount);
            tokensSold = safeAdd(tokensSold, tokenAmount);

            alsToken.transfer(msg.sender, tokenAmount);
            FundTransfer(msg.sender, etherAmount, true);
        } else {
            uint256 etherToSpend = safeDiv(availableTokens, price);
            amountRaised = safeAdd(amountRaised, etherToSpend);
            tokensSold = safeAdd(tokensSold, availableTokens);

            alsToken.transfer(msg.sender, availableTokens);
            FundTransfer(msg.sender, etherToSpend, true);

            // Return the rest of the funds back to the caller.
            uint256 amountToRefund = safeSub(etherAmount, etherToSpend);
            msg.sender.transfer(amountToRefund);
        }
    }

    function withdrawEther(uint _amount) external onlyOwner {
        require(this.balance &gt;= _amount);
        owner.transfer(_amount);
        FundTransfer(owner, _amount, false);
    }
}