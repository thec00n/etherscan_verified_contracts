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

contract BETR_TOKEN {
    using SafeMath for uint256;

    string public constant name = &quot;Better Betting&quot;;
    string public symbol = &quot;BETR&quot;;
    uint256 public constant decimals = 18;

    uint256 public hardCap = 650000000 * (10 ** decimals);
    uint256 public totalSupply;

    address public escrow; // reference to escrow contract for transaction and authorization
    address public owner; // reference to the contract creator
    address public tgeIssuer = 0xba81ACCC7074B5D9ABDAa25c30DbaD96BF44D660;

    bool public tgeActive;
    uint256 public tgeDuration = 30 days;
    uint256 public tgeStartTime;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed; // third party authorisations for token transfering
    mapping (address =&gt; bool) public escrowAllowed; // per address switch authorizing the escrow to escrow user tokens

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function BETR_TOKEN() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyTgeIssuer {
        require(msg.sender == tgeIssuer);
        _;
    }

    modifier onlyEscrow {
        require(msg.sender == escrow);
        _;
    }

    modifier tgeRunning {
        require(tgeActive &amp;&amp; block.timestamp &lt; tgeStartTime + tgeDuration);
        _;
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

    function allowEscrow(bool _choice) external returns(bool) {
      escrowAllowed[msg.sender] = _choice;
      return true;
    }

    function escrowFrom(address _from, uint256 _value) external onlyEscrow returns(bool) {
      require (
        _from != address(0) &amp;&amp;
        balances[_from] &gt;= _value &amp;&amp;
        escrowAllowed[_from] &amp;&amp;
        _value &gt; 0
      );
      balances[_from] = balances[_from].sub(_value);
      balances[escrow] = balances[escrow].add(_value);
      Transfer(_from, escrow, _value);
      return true;
    }

    function escrowReturn(address _to, uint256 _value, uint256 _fee) external onlyEscrow returns(bool) {
        require(
            _to != address(0) &amp;&amp;
            _value &gt; 0
        );
        if(_fee &gt; 0) {
            require(_fee &lt; totalSupply &amp;&amp; _fee &lt; balances[escrow]);
            totalSupply = totalSupply.sub(_fee);
            balances[escrow] = balances[escrow].sub(_fee);
        }
        require(transfer(_to, _value));
        return true;
    }

    function mint(address _user, uint256 _tokensAmount) public onlyTgeIssuer tgeRunning returns(bool) {
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

    function reserveTokensGroup(address[] _users, uint256[] _tokensAmounts) external onlyOwner {
        require(_users.length == _tokensAmounts.length);
        uint256 newSupply;
        for(uint8 i = 0; i &lt; _users.length; i++){
            newSupply = totalSupply.add(_tokensAmounts[i].mul(10 ** decimals));
            require(
                _users[i] != address(0) &amp;&amp;
                _tokensAmounts[i] &gt; 0 &amp;&amp;
                newSupply &lt; hardCap
            );
            balances[_users[i]] = balances[_users[i]].add(_tokensAmounts[i].mul(10 ** decimals));
            totalSupply = newSupply;
            Transfer(0x0, _users[i], _tokensAmounts[i]);
        }
    }

    function reserveTokens(address _user, uint256 _tokensAmount) external onlyOwner {
        uint256 newSupply = totalSupply.add(_tokensAmount.mul(10 ** decimals));
        require(
            _user != address(0) &amp;&amp;
            _tokensAmount &gt; 0 &amp;&amp;
            newSupply &lt; hardCap
        );
        balances[_user] = balances[_user].add(_tokensAmount.mul(10 ** decimals));
        totalSupply = newSupply;
        Transfer(0x0, _user, _tokensAmount);
    }

    function startTge() external onlyOwner {
        tgeActive = true;
        if(tgeStartTime == 0) tgeStartTime = block.timestamp;
    }

    function stopTge(bool _restart) external onlyOwner {
      tgeActive = false;
      if(_restart) tgeStartTime = 0;
    }

    function extendTge(uint256 _time) external onlyOwner {
      tgeDuration = tgeDuration.add(_time);
    }

    function setEscrow(address _escrow) external onlyOwner {
        escrow = _escrow;
    }

    function setTgeIssuer(address _tgeIssuer) external onlyOwner {
        tgeIssuer = _tgeIssuer;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return allowed[_owner][_spender];
    }
}