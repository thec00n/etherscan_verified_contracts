pragma solidity ^0.4.0;

interface ERC20 {
    function transferFrom(address _from, address _to, uint _value) public returns (bool);
    function approve(address _spender, uint _value) public returns (bool);
    function allowance(address _owner, address _spender) public constant returns (uint);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface ERC223 {
    function transfer(address _to, uint _value, bytes _data) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
}

contract ERC223ReceivingContract {
    function tokenFallback(address _from, uint _value, bytes _data) public;
}

contract BitsenseToken {
    string internal _symbol;
    string internal _name;
    uint8 internal _decimals;
    uint internal _totalSupply = 1000000000000000;
    mapping (address =&gt; uint) _balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint)) internal _allowances;

    function BitsenseToken(string symbol, string name, uint8 decimals, uint totalSupply) public {
        _symbol = symbol;
        _name = name;
        _decimals = decimals;
        _totalSupply = totalSupply;
    }

    function name() public constant returns (string) {
        return _name;
    }

    function symbol() public constant returns (string) {
        return _symbol;
    }

    function decimals() public constant returns (uint8) {
        return _decimals;
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr) public constant returns (uint);
    function transfer(address _to, uint _value) public returns (bool);
    event Transfer(address indexed _from, address indexed _to, uint _value);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract Bitsense is BitsenseToken(&quot;BINS&quot;, &quot;Bitsense&quot;, 8, 1000000000000000), ERC20, ERC223 {
    address private _owner;
    struct LockAccount{
        uint status;
    }
    
    struct Reward{
        uint amount;
    }
    
    mapping (address =&gt; LockAccount) lockAccounts;
    address[] public AllLockAccounts;
    
    mapping (address =&gt; Reward) rewards;
    address[] public rewardsAccounts;
    
    using SafeMath for uint;
    
 
    
    function Bitsense() public {
        _balanceOf[msg.sender] = _totalSupply;
        _owner = msg.sender;
    }
   
    
       function setLockAccount(address _addr) public{
        require(msg.sender == _owner);
        var lock_account = lockAccounts[_addr];
        lock_account.status = 1;
        AllLockAccounts.push(_addr) -1;
    }
    
        function setReward(address _addr, uint _amount) public{
        require(msg.sender == _owner);
        var reward = rewards[_addr];
        reward.amount +=  _amount;
        rewardsAccounts.push(_addr) -1;
    }
  
    function claimReward(address _addr) public returns (bool){
        var addressTo = _addr;
        uint amount = rewards[_addr].amount;
       
     
          if (amount &gt; 0 &amp;&amp;
            amount &lt;= _balanceOf[_owner] &amp;&amp;
            !isContract(addressTo)) {
            _balanceOf[_owner] = _balanceOf[_owner].sub(amount);
            _balanceOf[addressTo] = _balanceOf[addressTo].add(amount);
            Transfer(msg.sender, addressTo, amount);
            return true;
        }
          rewards[_addr].amount = 0;
        
    }
    
    function getLockAccounts() view public returns (address[]){
        return AllLockAccounts;
    }
    
     function getLockAccount(address _addr) view public returns (uint){
        return lockAccounts[_addr].status;
    }
    
    function getReward(address _addr) view public returns (uint){
        return rewards[_addr].amount;
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address _addr) public constant returns (uint) {
        return _balanceOf[_addr];
    }

    function transfer(address _to, uint _value) public returns (bool) {
        if (_value &gt; 0 &amp;&amp;
            _value &lt;= _balanceOf[msg.sender] &amp;&amp;
            !isContract(_to) &amp;&amp; !isLock(msg.sender)) {
            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        }
        return false;
    }
    
    

    function transfer(address _to, uint _value, bytes _data) public returns (bool) {
        if (_value &gt; 0 &amp;&amp;
            _value &lt;= _balanceOf[msg.sender] &amp;&amp;
            isContract(_to) &amp;&amp; !isLock(msg.sender)) {
            _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
            _contract.tokenFallback(msg.sender, _value, _data);
            Transfer(msg.sender, _to, _value, _data);
            return true;
        }
        return false;
    }
    
    function unLockAccount(address _addr) public {
        require(msg.sender == _owner);
       lockAccounts[_addr].status = 0;
       
    }
    function isLock (address _addr) private constant returns(bool){
        var lS = lockAccounts[_addr].status;
        
        if(lS == 1){
            return true;
        }
        
        return false;
    }

    function isContract(address _addr) private constant returns (bool) {
        uint codeSize;
        assembly {
            codeSize := extcodesize(_addr)
        }
        return codeSize &gt; 0;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        if (_allowances[_from][msg.sender] &gt; 0 &amp;&amp;
            _value &gt; 0 &amp;&amp;
            _allowances[_from][msg.sender] &gt;= _value &amp;&amp;
            _balanceOf[_from] &gt;= _value) {
            _balanceOf[_from] = _balanceOf[_from].sub(_value);
            _balanceOf[_to] = _balanceOf[_to].add(_value);
            _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
            Transfer(_from, _to, _value);
            return true;
        }
        return false;
    }
    

   
    function approve(address _spender, uint _value) public returns (bool) {
        _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint) {
        return _allowances[_owner][_spender];
    }
}