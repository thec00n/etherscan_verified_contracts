pragma solidity ^0.4.19;

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
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
contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract ERC20Basic is Ownable {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address =&gt; uint256) balances;

  uint256 totalSupply_;

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }
}
contract Justo is BasicToken {

  string public constant symbol = &quot;JTO&quot;;
  string public constant name = &quot;Justo&quot;;
  uint256 public constant decimals = 18;
  uint256 public totalCreationCap = 40e9 * (10**uint256(decimals));
  uint256 public totalSupply = 0;
  address public owner;
  address public fundsWallet = 0xa0b85a31A53b024240c89a1Cf65BCC48bb34DeDa;
  uint256 public tokenExchangeRate =  200000;
  mapping(address =&gt; uint256) balances;
  mapping(address =&gt; mapping (address =&gt; uint256)) allowed;
  
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  function Justo() public{
  owner = msg.sender;
  timeOfLastProof = now;
  }
function () public payable {
  create(msg.sender);
  fundsWallet.transfer(msg.value);
}
 function create(address beneficiary)public payable{
    uint256 amount = msg.value;
   
    if(amount &gt; 0){
      balances[beneficiary] += amount * tokenExchangeRate;
      totalSupply += amount * tokenExchangeRate;
    }if(totalSupply &gt; totalCreationCap) { revert();
    }
  }
function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
}
function collect(uint256 amount) onlyOwner public{
  msg.sender.transfer(amount);
}
function transfer(address _to, uint256 _amount) public returns (bool success) {
    if (balances[msg.sender] &gt;= _amount
        &amp;&amp; _amount &gt; 0
        &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
        return true;
    } else {
        return false;
    }
}
function transferFrom(
    address _from,
    address _to,
    uint256 _amount
) public returns (bool success) {
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
function approve(address _spender, uint256 _amount) public returns (bool success) {
    allowed[msg.sender][_spender] = _amount;
    Approval(msg.sender, _spender, _amount);
    return true;
}
function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
}
    bytes32 public currentChallenge;
    uint public timeOfLastProof;
    uint public difficulty = 10**32;

function proofOfWork(uint nonce){
        bytes8 n = bytes8(keccak256(nonce, currentChallenge)); 
        require(n &gt;= bytes8(difficulty));

        uint timeSinceLastProof = (now - timeOfLastProof); 
        require(timeSinceLastProof &gt;=  5 seconds);  
        balances[msg.sender] += timeSinceLastProof / 60 seconds; 

        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1; 

        timeOfLastProof = now;                              // Reset the counter
        currentChallenge = keccak256(nonce, currentChallenge, block.blockhash(block.number - 1));  // Save a hash that will be used as the next proof
    }
}