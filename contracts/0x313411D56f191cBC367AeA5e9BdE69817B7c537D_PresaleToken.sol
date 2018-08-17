pragma solidity ^0.4.13;

// ERC20 token interface is implemented only partially
// (no SafeMath is used because contract code is very simple)
// 
// Some functions left undefined:
//  - transfer, transferFrom,
//  - approve, allowance.
contract PresaleToken
{
/// Fields:
    string public constant name = &quot;Remechain Presale Token&quot;;
    string public constant symbol = &quot;RMC&quot;;
    uint public constant decimals = 18;
    uint public constant PRICE = 320;  // per 1 Ether

    //  price
    // Cap is 1875 ETH
    // 1 RMC = 0,003125 ETH or 1 ETH = 320 RMC
    // ETH price ~300$ - 13.10.2017
    uint public constant HARDCAP_ETH_LIMIT = 1875;
    uint public constant SOFTCAP_ETH_LIMIT = 500;
    uint public constant TOKEN_SUPPLY_LIMIT = PRICE * HARDCAP_ETH_LIMIT * (1 ether / 1 wei);
    uint public constant SOFTCAP_LIMIT = PRICE * SOFTCAP_ETH_LIMIT * (1 ether / 1 wei);
    
    // 25.11.2017 17:00 MSK
    uint public icoDeadline = 1511618400;
    
    uint public constant BOUNTY_LIMIT = 350000 * (1 ether / 1 wei);

    enum State{
       Init,
       Running,
       Paused,
       Migrating,
       Migrated
    }

    State public currentState = State.Init;
    uint public totalSupply = 0; // amount of tokens already sold
    uint public bountySupply = 0; // amount of tokens already given as a reward

    // Gathered funds can be withdrawn only to escrow&#39;s address.
    address public escrow = 0;

    // Token manager has exclusive priveleges to call administrative
    // functions on this contract.
    address public tokenManager = 0;

    // Crowdsale manager has exclusive priveleges to burn presale tokens.
    address public crowdsaleManager = 0;

    mapping (address =&gt; uint256) public balances;
    mapping (address =&gt; uint256) public ethBalances;

/// Modifiers:
    modifier onlyTokenManager()     { require(msg.sender == tokenManager); _;}
    modifier onlyCrowdsaleManager() { require(msg.sender == crowdsaleManager); _;}
    modifier onlyInState(State state){ require(state == currentState); _;}

/// Events:
    event LogBuy(address indexed owner, uint value);
    event LogBurn(address indexed owner, uint value);
    event LogStateSwitch(State newState);

/// Functions:
    /// @dev Constructor
    /// @param _tokenManager Token manager address.
    function PresaleToken(address _tokenManager, address _escrow) public
    {
        require(_tokenManager!=0);
        require(_escrow!=0);

        tokenManager = _tokenManager;
        escrow = _escrow;
    }
    
    function reward(address _user, uint  _amount) public onlyTokenManager {
        require(_user != 0x0);
        
        assert(bountySupply + _amount &gt;= bountySupply);
        assert(bountySupply + _amount &lt;= BOUNTY_LIMIT);
        bountySupply += _amount;
        
        assert(balances[_user] + _amount &gt;= balances[_user]);
        balances[_user] += _amount;
        
        addAddressToList(_user);
    }
    
    function isIcoSuccessful() constant public returns(bool successful)  {
        return totalSupply &gt;= SOFTCAP_LIMIT;
    }
    
    function isIcoOver() constant public returns(bool isOver) {
        return now &gt;= icoDeadline;
    }

    function buyTokens(address _buyer) public payable onlyInState(State.Running)
    {
        assert(!isIcoOver());
        require(msg.value != 0);
        
        uint ethValue = msg.value;
        uint newTokens = msg.value * PRICE;
       
        require(!(totalSupply + newTokens &gt; TOKEN_SUPPLY_LIMIT));
        assert(ethBalances[_buyer] + ethValue &gt;= ethBalances[_buyer]);
        assert(balances[_buyer] + newTokens &gt;= balances[_buyer]);
        assert(totalSupply + newTokens &gt;= totalSupply);
        
        ethBalances[_buyer] += ethValue;
        balances[_buyer] += newTokens;
        totalSupply += newTokens;
        
        addAddressToList(_buyer);

        LogBuy(_buyer, newTokens);
    }
    
    address[] public addressList;
    mapping (address =&gt; bool) isAddressInList;
    function addAddressToList(address _address) private {
        if (isAddressInList[_address]) {
            return;
        }
        addressList.push(_address);
        isAddressInList[_address] = true;
    }

    /// @dev Returns number of tokens owned by given address.
    /// @param _owner Address of token owner.
    function burnTokens(address _owner) public onlyCrowdsaleManager onlyInState(State.Migrating)
    {
        uint tokens = balances[_owner];
        require(tokens != 0);

        balances[_owner] = 0;
        totalSupply -= tokens;

        LogBurn(_owner, tokens);

        // Automatically switch phase when migration is done.
        if(totalSupply == 0) 
        {
            currentState = State.Migrated;
            LogStateSwitch(State.Migrated);
        }
    }

    /// @dev Returns number of tokens owned by given address.
    /// @param _owner Address of token owner.
    function balanceOf(address _owner) public constant returns (uint256) 
    {
        return balances[_owner];
    }

    function setPresaleState(State _nextState) public onlyTokenManager
    {
        // Init -&gt; Running
        // Running -&gt; Paused
        // Running -&gt; Migrating
        // Paused -&gt; Running
        // Paused -&gt; Migrating
        // Migrating -&gt; Migrated
        bool canSwitchState
             =  (currentState == State.Init &amp;&amp; _nextState == State.Running)
             || (currentState == State.Running &amp;&amp; _nextState == State.Paused)
             // switch to migration phase only if crowdsale manager is set
             || ((currentState == State.Running || currentState == State.Paused)
                 &amp;&amp; _nextState == State.Migrating
                 &amp;&amp; crowdsaleManager != 0x0)
             || (currentState == State.Paused &amp;&amp; _nextState == State.Running)
             // switch to migrated only if everyting is migrated
             || (currentState == State.Migrating &amp;&amp; _nextState == State.Migrated
                 &amp;&amp; totalSupply == 0);

        require(canSwitchState);

        currentState = _nextState;
        LogStateSwitch(_nextState);
    }

    uint public nextInListToReturn = 0;
    uint private constant transfersPerIteration = 50;
    function returnToFunders() private {
        uint afterLast = nextInListToReturn + transfersPerIteration &lt; addressList.length ? nextInListToReturn + transfersPerIteration : addressList.length; 
        
        for (uint i = nextInListToReturn; i &lt; afterLast; i++) {
            address currentUser = addressList[i];
            if (ethBalances[currentUser] &gt; 0) {
                currentUser.transfer(ethBalances[currentUser]);
                ethBalances[currentUser] = 0;
            }
        }
        
        nextInListToReturn = afterLast;
    }
    function withdrawEther() public
    {
        if (isIcoSuccessful()) {
            if(msg.sender == tokenManager &amp;&amp; this.balance &gt; 0) 
            {
                escrow.transfer(this.balance);
            }
        }
        else {
            if (isIcoOver()) {
                returnToFunders();
            }
        }
    }
    
    function returnFunds() public {
        returnFundsFor(msg.sender);
    }
    function returnFundsFor(address _user) public {
        assert(isIcoOver() &amp;&amp; !isIcoSuccessful());
        assert(msg.sender == tokenManager || msg.sender == address(this));
        
        if (ethBalances[_user] &gt; 0) {
            _user.transfer(ethBalances[_user]);
            ethBalances[_user] = 0;
        }
    }

/// Setters
    function setTokenManager(address _mgr) public onlyTokenManager
    {
        tokenManager = _mgr;
    }

    function setCrowdsaleManager(address _mgr) public onlyTokenManager
    {
        // You can&#39;t change crowdsale contract when migration is in progress.
        require(currentState != State.Migrating);

        crowdsaleManager = _mgr;
    }

    // Default fallback function
    function()  public payable 
    {
        buyTokens(msg.sender);
    }
}