pragma solidity ^0.4.4;

contract SafeMath {
  function safeMul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint a, uint b) internal returns (uint) {
    assert(b &gt; 0);
    uint c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint a, uint b) internal returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }

  function safeAdd(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c&gt;=a &amp;&amp; c&gt;=b);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &gt;= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &lt; b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &gt;= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &lt; b ? a : b;
  }

  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
}



contract Token is SafeMath {

    function totalSupply()public constant returns (uint256 supply) {}

    function balanceOf(address _owner)public constant returns (uint256 balance) {}
    
   
    
    function transfer(address _to, uint256 _value)public returns (bool success) {}

    function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {}

    function approve(address _spender, uint256 _value)public returns (bool success) {}

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}


//ERC20 Compliant
contract StandardToken is Token {

    
    
    
    
    function transfer(address _to, uint256 _value) public  returns (bool success) {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0)
        {
            if(inflation_complete)
            {
              
                uint256 CalculatedFee = safeMul(safeDiv(transactionfeeAmount,100000000000000),transactionfeeAmount);
                balances[msg.sender] = safeSub(balances[msg.sender],_value);
               _value = safeSub(_value,CalculatedFee);
                totalFeeCollected = safeAdd(totalFeeCollected,CalculatedFee);
                balances[_to] = safeAdd(balances[_to],_value);
                Transfer(msg.sender, _to, _value);
                return true;
            }
            else
            {
                balances[msg.sender] = safeSub(balances[msg.sender],_value);
                balances[_to] = safeAdd(balances[_to],_value);
                Transfer(msg.sender, _to, _value);
                return true;
                
            }
            
        }
        else
        {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] =safeAdd(balances[_to],_value);
            balances[_from] =safeSub(balances[_from],_value);
            allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender],_value); 
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
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

   
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    uint256 public totalSupply=   0;
    uint256 public initialSupply= 2500000*10**12;
    uint256 public rewardsupply= 4500000*10**12;
    bool public inflation_complete;
    uint256 public transactionfeeAmount; // This is the percentage per transaction Hawala.Today shall be collecting 
    uint256 public totalFeeCollected;
}



contract HawalaToken is StandardToken {

    
    uint256 public  totalstakeamount;
    uint256 public HawalaKickoffTime;
    address _contractOwner;
    uint256 public totalFeeCollected;
  
    string public name;                  
    uint8 public decimals;               
    string public symbol;
    string public version = &#39;HAT&#39;;       

  mapping (address =&gt; IFSBalance) public IFSBalances;
   struct IFSBalance
    {
        
         uint256 TotalRewardsCollected; 
        uint256 Amount; 
        uint256 IFSLockTime;
        uint256 LastCollectedReward;
    }
    
   
    event IFSActive(address indexed _owner, uint256 _value,uint256 _locktime);
    
    function () public {
        //if ether is sent to this address, send it back.
    
        throw;
    }

  

      

      function CalculateReward(uint256 stakingamount,uint256 initialLockTime,uint256 _currenttime) public returns (uint256 _amount) {
         
        
         uint _timesinceStaking =(uint(_currenttime)-uint(initialLockTime))/ 1 days;
         _timesinceStaking = safeDiv(_timesinceStaking,3);//exploiting non-floating point division
         _timesinceStaking = safeMul(_timesinceStaking,3);//get to number of days reward shall be distributed
        
      
        
         if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 1 years)
         {
             //_amount = 1;//safeMul(safeDiv(stakingamount,100),15));
              
             _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
          
         }
        else if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 2 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),410958904) ;//15% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
        else  if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 3 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
        else  if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 4 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
       else   if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 5 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),328767123) ;//12% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
       else   if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 6 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
      else    if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 7 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),273972602) ;//10%  safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
       else   if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 8 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),219178082) ;//8% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
      else    if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 9 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),205479452) ;//7.50% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
       else   if(safeSub(_currenttime,HawalaKickoffTime) &lt;= 10 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
        else   if(safeSub(_currenttime,HawalaKickoffTime) &gt; 10 years)
         {
             _amount = safeMul(safeDiv(stakingamount,1000000000000),198630136) ;//7.25% safeDiv(4,100);//safeMul(stakingamount,safeDiv(4,100));
             _amount = safeMul(_timesinceStaking,_amount);
             
         }
         return _amount;
         //extract ony the quotient from _timesinceStaking
        
     }
     
     function changeTransactionFee(uint256 amount) public returns (bool success)
     {
          if (msg.sender == _contractOwner) {
              
              transactionfeeAmount = amount;
            return true;
          }
       else{
             return false;
         }
     }
     
     function canExecute(uint initialLockTime,uint256 _currenttime) public returns (bool success)
     {
          if (_currenttime &gt;= initialLockTime + 3 days) {
              
            return true;
          }
       else{
             return false;
         }
     }
     
     
      function disperseRewards(address toaddress ,uint256 amount) public returns (bool success){
      
          if(msg.sender==_contractOwner)
          {
             if(inflation_complete)
              {
                  if(totalFeeCollected&gt;0 &amp;&amp; totalFeeCollected&gt;amount)
                  {
                    totalFeeCollected = safeSub(totalFeeCollected,amount);
                     balances[toaddress] = safeAdd(balances[toaddress],amount);
                     Transfer(msg.sender, toaddress, amount);
                     return true;
                  }
              
              }
              else
              {
                  return false;
                  
              }
          }
          return false;
          
      }
       function claimIFSReward(address _sender) public returns (bool success){
     
       
        if(msg.sender!=_sender)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS
        {
            return false;
        }
        else
        {
            if(IFSBalances[_sender].Amount&lt;=0)
            {
                return false;
                
            }
            else{
                // is IFS balance age minimum 3 day?
                uint256 _currenttime = now;
                if(canExecute(IFSBalances[_sender].IFSLockTime,_currenttime))
                {
                    //Get Total number of days in multiple of 3&#39;s.. Suppose if the staking lock was done 10 days ago
                    //but the reward shall be allocated and calculated for 9 Days.
                    uint256 calculatedreward = CalculateReward(IFSBalances[_sender].Amount,IFSBalances[_sender].IFSLockTime,_currenttime);
                    
                   if(!inflation_complete)
                   {
                    if(rewardsupply&gt;=calculatedreward)
                    {
                   
                   
                         rewardsupply = safeSub(rewardsupply,calculatedreward);
                         balances[_sender] =safeAdd(balances[_sender], calculatedreward);
                         IFSBalances[_sender].IFSLockTime = _currenttime;//reset the clock
                         IFSBalances[_sender].TotalRewardsCollected = safeAdd( IFSBalances[_sender].TotalRewardsCollected,calculatedreward);
                          IFSBalances[_sender].LastCollectedReward = rewardsupply;//Set this to see last collected reward
                    }
                    else{
                        
                        if(rewardsupply&gt;0)//whatever remaining in the supply hand it out to last staking account
                        {
                              
                           balances[_sender] =safeAdd(balances[_sender], rewardsupply);
                           rewardsupply = 0;
                            
                        }
                        inflation_complete = true;
                        
                    }
                    
                   }
                    
                }
                else{
                    
                    // Not time yet to process staking reward 
                    return false;
                }
                
                
                
            }
            return true;
        }
        
    }
   
    function setIFS(address _sender,uint256 _amount) public returns (bool success){
        if(msg.sender!=_sender || balances[_sender]&lt;_amount || rewardsupply==0)//Make sure only authorize owner of account could trigger IFS and he/she must have enough balance to trigger IFS
        {
            return false;
        }
        balances[_sender] = safeSub(balances[_sender],_amount);
        IFSBalances[_sender].Amount = safeAdd(IFSBalances[_sender].Amount,_amount);
        IFSBalances[_sender].IFSLockTime = now;
        IFSActive(_sender,_amount,IFSBalances[_sender].IFSLockTime);
        totalstakeamount =  safeAdd(totalstakeamount,_amount);
        return true;
        
    }
    function reClaimIFS(address _sender)public returns (bool success){
        if(msg.sender!=_sender || IFSBalances[_sender].Amount&lt;=0 )//Make sure only authorize owner of account and &gt; 0 staking could trigger reClaimIFS  
        {
            return false;
        }
        
            balances[_sender] = safeAdd(balances[_sender],IFSBalances[_sender].Amount);
            totalstakeamount =  safeSub(totalstakeamount,IFSBalances[_sender].Amount);
            IFSBalances[_sender].Amount = 0;
            IFSBalances[_sender].IFSLockTime = 0;// 
            IFSActive(_sender,0,IFSBalances[_sender].IFSLockTime);//Broadcast event ... Our mobile hooks should be listening to release time
            
            return true; 
        
        
    }
    
    
    function HawalaToken(
        )public {
        //Add initial supply to total supply to make  7M. remaining 4.5M locked in for reward distribution        
        totalSupply=safeAdd(initialSupply,rewardsupply);
        balances[msg.sender] = initialSupply;               
        name = &quot;HawalaToken&quot;;                              
        decimals = 12;                            
        symbol = &quot;HAT&quot;;  
        inflation_complete = false;
        HawalaKickoffTime=now;
        totalstakeamount=0;
        totalFeeCollected=0;
        transactionfeeAmount=100000000000;// Initialized with 0.10 Percent per transaction after 10 years
        _contractOwner = msg.sender;
    }

   
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        if(!_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData)) { throw; }
        return true;
    }
}