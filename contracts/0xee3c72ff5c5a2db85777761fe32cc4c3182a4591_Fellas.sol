pragma solidity ^0.4.23;

/*
                $$$$$$$$\        $$\ $$\                     
                $$  _____|       $$ |$$ |                    
                $$ |    $$$$$$\  $$ |$$ | $$$$$$\   $$$$$$$\ 
                $$$$$\ $$  __$$\ $$ |$$ | \____$$\ $$  _____|
                $$  __|$$$$$$$$ |$$ |$$ | $$$$$$$ |\$$$$$$\  
                $$ |   $$   ____|$$ |$$ |$$  __$$ | \____$$\ 
                $$ |   \$$$$$$$\ $$ |$$ |\$$$$$$$ |$$$$$$$  |
                \__|    \_______|\__|\__| \_______|\_______/ 
                                                             
                                                        
*/

// SafeMath
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


// Ownable
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}


// ERC223 https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
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


 // ContractReceiver
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

        /*
         * tkn variable is analogue of msg variable of Ether transaction
         * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
         * tkn.value the number of tokens that were sent   (analogue of msg.value)
         * tkn.data is data of token transaction   (analogue of msg.data)
         * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
         */
    }
}


// Fellas
contract Fellas is ERC223, Ownable {
    using SafeMath for uint256;

    string public name = &quot;Fellas&quot;;
    string public symbol = &quot;FELLAS&quot;;
    uint8 public decimals = 8; 
    uint256 public totalSupply = 50e9 * 1e8;
    bool public mintingStopped = false;

    mapping(address =&gt; uint256) public balanceOf;
    mapping(address =&gt; mapping (address =&gt; uint256)) public allowance;

    event Burn(address indexed from, uint256 amount);
    event Mint(address indexed to, uint256 amount);
    event MintStopped();

    constructor () public {
        owner = 0x2ed3C80eD58332f0C221809775eA2A071c01661a;
        balanceOf[owner] = totalSupply;
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

    // transfer
    function transfer(address _to, uint _value) public returns (bool success) {
        require(_value &gt; 0);

        bytes memory empty;
        if (isContract(_to)) {
            return transferToContract(_to, _value, empty);
        } else {
            return transferToAddress(_to, _value, empty);
        }
    }

    function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
        require(_value &gt; 0);

        if (isContract(_to)) {
            return transferToContract(_to, _value, _data);
        } else {
            return transferToAddress(_to, _value, _data);
        }
    }

    function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
        require(_value &gt; 0);

        if (isContract(_to)) {
            require(balanceOf[msg.sender] &gt;= _value);
            balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
            balanceOf[_to] = balanceOf[_to].add(_value);
            assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
            emit Transfer(msg.sender, _to, _value, _data);
            emit Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return transferToAddress(_to, _value, _data);
        }
    }

    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
        }
        return (length &gt; 0);
    }

    // function that is called when transaction target is an address
    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf[msg.sender] &gt;= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value, _data);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // function that is called when transaction target is a contract
    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
        require(balanceOf[msg.sender] &gt;= _value);
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        ContractReceiver receiver = ContractReceiver(_to);
        receiver.tokenFallback(msg.sender, _value, _data);
        emit Transfer(msg.sender, _to, _value, _data);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // transferFrom
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0)
                &amp;&amp; _value &gt; 0
                &amp;&amp; balanceOf[_from] &gt;= _value
                &amp;&amp; allowance[_from][msg.sender] &gt;= _value);

        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    // approve
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // allowance
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowance[_owner][_spender];
    }

    // burn
    function burn(address _from, uint256 _unitAmount) onlyOwner public {
        require(_unitAmount &gt; 0
                &amp;&amp; balanceOf[_from] &gt;= _unitAmount);

        balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
        totalSupply = totalSupply.sub(_unitAmount);
        emit Burn(_from, _unitAmount);
    }

    modifier canMinting() {
        require(!mintingStopped);
        _;
    }

    // mint
    function mint(address _to, uint256 _unitAmount) onlyOwner canMinting public returns (bool) {
        require(_unitAmount &gt; 0);

        totalSupply = totalSupply.add(_unitAmount);
        balanceOf[_to] = balanceOf[_to].add(_unitAmount);
        emit Mint(_to, _unitAmount);
        emit Transfer(address(0), _to, _unitAmount);
        return true;
    }

    // stopMinting
    function stopMinting() onlyOwner canMinting public returns (bool) {
        mintingStopped = true;
        emit MintStopped();
        return true;
    }

    // airdrop
    function airdrop(address[] addresses, uint256 amount) public returns (bool) {
        require(amount &gt; 0
                &amp;&amp; addresses.length &gt; 0);

        amount = amount.mul(1e8);
        uint256 totalAmount = amount.mul(addresses.length);
        require(balanceOf[msg.sender] &gt;= totalAmount);

        for (uint j = 0; j &lt; addresses.length; j++) {
            require(addresses[j] != 0x0);

            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
            emit Transfer(msg.sender, addresses[j], amount);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
        return true;
    }

    // airdropAmounts
    function airdropAmounts(address[] addresses, uint[] amounts) public returns (bool) {
        require(addresses.length &gt; 0
                &amp;&amp; addresses.length == amounts.length);

        uint256 totalAmount = 0;

        for(uint j = 0; j &lt; addresses.length; j++){
            require(amounts[j] &gt; 0
                    &amp;&amp; addresses[j] != 0x0);

            amounts[j] = amounts[j].mul(1e8);
            totalAmount = totalAmount.add(amounts[j]);
        }
        require(balanceOf[msg.sender] &gt;= totalAmount);

        for (j = 0; j &lt; addresses.length; j++) {
            balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
            emit Transfer(msg.sender, addresses[j], amounts[j]);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
        return true;
    }

    // collect
    function collect(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
        require(addresses.length &gt; 0
                &amp;&amp; addresses.length == amounts.length);

        uint256 totalAmount = 0;

        for (uint j = 0; j &lt; addresses.length; j++) {
            require(amounts[j] &gt; 0
                    &amp;&amp; addresses[j] != 0x0);

            amounts[j] = amounts[j].mul(1e8);
            require(balanceOf[addresses[j]] &gt;= amounts[j]);
            balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
            totalAmount = totalAmount.add(amounts[j]);
            emit Transfer(addresses[j], msg.sender, amounts[j]);
        }
        balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
        return true;
    }
}