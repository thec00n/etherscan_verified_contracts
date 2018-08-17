pragma solidity ^0.4.16;

/**
 * @title Controllable
 * @dev The Controllable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of &quot;user permissions&quot;.
 */
contract Controllable {
    
    address public owner;

    /**
    * @dev The Controllable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    function Controllable() public {
        owner = msg.sender;
    }
    
    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));      
        owner = newOwner;
    }

}

contract QudosTestToken is Controllable {
    
    uint256 public totalSupply;
    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
    
    string public constant name = &quot;QudosTestToken&quot;;
    string public constant symbol = &quot;QTTK&quot;;
    uint32 public constant decimals = 12;

    uint constant restrictedPercent = 25; //should never be set above 100
    address constant restricted = 0xded730565f420e9d70b8Bc66cEf86E6a417BE82D;
    uint constant start = 1509458400;
    uint constant period = 87;
    uint256 public constant hardcap = 30000000000 * 1 ether;
    
    bool public transferAllowed = false;
    bool public mintingFinished = false;
    
    modifier whenTransferAllowed() {
        if(msg.sender != owner){
            require(transferAllowed);
        }
        _;
    }

    modifier saleIsOn() {
        require(now &gt; start &amp;&amp; now &lt; start + period * 1 days);
        _;
    }
    
    modifier canMint() {
        require(!mintingFinished);
        _;
    }
  
    function transfer(address _to, uint256 _value) whenTransferAllowed public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[msg.sender]);
        
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        //assert(balances[_to] &gt;= _value); no need to check, since mint has limited hardcap
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transferFrom(address _from, address _to, uint256 _value) whenTransferAllowed public returns (bool) {
        require(_to != address(0));
        require(_value &lt;= balances[_from]);
        require(_value &lt;= allowed[_from][msg.sender]);
        
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;
        //assert(balances[_to] &gt;= _value); no need to check, since mint has limited hardcap
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        //NOTE: To prevent attack vectors like the one discussed here: 
        //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
        //clients SHOULD make sure to create user interfaces in such a way 
        //that they set the allowance first to 0 before setting it to another value for the same spender. 
    
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
   
    function allowTransfer() onlyOwner public {
        transferAllowed = true;
    }
    
    function mint(address _to, uint256 _value) onlyOwner saleIsOn canMint public returns (bool) {
        require(_to != address(0));
        
        uint restrictedTokens = _value * restrictedPercent / (100 - restrictedPercent);
        uint _amount = _value + restrictedTokens;
        assert(_amount &gt;= _value);
        
        if(_amount + totalSupply &lt;= hardcap){
        
            totalSupply = totalSupply + _amount;
            
            assert(totalSupply &gt;= _amount);
            
            balances[msg.sender] = balances[msg.sender] + _amount;
            assert(balances[msg.sender] &gt;= _amount);
            Mint(msg.sender, _amount);
        
            transfer(_to, _value);
            transfer(restricted, restrictedTokens);
        }
        return true;
    }

    function finishMinting() onlyOwner public returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }
    
    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public returns (bool) {
        require(_value &lt;= balances[msg.sender]);
        // no need to require value &lt;= totalSupply, since that would imply the
        // sender&#39;s balance is greater than the totalSupply, which *should* be an assertion failure
        balances[msg.sender] = balances[msg.sender] - _value;
        totalSupply = totalSupply - _value;
        Burn(msg.sender, _value);
        return true;
    }
    
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(_value &lt;= balances[_from]);
        require(_value &lt;= allowed[_from][msg.sender]);
        balances[_from] = balances[_from] - _value;
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        totalSupply = totalSupply - _value;
        Burn(_from, _value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    event Mint(address indexed to, uint256 amount);

    event MintFinished();

    event Burn(address indexed burner, uint256 value);

}