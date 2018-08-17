pragma solidity ^0.4.13;

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
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

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address =&gt; uint256) balances;

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }

}
contract StandardToken is ERC20, BasicToken {

  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;


  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[_from]);
    require(_value &lt;= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue &gt; oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  function Ownable() public{
    owner = msg.sender;
  }
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply = totalSupply.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;
  }
  function finishMinting() onlyOwner public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}
contract BurnableToken is StandardToken {

  function burn(uint _value) public {
    require(_value &gt; 0);
    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply = totalSupply.sub(_value);
    Burn(burner, _value);
  }

  event Burn(address indexed burner, uint indexed value);

}


contract EWA is MintableToken, BurnableToken {
    
    string public constant name = &quot;EWAcoin&quot;;
    
    string public constant symbol = &quot;EWA&quot;;
    
    uint32 public constant decimals = 0;
    
    struct Trnsaction {
        address addr;
        uint time;
        uint value;
    }
    
    mapping (uint =&gt; Trnsaction) TrnsactionLog;
    
    mapping (address =&gt; uint256) securities;
     
    mapping (address =&gt; uint256) production;
    
    uint public startsecurities;
    
    uint public startproduction;
    
    uint public starteth;
    
    address public moneybackaddr;
    
    uint public i;
    
    function EWA() public{
		owner = msg.sender;
		startsecurities = 1546214400;
		startproduction = 1546214400;
		starteth = 1514764800;
		moneybackaddr = 0x0F99f33cD5a6B1b77eD905C229FC1962D05fE74F;
    }
    
    function destroyforsecurities (uint _value) public {
        require (_value &gt; 99999);
        require (now &gt; startsecurities);
        if(balances[msg.sender] &gt;= _value &amp;&amp; securities[msg.sender] + _value &gt;= securities[msg.sender]) {
            burn (_value);
            securities[msg.sender] += _value;
        }
    }
    
    function securitiesOf(address _owner) public constant returns (uint balance) {
        return securities[_owner];
    }
    
    function destroyforproduction (uint _value) public {
        require (_value &gt; 0);
        require (now &gt; startproduction);
        if(balances[msg.sender] &gt;= _value &amp;&amp; production[msg.sender] + _value &gt;= production[msg.sender]) {
            burn (_value);
            production[msg.sender] += _value;
        }
    }
    
    function productionOf(address _owner) public constant returns (uint balance) {
        return production[_owner];
    }
    
    function destroyforeth (uint _value) public {
        require (_value &gt; 0);
        require (now &gt; starteth);
        require (this.balance &gt; _value.mul(120000000000000));
        if(balances[msg.sender] &gt;= _value) {
            burn (_value);
            TrnsactionLog[i].addr = msg.sender;
            TrnsactionLog[i].time = now;
            TrnsactionLog[i].value = _value;
            i++;
            msg.sender.transfer(_value.mul(120000000000000));
        }
    }
    
    function showTrnsactionLog (uint _number) public constant returns (address addr, uint time, uint value) {
        return (TrnsactionLog[_number].addr, TrnsactionLog[_number].time, TrnsactionLog[_number].value);   
    }
    
    function moneyback () public {
        require  (msg.sender == moneybackaddr);
        uint256 bal = balance1();
        if (bal &gt; 10 ) {
            moneybackaddr.transfer(bal);
        }
    }
    
    function balance1 () public constant returns (uint256){
        return this.balance;
    }
    
    function() external payable {
    }
    
}