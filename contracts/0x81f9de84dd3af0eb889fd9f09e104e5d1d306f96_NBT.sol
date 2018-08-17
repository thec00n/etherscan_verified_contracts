pragma solidity ^ 0.4.16;
contract Token {
    uint256 public totalSupply;

    function balanceOf(address _owner) public constant returns(uint256 balance);
    function transfer(address _to, uint256 _value) public returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
    function approve(address _spender, uint256 _value) public returns(bool success);
    function allowance(address _owner, address _spender) public constant returns(uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract NBT is Token {

    string public name;
    uint256 public decimals;
    string public symbol;
    uint public startTime;
    address public Short;
    address public Long;
    address public Team;
    address public Reward;
    address public Investment;
    address public Foundation;
    constructor(string _tokenName, string _tokenSymbol, address tempTeam, address tempReward, address tempInvestment, address tempFoundation) public {
        name = _tokenName;
        decimals = 18;
        symbol = _tokenSymbol;
        totalSupply = 1000000000 * 10 **uint256(decimals);
        startTime = now;
        Team = tempTeam;
        Reward = tempReward;
        Investment = tempInvestment;
        Foundation = tempFoundation;

        balances[Team] = totalSupply * 2 / 10;
        balances[Reward] = totalSupply * 3 / 10;
        balances[Investment] = totalSupply * 3 / 10;
        balances[Foundation] = totalSupply * 2 / 10;
        emit Transfer(0x0, Team, 200000000 * 10 **uint256(decimals));
        emit Transfer(0x0, Reward, 300000000 * 10 **uint256(decimals));
        emit Transfer(0x0, Investment, 300000000 * 10 **uint256(decimals));
        emit Transfer(0x0, Foundation, 200000000 * 10 **uint256(decimals));
    }


    function setShort(address addr) public {
        require(msg.sender == Investment);
        Short = addr;
    }


    function setLong(address addr) public {
        require(msg.sender == Investment);
        Long = addr;
    }

    function transfer(address _to, uint256 _value) public returns(bool success) {
        if (msg.sender == Team) {
            uint timeTemp = (now - startTime) / 60 / 60 / 24 / 100;
            if (timeTemp &gt; 10) {
                timeTemp = 10;
            }
            require(balances[msg.sender] - _value &gt;= (totalSupply / 5 - totalSupply * timeTemp / 50));
            record(_to, _value);
        }

        if (msg.sender == Short) {
            require(balances[msg.sender] &gt;= _value);
            record(_to, _value);
        }

        if (msg.sender == Long) {
            require(balances[msg.sender] &gt;= _value);
            longRecord(_to, _value);
        }

        if (number[msg.sender] != 0) {
            judge(_value, msg.sender);
        }

        if (longNumber[msg.sender] != 0) {
            longJudge(_value, msg.sender);
        }

        require(balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt; balances[_to]);
        require(_to != 0x0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }


    function record(address iniadr, uint256 account) private {
        uint256[] storage T = time[iniadr];
        T.push(now);
        time[iniadr] = T;
        uint256[] storage A = init[iniadr];
        A.push(account);
        init[iniadr] = A;
        number[iniadr] = 1;
    }

    function longRecord(address iniadr, uint256 account) private {
        uint256[] storage T = longTime[iniadr];
        T.push(now);
        longTime[iniadr] = T;
        uint256[] storage A = longInit[iniadr];
        A.push(account);
        longInit[iniadr] = A;
        longNumber[iniadr] = 1;
    }

    function judge(uint256 _value, address addr) private {
        uint256[] storage T = time[addr];
        uint256[] storage A = init[addr];
        number[addr] = 0;
        for (uint i = 0; i &lt; T.length; i++) {
            if (now &lt; (T[i] + 100 days)) {
                number[addr] += A[i];
            }
        }
        require(balances[addr] - _value &gt;= number[addr]);
    }

    function longJudge(uint256 _value, address addr) private {
        uint256[] storage T = longTime[addr];
        uint256[] storage A = longInit[addr];
        longNumber[addr] = 0;
        for (uint i = 0; i &lt; T.length; i++) {
            if (now &lt; (T[i] + 1000 days)) {
                longNumber[addr] += A[i];
            }
        }
        require(balances[addr] - _value &gt;= longNumber[addr]);
    }

    function balanceOf(address _owner) public constant returns(uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function benchTransfer(address[] addr, uint256[] num) public {
        require(addr.length == num.length);
        for (uint i = 0; i &lt; num.length; i++) {

            transfer(addr[i], num[i] * 10 **uint256(decimals));
        }
    }

    mapping(address =&gt;uint256) balances;
    mapping(address =&gt;mapping(address =&gt;uint256)) allowed;

    mapping(address =&gt;uint256[]) time;
    mapping(address =&gt;uint256[]) init;
    mapping(address =&gt;uint256) number;
    mapping(address =&gt;uint256[]) longTime;
    mapping(address =&gt;uint256[]) longInit;
    mapping(address =&gt;uint256) longNumber;
}