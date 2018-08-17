pragma solidity ^0.4.11;
 
contract Token {
    string public symbol = &quot;7&quot;;
    string public name = &quot;7 token&quot;;
    uint8 public constant decimals = 18;
    uint256 _totalSupply = 7000000000000000000;
    address owner = 0;
    bool startDone = false;
    uint public amountRaised;
    uint public deadline;
    uint public overRaisedUnsend = 0;
    uint public backers = 0;
    uint rate = 4;
    uint successcoef = 2;
    uint unreserved = 80;
    uint _durationInMinutes = 0;
    bool fundingGoalReached = false;
    mapping(address =&gt; uint256) public balanceOf;
	
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping(address =&gt; uint256) balances;
 
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed;
 
    function Token(address adr) {
		owner = adr;        
    }
	
	function StartICO(uint256 durationInMinutes)
	{
		if (msg.sender == owner &amp;&amp; startDone == false)
		{
			balances[owner] = _totalSupply;
			_durationInMinutes = durationInMinutes;
            deadline = now + durationInMinutes * 1 minutes;
			startDone = true;
		}
	}
 
    function totalSupply() constant returns (uint256 totalSupply) {        
		return _totalSupply;
    }
 
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }
 
    function transfer(address _to, uint256 _amount) returns (bool success) {
        if (balances[msg.sender] &gt;= _amount 
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
            return false;
        }
    }
 
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) returns (bool success) {
        if (balances[_from] &gt;= _amount
            &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }
    
    function () payable {
        uint _amount = msg.value;
        uint amount = msg.value;
        _amount = _amount * rate;
        if (amountRaised + _amount &lt;= _totalSupply * unreserved / 100
            &amp;&amp; balances[owner] &gt;= _amount
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[msg.sender] + _amount &gt; balances[msg.sender]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !fundingGoalReached 
            &amp;&amp; startDone) {
        backers += 1;
        balances[msg.sender] += _amount;
        balances[owner] -= _amount;
        amountRaised += _amount;
        Transfer(owner, msg.sender, _amount);
        } else {
            if (!msg.sender.send(amount)) {
                overRaisedUnsend += amount; 
            }
        }
    }
 
    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }
 
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    modifier afterDeadline() { if (now &gt; deadline || amountRaised &gt;= _totalSupply / successcoef) _; }

    function safeWithdrawal() afterDeadline {

    if (amountRaised &lt; _totalSupply / successcoef) {
            uint _amount = balances[msg.sender];
            balances[msg.sender] = 0;
            if (_amount &gt; 0) {
                if (msg.sender.send(_amount / rate)) {
                    balances[owner] += _amount;
                    amountRaised -= _amount;
                    Transfer(owner, msg.sender, _amount);
                } else {
                    balances[msg.sender] = _amount;
                }
            }
        }

    if (owner == msg.sender
    	&amp;&amp; amountRaised &gt;= _totalSupply / successcoef) {
           if (owner.send(this.balance)) {
               fundingGoalReached = true;
            } 
        }
    }
}