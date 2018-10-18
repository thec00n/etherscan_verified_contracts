pragma solidity ^0.4.15;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }
}

contract Token {
    uint256 public totalSupply;
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/*  ERC 20 token */
contract StandardToken is Token {
    using SafeMath for uint256;
    function transfer(address _to, uint256 _value) external returns (bool success) {
      if (balances[msg.sender] >= _value) {
        balances[msg.sender] -= _value;
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
      if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender,  uint256 _value) external returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    function increaseApproval (address _spender, uint _addedValue) external returns (bool success) {
      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }

    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
      uint oldValue = allowed[msg.sender][_spender];
      if (_subtractedValue >= oldValue) {
        allowed[msg.sender][_spender] = 0;
      } else {
        allowed[msg.sender][_spender] -= _subtractedValue;
      }
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract Ownable {
    event TransferOwner(address _from, address _to);

    address public owner;
    
    constructor() public {
        owner = msg.sender;
        emit TransferOwner(0x0, msg.sender);
    }
    
    function setOwner(address _owner) external returns (bool) {
        require(owner == msg.sender);
        owner = _owner;
        emit TransferOwner(msg.sender, _owner);
        return true;
    }
}

contract MintableToken is StandardToken, Ownable {
    function mint(address _to, uint256 _amount) external returns (bool) {
        require(owner == msg.sender, "Only owner can mint");
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(0x0, _to, _amount);
        return true;
    }
}

contract MetaToken is MintableToken {
    string private iName;
    string private iSymbol;
    uint8 private iDecimals;

    // The admin can only change metadata
    // it can't mint tokens or change values
    address public admin;

    constructor(
        string _name,
        string _symbol,
        uint8 _decimals,
        address _admin
    ) public {
        iName = _name;
        iSymbol = _symbol;
        iDecimals = _decimals;
        admin = _admin;
    }
    
    function name() external view returns (string) {
        return iName;
    }
    
    function symbol() external view returns (string) {
        return iSymbol;
    }
    
    function decimals() external view returns (uint8) {
        return iDecimals;
    }
    
    function setName(string _name) external {
        require(msg.sender == admin, "Only admin");
        iName = _name;
    }
    
    function setSymbol(string _symbol) external {
        require(msg.sender == admin, "Only admin");
        iSymbol = _symbol;
    }
    
    function setAdmin(address _admin) external {
        require(msg.sender == admin, "Only admin");
        admin = _admin;
    }
}

contract Button is Ownable {
    // metadata
    string public constant name = "THE BUTTON";
    string public constant symbol = "BUTTON";
    string public constant version = "0.0";
    uint8 public constant decimals = 0;
    uint256 public constant totalSupply = 1;
    
    uint256 private _ticket = 750000000000000;
    uint256 public end;
    
    // 1 hour
    uint256 public duration = 1 * 60 * 60;
    
    // Ticket window
    uint256 public window = 24 * 60 * 60;
    
    // Plays in window
    
    // E-BUTTON Tokens
    MetaToken public eButton;
    MetaToken public eTicket;
    MetaToken public wtToken;

    // Winner
    address public best;
    
    // Bids
    mapping(uint256 => uint256) public total;
    
    // Events 
    event Buy(address _by, uint256 _ticket, uint256 _end);
    event Claim(address _by, uint256 _amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    
    constructor() public {
        end = now + duration;
        eButton = new MetaToken('E-BUTTON Token', "E-BUTTON", 18, msg.sender);
        eTicket = new MetaToken('TICKET Token', "T-BUTTON", 0, msg.sender);
        wtToken = new MetaToken('Why ??? token', 'WHY', 0, msg.sender);
    }
    
    function balanceOf(address _owner) external view returns (uint256) {
        return _owner == best ? 1 : 0; 
    }
    
    function ticket() external view returns (uint256) {
        if (total[now / window] == 0) {
            // Recalc ticket
            uint256 lastPlayDay = (end - duration) / window;
            return (total[lastPlayDay] / 30 + _ticket * 2) / 3;
        } else {
            return _ticket;
        }
    }
    
    function claim() external returns (bool) {
        require(msg.sender == best, "The caller is not the winner");
        require(now >= end, "The round didn't end");
        require(best.send(address(this).balance), "The winner can't receive ETH");
        emit Claim(msg.sender, address(this).balance);
        _ticket = 750000000000000;
        return true;
    }
    
    function transfer(address _to, uint256 _amount) external returns (bool) {
        require(_amount == 1, "THERE IS ONLY ONE BUTTON");
        require(msg.sender == best, "THE BUTTON IS NOT YOURS");
        emit Transfer(msg.sender, _to, 1);
        best = _to;
        return true;
    }
    
    function() external payable {
        uint256 day = now / window;

        // Recalc ticket if required
        if (total[day] == 0) {
            uint256 lastPlayDay = (end - duration) / window;
            _ticket = (total[lastPlayDay] / 30 + _ticket * 2) / 3;
        }
        
        require(msg.value >= _ticket, "Didn't pay the ticket");
        emit Transfer(best, msg.sender, 1);
        
        if (best == msg.sender && (end - now) < duration / 4) {
            // GOOD! You are outbidding yourself
            // have a Why token as medal
            wtToken.mint(msg.sender, 1);
        }
        
        best = msg.sender;
        owner.send((msg.value / 100) * 5); // Ignore fee failure
        end = now + duration;

        total[day] += _ticket;

        emit Buy(msg.sender, _ticket, end);

        // Emit extra Tokens
        eButton.mint(msg.sender, _ticket);
        eTicket.mint(msg.sender, 1);
    }
}