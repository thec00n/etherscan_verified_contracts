pragma solidity ^0.4.18;

/**
 * @title SafeMath
 * @dev Math operations with safety checks
 */
contract SafeMath {
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &gt; 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a &amp;&amp; c &gt;= b);
        return c;
    }
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Basic {
    uint256 public totalSupply;
    uint8 public decimals;
    function balanceOf(address _owner) public constant returns (uint256 _balance);
    function transfer(address _to, uint256 _value) public returns (bool _succes);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}



/**
 * @title Crowdsale
 * @dev Crowdsale contract 
 */
contract Crowdsale is SafeMath {

    // token address
    address public tokenAddress = 0xa5FD4f631Ddf9C37d7B8A2c429a58bDC78abC843;
    
    // The token being sold
    ERC20Basic public ipc = ERC20Basic(tokenAddress);
    
    // address where funds are collected
    address public crowdsaleAgent = 0x783fE4521c2164eB6a7972122E7E33a1D1A72799;
    
    address public owner = 0xa52858fB590CFe15d03ee1F3803F2D3fCa367166;

    // amount of raised money in wei
    uint256 public weiRaised;

    // minimum amount of ether to participate in ICO
    uint256 public minimumEtherAmount = 0.2 ether;

    // start and end timestamps where investments are allowed (both inclusive)
    // + deadlines within bonus program
    uint256 public startTime = 1520082000;     //(GMT): Saturday, 3. March 2018 13:00:00
    uint256 public deadlineOne = 1520168400;   //(GMT): Sunday, 4. March 2018 13:00:00
    uint256 public deadlineTwo = 1520427600;   //(GMT): Wednesday, 7. March 2018 13:00:00
    uint256 public deadlineThree = 1520773200; //(GMT): Sunday, 11. March 2018 13:00:00
    uint256 public endTime = 1522674000;       //(GMT): Monday, 2. April 2018 13:00:00 
    
    // token amount for one ether during crowdsale
    uint public firstRate = 6000; 
    uint public secondRate = 5500;
    uint public thirdRate = 5000;
    uint public finalRate = 4400;

    // token distribution during Crowdsale
    mapping(address =&gt; uint256) public distribution;
    
    /**
     * event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    modifier onlyCrowdsaleAgent {
        require(msg.sender == crowdsaleAgent);
        _;
    }
    
    // fallback function can be used to buy tokens
    function () public payable {
        buyTokens(msg.sender);
    }

    // token purchase function
    function buyTokens(address beneficiary) public payable {
        require(beneficiary != address(0));
        require(beneficiary != address(this));
        require(beneficiary != tokenAddress);
        require(validPurchase());
        uint256 weiAmount = msg.value;
        // calculate token amount to be transferred to beneficiary
        uint256 tokens = calcTokenAmount(weiAmount);
        // update state
        weiRaised = safeAdd(weiRaised, weiAmount);
        distribution[beneficiary] = safeAdd(distribution[beneficiary], tokens);
        ipc.transfer(beneficiary, tokens);
        TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
        forwardFunds();
    }

    // return true if crowdsale event has ended
    function hasEnded() public view returns (bool) {
        return now &gt; endTime;
    }
    
    // set crowdsale wallet where funds are collected
    function setCrowdsaleAgent(address _crowdsaleAgent) public returns (bool) {
        require(msg.sender == owner || msg.sender == crowdsaleAgent);
        crowdsaleAgent = _crowdsaleAgent;
        return true;
    }
    
    // set ico times
    function setTimes(  uint256 _startTime, bool changeStartTime,
                        uint256 firstDeadline, bool changeFirstDeadline,
                        uint256 secondDeadline, bool changeSecondDeadline,
                        uint256 thirdDeadline, bool changeThirdDeadline,
                        uint256 _endTime, bool changeEndTime) onlyCrowdsaleAgent public returns (bool) {
        if(changeStartTime) startTime = _startTime;
        if(changeFirstDeadline) deadlineOne = firstDeadline;
        if(changeSecondDeadline) deadlineTwo = secondDeadline;
        if(changeThirdDeadline) deadlineThree = thirdDeadline;
        if(changeEndTime) endTime = _endTime;
        return true;
                            
    }
    
    // set token rates
    function setNewIPCRates(uint _firstRate, bool changeFirstRate,
                            uint _secondRate, bool changeSecondRate,
                            uint _thirdRate, bool changeThirdRate,
                            uint _finaleRate, bool changeFinalRate) onlyCrowdsaleAgent public returns (bool) {
        if(changeFirstRate) firstRate = _firstRate;
        if(changeSecondRate) secondRate = _secondRate;
        if(changeThirdRate) thirdRate = _thirdRate;
        if(changeFinalRate) finalRate = _finaleRate;
        return true;
    }
    
    // set new minumum amount of Wei to participate in ICO
    function setMinimumEtherAmount(uint256 _minimumEtherAmountInWei) onlyCrowdsaleAgent public returns (bool) {
        minimumEtherAmount = _minimumEtherAmountInWei;
        return true;
    }
    
    // withdraw remaining IPC token amount after crowdsale has ended
    function withdrawRemainingIPCToken() onlyCrowdsaleAgent public returns (bool) {
        uint256 remainingToken = ipc.balanceOf(this);
        require(hasEnded() &amp;&amp; remainingToken &gt; 0);
        ipc.transfer(crowdsaleAgent, remainingToken);
        return true;
    }
    
    // send erc20 token from this contract
    function withdrawERC20Token(address beneficiary, address _token) onlyCrowdsaleAgent public {
        ERC20Basic erc20Token = ERC20Basic(_token);
        uint256 amount = erc20Token.balanceOf(this);
        require(amount&gt;0);
        erc20Token.transfer(beneficiary, amount);
    }
    
    // transfer &#39;weiAmount&#39; wei to &#39;beneficiary&#39;
    function sendEther(address beneficiary, uint256 weiAmount) onlyCrowdsaleAgent public {
        beneficiary.transfer(weiAmount);
    }

    // Calculate the token amount from the donated ETH onsidering the bonus system.
    function calcTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        uint256 price;
        if (now &gt;= startTime &amp;&amp; now &lt; deadlineOne) {
            price = firstRate; 
        } else if (now &gt;= deadlineOne &amp;&amp; now &lt; deadlineTwo) {
            price = secondRate;
        } else if (now &gt;= deadlineTwo &amp;&amp; now &lt; deadlineThree) {
            price = thirdRate;
        } else if (now &gt;= deadlineThree &amp;&amp; now &lt;= endTime) {
        	price = finalRate;
        }
        uint256 tokens = safeMul(price, weiAmount);
        uint8 decimalCut = 18 &gt; ipc.decimals() ? 18-ipc.decimals() : 0;
        return safeDiv(tokens, 10**uint256(decimalCut));
    }

    // forward ether to the fund collection wallet
    function forwardFunds() internal {
        crowdsaleAgent.transfer(msg.value);
    }

    // return true if valid purchase
    function validPurchase() internal view returns (bool) {
        bool withinPeriod = now &gt;= startTime &amp;&amp; now &lt;= endTime;
        bool isMinimumAmount = msg.value &gt;= minimumEtherAmount;
        bool hasTokenBalance = ipc.balanceOf(this) &gt; 0;
        return withinPeriod &amp;&amp; isMinimumAmount &amp;&amp; hasTokenBalance;
    }
     
    // selfdestruct crowdsale contract only after crowdsale has ended
    function killContract() onlyCrowdsaleAgent public {
        require(hasEnded() &amp;&amp; ipc.balanceOf(this) == 0);
     selfdestruct(crowdsaleAgent);
    }
}