pragma solidity ^0.4.23;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}



/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract BouncyCoinSelfdrop {

  event TokensSold(address buyer, uint256 tokensAmount, uint256 ethAmount);

  // Total Supply: 15,000,000,000, 70% for the selfrop
  uint256 public constant MAX_TOKENS_SOLD = 10500000000 * 10**18;

  // Token Price: 0.0000001 ETH = 1 BOUNCY <=> 1 ETH = 10,000,000 Million BOUNCY
  uint256 public constant PRICE = 0.0000001 * 10**18;

  uint256 public constant MIN_CONTRIBUTION = 0.01 ether;

  uint256 public constant HARD_CAP = 500 ether;

  //  unix time values taken from https://www.unixtimestamp.com/
  // 1st ROUND (+50% Bonus): October 15-18, 2018
  // 1539561600 Is equivalent to: 10/15/2018 @ 12:00am (UTC)
  uint oct_15 = 1539561600;

  // 2nd Round (+30% Bonus): October 19-23, 2018
  // 1539907200 Is equivalent to: 10/19/2018 @ 12:00am (UTC)
  uint oct_19 = 1539907200;

  // 3rd Round (+10% Bonus): October 24-29, 2018
  // 1540339200 Is equivalent to: 10/24/2018 @ 12:00am (UTC)
  uint oct_24 = 1540339200;

  // 1540857600 Is equivalent to: 10/30/2018 @ 12:00am (UTC)
  // ** END TIME **
  uint oct_30 = 1540857600;

  // base multiplier does not include extra 10% for 1 ETH and above
  uint256 public first_round_base_multiplier = 40; // 40 % Bonus
  uint256 public second_round_base_multiplier = 20; // 20 % Bonus
  uint256 public third_round_base_multiplier = 0; // 0 % Bonus

  address public owner;

  address public wallet;

  uint256 public tokensSold;

  uint256 public totalReceived;

  ERC20 public bouncyCoinToken;

  /* Current stage */
  Stages public stage;

  enum Stages {
    Deployed,
    Started,
    Ended
  }

  /* Modifiers */

  modifier atStage(Stages _stage) {
    require(stage == _stage);
    _;
  }

  modifier isOwner() {
    require(msg.sender == owner);
    _;
  }

  /* Constructor */

  constructor(address _wallet, address _bouncyCoinToken)
    public {
    require(_wallet != 0x0);
    require(_bouncyCoinToken != 0x0);

    owner = msg.sender;
    wallet = _wallet;
    bouncyCoinToken = ERC20(_bouncyCoinToken);
    stage = Stages.Deployed;
  }

  /* Public functions */

  function()
    public
    payable {
    if (stage == Stages.Started) {
      buyTokens();
    } else {
      revert();
    }
  }

  function buyTokens()
    public
    payable
    atStage(Stages.Started) {
    require(msg.value >= MIN_CONTRIBUTION);

    uint256 base_multiplier;
    if (now > oct_30) {
      base_multiplier = 0;
    } else if (now > oct_24) {
      base_multiplier = third_round_base_multiplier;
    } else if (now > oct_19) {
      base_multiplier = second_round_base_multiplier;
    } else if (now > oct_15) {
      base_multiplier = first_round_base_multiplier;
    } else {
      base_multiplier = 0;
    }

    uint256 multiplier;
    if (msg.value >= 1 ether) multiplier = base_multiplier + 10;
    else multiplier = base_multiplier;

    uint256 amountRemaining = msg.value;

    uint256 tokensAvailable = MAX_TOKENS_SOLD - tokensSold;
    uint256 baseTokens = amountRemaining * 10**18 / PRICE;
    // adjust for bonus multiplier
    uint256 maxTokensByAmount = baseTokens + ((baseTokens * multiplier) / 100);

    uint256 tokensToReceive = 0;
    if (maxTokensByAmount > tokensAvailable) {
      tokensToReceive = tokensAvailable;
      amountRemaining -= (PRICE * tokensToReceive) / 10**18;
    } else {
      tokensToReceive = maxTokensByAmount;
      amountRemaining = 0;
    }
    tokensSold += tokensToReceive;

    assert(tokensToReceive > 0);
    assert(bouncyCoinToken.transfer(msg.sender, tokensToReceive));

    if (amountRemaining != 0) {
      msg.sender.transfer(amountRemaining);
    }

    uint256 amountAccepted = msg.value - amountRemaining;
    wallet.transfer(amountAccepted);
    totalReceived += amountAccepted;
    require(totalReceived <= HARD_CAP);

    if (tokensSold == MAX_TOKENS_SOLD) {
      finalize();
    }

    emit TokensSold(msg.sender, tokensToReceive, amountAccepted);
  }

  function start()
    public
    isOwner {
    stage = Stages.Started;
  }

  function stop()
    public
    isOwner {
    finalize();
  }

  function finalize()
    private {
    stage = Stages.Ended;
  }

  // In case of accidental ether lock on contract
  function withdraw()
    public
    isOwner {
    owner.transfer(address(this).balance);
  }

  // In case of accidental token transfer to this address, owner can transfer it elsewhere
  function transferERC20Token(address _tokenAddress, address _to, uint256 _value)
    public
    isOwner {
    ERC20 token = ERC20(_tokenAddress);
    assert(token.transfer(_to, _value));
  }

}