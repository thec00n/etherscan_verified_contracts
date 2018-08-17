pragma solidity ^0.4.18;




contract Kiyomi {
    string public constant symbol = &quot;pep&quot;;

    string public constant name = &quot;Kiyomi&quot;;

    uint public constant decimals = 8;

    uint _totalSupply = 21000000 * 10 ** decimals;

    uint public marketSupply;

    uint public marketPrice;

    address owner;

    mapping (address =&gt; uint) accounts;

    mapping (address =&gt; mapping (address =&gt; uint)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approval(address indexed _owner, address indexed _spender, uint _value);

    function Kiyomi() public {
        owner = msg.sender;
        accounts[owner] = _totalSupply;
        Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public constant returns (uint __totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address _account) public constant returns (uint balance) {
        return accounts[_account];
    }

    function allowance(address _account, address _spender) public constant returns (uint remaining) {
        return allowed[_account][_spender];
    }

    function transfer(address _to, uint _amount) public returns (bool success) {
        require(_amount &gt; 0 &amp;&amp; accounts[msg.sender] &gt;= _amount);
        accounts[msg.sender] -= _amount;
        accounts[_to] += _amount;
        Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        require(_amount &gt; 0 &amp;&amp; accounts[_from] &gt;= _amount &amp;&amp; allowed[_from][msg.sender] &gt;= _amount);
        accounts[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        accounts[_to] += _amount;
        Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint _amount) public returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function purchase() public payable returns (bool _status) {
        require(msg.value &gt; 0 &amp;&amp; marketSupply &gt; 0 &amp;&amp; marketPrice &gt; 0 &amp;&amp; accounts[owner] &gt; 0);
        // Calculate available and required units
        uint unitsAvailable = accounts[owner] &lt; marketSupply ? accounts[owner] : marketSupply;
        uint unitsRequired = msg.value / marketPrice;
        uint unitsFinal = unitsAvailable &lt; unitsRequired ? unitsAvailable : unitsRequired;
        // Transfer funds
        marketSupply -= unitsFinal;
        accounts[owner] -= unitsFinal;
        accounts[msg.sender] += unitsFinal;
        Transfer(owner, msg.sender, unitsFinal);
        // Calculate remaining ether amount
        uint remainEther = msg.value - (unitsFinal * marketPrice);
        // Return extra ETH to sender
        if (remainEther &gt; 0) {
            msg.sender.transfer(remainEther);
        }
        return true;
    }



    function crowdsaleSetup(uint _supply, uint _perEther) public returns (bool _status) {
        require(msg.sender == owner &amp;&amp; accounts[owner] &gt;= _supply * 10 ** decimals);
        marketSupply = _supply * 10 ** decimals;
        marketPrice = 1 ether / (_perEther * 10 ** decimals);
        return true;
    }

    function withdrawFunds(uint _amount) public returns (bool _status) {
        require(msg.sender == owner &amp;&amp; _amount &gt; 0 &amp;&amp; this.balance &gt;= _amount);
        owner.transfer(_amount);
        return true;
    }
}