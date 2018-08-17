pragma solidity ^0.4.18;

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

    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ERC223 {
    uint public totalSupply;

    function balanceOf(address who) public view returns (uint);
    function totalSupply() public view returns (uint256 _supply);
    function transfer(address to, uint value) public returns (bool ok);
    function transfer(address to, uint value, bytes data) public returns (bool ok);
    function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);

    function name() public view returns (string _name);
    function symbol() public view returns (string _symbol);
    function decimals() public view returns (uint8 _decimals);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

 contract ContractReceiver {

    struct TKN {
        address sender;
        uint value;
        bytes data;
        bytes4 sig;
    }

    function tokenFallback(address _from, uint _value, bytes _data) public pure {
        TKN memory tkn;
        tkn.sender = _from;
        tkn.value = _value;
        tkn.data = _data;
        uint32 u = uint32(_data[3]) + (uint32(_data[2]) &lt;&lt; 8) + (uint32(_data[1]) &lt;&lt; 16) + (uint32(_data[0]) &lt;&lt; 24);
        tkn.sig = bytes4(u);
    }
}

contract OCTCOIN is ERC223, Ownable {
    using SafeMath for uint256;

    string public name = &quot;OCTCOIN&quot;;
    string public symbol = &quot;OCTC&quot;;
    uint8 public decimals = 6;
    uint256 public totalSupply = 50e9 * 1e6;
    uint256 public distributeAmount = 0;
    
    mapping(address =&gt; uint256) public balanceOf;
    mapping(address =&gt; mapping (address =&gt; uint256)) public allowance;
    mapping (address =&gt; bool) public frozenAccount;
    mapping (address =&gt; uint256) public unlockUnixTime;
    
    event FrozenFunds(address indexed target, bool frozen);
    event LockedFunds(address indexed target, uint256 locked);
    event Burn(address indexed from, uint256 amount);

    function OCTCOIN() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function name() public view returns (string _name) {
        return name;
    }

    function symbol() public view returns (string _symbol) {
        return symbol;
    }

    function decimals() public view returns (uint8 _decimals) {
        return decimals;
    }

    function totalSupply() public view returns (uint256 _totalSupply) {
        return totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
        require(targets.length &gt; 0);

        for (uint j = 0; j &lt; targets.length; j++) {
            require(targets[j] != 0x0);
            frozenAccount[targets[j]] = isFrozen;
            FrozenFunds(targets[j], isFrozen);
        }
    }

    function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
        require(targets.length &gt; 0
                &amp;&amp; targets.length == unixTimes.length);
                
        for(uint j = 0; j &lt; targets.length; j++){
            require(unlockUnixTime[targets[j]] &lt; unixTimes[j]);
            unlockUnixTime[targets[j]] = unixTimes[j];
            LockedFunds(targets[j], unixTimes[j]);
        }
    }

    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
        require(_value &gt; 0
                &amp;&amp; frozenAccount[msg.sender] == false 
                &amp;&amp; frozenAccount[_to] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender] 
                &amp;&amp; now &gt; unlockUnixTime[_to]);

        if (isContract(_to)) {
            require(balanceOf[msg.sender] &gt;= _value);
            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
            balanceOf[_to] = balanceOf[_to].add(_value);
            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
            Transfer(msg.sender, _to, _value, _data);
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return transferToAddress(_to, _value, _data);
        }
    }

    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
        require(_value &gt; 0
                &amp;&amp; frozenAccount[msg.sender] == false 
                &amp;&amp; frozenAccount[_to] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender] 
                &amp;&amp; now &gt; unlockUnixTime[_to]);

        if (isContract(_to)) {
            return transferToContract(_to, _value, _data);
        } else {
            return transferToAddress(_to, _value, _data);
        }
    }

    function transfer(address _to, uint _value) public returns (bool success) {
        require(_value &gt; 0
                &amp;&amp; frozenAccount[msg.sender] == false 
                &amp;&amp; frozenAccount[_to] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender] 
                &amp;&amp; now &gt; unlockUnixTime[_to]);

        bytes memory empty;
        if (isContract(_to)) {
            return transferToContract(_to, _value, empty);
        } else {
            return transferToAddress(_to, _value, empty);
        }
    }

    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
            length := extcodesize(_addr)
        }
        return (length &gt; 0);
    }

    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf[msg.sender] &gt;= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        Transfer(msg.sender, _to, _value, _data);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf[msg.sender] &gt;= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        ContractReceiver receiver = ContractReceiver(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
        Transfer(msg.sender, _to, _value, _data);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0)
                &amp;&amp; _value &gt; 0
                &amp;&amp; balanceOf[_from] &gt;= _value
                &amp;&amp; allowance[_from][msg.sender] &gt;= _value
                &amp;&amp; frozenAccount[_from] == false 
                &amp;&amp; frozenAccount[_to] == false
                &amp;&amp; now &gt; unlockUnixTime[_from] 
                &amp;&amp; now &gt; unlockUnixTime[_to]);

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowance[_owner][_spender];
    }

    function burn(address _from, uint256 _unitAmount) onlyOwner public {
        require(_unitAmount &gt; 0
                &amp;&amp; balanceOf[_from] &gt;= _unitAmount);

        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
        totalSupply = totalSupply.sub(_unitAmount);
        Burn(_from, _unitAmount);
    }

    function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
        require(amount &gt; 0 
                &amp;&amp; addresses.length &gt; 0
                &amp;&amp; frozenAccount[msg.sender] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender]);

        amount = amount.mul(1e6);
        uint256 totalAmount = amount.mul(addresses.length);
        require(balanceOf[msg.sender] &gt;= totalAmount);
        
        for (uint j = 0; j &lt; addresses.length; j++) {
            require(addresses[j] != 0x0
                    &amp;&amp; frozenAccount[addresses[j]] == false
                    &amp;&amp; now &gt; unlockUnixTime[addresses[j]]);

            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
            Transfer(msg.sender, addresses[j], amount);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
        return true;
    }

    function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
        require(addresses.length &gt; 0
                &amp;&amp; addresses.length == amounts.length
                &amp;&amp; frozenAccount[msg.sender] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender]);
                
        uint256 totalAmount = 0;
        
        for(uint j = 0; j &lt; addresses.length; j++){
            require(amounts[j] &gt; 0
                    &amp;&amp; addresses[j] != 0x0
                    &amp;&amp; frozenAccount[addresses[j]] == false
                    &amp;&amp; now &gt; unlockUnixTime[addresses[j]]);
                    
            amounts[j] = amounts[j].mul(1e6);
            totalAmount = totalAmount.add(amounts[j]);
        }
        require(balanceOf[msg.sender] &gt;= totalAmount);
        
        for (j = 0; j &lt; addresses.length; j++) {
            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
            Transfer(msg.sender, addresses[j], amounts[j]);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
        return true;
    }

    function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
        require(addresses.length &gt; 0
                &amp;&amp; addresses.length == amounts.length);

        uint256 totalAmount = 0;
        
        for (uint j = 0; j &lt; addresses.length; j++) {
            require(amounts[j] &gt; 0
                    &amp;&amp; addresses[j] != 0x0
                    &amp;&amp; frozenAccount[addresses[j]] == false
                    &amp;&amp; now &gt; unlockUnixTime[addresses[j]]);
                    
            amounts[j] = amounts[j].mul(1e6);
            require(balanceOf[addresses[j]] &gt;= amounts[j]);
            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
            totalAmount = totalAmount.add(amounts[j]);
            Transfer(addresses[j], msg.sender, amounts[j]);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
        return true;
    }

    function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
        distributeAmount = _unitAmount;
    }
    
    function autoDistribute() payable public {
        require(distributeAmount &gt; 0
                &amp;&amp; balanceOf[owner] &gt;= distributeAmount
                &amp;&amp; frozenAccount[msg.sender] == false
                &amp;&amp; now &gt; unlockUnixTime[msg.sender]);
        if(msg.value &gt; 0) owner.transfer(msg.value);
        
        balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
        Transfer(owner, msg.sender, distributeAmount);
    }

    function() payable public {
        autoDistribute();
     }
}