pragma solidity ^0.4.0;
contract Ownable {
    address public owner;

    function Ownable() public { //This call only first time when contract deployed by person
        owner = msg.sender;
    }
    modifier onlyOwner() { //This modifier is for checking owner is calling
        if (owner == msg.sender) {
            _;
        } else {
            revert();
        }
    }
}
contract Mortal is Ownable {
    
    function kill () public {
        if (msg.sender == owner)
            selfdestruct(owner);
    }
}
contract Token {
    uint256 public etherRaised = 0;
    uint256 public totalSupply;
    uint256 public bountyReserveTokens;
    uint256 public advisoryReserveTokens;
    uint256 public teamReserveTokens;
    uint256 public bountyReserveTokensDistributed = 0;
    uint256 public advisoryReserveTokensDistributed = 0;
    uint256 public teamReserveTokensDistributed = 0;
    uint256 public deadLine = 0;
    bool public isBurned = false;

    function balanceOf(address _owner) public constant returns(uint256 balance);

    function transfer(address _to, uint256 _tokens) public returns(bool resultTransfer);

    function transferFrom(address _from, address _to, uint256 _tokens, uint256 deadLine_Locked) public returns(bool resultTransfer);

    function approve(address _spender, uint _value) public returns(bool success);

    function allowance(address _owner, address _spender) public constant returns(uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event Burn(address indexed burner, uint256 value);
}
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    Unpause();
  }
}
contract KirkeContract is Token, Mortal, Pausable {

    function transfer(address _to, uint256 _value) public returns(bool success) {
        require(_to != 0x0);
        require(_value &gt; 0);
        uint256 bonus = 0;

        uint256 totalTokensToTransfer = _value + bonus;

        if (balances[msg.sender] &gt;= totalTokensToTransfer) {
            balances[msg.sender] -= totalTokensToTransfer;
            balances[_to] += totalTokensToTransfer;
            Transfer(msg.sender, _to, totalTokensToTransfer);
            return true;
        } else {
            return false;
        }
    }



    function transferFrom(address _from, address _to, uint256 totalTokensToTransfer, uint256 deadLine_Locked) public returns(bool success) {
        require(_from != 0x0);
        require(_to != 0x0);
        require(totalTokensToTransfer &gt; 0);
        require(now &gt; deadLine_Locked || _from == owner);

        if (balances[_from] &gt;= totalTokensToTransfer &amp;&amp; allowance(_from, _to) &gt;= totalTokensToTransfer) {
            balances[_to] += totalTokensToTransfer;
            balances[_from] -= totalTokensToTransfer;
            allowed[_from][msg.sender] -= totalTokensToTransfer;
            Transfer(_from, _to, totalTokensToTransfer);
            return true;
        } else {
            return false;
        }
    }



    function balanceOf(address _owner) public constant returns(uint256 balanceOfUser) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns(bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns(uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping(address =&gt; uint256) balances;
    mapping(address =&gt; mapping(address =&gt; uint256)) allowed;
}
contract Kirke is KirkeContract{
    string public constant name = &quot;Kirke&quot;;
    uint8 public constant decimals = 18;
    string public constant symbol = &quot;KIK&quot;;
    uint256 rateForToken;
    bool public isPaused;
    uint256 firstBonusEstimate;
    uint256 secondBonusEstimate;
    uint256 thirdBonusEstimate;
    uint256 fourthBonusEstimate;
    uint256 firstBonusPriceRate;
    uint256 secondBonusPriceRate;
    uint256 thirdBonusPriceRate;
    uint256 fourthBonusPriceRate;
    uint256 tokensDistributed;
    function Kirke() payable public {
        owner = msg.sender;
        totalSupply = 355800000 * (10 ** uint256(decimals));
        bountyReserveTokens = 200000 * (10 ** uint256(decimals));
        advisoryReserveTokens = 4000000 * (10 ** uint256(decimals));
        teamReserveTokens = 40000000 * (10 ** uint256(decimals));
        rateForToken = 85000 * (10 ** uint256(decimals));//( 1ETH = 700 ) * 100
        balances[msg.sender] = totalSupply;
        deadLine = (now) + 59 days;
        firstBonusEstimate = 50000000 * (10 ** uint256(decimals));
        firstBonusPriceRate = 5 * (10 ** uint256(decimals));//Dividing it with 100 0.05
        secondBonusEstimate = 100000000 * (10 ** uint256(decimals));
        secondBonusPriceRate = 6 * (10 ** uint256(decimals));//Dividing it with 100 0.06
        thirdBonusEstimate = 150000000 * (10 ** uint256(decimals));
        thirdBonusPriceRate = 7 * (10 ** uint256(decimals));//Dividing it with 100 0.07
        fourthBonusEstimate = 400000000 * (10 ** uint256(decimals));
        fourthBonusPriceRate = 8 * (10 ** uint256(decimals));//Dividing it with 100 0.08
        isPaused = false;
        tokensDistributed = 0;
    }

    /**
     * @dev directly send ether and transfer token to that account 
     */
    function() payable public whenNotPaused{
        require(msg.sender != 0x0);
        require(now &lt; deadLine);
        if(isBurned){
            revert();
        }
        uint tokensToTransfer = 0;
        if(tokensDistributed &gt;= 0 &amp;&amp; tokensDistributed &lt; firstBonusEstimate){
            tokensToTransfer = (( msg.value * rateForToken ) / firstBonusPriceRate);
        }
        if(tokensDistributed &gt;= firstBonusEstimate &amp;&amp; tokensDistributed &lt; secondBonusEstimate){
            tokensToTransfer = (( msg.value * rateForToken ) / secondBonusPriceRate);
        }
        if(tokensDistributed &gt;= secondBonusEstimate &amp;&amp; tokensDistributed &lt; thirdBonusEstimate){
            tokensToTransfer = (( msg.value * rateForToken ) / thirdBonusPriceRate);
        }
        if(tokensDistributed &gt;= thirdBonusEstimate &amp;&amp; tokensDistributed &lt; fourthBonusEstimate){
            tokensToTransfer = (( msg.value * rateForToken ) / fourthBonusPriceRate);
        }
        
        if(balances[owner] &lt; tokensToTransfer) 
        {
           revert();
        }
        
        allowed[owner][msg.sender] += tokensToTransfer;
        bool transferRes=transferFrom(owner, msg.sender, tokensToTransfer, deadLine);
        if (!transferRes) {
            revert();
        }
        else{
            tokensDistributed += tokensToTransfer;
            etherRaised += msg.value;
        }
    }
    //Transfer All Balance to Address
    function transferFundToAccount() public onlyOwner whenPaused returns(uint256 result){
        require(etherRaised&gt;0);
        owner.transfer(etherRaised);
        etherRaised=0;
        return etherRaised;
    }
    //Transfer Bounty Reserve Tokens
    function transferBountyReserveTokens(address _bountyAddress, uint256 tokensToTransfer) public onlyOwner {
        tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
        if(bountyReserveTokensDistributed + tokensToTransfer &gt; bountyReserveTokens){
            revert();
        }
        allowed[owner][_bountyAddress] += tokensToTransfer;
        bool transferRes=transferFrom(owner, _bountyAddress, tokensToTransfer, deadLine);
        if (!transferRes) {
            revert();
        }
        else{
            bountyReserveTokensDistributed += tokensToTransfer;
        }
    }
    //Transfer Bounty Reserve Tokens
    function transferTeamReserveTokens(address _teamAddress, uint256 tokensToTransfer) public onlyOwner {
        tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
        if(teamReserveTokensDistributed + tokensToTransfer &gt; teamReserveTokens){
            revert();
        }
        allowed[owner][_teamAddress] += tokensToTransfer;
        bool transferRes=transferFrom(owner, _teamAddress, tokensToTransfer, deadLine);
        if (!transferRes) {
            revert();
        }
        else{
            teamReserveTokensDistributed += tokensToTransfer;
        }
    }
    //Transfer Bounty Reserve Tokens
    function transferAdvisoryReserveTokens(address _advisoryAddress, uint256 tokensToTransfer) public onlyOwner {
        tokensToTransfer = tokensToTransfer * (10 ** uint256(decimals));
        if(advisoryReserveTokensDistributed + tokensToTransfer &gt; advisoryReserveTokens){
            revert();
        }
        allowed[owner][_advisoryAddress] += tokensToTransfer;
        bool transferRes=transferFrom(owner, _advisoryAddress, tokensToTransfer, deadLine);
        if (!transferRes) {
            revert();
        }
        else{
            advisoryReserveTokensDistributed += tokensToTransfer;
        }
    }
    //Burning Of Tokens
    function burn() public onlyOwner {
        isBurned = true;
    }
}