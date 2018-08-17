pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// &#39;AGRI&#39; - AgriChain Utility Token Contract
//
// Symbol           : AGRI
// Name             : AgriChain Utility Token
// Max Total supply : 1,000,000,000.000000000000000000 (1 billion)
// Decimals         : 18
//
// Company          : AgriChain Pty Ltd (trading as BlockGrain)
//                  : https://agrichain.com
// Version          : 2.1 
// Author           : Martin Halford &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6102150e2100061308020900080f4f020e0c">[email&#160;protected]</a>&gt;
// Published        : 15 Aug 2018
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe Maths
// ----------------------------------------------------------------------------
library SafeMath {
    
    function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
        if (_a == 0) {
            return 0;
        }
        uint256 c = _a * _b;
        require(c / _a == _b, &quot;Muliply overflow error.&quot;);
        return c;
    }

    function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
        require(_b &gt; 0, &quot;Divide by zero error.&quot;); 
        uint256 c = _a / _b;
        return c;
    }

    function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
        require(_b &lt;= _a, &quot;Subtraction overflow error.&quot;);
        uint256 c = _a - _b;
        return c;
    }

    function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
        uint256 c = _a + _b;
        require(c &gt;= _a, &quot;Addition overflow error.&quot;);
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, &quot;Mod overflow error&quot;);
        return a % b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// ----------------------------------------------------------------------------
contract ERC20Interface {

    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {

    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, &quot;Not contract owner.&quot;);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner, &quot;Not new contract owner.&quot;);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// Agri Token
// ----------------------------------------------------------------------------
contract AgriChainToken is ERC20Interface, Owned {
    
    using SafeMath for uint;

    uint256 constant public MAX_SUPPLY = 1000000000000000000000000000; // 1 billion Agri 

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint256 _totalSupply;

    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;

    // Flag to allow or disallow transfers
    bool public isAllowingTransfers;

    // List of admins who can mint, burn and allow transfers of tokens
    mapping (address =&gt; bool) public administrators;

    // modifier to check if transfers being allowed
    modifier allowingTransfers() {
        require(isAllowingTransfers, &quot;Contract currently not allowing transfers.&quot;);
        _;
    }

    // modifier to check admin status
    modifier onlyAdmin() {
        require(administrators[msg.sender], &quot;Not contract administrator.&quot;);
        _;
    }

    // This notifies clients about the amount burnt, only admins can burn tokens
    event Burn(address indexed burner, uint256 value); 

    // This notifies clients about the transfers being allowed or disallowed
    event AllowTransfers ();
    event DisallowTransfers ();

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(uint initialTokenSupply) public {
        symbol = &quot;AGRI&quot;;
        name = &quot;AgriChain Utility Token&quot;;
        decimals = 18;
        _totalSupply = initialTokenSupply * 10**uint(decimals);

        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner&#39;s account to `to` account
    // - Owner&#39;s account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public allowingTransfers returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner&#39;s account
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public allowingTransfers returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender&#39;s account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner&#39;s account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    // ------------------------------------------------------------------------
    // Don&#39;t accept ETH
    // ------------------------------------------------------------------------
    function () public payable {
        revert(&quot;Contract does not accept ETH.&quot;);
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyAdmin returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }

    // ------------------------------------------------------------------------
    // Administrator can mint additional tokens 
    // Do ** NOT ** let totalSupply exceed MAX_SUPPLY
    // ------------------------------------------------------------------------
    function mintTokens(uint256 _value) public onlyAdmin {
        require(_totalSupply.add(_value) &lt;= MAX_SUPPLY, &quot;Cannot mint greater than maximum supply.&quot;);
        balances[msg.sender] = balances[msg.sender].add(_value);
        _totalSupply = _totalSupply.add(_value);
        emit Transfer(0, msg.sender, _value);      
    }    

    // ------------------------------------------------------------------------
    // Administrator can burn tokens
    // ------------------------------------------------------------------------
    function burn(uint256 _value) public onlyAdmin {
        require(_value &lt;= balances[msg.sender], &quot;Burn value exceeds balance.&quot;);
        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Burn(burner, _value);
    }

    // ------------------------------------------------------------------------
    // Administrator can allow transfer of tokens
    // ------------------------------------------------------------------------
    function allowTransfers() public onlyAdmin {
        isAllowingTransfers = true;
        emit AllowTransfers();
    }

    // ------------------------------------------------------------------------
    // Administrator can disallow transfer of tokens
    // ------------------------------------------------------------------------
    function disallowTransfers() public onlyAdmin {
        isAllowingTransfers = false;
        emit DisallowTransfers();
    }

    // ------------------------------------------------------------------------
    // Owner can add administrators of tokens
    // ------------------------------------------------------------------------
    function addAdministrator(address _admin) public onlyOwner {
        administrators[_admin] = true;
    }

    // ------------------------------------------------------------------------
    // Owner can remove administrators of tokens
    // ------------------------------------------------------------------------
    function removeAdministrator(address _admin) public onlyOwner {
        administrators[_admin] = false;
    }
}