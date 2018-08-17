pragma solidity ^0.4.18;

contract Token {

    // ERC20 standard

    function balanceOf(address _owner) constant public returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
    function totalSupply() constant public returns (uint256 supply);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract SafeMath {

  function safeMul(uint a, uint b) internal pure returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeSub(uint a, uint b) internal pure returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }
  function safeAdd(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c &gt;= a &amp;&amp; c &gt;= b);
    return c;
  }

  modifier onlyPayloadSize(uint numWords) {
     assert(msg.data.length &gt;= numWords * 32 + 4);
     _;
  }

}

contract StandardToken is Token, SafeMath {
    
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    uint256 public totalSupply;

    function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
        require(_to != address(0));
        require(balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0);
        balances[_from] = safeSub(balances[_from], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) public returns (bool success) {
        require(allowed[msg.sender][_spender] == _oldValue);
        allowed[msg.sender][_spender] = _newValue;
        Approval(msg.sender, _spender, _newValue);
        return true;
    }

    function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }
    
    
    function totalSupply() constant public returns (uint256 supply) {
        supply = totalSupply;
    }
    
}



contract TabarniaCoin is StandardToken {

    string public name = &quot;Tabarnia Coin&quot;;
    string public motto = &quot;Acta est fabula&quot;;
    uint8 public decimals = 18;
    string public symbol = &quot;TAB&quot;;
    string public version = &#39;1.0&#39;;
    string public author = &quot;Lord Cid&quot;;
    string public mission = &quot;Somos Anonimos. Somos Legion. No perdonamos. No olvidamos.&quot;;
    uint256 public tabsOneEthCanBuyICO = 1000;
    bool public halted = false;
    bool public tradeable = true;
    address public fundsWallet;

    struct Proposal {
        uint voteCount;
    }
    
    struct Voter {
        uint8 vote;
        bool voted;
    }
    
    mapping(address =&gt; Voter) voters;
    
    Proposal[] proposals;

    event Burn(address indexed from, uint256 value);

    modifier onlyFundsWallet {
        require(msg.sender == fundsWallet);
        _;
    }

    modifier isTradeable {
        require(tradeable || msg.sender == fundsWallet);
        _;
    }

    function TabarniaCoin() public {
        totalSupply = 1000000 * 1000000000000000000;
        balances[msg.sender] = totalSupply;
        fundsWallet = msg.sender;
    }

    function() payable public {
        require(!halted);
        uint256 amount = safeMul(msg.value,tabsOneEthCanBuyICO);

        if (balances[fundsWallet] &lt; amount) {
            return;
        }

        balances[fundsWallet] = safeSub(balances[fundsWallet], amount);
        balances[msg.sender] = safeAdd(balances[msg.sender], amount);

        Transfer(fundsWallet, msg.sender, amount);

        fundsWallet.transfer(msg.value);                               
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        if (!_spender.call(bytes4(bytes32(keccak256(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData)) { throw; }
        return true;
    }

    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf(msg.sender) &gt;= _value);
        balances[msg.sender] = safeSub(balances[msg.sender], _value);
        totalSupply = safeSub(totalSupply, _value); 
        Burn(msg.sender, _value);
        return true;
    }

    function halt() external onlyFundsWallet {
        halted = true;
    }

    function unhalt() external onlyFundsWallet {
        halted = false;
    }


    function enableTrading() external onlyFundsWallet {
        tradeable = true;
    }

    function disableTrading() external onlyFundsWallet {
        tradeable = false;
    }

    function transfer(address _to, uint256 _value) isTradeable public returns (bool success) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) isTradeable public returns (bool success) {
        return super.transferFrom(_from, _to, _value);
    }
    
    function claimVotingRight() public {
        require(tradeable);
        voters[msg.sender].voted = false;
        voters[msg.sender].vote = 0;
    }

    function newVoting(uint8 _numProposals) public onlyFundsWallet {
        require(!tradeable);
        proposals.length = _numProposals;
        for (uint8 prop = 0; prop &lt; proposals.length; prop++) {
            proposals[prop].voteCount = 0;
        }

    }

    function vote(uint8 toProposal) public {
        require(!tradeable);
        require(toProposal &lt; proposals.length);
        require(balances[msg.sender] &gt; 0);
        require(!voters[msg.sender].voted);
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = toProposal;
        proposals[toProposal].voteCount = safeAdd(proposals[toProposal].voteCount,balances[msg.sender]);
    }

    function winningProposal() public constant returns (uint8 _winningProposal) {
        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop &lt; proposals.length; prop++)
            if (proposals[prop].voteCount &gt; winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
    }

    function changeFundsWallet(address newFundsWallet) external onlyFundsWallet {
        require(newFundsWallet != address(0));
        fundsWallet = newFundsWallet;
    }
    

}