pragma solidity ^0.4.18;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
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

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Bob {
  using SafeMath for uint;

  enum DepositState {
    Uninitialized,
    BobMadeDeposit,
    AliceClaimedDeposit,
    BobClaimedDeposit
  }

  enum PaymentState {
    Uninitialized,
    BobMadePayment,
    AliceClaimedPayment,
    BobClaimedPayment
  }

  struct BobDeposit {
    bytes20 depositHash;
    DepositState state;
  }

  struct BobPayment {
    bytes20 paymentHash;
    PaymentState state;
  }

  uint public blocksPerDeal;

  mapping (bytes32 =&gt; BobDeposit) public deposits;

  mapping (bytes32 =&gt; BobPayment) public payments;

  function Bob(uint _blocksPerDeal) {
    require(_blocksPerDeal &gt; 0);
    blocksPerDeal = _blocksPerDeal;
  }

  function bobMakesEthDeposit(
    bytes32 _txId,
    address _alice,
    bytes20 _secretHash
  ) external payable {
    require(_alice != 0x0 &amp;&amp; msg.value &gt; 0 &amp;&amp; deposits[_txId].state == DepositState.Uninitialized);
    bytes20 depositHash = ripemd160(
      _alice,
      msg.sender,
      _secretHash,
      address(0),
      msg.value,
      block.number.add(blocksPerDeal.mul(2))
    );
    deposits[_txId] = BobDeposit(
      depositHash,
      DepositState.BobMadeDeposit
    );
  }

  function bobMakesErc20Deposit(
    bytes32 _txId,
    uint _amount,
    address _alice,
    bytes20 _secretHash,
    address _tokenAddress
  ) external {
    bytes20 depositHash = ripemd160(
      _alice,
      msg.sender,
      _secretHash,
      _tokenAddress,
      _amount,
      block.number.add(blocksPerDeal.mul(2))
    );
    deposits[_txId] = BobDeposit(
      depositHash,
      DepositState.BobMadeDeposit
    );
    ERC20 token = ERC20(_tokenAddress);
    assert(token.transferFrom(msg.sender, address(this), _amount));
  }

  function bobClaimsDeposit(
    bytes32 _txId,
    uint _amount,
    uint _aliceCanClaimAfter,
    address _alice,
    address _tokenAddress,
    bytes _secret
  ) external {
    require(deposits[_txId].state == DepositState.BobMadeDeposit);
    bytes20 depositHash = ripemd160(
      _alice,
      msg.sender,
      ripemd160(sha256(_secret)),
      _tokenAddress,
      _amount,
      _aliceCanClaimAfter
    );
    require(depositHash == deposits[_txId].depositHash &amp;&amp; block.number &lt; _aliceCanClaimAfter);
    deposits[_txId].state = DepositState.BobClaimedDeposit;
    if (_tokenAddress == 0x0) {
      msg.sender.transfer(_amount);
    } else {
      ERC20 token = ERC20(_tokenAddress);
      assert(token.transfer(msg.sender, _amount));
    }
  }

  function aliceClaimsDeposit(
    bytes32 _txId,
    uint _amount,
    uint _aliceCanClaimAfter,
    address _bob,
    address _tokenAddress,
    bytes20 _secretHash
  ) external {
    require(deposits[_txId].state == DepositState.BobMadeDeposit);
    bytes20 depositHash = ripemd160(
      msg.sender,
      _bob,
      _secretHash,
      _tokenAddress,
      _amount,
      _aliceCanClaimAfter
    );
    require(depositHash == deposits[_txId].depositHash &amp;&amp; block.number &gt;= _aliceCanClaimAfter);
    deposits[_txId].state = DepositState.AliceClaimedDeposit;
    if (_tokenAddress == 0x0) {
      msg.sender.transfer(_amount);
    } else {
      ERC20 token = ERC20(_tokenAddress);
      assert(token.transfer(msg.sender, _amount));
    }
  }

  function bobMakesEthPayment(
    bytes32 _txId,
    address _alice,
    bytes20 _secretHash
  ) external payable {
    require(_alice != 0x0 &amp;&amp; msg.value &gt; 0 &amp;&amp; payments[_txId].state == PaymentState.Uninitialized);
    bytes20 paymentHash = ripemd160(
      _alice,
      msg.sender,
      _secretHash,
      address(0),
      msg.value,
      block.number.add(blocksPerDeal)
    );
    payments[_txId] = BobPayment(
      paymentHash,
      PaymentState.BobMadePayment
    );
  }

  function bobMakesErc20Payment(
    bytes32 _txId,
    uint _amount,
    address _alice,
    bytes20 _secretHash,
    address _tokenAddress
  ) external {
    require(
      _alice != 0x0 &amp;&amp;
      _amount &gt; 0 &amp;&amp;
      payments[_txId].state == PaymentState.Uninitialized &amp;&amp;
      _tokenAddress != 0x0
    );
    bytes20 paymentHash = ripemd160(
      _alice,
      msg.sender,
      _secretHash,
      _tokenAddress,
      _amount,
      block.number.add(blocksPerDeal)
    );
    payments[_txId] = BobPayment(
      paymentHash,
      PaymentState.BobMadePayment
    );
    ERC20 token = ERC20(_tokenAddress);
    assert(token.transferFrom(msg.sender, address(this), _amount));
  }

  function bobClaimsPayment(
    bytes32 _txId,
    uint _amount,
    uint _bobCanClaimAfter,
    address _alice,
    address _tokenAddress,
    bytes20 _secretHash
  ) external {
    require(payments[_txId].state == PaymentState.BobMadePayment);
    bytes20 paymentHash = ripemd160(
      _alice,
      msg.sender,
      _secretHash,
      _tokenAddress,
      _amount,
      _bobCanClaimAfter
    );
    require(block.number &gt;= _bobCanClaimAfter &amp;&amp; paymentHash == payments[_txId].paymentHash);
    payments[_txId].state = PaymentState.BobClaimedPayment;
    if (_tokenAddress == 0x0) {
      msg.sender.transfer(_amount);
    } else {
      ERC20 token = ERC20(_tokenAddress);
      assert(token.transfer(msg.sender, _amount));
    }
  }

  function aliceClaimsPayment(
    bytes32 _txId,
    uint _amount,
    uint _bobCanClaimAfter,
    address _bob,
    address _tokenAddress,
    bytes _secret
  ) external {
    require(payments[_txId].state == PaymentState.BobMadePayment);
    bytes20 paymentHash = ripemd160(
      msg.sender,
      _bob,
      ripemd160(sha256(_secret)),
      _tokenAddress,
      _amount,
      _bobCanClaimAfter
    );
    require(block.number &lt; _bobCanClaimAfter &amp;&amp; paymentHash == payments[_txId].paymentHash);
    payments[_txId].state = PaymentState.AliceClaimedPayment;
    if (_tokenAddress == 0x0) {
      msg.sender.transfer(_amount);
    } else {
      ERC20 token = ERC20(_tokenAddress);
      assert(token.transfer(msg.sender, _amount));
    }
  }
}