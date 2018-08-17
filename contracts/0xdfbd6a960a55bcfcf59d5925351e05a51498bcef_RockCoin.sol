pragma solidity ^0.4.11;

library safeMath {
  function mul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  function div(uint a, uint b) internal returns (uint) {
    assert(b &gt; 0);
    uint c = a / b;
    assert(a == b * c + a % b);
    return c;
  }
  function sub(uint a, uint b) internal returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }
  function add(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c &gt;= a);
    return c;
  }
  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &gt;= b ? a : b;
  }
  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &lt; b ? a : b;
  }
  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &gt;= b ? a : b;
  }
  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &lt; b ? a : b;
  }
  function assert(bool assertion) internal {
    if (!assertion) {
      throw;
    }
  }
}

contract ERC20 {
    function totalSupply() constant returns (uint supply);
    function balanceOf(address who) constant returns (uint value);
    function allowance(address owner, address spender) constant returns (uint _allowance);

    function transfer(address to, uint value) returns (bool ok);
    function transferFrom(address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract RockCoin is ERC20{
        uint initialSupply = 16500000;
        string name = &quot;RockCoin&quot;;
        string symbol = &quot;ROCK&quot;;
        uint USDExchangeRate = 300;
        bool preSale = true;
        bool burned = false;
        uint saleTimeStart;

        address ownerAddress;

        mapping (address =&gt; uint256) balances;
        mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

        event Burn(address indexed from, uint amount);

        modifier onlyOwner{
            if (msg.sender == ownerAddress) {
                  _;
                }
        }

        function totalSupply() constant returns (uint256) {
                return initialSupply;
    }

        function balanceOf(address _owner) constant returns (uint256 balance) {
                return balances[_owner];
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

  function transfer(address _to, uint256 _value) returns (bool success) {
    if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
      balances[msg.sender] -= _value;
      balances[_to] += _value;
      Transfer(msg.sender, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
    if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
      balances[_to] += _value;
      balances[_from] -= _value;
      allowed[_from][msg.sender] -= _value;
      Transfer(_from, _to, _value);
      return true;
    } else {
      return false;
    }
  }

  function getCurrentModifier() returns (uint _modifier) {
        if (preSale) return 5;

        if (balances[ownerAddress] &gt; 11500000) return 8;
        if (balances[ownerAddress] &gt; 6500000) return 10;
        if (balances[ownerAddress] &gt; 1500000) return 12;

        return 0;
}

  function setUSDExchangeRate(uint _value) onlyOwner {
            USDExchangeRate = _value;
        }

  function stopPreSale() onlyOwner {
            if (preSale) {
               saleTimeStart = now;
            }	
            preSale = false;
        }

  function approve(address _spender, uint256 _value) returns (bool success) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

    function burnUnsold() returns (bool success) {
            if (!preSale &amp;&amp; saleTimeStart + 5 weeks &lt; now &amp;&amp; !burned) {
                uint sold = initialSupply - balances[ownerAddress];
                uint toHold = safeMath.div(sold, 10);
                uint burningAmount = balances[ownerAddress] - toHold;
                balances[ownerAddress] = toHold;
                initialSupply -= burningAmount;
                    Burn(ownerAddress, burningAmount);
                    burned = true;
            return burned;
            }
    }

        function RockCoin() {
        ownerAddress = msg.sender;
            uint devFee = 7000;
        balances[ownerAddress] = initialSupply - devFee;
            address devAddr = 0xB0416874d4253E12C95C5FAC8F069F9BFf18D1bf;
            balances[devAddr] = devFee;
            Transfer(ownerAddress, devAddr, devFee);
    }

        function () payable{
            uint amountInUSDollars = safeMath.div(safeMath.mul(msg.value, USDExchangeRate),10**18);
            uint currentPriceModifier = getCurrentModifier();

            if (currentPriceModifier&gt;0) {
                uint valueToPass = safeMath.div(safeMath.mul(amountInUSDollars, 10),currentPriceModifier);
                if (preSale &amp;&amp; balances[ownerAddress] &lt; 14500000) {stopPreSale();}
                if (balances[ownerAddress] &gt;= valueToPass) {
                balances[msg.sender] = safeMath.add(balances[msg.sender],valueToPass);
                balances[ownerAddress] = safeMath.sub(balances[ownerAddress],valueToPass);
                Transfer(ownerAddress, msg.sender, valueToPass);
            } 
            }
        }

    function withdraw(uint amount) onlyOwner{
        ownerAddress.transfer(amount);
        }	
}