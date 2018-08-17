pragma solidity ^0.4.10;

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

    function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
      assert(b &gt; 0);
      uint c = a / b;
      assert(a == b * c + a % b);
      return c;
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

contract StandardToken is Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
      if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
      } else {
        return false;
      }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
      } else {
        return false;
      }
    }

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

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
}

contract Mondo is SafeMath, StandardToken {

    string public constant name = &quot;Mondo Token&quot;;
    string public constant symbol = &quot;MND&quot;;
    uint256 public constant decimals = 18;

    uint256 private constant tokenCreationCapPreICO02 =  5000000*10**decimals;
    uint256 private constant tokenCreationCapPreICO15 =  11000000*10**decimals;
    uint256 public constant tokenCreationCap = 23500000*10**decimals;

    address public constant owner = 0x0077DA9DF6507655CDb3aB9277A347EDe759F93F;

    // 1 ETH = 280 USD Date: 11.08.2017
    uint private oneTokenInWeiSale1 = 70175438596491; // 0,02 $
    uint private oneTokenInWei1Sale2 = 526315789473684; // 0,15 $
    uint private oneTokenInWei = 5473684210526320; // 1,56 $

    Phase public currentPhase = Phase.PreICO1;

    enum Phase {
        PreICO1,
        PreICO2,
        ICO
    }

    modifier onlyOwner {
        if(owner != msg.sender) revert();
        _;
    }

    event CreateMND(address indexed _to, uint256 _value);

    function Mondo() {}

    function () payable {
        createTokens();
    }

    function createTokens() internal {
        if (msg.value &lt;= 0) revert();

        if (currentPhase == Phase.PreICO1) {
            if (totalSupply &lt;= tokenCreationCapPreICO02) {
                generateTokens(oneTokenInWeiSale1);
            }
        }
        else if (currentPhase == Phase.PreICO2) {
            if (totalSupply &gt; tokenCreationCapPreICO02 &amp;&amp; totalSupply &lt;= tokenCreationCapPreICO15) {
                generateTokens(oneTokenInWei1Sale2);
            }
        }
        else if (currentPhase == Phase.ICO) {
            if (totalSupply &gt; tokenCreationCapPreICO15 &amp;&amp; totalSupply &lt;= tokenCreationCap) {
                generateTokens(oneTokenInWei);
            }
        } else {
            revert();
        }
    }

    function generateTokens(uint _oneTokenInWei) internal {
        uint multiplier = 10 ** decimals;
        uint256 tokens = safeDiv(msg.value, _oneTokenInWei)*multiplier;
        uint256 checkedSupply = safeAdd(totalSupply, tokens);
        if (tokenCreationCap &lt;= checkedSupply) revert();
        balances[msg.sender] += tokens;
        totalSupply = safeAdd(totalSupply, tokens);
        CreateMND(msg.sender,tokens);
    }

    function changePhaseToPreICO2() external onlyOwner returns (bool){
        currentPhase = Phase.PreICO2;
        return true;
    }

    function changePhaseToICO() external onlyOwner returns (bool){
        currentPhase = Phase.ICO;
        return true;
    }

    function changeTokenPrice(uint tpico1, uint tpico2, uint tpico) external onlyOwner returns (bool){
        oneTokenInWeiSale1 = tpico1;
        oneTokenInWei1Sale2 = tpico2;
        oneTokenInWei = tpico;
        return true;
    }

    function finalize() external onlyOwner returns (bool){
      owner.transfer(this.balance);
      return true;
    }
}