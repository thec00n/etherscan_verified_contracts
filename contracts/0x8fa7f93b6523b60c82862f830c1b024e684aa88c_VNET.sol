pragma solidity ^0.4.8;

/**
 * @title VNET Token - The Next Generation Value Transfering Network.
 * @author Wang Yunxiao - &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="790e0001404f404b4b391e14181015571a1614">[email&#160;protected]</a>&gt;
 */

contract SafeMath {
    function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &gt; 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a &amp;&amp; c &gt;= b);
        return c;
    }
}

contract VNET is SafeMath {
    string constant tokenName = &#39;VNET&#39;;
    string constant tokenSymbol = &#39;VNET&#39;;
    uint8 constant decimalUnits = 8;

    string public name;
    string public symbol;
    uint8 public decimals;

    uint256 public totalSupply = 100 * (10**8) * (10**8); // 100 yi

    address public owner;
    
    mapping(address =&gt; bool) restrictedAddresses;
    mapping(address =&gt; uint256) public balanceOf;
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    modifier onlyOwner {
        assert(owner == msg.sender);
        _;
    }

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function VNET() public {
        balanceOf[msg.sender] = totalSupply;                // Give the creator all tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
        decimals = decimalUnits;                            // Amount of decimals for display purposes
        owner = msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_value &gt; 0);
        require(balanceOf[msg.sender] &gt;= _value);              // Check if the sender has enough
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);    // Check for overflows
        require(!restrictedAddresses[msg.sender]);
        require(!restrictedAddresses[_to]);
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);   // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                 // Add the same to the recipient
        Transfer(msg.sender, _to, _value);                  // Notify anyone listening that this transfer took place
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;            // Set allowance
        Approval(msg.sender, _spender, _value);              // Raise Approval event
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] &gt;= _value);                  // Check if the sender has enough
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);   // Check for overflows
        require(_value &lt;= allowance[_from][msg.sender]);      // Check allowance
        require(!restrictedAddresses[_from]);
        require(!restrictedAddresses[msg.sender]);
        require(!restrictedAddresses[_to]);
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);    // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);        // Add the same to the recipient
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function totalSupply() constant public returns (uint256 Supply) {
        return totalSupply;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balanceOf[_owner];
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
      return allowance[_owner][_spender];
    }

    function() public payable {
        revert();
    }

    /* Owner can add new restricted address or removes one */
    function editRestrictedAddress(address _newRestrictedAddress) public onlyOwner {
        restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
    }

    function isRestrictedAddress(address _querryAddress) constant public returns (bool answer) {
        return restrictedAddresses[_querryAddress];
    }
}