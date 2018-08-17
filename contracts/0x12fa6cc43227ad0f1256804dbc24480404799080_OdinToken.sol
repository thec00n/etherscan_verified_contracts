// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// ODIN token contract 
// ----------------------------------------------------------------------------
pragma solidity ^0.4.21;

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

contract ERC20Interface {
//    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Burn(uint tokens);

    // mitigates the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length &gt;= size + 4);
        _;
    }
    
}

contract Owned {
    address public owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

}

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract OdinToken is ERC20Interface, Owned {

  using SafeMath for uint256;

    string public symbol;
    string public name;
    uint8 public decimals;
//    uint private totalSupply;
    bool private _whitelistAll;

    struct balanceData {  
       bool locked;
       uint balance;
       uint airDropQty;
    }

    mapping(address =&gt; balanceData) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;


  /**
  * @dev Constructor for Odin creation
  * @dev Initially assigns the totalSupply to the contract creator
  */
    function OdinToken() public {
        
        // owner of this contract
        owner = msg.sender;
        symbol = &quot;ODIN&quot;;
        name = &quot;ODIN Token&quot;;
        decimals = 18;
        _whitelistAll=false;
        totalSupply = 100000000000000000000000;
        balances[owner].balance = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // function totalSupply() constant public returns (uint256 totalSupply) {
    //     return totalSupply;
    // }
    uint256 public totalSupply;


    // ------------------------------------------------------------------------
    // whitelist an address
    // ------------------------------------------------------------------------
    function whitelistAddress(address tokenOwner) onlyOwner public returns (bool)    {
		balances[tokenOwner].airDropQty = 0;
		return true;
    }


    /**
  * @dev Whitelist all addresses early
  * @return An bool showing if the function succeeded.
  */
    function whitelistAllAddresses() onlyOwner public returns (bool) {
        _whitelistAll = true;
        return true;
    }


    /**
  * @dev Gets the balance of the specified address.
  * @param tokenOwner The address to query the the balance of.
  * @return An uint representing the amount owned by the passed address.
  */
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner].balance;
    }

    function airdrop(address[] recipients, uint[] values) onlyOwner public {

    require(recipients.length &lt;= 255);
    require (msg.sender==owner);
    require(recipients.length == values.length);
    for (uint i = 0; i &lt; recipients.length; i++) {
        if (balances[recipients[i]].balance==0) {
          OdinToken.transfer(recipients[i], values[i]);
    }
    }
  }
  
    function canSpend(address tokenOwner, uint _value) public constant returns (bool success) {

        if (_value &gt; balances[tokenOwner].balance) {return false;}     // do they have enough to spend?
        if (tokenOwner==address(0)) {return false;}                               // cannot send to address[0]

        if (tokenOwner==owner) {return true;}                                       // owner can always spend
        if (_whitelistAll) {return true;}                                   // we pulled the rip cord
        if (balances[tokenOwner].airDropQty==0) {return true;}                      // these are not airdrop tokens
        if (block.timestamp&gt;1569974400) {return true;}                      // no restrictions after june 30, 2019

        // do not allow transfering air dropped tokens prior to Sep 1 2018
         if (block.timestamp &lt; 1535760000) {return false;}

        // after Sep 1 2018 and before Dec 31, 2018, do not allow transfering more than 10% of air dropped tokens
        if (block.timestamp &lt; 1546214400 &amp;&amp; (balances[tokenOwner].balance - _value) &lt; (balances[tokenOwner].airDropQty / 10 * 9)) {
            return false;
        }

        // after Dec 31 2018 and before March 31, 2019, do not allow transfering more than 25% of air dropped tokens
        if (block.timestamp &lt; 1553990400 &amp;&amp; (balances[tokenOwner].balance - _value) &lt; balances[tokenOwner].airDropQty / 4 * 3) {
            return false;
        }

        // after March 31, 2019 and before Jun 30, 2019, do not allow transfering more than 50% of air dropped tokens
        if (block.timestamp &lt; 1561852800 &amp;&amp; (balances[tokenOwner].balance - _value) &lt; balances[tokenOwner].airDropQty / 2) {
            return false;
        }

        // after Jun 30, 2019 and before Oct 2, 2019, do not allow transfering more than 75% of air dropped tokens
        if (block.timestamp &lt; 1569974400 &amp;&amp; (balances[tokenOwner].balance - _value) &lt; balances[tokenOwner].airDropQty / 4) {
            return false;
        }
        
        return true;

    }

    function transfer(address to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {

        require (canSpend(msg.sender, _value));
        balances[msg.sender].balance = balances[msg.sender].balance.sub( _value);
        balances[to].balance = balances[to].balance.add( _value);
        if (msg.sender == owner) {
            balances[to].airDropQty = balances[to].airDropQty.add( _value);
        }
        emit Transfer(msg.sender, to,  _value);
        return true;
    }

    function approve(address spender, uint  _value) public returns (bool success) {

        require (canSpend(msg.sender, _value));

        // // mitigates the ERC20 spend/approval race condition
        // if ( _value != 0 &amp;&amp; allowed[msg.sender][spender] != 0) { return false; }

        allowed[msg.sender][spender] =  _value;
        emit Approval(msg.sender, spender,  _value);
        return true;
    }

    function transferFrom(address from, address to, uint  _value) onlyPayloadSize(3 * 32) public returns (bool success) {

        if (balances[from].balance &gt;=  _value &amp;&amp; allowed[from][msg.sender] &gt;=  _value &amp;&amp;  _value &gt; 0) {

            allowed[from][msg.sender].sub( _value);
            balances[from].balance = balances[from].balance.sub( _value);
            balances[to].balance = balances[to].balance.add( _value);
            emit Transfer(from, to,  _value);
          return true;
        } else {
          require(false);
        }
      }
    

    // ------------------------------------------------------------------------
    // not implemented
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    
    // ------------------------------------------------------------------------
    // Used to burn unspent tokens in the contract
    // ------------------------------------------------------------------------
    function burn(uint  _value) onlyOwner public returns (bool) {
        require((balances[owner].balance -  _value) &gt;= 0);
        balances[owner].balance = balances[owner].balance.sub( _value);
        totalSupply = totalSupply.sub( _value);
        emit Burn( _value);
        return true;
    }

}