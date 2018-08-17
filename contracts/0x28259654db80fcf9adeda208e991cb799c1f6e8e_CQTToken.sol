pragma solidity ^0.4.19;

library SafeMath { //standart library for uint
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0 || b == 0){
        return 0;
    }
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
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

contract Ownable { //standart contract to identify owner

  address public owner;

  address public newOwner;

  address public techSupport;

  address public newTechSupport;

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier onlyTechSupport() {
    require(msg.sender == techSupport);
    _;
  }

  function Ownable() public {
    owner = msg.sender;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require(_newOwner != address(0));
    newOwner = _newOwner;
  }

  function acceptOwnership() public {
    if (msg.sender == newOwner) {
      owner = newOwner;
    }
  }

  function transferTechSupport (address _newSupport) public{
    require (msg.sender == owner || msg.sender == techSupport);
    newTechSupport = _newSupport;
  }

  function acceptSupport() public{
    if(msg.sender == newTechSupport){
      techSupport = newTechSupport;
    }
  }

}

contract CQTToken is Ownable { //ERC - 20 token contract
  using SafeMath for uint;
  // Triggered when tokens are transferred.
  event Transfer(address indexed _from, address indexed _to, uint256 _value);

  // Triggered whenever approve(address _spender, uint256 _value) is called.
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  string public constant symbol = &quot;CQT&quot;;
  string public constant name = &quot;Checqit&quot;;
  uint8 public constant decimals = 8;
  uint256 _totalSupply = 1000000000*pow(10,decimals);

  // Owner of this contract
  address public owner;

  // Balances for each account
  mapping(address =&gt; uint256) balances;

  // Owner of account approves the transfer of an amount to another account
  mapping(address =&gt; mapping (address =&gt; uint256)) allowed;

  function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
    return (a**b);
  }

  function totalSupply() public constant returns (uint256) { //standart ERC-20 function
    return _totalSupply;
  }

  function balanceOf(address _address) public constant returns (uint256 balance) {//standart ERC-20 function
    return balances[_address];
  }

  //standart ERC-20 function
  function transfer(address _to, uint256 _amount) public returns (bool success) {
    require(this != _to);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = balances[_to].add(_amount);
    Transfer(msg.sender,_to,_amount);
    return true;
  }
  
  address public crowdsaleContract;

  bool flag = false;
  //connect to crowdsaleContract, can be use once
  function setCrowdsaleContract (address _address) public{
    require (!flag);
    crowdsaleContract = _address;
    flag = true;
  }

  //standart ERC-20 function
  function transferFrom( 
    address _from,
    address _to,
    uint256 _amount
    )public returns (bool success) {
      require(this != _to);

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
  //standart ERC-20 function
  function approve(address _spender, uint256 _amount)public returns (bool success) { 
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
  }

  //standart ERC-20 function
  function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  //Constructor
  function CQTToken(address _owner) public {
    techSupport = msg.sender;
    //testParameter
    // techSupport = 0x8C0F5211A006bB28D4c694dC76632901664230f9;

    owner = _owner;
    
    balances[this] = _totalSupply;

    teamBalanceMap[_owner] = true;
    futureExpanstionMap[_owner] = true;
    bountyProgramMap[_owner] = true;
  }

  //make investor balance = 0
  function burnTokens(address _address) public{
    require(msg.sender == crowdsaleContract);
    Transfer(_address,0,balances[_address]);
    balances[_address] = 0;
  }

  //burn some tokens in this contract
  function burnSomeTokens(uint _value) public{
    require (msg.sender == crowdsaleContract);
    balances[this] = balances[this].sub(_value);
    Transfer(this,0,_value);
  }

  // only crowdsaleContract can use this balance 
  uint private crowdsaleTokens = (uint)(610000000).mul(pow(10,decimals));

  function getCrowdsaleTokens() public view returns(uint) {
    return crowdsaleTokens;
  }
  
  // balances for owner&#39;s team
  uint public teamBalance = (uint)(250000000).mul(pow(10,decimals));
  uint public futureExpanstion = (uint)(130000000).mul(pow(10,decimals));
  uint public bountyProgram = (uint)(10000000).mul(pow(10,decimals));

  mapping (address =&gt; bool) public teamBalanceMap;
  mapping (address =&gt; bool) public futureExpanstionMap;
  mapping (address =&gt; bool) public bountyProgramMap;

  function addInTeamBalanceMap (address _address) public onlyOwner {
    require(!teamBalanceMap[_address]);
    teamBalanceMap[_address] = true;
  }

  function removeFromTeamBalanceMap (address _address) public onlyOwner {
    require(teamBalanceMap[_address]);
    teamBalanceMap[_address] = false;
  }
  
  function addInFutureExpanstionMap (address _address) public onlyOwner {
    require(!futureExpanstionMap[_address]);
    futureExpanstionMap[_address] = true;
  }
  
  function removeFromFutureExpanstionMap (address _address) public onlyOwner {
    require(futureExpanstionMap[_address]);
    futureExpanstionMap[_address] = false;
  }

  function addInBountyProgramMap (address _address) public onlyOwner {
    require(!bountyProgramMap[_address]);
    bountyProgramMap[_address] = true;
  }
  
  function removeFromBountyProgramMap (address _address) public onlyOwner {
    require(bountyProgramMap[_address]);
    bountyProgramMap[_address] = false;
  }
  
  function sendTeamBalance (address _address, uint _value) public {
    require(teamBalanceMap[msg.sender]);
    teamBalance = teamBalance.sub(_value);
    balances[this] = balances[this].sub(_value);
    balances[_address] = balances[_address].add(_value);
    Transfer(this,_address,_value);
  }

  function sendFutureExpanstionBalance (address _address, uint _value) public {
    require(futureExpanstionMap[msg.sender]);
    futureExpanstion = futureExpanstion.sub(_value);
    balances[this] = balances[this].sub(_value);
    balances[_address] = balances[_address].add(_value);
    Transfer(this,_address,_value);
  }  

  function sendBountyProgramBalance (address _address, uint _value) public {
    require(bountyProgramMap[msg.sender]);
    bountyProgram = bountyProgram.sub(_value);
    balances[this] = balances[this].sub(_value);
    balances[_address] = balances[_address].add(_value);
    Transfer(this,_address,_value);
  }        

  //crowdsale function
  function sendCrowdsaleTokens(address _address, uint256 _value)  public { 
    require (msg.sender == crowdsaleContract);
    crowdsaleTokens = crowdsaleTokens.sub(_value);
    balances[this] = balances[this].sub(_value);
    balances[_address] = balances[_address].add(_value);
    Transfer(this, _address, _value);
  } 
}