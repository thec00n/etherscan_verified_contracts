pragma solidity ^0.4.16;

contract ptxToken {

using SafeMath for uint256;
string public constant symbol = &quot;PTX&quot;;
string public constant name = &quot;ptx Token&quot;;
uint8 public constant decimals = 18;
uint256 _totalSupply = 1000000000 * 10 ** uint256(decimals);

// Owner of this contract
address public owner;

// Balances for each account
mapping(address =&gt; uint256) balances;

// Owner of account approves the transfer of an amount to another account
mapping(address =&gt; mapping (address =&gt; uint256)) allowed;

// Constructor
function ptxToken() public {
   owner = msg.sender;
   balances[owner] = _totalSupply;
}

// ERC20
function totalSupply() public constant returns (uint256) {
   return _totalSupply;
}

function balanceOf(address _owner) public constant returns (uint256 balance) {
   return balances[_owner];
}

function transfer(address _to, uint256 _amount) public returns (bool success) {
   if (balances[msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0) {
       balances[msg.sender] = balances[msg.sender].sub(_amount);
       balances[_to] = balances[_to].add(_amount);
       Transfer(msg.sender, _to, _amount);
       return true;
   } else {
       return false;
   }
}

function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
   if (balances[_from] &gt;= _amount &amp;&amp; allowed[_from][msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0) {
       balances[_from] = balances[_from].sub(_amount);
       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
       balances[_to] = balances[_to].add(_amount);
       Transfer(_from, _to, _amount);
       return true;
   } else {
       return false;
   }
}

function approve(address _spender, uint256 _amount) public returns (bool success) {
   if(balances[msg.sender]&gt;=_amount &amp;&amp; _amount&gt;0) {
       allowed[msg.sender][_spender] = _amount;
       Approval(msg.sender, _spender, _amount);
       return true;
   } else {
       return false;
   }
}

function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
   return allowed[_owner][_spender];
}

event Transfer(address indexed _from, address indexed _to, uint _value);
event Approval(address indexed _owner, address indexed _spender, uint _value);

// custom
function getMyBalance() public view returns (uint) {
   return balances[msg.sender];
}
}

library SafeMath {
function mul(uint256 a, uint256 b) internal constant returns (uint256) {
uint256 c = a * b;
assert(a == 0 || c / a == b);
return c;
}

function div(uint256 a, uint256 b) internal constant returns (uint256) {

uint256 c = a / b;

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