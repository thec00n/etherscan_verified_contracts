pragma solidity ^0.4.18;


contract Token {
    function balanceOf(address _account) public constant returns (uint256 balance);

    function transfer(address _to, uint256 _value) public returns (bool success);
}


contract RocketCoin {
    string public constant symbol = &quot;XRC&quot;;

    string public constant name = &quot;Rocket Coin&quot;;

    uint public constant decimals = 18;

    uint public constant totalSupply = 10000000 * 10 ** decimals;

    address owner;

    bool airDropStatus = true;

    uint airDropAmount = 300 * 10 ** decimals;

    uint airDropGasPrice = 20 * 10 ** 9;

    mapping (address =&gt; bool) participants;

    mapping (address =&gt; uint256) balances;

    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function RocketCoin() public {
        owner = msg.sender;
        balances[owner] = totalSupply;
        Transfer(address(0), owner, totalSupply);
    }

    function() public payable {
        require(airDropStatus &amp;&amp; balances[owner] &gt;= airDropAmount &amp;&amp; !participants[msg.sender] &amp;&amp; tx.gasprice &gt;= airDropGasPrice);
        balances[owner] -= airDropAmount;
        balances[msg.sender] += airDropAmount;
        Transfer(owner, msg.sender, airDropAmount);
        participants[msg.sender] = true;
    }

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function transfer(address _to, uint256 _amount) public returns (bool success) {
        require(balances[msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0);
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
        return true;
    }

    function multiTransfer(address[] _addresses, uint[] _amounts) public returns (bool success) {
        require(_addresses.length &lt;= 100 &amp;&amp; _addresses.length == _amounts.length);
        uint totalAmount;
        for (uint a = 0; a &lt; _amounts.length; a++) {
            totalAmount += _amounts[a];
        }
        require(totalAmount &gt; 0 &amp;&amp; balances[msg.sender] &gt;= totalAmount);
        balances[msg.sender] -= totalAmount;
        for (uint b = 0; b &lt; _addresses.length; b++) {
            if (_amounts[b] &gt; 0) {
                balances[_addresses[b]] += _amounts[b];
                Transfer(msg.sender, _addresses[b], _amounts[b]);
            }
        }
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
        require(balances[_from] &gt;= _amount &amp;&amp; allowed[_from][msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0);
        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        balances[_to] += _amount;
        Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function setupAirDrop(bool _status, uint _amount, uint _Gwei) public returns (bool success) {
        require(msg.sender == owner);
        airDropStatus = _status;
        airDropAmount = _amount * 10 ** decimals;
        airDropGasPrice = _Gwei * 10 ** 9;
        return true;
    }

    function withdrawFunds(address _token) public returns (bool success) {
        require(msg.sender == owner);
        if (_token == address(0)) {
            owner.transfer(this.balance);
        }
        else {
            Token ERC20 = Token(_token);
            ERC20.transfer(owner, ERC20.balanceOf(this));
        }
        return true;
    }
}