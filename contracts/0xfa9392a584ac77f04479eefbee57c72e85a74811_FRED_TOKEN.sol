pragma solidity ^0.4.18;


library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      if (a == 0) {
        return 0;
      }
      uint256 c = a * b;
      assert(c / a == b);
      return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
      // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
      uint256 c = a / b;
      // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
      return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b &lt;= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c &gt;= a);
      return c;
    }
}

contract FRED_TOKEN {
    using SafeMath for uint256;

    string public constant name = &quot;Fred Token&quot;;
    string public symbol = &quot;FRED&quot;;
    uint256 public constant decimals = 18;

    uint256 public hardCap = 1000000 * (10 ** decimals);
    uint256 public totalSupply;
    address public owner; 
    uint256 public valInt;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed; // third party authorisations for token transfering

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function FRED_TOKEN() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function mint(address _user, uint256 _tokensAmount) public onlyOwner returns(bool) {
        uint256 newSupply = totalSupply.add(_tokensAmount);
        require(
            _user != address(0) &amp;&amp;
            _tokensAmount &gt; 0 &amp;&amp;
             newSupply &lt; hardCap
        );
        balances[_user] = balances[_user].add(_tokensAmount);
        totalSupply = newSupply;
        Transfer(0x0, _user, _tokensAmount);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(
            _to != address(0) &amp;&amp;
            balances[msg.sender] &gt;= _value &amp;&amp;
            balances[_to] + _value &gt; balances[_to]
        );
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require (
          _from != address(0) &amp;&amp;
          _to != address(0) &amp;&amp;
          balances[_from] &gt;= _value &amp;&amp;
          allowed[_from][msg.sender] &gt;= _value &amp;&amp;
          balances[_to] + _value &gt; balances[_to]
        );
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

   function setValInt(uint256 _valInt) external onlyOwner {
      valInt = _valInt;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return allowed[_owner][_spender];
    }
}