pragma solidity ^0.4.24;

contract VerityToken {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ValidationNodeLock {
  address public owner;
  address public tokenAddress;
  bool public allFundsCanBeUnlocked = false;
  uint public lastLockingTime;
  // 30_000 evt tokens minimal investment
  uint public nodePrice = 30000 * 10**18;

  uint public lockedUntil;
  mapping(address =&gt; mapping(string =&gt; uint)) lockingData;

  event Withdrawn(address indexed withdrawer, uint indexed withdrawnAmount);
  event FundsLocked(
    address indexed user,
    uint indexed lockedAmount,
    uint indexed validationNodes
  );
  event AllFundsCanBeUnlocked(
    uint indexed triggeredTimestamp,
    bool indexed canAllFundsBeUnlocked
  );

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  modifier lastLockingTimeIsInTheFuture(uint _lastLockingTime) {
    require(now &lt; _lastLockingTime);
    _;
  }

  modifier onlyOnceLockingPeriodIsOver() {
    require(now &gt;= lockedUntil || allFundsCanBeUnlocked);
    _;
  }

  modifier checkUsersTokenBalance(uint _fundsToTransfer) {
    require(
      _fundsToTransfer &lt;= VerityToken(tokenAddress).balanceOf(msg.sender)
    );
    _;
  }

  modifier checkValidLockingTime() {
    require(now &lt;= lastLockingTime);
    _;
  }

  modifier checkValidLockingArguments(uint _tokens, uint _nodes) {
    require(_tokens &gt;= nodePrice &amp;&amp; _nodes &gt;= 1);
    _;
  }

  modifier checkValidLockingAmount(uint _tokens, uint _nodes) {
    require(_tokens == (_nodes * nodePrice));
    _;
  }

  modifier lockedUntilIsInTheFuture(uint _lockedUntil) {
    require(now &lt; _lockedUntil);
    _;
  }

  modifier lastLockingTimeIsBeforeLockedUntil(
    uint _lastLockingTime,
    uint _lockedUntil
  )
  {
    require(_lastLockingTime &lt; _lockedUntil);
    _;
  }

  modifier checkLockIsNotTerminated() {
    require(allFundsCanBeUnlocked == false);
    _;
  }

  constructor(address _tokenAddress, uint _lastLockingTime, uint _lockedUntil)
    public
    lastLockingTimeIsInTheFuture(_lastLockingTime)
    lockedUntilIsInTheFuture(_lockedUntil)
    lastLockingTimeIsBeforeLockedUntil(_lastLockingTime, _lockedUntil)
  {
    owner = msg.sender;
    tokenAddress = _tokenAddress;
    lastLockingTime = _lastLockingTime;
    lockedUntil = _lockedUntil;
  }

  function lockFunds(uint _tokens, uint _nodes)
    public
    checkValidLockingTime()
    checkLockIsNotTerminated()
    checkUsersTokenBalance(_tokens)
    checkValidLockingArguments(_tokens, _nodes)
    checkValidLockingAmount(_tokens, _nodes)
  {
    require(
      VerityToken(tokenAddress).transferFrom(msg.sender, address(this), _tokens)
    );

    lockingData[msg.sender][&quot;amount&quot;] += _tokens;
    lockingData[msg.sender][&quot;nodes&quot;] += _nodes;

    emit FundsLocked(
      msg.sender,
      _tokens,
      _nodes
    );
  }

  function withdrawFunds()
    public
    onlyOnceLockingPeriodIsOver()
  {
    uint amountToBeTransferred = lockingData[msg.sender][&quot;amount&quot;];
    lockingData[msg.sender][&quot;amount&quot;] = 0;
    VerityToken(tokenAddress).transfer(msg.sender, amountToBeTransferred);

    emit Withdrawn(
      msg.sender,
      amountToBeTransferred
    );
  }

  function terminateTokenLock() public onlyOwner() {
    allFundsCanBeUnlocked = true;

    emit AllFundsCanBeUnlocked(
      now,
      allFundsCanBeUnlocked
    );
  }

  function getUserData(address _user) public view returns (uint[2]) {
    return [lockingData[_user][&quot;amount&quot;], lockingData[_user][&quot;nodes&quot;]];
  }
}