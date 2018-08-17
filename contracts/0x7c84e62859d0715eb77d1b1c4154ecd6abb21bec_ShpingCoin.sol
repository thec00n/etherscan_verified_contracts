pragma solidity ^0.4.16;

contract ShpingCoin {

    string public name = &quot;Shping Coin&quot;; 
    string public symbol = &quot;SHPING&quot;;
    uint8 public decimals = 18;
    uint256 public coinsaleDeadline = 1521845940; // 23/03/2018, 22:59:00 GMT | 23/03/2018, 23:59:00 CET | Saturday, 24 March 2018 9:59:00 AM GMT+11:00

    uint256 public totalSupply;
    mapping(address =&gt; uint256) balances; 
    mapping(address =&gt; mapping (address =&gt; uint256)) allowed; 

    mapping(address =&gt; mapping(string =&gt; bool)) platinumUsers;
    mapping(address =&gt; mapping(string =&gt; uint256)) campaigns; // Requests for a campaign activation 
    mapping(address =&gt; uint256) budgets; // Account budget for rewards campaigns

    address public owner;
    address public operator;

    function ShpingCoin() public {
        owner = msg.sender;
        totalSupply = 10000000000 * (10 ** uint256(decimals));
        balances[msg.sender] = totalSupply;
        operator = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyOperator() {
        require(msg.sender == operator);
        _;
    }

    function changeOperator(address newOperator) public onlyOwner {
        require(newOperator != address(0));
        require(newOperator != operator);
        require(balances[newOperator]+balances[operator] &gt;= balances[newOperator]);
        require(budgets[newOperator]+budgets[operator] &gt;= budgets[newOperator]);

        if (operator != owner) {
            balances[newOperator] += balances[operator];
            budgets[newOperator] += budgets[operator];
            NewBudget(newOperator, budgets[newOperator]);
            Transfer(operator, newOperator, balances[operator]);
            balances[operator] = 0;
            budgets[operator] = 0;
            NewBudget(operator, 0);
        }
        operator = newOperator;
    }

    //Permanent platinum level

    function isPlatinumLevel(address user, string hashedID) public constant returns (bool) {
        return platinumUsers[user][hashedID];
    }

    function setPermanentPlatinumLevel(address user, string hashedID) public onlyOwner returns (bool) {
        require(!isPlatinumLevel(user, hashedID));
        platinumUsers[user][hashedID] = true;
        return true;
    }

    //Rewards campaigns
    function activateCampaign(string campaign, uint256 budget) public returns (bool) {
        require(campaigns[msg.sender][campaign] == 0);
        require(budget != 0);
        require(balances[msg.sender] &gt;= budgets[msg.sender]);
        require(balances[msg.sender] - budgets[msg.sender] &gt;= budget);
        campaigns[msg.sender][campaign] = budget;
        Activate(msg.sender, budget, campaign);
        return true;
    }

    function getBudget(address account) public constant returns (uint256) {
        return budgets[account];
    }

    function rejectCampaign(address account, string campaign) public onlyOperator returns (bool) {
        require(account != address(0));
        campaigns[account][campaign] = 0;
        Reject(account, campaign);
        return true;
    }

    function setBudget(address account, string campaign) public onlyOperator returns (bool) {
        require(account != address(0));
        require(campaigns[account][campaign] != 0);
        require(balances[account] &gt;= budgets[account]);
        require(balances[account] - budgets[account] &gt;= campaigns[account][campaign]);
        require(budgets[account] + campaigns[account][campaign] &gt; budgets[account]);

        budgets[account] += campaigns[account][campaign];
        campaigns[account][campaign] = 0;
        NewBudget(account, budgets[account]);
        return true;
    }

    function releaseBudget(address account, uint256 budget) public onlyOperator returns (bool) {
        require(account != address(0));
        require(budget != 0);
        require(budgets[account] &gt;= budget);
        require(balances[account] &gt;= budget);
        require(balances[operator] + budget &gt; balances[operator]);

        budgets[account] -= budget;
        balances[account] -= budget;
        balances[operator] += budget;
        Released(account, budget);
        NewBudget(account, budgets[account]);
        return true;
    }

    function clearBudget(address account) public onlyOperator returns (bool) {
        budgets[account] = 0;
        NewBudget(account, 0);
        return true;
    }

    event Activate(address indexed account, uint256 indexed budget, string campaign);
    event NewBudget(address indexed account, uint256 budget);
    event Reject(address indexed account, string campaign);
    event Released(address indexed account, uint256 value);

    //ERC20 interface
    function balanceOf(address account) public constant returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(msg.sender == owner || msg.sender == operator || now &gt; coinsaleDeadline);
        require(balances[msg.sender] - budgets[msg.sender] &gt;= value);
        require(balances[to] + value &gt;= balances[to]);
        
        balances[msg.sender] -= value;
        balances[to] += value;
        Transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(from == owner || from == operator || msg.sender == owner || msg.sender == operator || now &gt; coinsaleDeadline);
        require(balances[from] - budgets[from] &gt;= value);
        require(allowed[from][msg.sender] &gt;= value);
        require(balances[to] + value &gt;= balances[to]);

        balances[from] -= value;
        allowed[from][msg.sender] -= value;
        balances[to] += value;
        Transfer(from, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address account, address spender) public constant returns (uint256) {
        return allowed[account][spender];
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}