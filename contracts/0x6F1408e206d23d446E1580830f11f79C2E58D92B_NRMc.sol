pragma solidity ^0.4.11;
 
contract NRMc {
    string public symbol = &quot;NRMc&quot;;
    string public name = &quot;NRMc Closed ICO&quot;;
    uint8 public constant decimals = 18;
    uint256 _totalSupply = 20000000000000000000000000;
    uint256 perReserve   =  2000000000000000000000000;
    bool startDone = false;
    bool finishDone = false;
    bool onefiveDone = false;
    address owner = 0;
    address reserve1 = 0x0d4dAA952a8840715d901f97EDb98973Ce8010F7;
    address reserve2 = 0xCd4846fF42C1DCe3E421cb4fE8d01523B962D641;
    address reserve3 = 0x2241C99B6f44Cc630a073703EdFDf3c9964CbE22;
    address reserve4 = 0x5c5bfC25A0B99ac5F974927F1f6D39f19Af9D14C;
    address reserve5 = 0xa8356f49640093cec3dCd6dcE1ff4Dfe3785c17c;
    bool prereserved1Done = false;
    bool prereserved2Done = false;
    bool prereserved3Done = false;
    bool prereserved4Done = false;
    bool prereserved5Done = false;
    address out1 = 0xF9D23f5d833dB355bfc870c8aCD9f4fc7EF05883;
    address out2 = 0x5c07f5DD4d3eE06A977Dee53072e10de9414E3f0;
    address out3 = 0xF425821a2545cF1414B6E342ff5D95f3c572a7CD;
    address out4 = 0xa873134afa83410787Ae29dBfB39e5C38ca05fF2;
    address out5 = 0x5E663D73de8205b3f339fAA5a4218AcA95963260;
    bool public out1Done = false;
    bool public out2Done = false;
    bool public out3Done = false;
    bool public out4Done = false;
    bool public out5Done = false;
    uint public amountRaised;
    uint public deadline;
    uint public overRaisedUnsend = 0;
    uint public backers = 0;
    uint public rate = 45000;
    uint public onefive = 0;
    uint _durationInMinutes = 0;
    mapping(address =&gt; uint256) public balanceOf;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping(address =&gt; uint256) balances;
 
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed;
 
    function NRMc(address adr) {
        if (startDone == false) {
        owner = adr;        
        }
    }
    
    function StartICO(uint256 durationInMinutes) {
        if (msg.sender == owner 
        &amp;&amp; startDone == false)
        {
            balances[owner] = _totalSupply;
            _durationInMinutes = durationInMinutes;
            deadline = now + durationInMinutes * 1 minutes;
            startDone = true;
        }
    }
    
    function SendPreReserved1() {
            if (msg.sender == owner 
            &amp;&amp; prereserved1Done == false
            &amp;&amp; balances[owner] &gt;= perReserve
            &amp;&amp; balances[reserve1] + perReserve &gt; balances[reserve1]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) 
            {
                balances[owner] -= perReserve;
                balances[reserve1] += perReserve;
                Transfer(owner, reserve1, perReserve);
                prereserved1Done = true;
                backers += 1; 
            }
    }       
    
    function SendPreReserved2() {
            if (msg.sender == owner 
            &amp;&amp; prereserved2Done == false
            &amp;&amp; balances[owner] &gt;= perReserve
            &amp;&amp; balances[reserve2] + perReserve &gt; balances[reserve2]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) 
            {
                balances[owner] -= perReserve;
                balances[reserve2] += perReserve;
                Transfer(owner, reserve2, perReserve);
                prereserved2Done = true;
                backers += 1; 
            }
    }       

    function SendPreReserved3() {
            if (msg.sender == owner 
            &amp;&amp; prereserved3Done == false
            &amp;&amp; balances[owner] &gt;= perReserve
            &amp;&amp; balances[reserve3] + perReserve &gt; balances[reserve3]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) 
            {
                balances[owner] -= perReserve;
                balances[reserve3] += perReserve;
                Transfer(owner, reserve3, perReserve);
                prereserved3Done = true;
                backers += 1; 
            }
    }       
    
    function SendPreReserved4() {
            if (msg.sender == owner 
            &amp;&amp; prereserved4Done == false
            &amp;&amp; balances[owner] &gt;= perReserve
            &amp;&amp; balances[reserve4] + perReserve &gt; balances[reserve4]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) 
            {
                balances[owner] -= perReserve;
                balances[reserve4] += perReserve;
                Transfer(owner, reserve4, perReserve);
                prereserved4Done = true;
                backers += 1; 
            }
    }       
    
    function SendPreReserved5() {
            if (msg.sender == owner 
            &amp;&amp; prereserved5Done == false
            &amp;&amp; balances[owner] &gt;= perReserve
            &amp;&amp; balances[reserve5] + perReserve &gt; balances[reserve5]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) 
            {
                balances[owner] -= perReserve;
                balances[reserve5] += perReserve;
                Transfer(owner, reserve5, perReserve);
                prereserved5Done = true;
                backers += 1; 
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
        uint _amount = msg.value * rate;
        uint amount = msg.value;
        if (balances[owner] &gt;= _amount
            &amp;&amp; _amount &gt; 0
            &amp;&amp; balances[msg.sender] + _amount &gt; balances[msg.sender]
            &amp;&amp; now &lt;= deadline
            &amp;&amp; !finishDone 
            &amp;&amp; startDone) {
        backers += 1;
        balances[msg.sender] += _amount;
        balances[owner] -= _amount;
        amountRaised += amount;
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
    
    modifier afterDeadline() { if (now &gt; deadline || balances[owner] == 0) _; }

    function safeWithdrawal() afterDeadline {
        
    if (onefiveDone == false) {
        onefive = this.balance / 5;
        onefiveDone = true;
    }

    if (out1 == msg.sender &amp;&amp; !out1Done) {
        if (out1.send(onefive)) {
           out1Done = true;
        } 
    }
        
    if (out2 == msg.sender &amp;&amp; !out2Done) {
        if (out2.send(onefive)) {
           out2Done = true;
        } 
    }  
        
    if (out3 == msg.sender &amp;&amp; !out3Done) {
        if (out3.send(onefive)) {
           out3Done = true;
        } 
    }
    
    if (out4 == msg.sender &amp;&amp; !out4Done) {
        if (out4.send(onefive)) {
           out4Done = true;
        } 
    }
    
    if (out5 == msg.sender &amp;&amp; !out5Done) {
        if (out5.send(onefive)) {
           out5Done = true;
        } 
    }
    }
}