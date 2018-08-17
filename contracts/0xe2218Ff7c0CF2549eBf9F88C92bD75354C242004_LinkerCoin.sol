pragma solidity ^0.4.16;

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

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract ERC20Interface {
    // Get the total token supply
    function totalSupply() public constant returns (uint256 supply);

    // Get the account balance of another account with address _owner
    function balanceOf(address _owner) public constant returns (uint256 balance);

    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value) public returns (bool success);

    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    // this function is required for some DEX functionality
    function approve(address _spender, uint256 _value) public returns (bool success);

    // Returns the amount which _spender is still allowed to withdraw from _owner
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining);

    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
   
contract Token is ERC20Interface {
    
    using SafeMath for uint;
    
    string public constant symbol = &quot;LNC&quot;;
    string public constant name = &quot;Linker Coin&quot;;
    uint8 public constant decimals = 18;
    uint256 _totalSupply = 500000000000000000000000000;
    
    //AML &amp; KYC
    mapping (address =&gt; bool) public frozenAccount;
    event FrozenFunds(address target, bool frozen);
  
    // Linker coin has  5*10^25 units, each unit has 10^18  minimum fractions which are called 
    // Owner of this contract
    address public owner;

    // Balances for each account
    mapping(address =&gt; uint256) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed;

    // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function IsFreezedAccount(address _addr) public constant returns (bool) {
        return frozenAccount[_addr];
    }

    // Constructor
    function Token() public {
        owner = msg.sender;
        balances[owner] = _totalSupply;
    }

    function totalSupply() public constant returns (uint256 supply) {
        supply = _totalSupply;
    }

    // What is the balance of a particular account?
    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    // Transfer the balance from owner&#39;s account to another account
    function transfer(address _to, uint256 _value) public returns (bool success)
    {
        if (_to != 0x0  // Prevent transfer to 0x0 address.
            &amp;&amp; IsFreezedAccount(msg.sender) == false
            &amp;&amp; balances[msg.sender] &gt;= _value 
            &amp;&amp; _value &gt; 0
            &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[msg.sender] = balances[msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value);
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    // Send _value amount of tokens from address _from to address _to
    // The transferFrom method is used for a withdraw workflow, allowing contracts to send
    // tokens on your behalf, for example to &quot;deposit&quot; to a contract address and/or to charge
    // fees in sub-currencies; the command should fail unless the _from account has
    // deliberately authorized the sender of the message via some mechanism; we propose
    // these standardized APIs for approval:
    function transferFrom(address _from,address _to, uint256 _value) public returns (bool success) {
        if (_to != 0x0  // Prevent transfer to 0x0 address.
            &amp;&amp; IsFreezedAccount(_from) == false
            &amp;&amp; balances[_from] &gt;= _value
            &amp;&amp; allowed[_from][msg.sender] &gt;= _value
            &amp;&amp; _value &gt; 0
            &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[_from] = balances[_from].sub(_value);
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value);
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    function FreezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }
}
 
contract LinkerCoin is Token {
    
    //LP Setup lp:liquidity provider
    
    uint8 public constant decimalOfPrice = 10;  // LNC/ETH
    uint256 public constant multiplierOfPrice = 10000000000;
    uint256 public constant multiplier = 1000000000000000000;
    uint256 public lpAskPrice = 100000000000; //LP sell price
    uint256 public lpBidPrice = 1; //LP buy price
    uint256 public lpAskVolume = 0; //LP sell volume
    uint256 public lpBidVolume = 0; //LP buy volume
    uint256 public lpMaxVolume = 1000000000000000000000000; //the deafult maximum volume of the liquididty provider is 10000 LNC
    
    //LP Para
    uint256 public edgePerPosition = 1; // (lpTargetPosition - lpPosition) / edgePerPosition = the penalty of missmatched position
    uint256 public lpTargetPosition;
    uint256 public lpFeeBp = 10; // lpFeeBp is basis point of fee collected by LP
    
    bool public isLpStart = false;
    bool public isBurn = false;
    
    function LinkerCoin() public {
        balances[msg.sender] = _totalSupply;
        lpTargetPosition = 200000000000000000000000000;
    }
    
    event Burn(address indexed from, uint256 value);
    function burn(uint256 _value) onlyOwner public returns (bool success) {
        if (isBurn == true)
        {
            balances[msg.sender] = balances[msg.sender].sub(_value);
            _totalSupply = _totalSupply.sub(_value);
            Burn(msg.sender, _value);
            return true;
        }
        else{
            return false;
        }
    }
    
    event SetBurnStart(bool _isBurnStart);
    function setBurnStart(bool _isBurnStart) onlyOwner public {
        isBurn = _isBurnStart;
    }

    //Owner will be Lp 
    event SetPrices(uint256 _lpBidPrice, uint256 _lpAskPrice, uint256 _lpBidVolume, uint256 _lpAskVolume);
    function setPrices(uint256 _lpBidPrice, uint256 _lpAskPrice, uint256 _lpBidVolume, uint256 _lpAskVolume) onlyOwner public{
        require(_lpBidPrice &lt; _lpAskPrice);
        require(_lpBidVolume &lt;= lpMaxVolume);
        require(_lpAskVolume &lt;= lpMaxVolume);
        lpBidPrice = _lpBidPrice;
        lpAskPrice = _lpAskPrice;
        lpBidVolume = _lpBidVolume;
        lpAskVolume = _lpAskVolume;
        SetPrices(_lpBidPrice, _lpAskPrice, _lpBidVolume, _lpAskVolume);
    }
    
    event SetLpMaxVolume(uint256 _lpMaxVolume);
    function setLpMaxVolume(uint256 _lpMaxVolume) onlyOwner public {
        require(_lpMaxVolume &lt; 1000000000000000000000000);
        lpMaxVolume = _lpMaxVolume;
        if (lpMaxVolume &lt; lpBidVolume){
            lpBidVolume = lpMaxVolume;
        }
        if (lpMaxVolume &lt; lpAskVolume){
            lpAskVolume = lpMaxVolume;
        }
        SetLpMaxVolume(_lpMaxVolume);
    }
    
    event SetEdgePerPosition(uint256 _edgePerPosition);
    function setEdgePerPosition(uint256 _edgePerPosition) onlyOwner public {
        //require(_edgePerPosition &lt; 100000000000000000000000000000);
        edgePerPosition = _edgePerPosition;
        SetEdgePerPosition(_edgePerPosition);
    }
    
    event SetLPTargetPostion(uint256 _lpTargetPositionn);
    function setLPTargetPostion(uint256 _lpTargetPosition) onlyOwner public {
        require(_lpTargetPosition &lt;totalSupply() );
        lpTargetPosition = _lpTargetPosition;
        SetLPTargetPostion(_lpTargetPosition);
    }
    
    event SetLpFee(uint256 _lpFeeBp);
    function setLpFee(uint256 _lpFeeBp) onlyOwner public {
        require(_lpFeeBp &lt;= 100);
        lpFeeBp = _lpFeeBp;
        SetLpFee(lpFeeBp);
    }
    
    event SetLpIsStart(bool _isLpStart);
    function setLpIsStart(bool _isLpStart) onlyOwner public {
        isLpStart = _isLpStart;
    }
    
    function getLpBidPrice()public constant returns (uint256)
    { 
        uint256 lpPosition = balanceOf(owner);
            
        if (lpTargetPosition &gt;= lpPosition)
        {
            return lpBidPrice;
        }
        else
        {
            return lpBidPrice.sub((((lpPosition.sub(lpTargetPosition)).div(multiplier)).mul(edgePerPosition)).div(multiplierOfPrice));
        }
    }
    
    function getLpAskPrice()public constant returns (uint256)
    {
        uint256 lpPosition = balanceOf(owner);
            
        if (lpTargetPosition &lt;= lpPosition)
        {
            return lpAskPrice;
        }
        else
        {
            return lpAskPrice.add((((lpTargetPosition.sub(lpPosition)).div(multiplier)).mul(edgePerPosition)).div(multiplierOfPrice));
        }
    }
    
    function getLpIsWorking(int minSpeadBp) public constant returns (bool )
    {
        if (isLpStart == false)
            return false;
         
        if (lpAskVolume == 0 || lpBidVolume == 0)
        {
            return false;
        }
        
        int256 bidPrice = int256(getLpBidPrice());
        int256 askPrice = int256(getLpAskPrice());
        
        if (askPrice - bidPrice &gt; minSpeadBp * (bidPrice + askPrice) / 2 / 10000)
        {
            return false;
        }
        
        return true;
    }
    
    function getAmountOfLinkerBuy(uint256 etherAmountOfSell) public constant returns (uint256)
    {
        return ((( multiplierOfPrice.mul(etherAmountOfSell) ).div(getLpAskPrice())).mul(uint256(10000).sub(lpFeeBp))).div(uint256(10000));
    }
    
    function getAmountOfEtherSell(uint256 linkerAmountOfBuy) public constant returns (uint256)
    {
        return (((getLpBidPrice().mul(linkerAmountOfBuy)).div(multiplierOfPrice)).mul(uint256(10000).sub(lpFeeBp))).div(uint256(10000));
    }
    
    function () public payable {
    }
    
    function buy() public payable returns (uint256){
        require (getLpIsWorking(500));                      // Check Whether Lp Bid and Ask spread is less than 5%
        uint256 amount = getAmountOfLinkerBuy(msg.value);   // calculates the amount of buy from customer 
        require(balances[owner] &gt;= amount);                  // checks if it has enough to sell
        balances[msg.sender] = balances[msg.sender].add(amount);                     // adds the amount to buyer&#39;s balance
        balances[owner] = balances[owner].sub(amount);                           // subtracts amount from seller&#39;s balance
        lpAskVolume = lpAskVolume.sub(amount);
        Transfer(owner, msg.sender, amount);                 // execute an event reflecting the chang               // ends function and returns
        return amount;                                    
    }
    
    function sell(uint256 amount)public returns (uint256) {    
        require (getLpIsWorking(500));
        require (balances[msg.sender] &gt;= amount);           // checks if the sender has enough to sell
        balances[owner] = balances[owner].add(amount);                           // adds the amount to owner&#39;s balance
        balances[msg.sender] = balances[msg.sender].sub(amount);                     // subtracts the amount from seller&#39;s balance
        lpBidVolume = lpBidVolume.sub(amount);
        uint256 linkerSendAmount = getAmountOfEtherSell(amount);
        
        msg.sender.transfer(linkerSendAmount);         // sends ether to the seller: it&#39;s important to do this last to prevent recursion attacks
        Transfer(msg.sender, this, linkerSendAmount);       // executes an event reflecting on the change
        return linkerSendAmount;                                   // ends function and returns
    }
    
    function transferEther(uint256 amount) onlyOwner public{
        msg.sender.transfer(amount);
        Transfer(msg.sender, this, amount);
    }
}