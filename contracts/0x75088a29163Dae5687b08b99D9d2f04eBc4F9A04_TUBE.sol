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

contract TUBE is SafeMath, StandardToken {

    string public constant name = &quot;MaxiTube preICO Token&quot;;
    string public constant symbol = &quot;TUBE&quot;;
    uint256 public constant decimals = 18;
    uint256 public constant tokenCreationCap =  40000*10**decimals;

    address public owner;

    //~10usd
    uint public oneTokenInWei = 32786885245901600;
    

    modifier onlyOwner {
        if(owner!=msg.sender) revert();
        _;
    }

    event CreateTUBE(address indexed _to, uint256 _value);

    function TUBE() {
        owner = msg.sender;

    }

    function () payable {
        createTokens();
    }

    function createTokens() internal {
        if (msg.value &lt;= 0) revert();

        uint multiplier = 10 ** decimals;
        uint256 tokens = safeMult(msg.value, multiplier) / oneTokenInWei;

        uint256 checkedSupply = safeAdd(totalSupply, tokens);
        if (tokenCreationCap &lt; checkedSupply) revert();

        balances[msg.sender] += tokens;
        totalSupply = safeAdd(totalSupply, tokens);
    }

    function finalize() external onlyOwner {
        owner.transfer(this.balance);
    }

    function setEthPrice(uint _etherPrice) onlyOwner {
        oneTokenInWei = _etherPrice;
    }

    function transferRoot(address _newOwner) onlyOwner {
        owner = _newOwner;
    }

    function mint(address _to, uint256 _tokens) onlyOwner {
        uint256 checkedSupply = safeAdd(totalSupply, _tokens);
        if (tokenCreationCap &lt; checkedSupply) revert();
        balances[_to] += _tokens;
        totalSupply = safeAdd(totalSupply, _tokens);
    }

}