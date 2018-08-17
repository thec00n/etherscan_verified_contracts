pragma solidity ^0.4.11;

/**
 * ERC 20 token
 *
 * https://github.com/ethereum/EIPs/issues/20
 */
contract MoacToken  {
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; uint256) redeem;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    uint256 public totalSupply;
    string public name = &quot;MoacToken Token&quot;;
    string public symbol = &quot;MOAC&quot;;
    uint public decimals = 18;

    uint public startBlock; //crowdsale start block (set in constructor)
    uint public endBlock; //crowdsale end block (set in constructor)

    address public founder = 0x0;
    address public owner = 0x0;

    // signer address 
    address public signer = 0x0;

    // price is defined by levels
    uint256 public levelOneTokenNum = 30000000 * 10**18; //first level 
    uint256 public levelTwoTokenNum = 50000000 * 10**18; //second level 
    uint256 public levelThreeTokenNum = 75000000 * 10**18; //third level 
    uint256 public levelFourTokenNum = 100000000 * 10**18; //fourth level 
    
    //max amount raised during crowdsale
    uint256 public etherCap = 1000000 * 10**18;  
    uint public transferLockup = 370285; 
    uint public founderLockup = 86400; 
    
    uint256 public founderAllocation = 100 * 10**16; 
    bool public founderAllocated = false; 

    uint256 public saleTokenSupply = 0; 
    uint256 public saleEtherRaised = 0; 
    bool public halted = false; 

    event Donate(uint256 eth, uint256 fbt);
    event AllocateFounderTokens(address indexed sender);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event print(bytes32 msg);

    function MoacToken(address founderInput, address signerInput, uint startBlockInput, uint endBlockInput) {
        founder = founderInput;
        signer = signerInput;
        startBlock = startBlockInput;
        endBlock = endBlockInput;
        owner = msg.sender;
    }

    //price based on current token supply
    function price() constant returns(uint256) {
        if (totalSupply&lt;levelOneTokenNum) return 1600;
        if (totalSupply&gt;=levelOneTokenNum &amp;&amp; totalSupply &lt; levelTwoTokenNum) return 1000;
        if (totalSupply&gt;=levelTwoTokenNum &amp;&amp; totalSupply &lt; levelThreeTokenNum) return 800;
        if (totalSupply&gt;=levelThreeTokenNum &amp;&amp; totalSupply &lt; levelFourTokenNum) return 730;
        if (totalSupply&gt;=levelFourTokenNum) return 680;
        return 1600;
    }

    // price() exposed for unit tests
    function testPrice(uint256 currentSupply) constant returns(uint256) {
        if (currentSupply&lt;levelOneTokenNum) return 1600;
        if (currentSupply&gt;=levelOneTokenNum &amp;&amp; currentSupply &lt; levelTwoTokenNum) return 1000;
        if (currentSupply&gt;=levelTwoTokenNum &amp;&amp; currentSupply &lt; levelThreeTokenNum) return 800;
        if (currentSupply&gt;=levelThreeTokenNum &amp;&amp; currentSupply &lt; levelFourTokenNum) return 730;
        if (currentSupply&gt;=levelFourTokenNum) return 680;
        return 1600;
    }


    // Donate entry point
    function donate( bytes32 hash) payable {
        print(hash);
        if (block.number&lt;startBlock || block.number&gt;endBlock || (saleEtherRaised + msg.value)&gt;etherCap || halted) throw;
        uint256 tokens = (msg.value * price());
        balances[msg.sender] = (balances[msg.sender] + tokens);
        totalSupply = (totalSupply + tokens);
        saleEtherRaised = (saleEtherRaised + msg.value);
        //immediately send Ether to founder address
        if (!founder.call.value(msg.value)()) throw; 
        Donate(msg.value, tokens);
    }

    /**
     * Set up founder address token balance.
     */
    function allocateFounderTokens() {
        if (msg.sender!=founder) throw;
        if (block.number &lt;= endBlock + founderLockup) throw;
        if (founderAllocated) throw;
        balances[founder] = (balances[founder] + saleTokenSupply * founderAllocation / (1 ether));
        totalSupply = (totalSupply + saleTokenSupply * founderAllocation / (1 ether));
        founderAllocated = true;
        AllocateFounderTokens(msg.sender);
    }

    /**
     * For offline donation, executed by signer only. only available during the sale
     */
    function offlineDonate(uint256 offlineTokenNum, uint256 offlineEther) {
        if (msg.sender!=signer) throw;
        if (block.number &gt;= endBlock) throw; //offline can be done only before end block
        
        //check if overflow
        if( (totalSupply +offlineTokenNum) &gt; totalSupply &amp;&amp; (saleEtherRaised + offlineEther)&gt;saleEtherRaised){
            totalSupply = (totalSupply + offlineTokenNum);
            balances[founder] = (balances[founder] + offlineTokenNum );
            saleEtherRaised = (saleEtherRaised + offlineEther);
        }
    }


    /** 
     * emergency adjust if incorrectly set by signer, only available during the sale
     */
    function offlineAdjust(uint256 offlineTokenNum, uint256 offlineEther) {
        if (msg.sender!=founder) throw;
        if (block.number &gt;= endBlock) throw; //offline can be done only before end block
        
        //check if overflow
        if( (totalSupply - offlineTokenNum) &gt; 0 &amp;&amp; (saleEtherRaised - offlineEther) &gt; 0 &amp;&amp; (balances[founder] - offlineTokenNum)&gt;0){
            totalSupply = (totalSupply - offlineTokenNum);
            balances[founder] = (balances[founder] - offlineTokenNum );
            saleEtherRaised = (saleEtherRaised - offlineEther);
        }
    }


    //check for redeemed balance
    function redeemBalanceOf(address _owner) constant returns (uint256 balance) {
        return redeem[_owner];
    }

    /**
     * redeem token in MOAC network
     */
    function redeemToken(uint256 tokenNum) {
        if (block.number &lt;= (endBlock + transferLockup) &amp;&amp; msg.sender!=founder) throw; 
        if( balances[msg.sender] &lt; tokenNum ) throw;
        balances[msg.sender] = (balances[msg.sender] - tokenNum );
        redeem[msg.sender] += tokenNum;
    }

    /**
     * restore redeemed back to user, only founder can do, if user made an error
     */
    function redeemRestore(address _to, uint256 tokenNum){
        if( msg.sender != founder) throw;
        if( redeem[_to] &lt; tokenNum ) throw;

        redeem[_to] -= tokenNum;
        balances[_to] += tokenNum;
    }


    /**
     * Emergency Stop ICO.
     */
    function halt() {
        if (msg.sender!=founder) throw;
        halted = true;
    }

    function unhalt() {
        if (msg.sender!=founder) throw;
        halted = false;
    }

    // only owner can kill
    function kill() { 
        if (msg.sender == owner) suicide(owner); 
    }


    /**
     * Change founder address (where ICO ETH is being forwarded).
     */
    function changeFounder(address newFounder) {
        if (msg.sender!=founder) throw;
        founder = newFounder;
    }

    /**
     * ERC 20 Standard Token interface transfer function
     */
    function transfer(address _to, uint256 _value) returns (bool success) {
        if (block.number &lt;= (endBlock + transferLockup) &amp;&amp; msg.sender!=founder) throw;

        //Default assumes totalSupply can&#39;t be over max (2^256 - 1).
        if (balances[msg.sender] &gt;= _value &amp;&amp; (balances[_to] + _value) &gt; balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }

    }

    /**
     * ERC 20 Standard Token interface transfer function
     */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (block.number &lt;= (endBlock + transferLockup) &amp;&amp; msg.sender!=founder) throw;

        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; (balances[_to] + _value) &gt; balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    /**
     * Do not allow direct deposits.
     *
     * All crowdsale depositors must have read the legal agreement.
     * This is confirmed by having them signing the terms of service on the website.
     * The give their crowdsale Ethereum source address on the website.
     * donate() takes data as input and rejects all deposits that do not have
     * signature you receive after reading terms of service.
     *
     */
    function() {
        throw;
    }

}