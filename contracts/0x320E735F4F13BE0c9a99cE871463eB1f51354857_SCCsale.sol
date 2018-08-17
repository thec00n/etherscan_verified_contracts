pragma solidity ^0.4.18;


contract SafeMath{
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}
contract ERC20{

  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

}
contract SCCsale is ERC20, SafeMath{

  mapping(address =&gt; uint256) balances;

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[msg.sender]);

    balances[msg.sender] = sub(balances[msg.sender],(_value));
    balances[_to] = add(balances[_to],(_value));
    Transfer(msg.sender, _to, _value);
    return true;
  }
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
  
  uint256 public totalSupply;

  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[_from]);
    require(_value &lt;= allowed[_from][msg.sender]);

    balances[_from] = sub(balances[_from],(_value));
    balances[_to] = add(balances[_to],(_value));
    allowed[_from][msg.sender] = sub(allowed[_from][msg.sender],(_value));
    Transfer(_from, _to, _value);
    return true;
  }
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

    modifier during_offering_time(){
        if (now &lt;= startTime){
            revert();
        }else{
            if (totalSupply&gt;=cap){
                revert();
            }else{
                    _;
                }
            }
    }

    function () public payable during_offering_time {
        createTokens(msg.sender);
    }

    function  createTokens(address recipient) public payable  {
        if (msg.value == 0) {
          revert();
        }

        uint tokens = div(mul(msg.value, price), 1 ether);
        uint extra =0;
        
        totalContribution=add(totalContribution,msg.value);   
                
        if (tokens&gt;=1000){
            uint    random_number=uint(keccak256(block.blockhash(block.number-1), tokens ))%6;    
            if (tokens&gt;=50000){
                random_number= 0;
            }            
            if (random_number == 0) {
                extra = add(extra, mul(tokens,10));
            }    
            if (random_number &gt;0) {
                extra = add(extra, mul(tokens,random_number));
            }

        }
        
        if ( (block.number % 2)==0) {
            extra = mul(add(extra,tokens),2);
        }
      
        totalBonusTokensIssued=add(totalBonusTokensIssued,extra);
        tokens= add(tokens,extra);
        totalSupply = add(totalSupply, tokens);
        balances[recipient] = add(balances[recipient], tokens);
        if ( totalSupply&gt;=cap) {
            purchasingAllowed =false;
        }  
        if (!owner.send(msg.value)) {
          revert();
        }
    }
    
    function getStats() constant public returns (uint256, uint256, uint256, bool) {
        return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
    }
    
    uint256 public totalContribution=0;
    uint256 public totalBonusTokensIssued=0;
    bool public purchasingAllowed = true;
    string     public name = &quot;Scam Connect&quot;;
    string     public symbol = &quot;SCC&quot;;
    uint     public decimals = 3;
    uint256 public price;
    address public owner;
    uint256 public startTime;
    uint256 public cap;
  
    function SCCsale() public {
        totalSupply = 0;
        startTime = now + 1 days;


        owner     = msg.sender;
        price     = 100000;
        cap = 7600000;
    }

}