pragma solidity ^ 0.4.18;

contract ERC20 {
  uint256 public totalsupply;
  function totalSupply() public constant returns(uint256 _totalSupply);
  function balanceOf(address who) public constant returns (uint256);
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool ok);
  function approve(address spender, uint256 value) public returns (bool ok);
  function transfer(address to, uint256 value) public returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) pure internal returns(uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) pure internal returns(uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    function sub(uint256 a, uint256 b) pure internal returns(uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) pure internal returns(uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }
}

contract FreedomStreaming is ERC20
{
    
    using SafeMath
    for uint256;
    
    string public constant name = &quot;Freedom Token&quot;;

    string public constant symbol = &quot;FDM&quot;;

    uint8 public constant decimals = 18;

    uint256 public constant totalsupply = 1000000000000000000000000000;
      
    mapping(address =&gt; uint256) balances;

    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
    
    address owner = 0x963cb5e7190FA77435AFe61FBb8C2dDB073e42c2;
    
    event supply(uint256 bnumber);

    event events(string _name);

    uint256 _price_tokn;
    
    bool stopped = true;

    uint256 no_of_tokens;
    
    enum Stages {
        NOTSTARTED,
        PREICO,
        ICO,
        PAUSED,
        ENDED
    }
    
    Stages public stage;
    
    bool ico_ended = false;

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
   
    function FreedomStreaming() public
    {
        balances[owner] = 350000000000000000000000000;      
        balances[address(this)] = 650000000000000000000000000;
        stage = Stages.NOTSTARTED;
    }
    
    function () public payable
    {
        if(!ico_ended &amp;&amp; !stopped &amp;&amp; msg.value &gt;= 0.01 ether)
        {
            no_of_tokens = SafeMath.mul(msg.value , _price_tokn); 
            if(balances[address(this)] &gt;= no_of_tokens )
            {
        
              balances[address(this)] =SafeMath.sub(balances[address(this)],no_of_tokens);
              balances[msg.sender] = SafeMath.add(balances[msg.sender],no_of_tokens);
              Transfer(address(this), msg.sender, no_of_tokens);
              owner.transfer(this.balance); 
   
            }
            else
            {
                revert();
            }
        
        }
      else
       {
           revert();
       }
   }
    
    function totalSupply() public constant returns(uint256) {
       return totalsupply;
    }
    
     function balanceOf(address sender) public constant returns(uint256 balance) {
        return balances[sender];
    }

    
    function transfer(address _to, uint256 _amount) public returns(bool success) {
        if (balances[msg.sender] &gt;= _amount &amp;&amp;
            _amount &gt; 0 &amp;&amp;
            balances[_to] + _amount &gt; balances[_to]) {
         
            balances[msg.sender] = SafeMath.sub(balances[msg.sender],_amount);
            balances[_to] = SafeMath.add(balances[_to],_amount);
            Transfer(msg.sender, _to, _amount);

            return true;
        } else {
            return false;
        }
    }
    
    
    function pauseICOs() external onlyOwner {
        stage = Stages.PAUSED;
        stopped = true;
    }

    
    function Start_Resume_ICO() external onlyOwner {
        stage = Stages.ICO;
        stopped = false;
        _price_tokn = 10000;
    }
    
    
     function Start_Resume_PreICO() external onlyOwner
     {
         stage = Stages.PREICO;
         stopped = false;
         _price_tokn = 12000;
     }
     
     function end_ICOs() external onlyOwner
     {
         ico_ended = true;
         stage = Stages.ENDED;
     }
    
   
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) public returns(bool success) {

            require(balances[_from] &gt;= _amount &amp;&amp; allowed[_from][msg.sender] &gt;= _amount);    
                
            balances[_from] = SafeMath.sub(balances[_from],_amount);
            allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _amount);
            balances[_to] = SafeMath.add(balances[_to], _amount);
            Transfer(_from, _to, _amount);
            
            return true;
       
    }

  function approve(address _spender, uint256 _value) public returns (bool) {

    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function drain() external onlyOwner {
        owner.transfer(this.balance);
    }

    function drainToken() external onlyOwner
    {
        require(ico_ended);
        
        balances[owner] = SafeMath.add(balances[owner],balances[address(this)]);
        Transfer(address(this), owner, balances[address(this)]);
        balances[address(this)] = 0;
    }
    

}