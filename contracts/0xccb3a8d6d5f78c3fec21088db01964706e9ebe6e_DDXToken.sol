pragma solidity ^0.4.18;


contract DDXToken {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping(address =&gt; uint) public balances;
    mapping(address =&gt; mapping(address =&gt; uint)) public allowed;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;

    bool public locked;

    address public creator;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function DDXToken() public {
        name = &quot;Decentralized Derivatives Exchange Token&quot;;
        symbol = &quot;DDX&quot;;
        decimals = 18;
        totalSupply = 200000000 ether;

        locked = true;
        creator = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    // Don&#39;t let people randomly send ETH to contract
    function() public payable {
        revert();
    }

    // Once unlocked, transfer can never be locked again
    function unlockTransfer() public {
        require(msg.sender == creator);
        locked = false;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] &gt;= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // Token must be unlocked to enable transferFrom
        // transferFrom is used in public sales (i.e. Decentralized Exchanges)
        // this mitigates risk of users selling the token to the public before proper disclosure/paperwork is in order
        require(!locked);
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] &gt;= _value &amp;&amp; allowance &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance &lt; MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}