pragma solidity ^0.4.10;

// ----------------------------------------------------------------------------
// The EncryptoTel smart contract - provided by Incent - join us on slack; 
// http://incentinvites.herokuapp.com/
//
// A collaboration between Incent, Bok and EncryptoTel :)
//
// Enjoy. (c) Incent Loyalty Pty Ltd and Bok Consulting Pty Ltd 2017. 
// The MIT Licence.
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Contract configuration
// ----------------------------------------------------------------------------
contract TokenConfig {
    string public constant symbol = &quot;ETT&quot;;
    string public constant name = &quot;EncryptoTel Token&quot;;
    uint8 public constant decimals = 8;  // 8 decimals, same as tokens on Waves
    uint256 public constant TOTALSUPPLY = 7766398700000000;
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
// ----------------------------------------------------------------------------
contract ERC20Interface {
    uint256 public totalSupply;
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) 
        returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant 
        returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, 
        uint256 _value);
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address _newOwner) onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() {
        if (msg.sender != newOwner) throw;
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}


// ----------------------------------------------------------------------------
// WavesEthereumSwap functionality
// ----------------------------------------------------------------------------
contract WavesEthereumSwap is Owned, ERC20Interface {
    event WavesTransfer(address indexed _from, string wavesAddress,
        uint256 amount);

    function moveToWaves(string wavesAddress, uint256 amount) {
        if (!transfer(owner, amount)) throw;
        WavesTransfer(msg.sender, wavesAddress, amount);
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/issues/20
// ----------------------------------------------------------------------------
contract EncryptoTelToken is TokenConfig, WavesEthereumSwap {

    // ------------------------------------------------------------------------
    // Balances for each account
    // ------------------------------------------------------------------------
    mapping(address =&gt; uint256) balances;

    // ------------------------------------------------------------------------
    // Owner of account approves the transfer of an amount to another account
    // ------------------------------------------------------------------------
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function EncryptoTelToken() Owned() TokenConfig() {
        totalSupply = TOTALSUPPLY;
        balances[owner] = TOTALSUPPLY;
    }

    // ------------------------------------------------------------------------
    // Get the account balance of another account with address _owner
    // ------------------------------------------------------------------------
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from owner&#39;s account to another account
    // ------------------------------------------------------------------------
    function transfer(
        address _to, 
        uint256 _amount
    ) returns (bool success) {
        if (balances[msg.sender] &gt;= _amount             // User has balance
            &amp;&amp; _amount &gt; 0                              // Non-zero transfer
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]  // Overflow check
        ) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // ------------------------------------------------------------------------
    // Allow _spender to withdraw from your account, multiple times, up to the
    // _value amount. If this function is called again it overwrites the
    // current allowance with _value.
    // ------------------------------------------------------------------------
    function approve(
        address _spender,
        uint256 _amount
    ) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    // ------------------------------------------------------------------------
    // Spender of tokens transfer an amount of tokens from the token owner&#39;s
    // balance to another account. The owner of the tokens must already
    // have approve(...)-d this transfer
    // ------------------------------------------------------------------------
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] &gt;= _amount                  // From a/c has balance
            &amp;&amp; allowed[_from][msg.sender] &gt;= _amount    // Transfer approved
            &amp;&amp; _amount &gt; 0                              // Non-zero transfer
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]  // Overflow check
        ) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender&#39;s account
    // ------------------------------------------------------------------------
    function allowance(
        address _owner, 
        address _spender
    ) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    // ------------------------------------------------------------------------
    // Transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(
        address tokenAddress, 
        uint256 amount
    ) onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, amount);
    }
    
    // ------------------------------------------------------------------------
    // Don&#39;t accept ethers
    // ------------------------------------------------------------------------
    function () {
        throw;
    }
}