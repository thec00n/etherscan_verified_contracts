pragma solidity ^0.4.8;

contract MigrationAgent {
    function migrateFrom(address _from, uint256 _value);
}

contract ERC20Interface {
     function totalSupply() constant returns (uint256 totalSupply);
     function balanceOf(address _owner) constant returns (uint256 balance);
     function transfer(address _to, uint256 _value) returns (bool success);
     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
     function approve(address _spender, uint256 _value) returns (bool success);
     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/// Ethereum Ultimate (ETHU)
contract EthereumUltimateToken is ERC20Interface {
    string public constant name = &quot;Ethereum Ultimate&quot;;
    string public constant symbol = &quot;ETHU&quot;;
    uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
    uint256 public constant tokenCreationCap = 3000000* 10**18;
    uint256 public constant tokenCreationMin = 250000* 10**18;
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed;
    uint public fundingStart;
    uint public fundingEnd;
    bool public funding = true;
    address public master;
    uint256 totalTokens;
    uint256 soldAfterPowerHour;
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; uint) lastTransferred;
    mapping (address =&gt; uint256) balancesEther;
    address public migrationAgent;
    uint256 public totalMigrated;
    event Migrate(address indexed _from, address indexed _to, uint256 _value);
    event Refund(address indexed _from, uint256 _value);
    uint totalParticipants;

    function EthereumUltimateToken() {
        master = msg.sender;
        fundingStart = 1509279285;
        fundingEnd = 1514764800;
    }
    
    function getAmountofTotalParticipants() constant returns (uint){
        return totalParticipants;
    }
    
    function getAmountSoldAfterPowerDay() constant external returns(uint256){
        return soldAfterPowerHour;
    }

    function transfer(address _to, uint256 _value) returns (bool success) {
        if(funding) throw;

        var senderBalance = balances[msg.sender];
        if (senderBalance &gt;= _value &amp;&amp; _value &gt; 0) {
            senderBalance -= _value;
            balances[msg.sender] = senderBalance;
            
            balances[_to] += _value;
            
            lastTransferred[msg.sender]=block.timestamp;
            Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }
    function totalSupply() constant returns (uint256 totalSupply) {
        return totalTokens;
    }
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
    function EtherBalanceOf(address _owner) constant returns (uint256) {
        return balancesEther[_owner];
    }
    function TimeLeft() external constant returns (uint256) {
        if(fundingEnd&gt;block.timestamp)
            return fundingEnd-block.timestamp;
        else
            return 0;
    }
    function TimeLeftBeforeCrowdsale() external constant returns (uint256) {
        if(fundingStart&gt;block.timestamp)
            return fundingStart-block.timestamp;
        else
            return 0;
    }
function migrate(uint256 _value) external {
        if(funding) throw;
        if(migrationAgent == 0) throw;
        if(_value == 0) throw;
        if(_value &gt; balances[msg.sender]) throw;
        balances[msg.sender] -= _value;
        totalTokens -= _value;
        totalMigrated += _value;
        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
        Migrate(msg.sender, migrationAgent, _value);
    }

    function setMigrationAgent(address _agent) external {
        if(funding) throw;
        
        if(migrationAgent != 0) throw;
        
        if(msg.sender != master) throw;
        
        migrationAgent = 0xc04FdF16cDf0af953D2eF14cFB01cDdBE881Dd2D;
    }
    
    function getExchangeRate() constant returns(uint){
            return 30000; // 30000 
    }
    
    function ICOopen() constant returns(bool){
        if(!funding) return false;
        else if(block.timestamp &lt; fundingStart) return false;
        else if(block.timestamp &gt; fundingEnd) return false;
        else if(tokenCreationCap &lt;= totalTokens) return false;
        else return true;
    }

    function() payable external {
        if(!funding) throw;
        if(block.timestamp &lt; fundingStart) throw;
        if(block.timestamp &gt; fundingEnd) throw;
        if(msg.value == 0) throw;
        if((msg.value  * getExchangeRate()) &gt; (tokenCreationCap - totalTokens)) throw;
        var numTokens = msg.value * getExchangeRate();
        totalTokens += numTokens;
        
        if(getExchangeRate()!=30000){
            soldAfterPowerHour += numTokens;
        }
        balances[msg.sender] += numTokens;
        balancesEther[msg.sender] += msg.value;
        totalParticipants+=1;
        Transfer(0, msg.sender, numTokens);
    }

    function finalize() external {
        if(!funding) throw;
        funding = false;
        uint256 percentOfTotal = 25;
        uint256 additionalTokens = totalTokens * percentOfTotal / (37 + percentOfTotal);
        totalTokens += additionalTokens;
        balances[master] += additionalTokens;
        Transfer(0, master, additionalTokens);
        if (!master.send(this.balance)) throw;
    }

    function refund() external {
        if(!funding) throw;
        if(block.timestamp &lt;= fundingEnd) throw;
        if(totalTokens &gt;= tokenCreationMin) throw;

        var ethuValue = balances[msg.sender];
        var ethValue = balancesEther[msg.sender];
        if (ethuValue == 0) throw;
        balances[msg.sender] = 0;
        balancesEther[msg.sender] = 0;
        totalTokens -= ethuValue;

        Refund(msg.sender, ethValue);
        if (!msg.sender.send(ethValue)) throw;
    }
	
     function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
         if(funding) throw;
         if (balances[_from] &gt;= _amount
             &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
             &amp;&amp; _amount &gt; 0
             &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(_from, _to, _amount);
             return true;
         } else {
             return false;
         }
     }
  
     function approve(address _spender, uint256 _amount) returns (bool success) {
         if(funding) throw;
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
     }
  
     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
         return allowed[_owner][_spender];
     }
}