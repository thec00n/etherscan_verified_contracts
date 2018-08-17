pragma solidity ^0.4.13;


contract Token {   
    uint256 public totalSupply;
    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract StandardToken is Token {
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    function transfer(address _to, uint256 _value) public returns (bool success) {       
        address sender = msg.sender;
        require(balances[sender] &gt;= _value);
        balances[sender] -= _value;
        balances[_to] += _value;
        Transfer(sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {      
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }    
}

contract GigaGivingToken is StandardToken {
    string public constant NAME = &quot;Giga Coin&quot;;
    string public constant SYMBOL = &quot;GC&quot;;
    uint256 public constant DECIMALS = 0;
    uint256 public constant TOTAL_TOKENS = 15000000;
    uint256 public constant  CROWDSALE_TOKENS = 12000000;  
    string public constant VERSION = &quot;GC.2&quot;;

    function GigaGivingToken () public {
        balances[msg.sender] = TOTAL_TOKENS; 
        totalSupply = TOTAL_TOKENS;
    }
    
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        require(_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData));
        return true;
    }
}



library SafeMath {
  function mul(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal returns (uint256) {    
    uint256 c = a / b;    
    return c;
  }

  function sub(uint256 a, uint256 b) internal returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract GigaGivingICO {
    using SafeMath for uint256;
         
    uint256 private fundingGoal;
    uint256 private amountRaised;

    uint256 public constant PHASE_1_PRICE = 1600000000000000;
    uint256 public constant PHASE_2_PRICE = 2000000000000000; 
    uint256 public constant PHASE_3_PRICE = 2500000000000000; 
    uint256 public constant PHASE_4_PRICE = 4000000000000000;
    uint256 public constant PHASE_5_PRICE = 5000000000000000; 
    uint256 public constant DURATION = 5 weeks;  
    uint256 public startTime;
    uint256 public tokenSupply;
 
    address public beneficiary;

    GigaGivingToken public tokenReward;
    mapping(address =&gt; uint256) public balanceOf;
    bool public fundingGoalReached = false;
    bool public crowdsaleClosed = false;

    event GoalReached(address goalBeneficiary, uint256 totalAmountRaised);
    event FundTransfer(address backer, uint256 amount, bool isContribution);
    
    function GigaGivingICO (address icoToken, address icoBeneficiary) public {
        fundingGoal = 1000 ether; 
        startTime = 1510765200;
        beneficiary = icoBeneficiary;
        tokenReward = GigaGivingToken(icoToken);
        tokenSupply = 12000000;
    }

    function () public payable {
        require(now &gt;= startTime);
        require(now &lt;= startTime + DURATION);
        require(!crowdsaleClosed);
        require(msg.value &gt; 0);
        uint256 amount = msg.value;
        uint256 coinTotal = 0;      
        
        if (now &gt; startTime + 4 weeks) {
            coinTotal = amount.div(PHASE_5_PRICE);
        } else if (now &gt; startTime + 3 weeks) {
            coinTotal = amount.div(PHASE_4_PRICE);
        } else if (now &gt; startTime + 2 weeks) {
            coinTotal = amount.div(PHASE_3_PRICE);
        } else if (now &gt; startTime + 1 weeks) {
            coinTotal = amount.div(PHASE_2_PRICE);
        } else {
            coinTotal = amount.div(PHASE_1_PRICE);
        }
       
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        amountRaised = amountRaised.add(amount);
        tokenSupply = tokenSupply.sub(coinTotal);
        tokenReward.transfer(msg.sender, coinTotal);
        FundTransfer(msg.sender, amount, true);
    }  

    modifier afterDeadline() { 
        if (now &gt;= (startTime + DURATION)) {
            _;
        }
    }

    function checkGoalReached() public afterDeadline {
        if (amountRaised &gt;= fundingGoal) {
            fundingGoalReached = true;
            GoalReached(beneficiary, amountRaised);
        }
        crowdsaleClosed = true;
    }

    function safeWithdrawal() public afterDeadline {
        if (!fundingGoalReached) {
            uint amount = balanceOf[msg.sender];
            balanceOf[msg.sender] = 0;
            if (amount &gt; 0) {
                if (msg.sender.send(amount)) {
                    FundTransfer(msg.sender, amount, false);
                } else {
                    balanceOf[msg.sender] = amount;
                }
            }
        }

        if (fundingGoalReached &amp;&amp; beneficiary == msg.sender) {
            if (beneficiary.send(amountRaised)) {
                tokenReward.transfer(msg.sender, tokenSupply);
                FundTransfer(beneficiary, amountRaised, false);                
            } else {               
                fundingGoalReached = false;
            }
        }
    }
}