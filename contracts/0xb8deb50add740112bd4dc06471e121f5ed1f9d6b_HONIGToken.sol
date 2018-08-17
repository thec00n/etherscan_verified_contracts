pragma solidity ^0.4.15;


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


contract HONIGToken  {
    using SafeMath for uint256;
    
    string public constant symbol = &quot;HONEY&quot;;
    string public constant name = &quot;HONIGToken&quot;;
    uint8 public constant decimals = 1;
	address public owner;
	uint256 _totalSupply = 1000000;
	
	// Ledger of the balance of the account
	mapping (address =&gt; uint256) balances;
	// Owner of account approves transfer of an account to another account
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    
    // Events can be trigger when certain actions happens
    // Triggered when tokens are transferred
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    // Constructor
    function HONIGToken() {
         owner = msg.sender;
         balances[owner] = _totalSupply;
     }


     /* Send coins */
    function transfer(address _to, uint256 _value) {
        require(balances[msg.sender] &gt;= _value);           // Check if the sender has enough
        require(balances[_to] + _value &gt;= balances[_to]); // Check for overflows
        balances[msg.sender] -= _value;                    // Subtract from the sender
        balances[_to] += _value;                           // Add the same to the recipient
    }
}