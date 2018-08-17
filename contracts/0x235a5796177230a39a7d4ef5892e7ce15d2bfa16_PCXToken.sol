pragma solidity ^0.4.13;
contract SafeMath {

    function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x + y;
        assert((z &gt;= x) &amp;&amp; (z &gt;= y));
        return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
        assert(x &gt;= y);
        uint256 z = x - y;
        return z;
    }

    function safeMult(uint256 x, uint256 y) internal returns(uint256) {
        uint256 z = x * y;
        assert((x == 0)||(z/x == y));
        return z;
    }
}

contract Token {
    uint256 public totalSupply;

    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/*  ERC 20 token */
contract StandardToken is Token, SafeMath {

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    modifier onlyPayloadSize(uint numwords) {
        assert(msg.data.length == numwords * 32 + 4);
        _;
    }

    function transfer(address _to, uint256 _value)
    returns (bool success)
    {
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
            balances[_to] = safeAdd(balances[_to], _value);
            Transfer(msg.sender, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint256 _value)
    returns (bool success)
    {
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0 &amp;&amp; balances[_to] + _value &gt; balances[_to]) {
            balances[_to] = safeAdd(balances[_to], _value);
            balances[_from] = safeSubtract(balances[_from], _value);
            allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
            Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value)
    onlyPayloadSize(2)
    returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
    constant
    onlyPayloadSize(2)
    returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }
}
contract PrivateCityTokens {
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
}


contract PCXToken is StandardToken {

    // Token metadata
	string public name = &quot;PRIVATE CITY TOKENS EXCHANGE&quot;;
	string public symbol = &quot;PCTX&quot;;
    uint256 public constant decimals = 18;

    // Deposit address of account controlled by the creators
    address public ethFundDeposit = 0xFEfC687c084E6A77322519BEc3A9107640905445;
    address public tokenExchangeAddress = 0x0d2d64c2c4ba21d08252661c3ca159982579b640;
    address public tokenAccountAddress = 0xFEfC687c084E6A77322519BEc3A9107640905445;
    //Access to token contract for vibe exchange
    PrivateCityTokens public tokenExchange;

    // Fundraising parameters
    enum ContractState { Fundraising, Finalized, Redeeming, Paused }
    ContractState public state;           // Current state of the contract
    ContractState private savedState;     // State of the contract before pause

    //start date: 08/07/2017 @ 12:00am (UTC)
    uint public startDate = 1506521932;
    //start date: 09/21/2017 @ 11:59pm (UTC)
    uint public endDate = 1506635111;
    
    uint256 public constant ETH_RECEIVED_MIN = 0;//1 * 10**decimals; // 0 ETH
    uint256 public constant TOKEN_MIN = 1 * 10**decimals; // 1 VIBEX

    // We need to keep track of how much ether have been contributed, since we have a cap for ETH too
    uint256 public totalReceivedEth = 0;

    // Since we have different exchange rates at different stages, we need to keep track
    // of how much ether each contributed in case that we need to issue a refund
    mapping (address =&gt; uint256) private ethBalances;
	

    modifier isFinalized() {
        require(state == ContractState.Finalized);
        _;
    }

    modifier isFundraising() {
        require(state == ContractState.Fundraising);
        _;
    }

    modifier isRedeeming() {
        require(state == ContractState.Redeeming);
        _;
    }

    modifier isPaused() {
        require(state == ContractState.Paused);
        _;
    }

    modifier notPaused() {
        require(state != ContractState.Paused);
        _;
    }

    modifier isFundraisingIgnorePaused() {
        require(state == ContractState.Fundraising || (state == ContractState.Paused &amp;&amp; savedState == ContractState.Fundraising));
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == ethFundDeposit);
        _;
    }

    modifier minimumReached() {
        require(totalReceivedEth &gt;= ETH_RECEIVED_MIN);
        _;
    }

    // Constructor
    function PCXToken()
    {
        // Contract state
        state = ContractState.Fundraising;
        savedState = ContractState.Fundraising;
        tokenExchange = PrivateCityTokens(tokenExchangeAddress);
        totalSupply = 0;
    }

    // Overridden method to check for end of fundraising before allowing transfer of tokens
    function transfer(address _to, uint256 _value)
    isFinalized // Only allow token transfer after the fundraising has ended
    onlyPayloadSize(2)
    returns (bool success)
    {
        return super.transfer(_to, _value);
    }


    // Overridden method to check for end of fundraising before allowing transfer of tokens
    function transferFrom(address _from, address _to, uint256 _value)
    isFinalized // Only allow token transfer after the fundraising has ended
    onlyPayloadSize(3)
    returns (bool success)
    {
        return super.transferFrom(_from, _to, _value);
    }
    
    /// @dev Accepts ether and creates new VIBEX tokens
    function ()
    payable
    external
    isFundraising
    {
        require(now &gt;= startDate);
        require(now &lt;= endDate);
        require(msg.value &gt; 0);
        

        // First we check the ETH cap, as it&#39;s easier to calculate, return
        // the contribution if the cap has been reached already
        uint256 checkedReceivedEth = safeAdd(totalReceivedEth, msg.value);

        // If all is fine with the ETH cap, we continue to check the
        // minimum amount of tokens
        uint256 tokens = safeMult(msg.value, getCurrentTokenPrice());
        require(tokens &gt;= TOKEN_MIN);

        // Only when all the checks have passed, then we update the state (ethBalances,
        // totalReceivedEth, totalSupply, and balances) of the contract
        ethBalances[msg.sender] = safeAdd(ethBalances[msg.sender], msg.value);
        totalReceivedEth = checkedReceivedEth;
        totalSupply = safeAdd(totalSupply, tokens);
        balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
        
        // Send the ETH to Vibehub Creators
        ethFundDeposit.transfer(msg.value);

    }


    /// @dev Returns the current token price
    function getCurrentTokenPrice()
    private
    constant
    returns (uint256 currentPrice)
    {
        return 100;//bonuses are not implied!
    }


    /// @dev Redeems VIBEs and records the Vibehub address of the sender
    function redeemTokens()
    external
    isRedeeming
    {
        uint256 vibeVal = balances[msg.sender];
        require(vibeVal &gt;= TOKEN_MIN); // At least TOKEN_MIN tokens have to be redeemed

        // Move the tokens of the caller to Vibehub&#39;s address
        //if (!super.transfer(ethFundDeposit, vibeVal)) revert();
        balances[msg.sender]=0;
        
        uint256 exchangeRate = ((160200000* 10**decimals)/totalSupply);
        uint256 numTokens = safeMult(exchangeRate, vibeVal); // Extra safe
        if(!tokenExchange.transferFrom(tokenAccountAddress, msg.sender, numTokens)) revert();

    }




    /// @dev Ends the fundraising period and sends the ETH to the ethFundDeposit wallet
    function finalize()
    external
    isFundraising
    minimumReached
    onlyOwner // Only the owner of the ethFundDeposit address can finalize the contract
    {
        // Move the contract to Finalized state
        state = ContractState.Finalized;
        savedState = ContractState.Finalized;
    }


    /// @dev Starts the redeeming period
    function startRedeeming()
    external
    isFinalized // The redeeming period can only be started after the contract is finalized
    onlyOwner   // Only the owner of the ethFundDeposit address can start the redeeming period
    {
        // Move the contract to Redeeming state
        state = ContractState.Redeeming;
        savedState = ContractState.Redeeming;
    }


    /// @dev Pauses the contract
    function pause()
    external
    notPaused   // Prevent the contract getting stuck in the Paused state
    onlyOwner   // Only the owner of the ethFundDeposit address can pause the contract
    {
        // Move the contract to Paused state
        savedState = state;
        state = ContractState.Paused;
    }


    /// @dev Proceeds with the contract
    function proceed()
    external
    isPaused
    onlyOwner   // Only the owner of the ethFundDeposit address can proceed with the contract
    {
        // Move the contract to the previous state
        state = savedState;
    }

}