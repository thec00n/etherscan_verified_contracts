pragma solidity ^0.4.11;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract token { function transfer(address receiver, uint amount){  } }
contract Crowdsale {
  using SafeMath for uint256;

  // uint256 durationInMinutes;
  // address where funds are collected
  address public wallet;
  // token address
  address public addressOfTokenUsedAsReward;

  uint256 public price = 200;//initial price

  token tokenReward;

  mapping (address =&gt; uint) public contributions;
  


  // start and end timestamps where investments are allowed (both inclusive)
  // uint256 public startTime;
  // uint256 public endTime;
  // amount of raised money in wei
  uint256 public weiRaised;
  uint256 public tokensSold;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);


  function Crowdsale() {
    //DO NOT FORGET TO CHANGE THIS
    //This is the wallet where all the ETH will go!
    wallet = 0x8c7E29FE448ea7E09584A652210fE520f992cE64;//this should be Filips wallet!
    // durationInMinutes = _durationInMinutes;
    //Here will come the checksum address we got
    addressOfTokenUsedAsReward = 0xA7352F9d1872D931b3F9ff3058025c4aE07EF888; //address of the token contract
    //web3.toChecksumAddress is needed here in most cases.



    tokenReward = token(addressOfTokenUsedAsReward);
  }

  bool public started = false;

  function startSale(){
    if (msg.sender != wallet) throw;
    started = true;
  }

  function stopSale(){
    if(msg.sender != wallet) throw;
    started = false;
  }

  function setPrice(uint256 _price){
    if(msg.sender != wallet) throw;
    price = _price;
  }

  // fallback function can be used to buy tokens
  function () payable {
    buyTokens(msg.sender);
  }

  // low level token purchase function
  function buyTokens(address beneficiary) payable {
    require(beneficiary != 0x0);
    require(validPurchase());

    uint256 weiAmount = msg.value;

    if(tokensSold &lt; 10000*10**6){
      price = 300;      
    }else if(tokensSold &lt; 20000*10**6){
      price = 284;
    }else if(tokensSold &lt; 30000*10**6){
      price = 269;
    }else if(tokensSold &lt; 40000*10**6){
      price = 256;
    }else if(tokensSold &lt; 50000*10**6){
      price = 244;
    }else if(tokensSold &lt; 60000*10**6){
      price = 233;
    }else if(tokensSold &lt; 70000*10**6){
      price = 223;
    }else if(tokensSold &lt; 80000*10**6){
      price = 214;
    }else if(tokensSold &lt; 90000*10**6){
      price = 205;
    }else if(tokensSold &lt; 100000*10**6){
      price = 197;
    }else if(tokensSold &lt; 110000*10**6){
      price = 189;
    }else if(tokensSold &lt; 120000*10**6){
      price = 182;
    }else if(tokensSold &lt; 130000*10**6){
      price = 175;
    }else if(tokensSold &lt; 140000*10**6){
      price = 168;
    }else if(tokensSold &lt; 150000*10**6){
      price = 162;
    }else if(tokensSold &lt; 160000*10**6){
      price = 156;
    }else if(tokensSold &lt; 170000*10**6){
      price = 150;
    }else if(tokensSold &lt; 180000*10**6){
      price = 145;
    }else if(tokensSold &lt; 190000*10**6){
      price = 140;
    }else if(tokensSold &lt; 200000*10**6){
      price = 135;
    }else if(tokensSold &lt; 210000*10**6){
      price = 131;
    }else if(tokensSold &lt; 220000*10**6){
      price = 127;
    }else if(tokensSold &lt; 230000*10**6){
      price = 123;
    }else if(tokensSold &lt; 240000*10**6){
      price = 120;
    }else if(tokensSold &lt; 250000*10**6){
      price = 117;
    }else if(tokensSold &lt; 260000*10**6){
      price = 114;
    }else if(tokensSold &lt; 270000*10**6){
      price = 111;
    }else if(tokensSold &lt; 280000*10**6){
      price = 108;
    }else if(tokensSold &lt; 290000*10**6){
      price = 105;
    }else if(tokensSold &lt; 300000*10**6){
      price = 102;
    }else if(tokensSold &lt; 310000*10**6){
      price = 100;
    }else if(tokensSold &lt; 320000*10**6){
      price = 98;
    }else if(tokensSold &lt; 330000*10**6){
      price = 96;
    }else if(tokensSold &lt; 340000*10**6){
      price = 94;
    }else if(tokensSold &lt; 350000*10**6){
      price = 92;
    }else if(tokensSold &lt; 360000*10**6){
      price = 90;
    }else if(tokensSold &lt; 370000*10**6){
      price = 88;
    }else if(tokensSold &lt; 380000*10**6){
      price = 86;
    }else if(tokensSold &lt; 390000*10**6){
      price = 84;
    }else if(tokensSold &lt; 400000*10**6){
      price = 82;
    }else if(tokensSold &lt; 410000*10**6){
      price = 80;
    }else if(tokensSold &lt; 420000*10**6){
      price = 78;
    }else if(tokensSold &lt; 430000*10**6){
      price = 76;
    }else if(tokensSold &lt; 440000*10**6){
      price = 74;
    }else if(tokensSold &lt; 450000*10**6){
      price = 72;
    }else if(tokensSold &lt; 460000*10**6){
      price = 70;
    }else if(tokensSold &lt; 470000*10**6){
      price = 68;
    }else if(tokensSold &lt; 480000*10**6){
      price = 66;
    }else if(tokensSold &lt; 490000*10**6){
      price = 64;
    }else if(tokensSold &lt; 500000*10**6){
      price = 62;
    }else if(tokensSold &lt; 510000*10**6){
      price = 60;
    }else if(tokensSold &lt; 520000*10**6){
      price = 58;
    }else if(tokensSold &lt; 530000*10**6){
      price = 57;
    }else if(tokensSold &lt; 540000*10**6){
      price = 56;
    }else if(tokensSold &lt; 550000*10**6){
      price = 55;
    }else if(tokensSold &lt; 560000*10**6){
      price = 54;
    }else if(tokensSold &lt; 570000*10**6){
      price = 53;
    }else if(tokensSold &lt; 580000*10**6){
      price = 52;
    }else if(tokensSold &lt; 590000*10**6){
      price = 51;
    }else if(tokensSold &lt; 600000*10**6){
      price = 50;
    }else if(tokensSold &lt; 610000*10**6){
      price = 49;
    }else if(tokensSold &lt; 620000*10**6){
      price = 48;
    }else if(tokensSold &lt; 630000*10**6){
      price = 47;
    }else if(tokensSold &lt; 640000*10**6){
      price = 46;
    }else if(tokensSold &lt; 650000*10**6){
      price = 45;
    }else if(tokensSold &lt; 660000*10**6){
      price = 44;
    }else if(tokensSold &lt; 670000*10**6){
      price = 43;
    }else if(tokensSold &lt; 680000*10**6){
      price = 42;
    }else if(tokensSold &lt; 690000*10**6){
      price = 41;
    }else if(tokensSold &lt; 700000*10**6){
      price = 40;
    }
    //the price above is Token per ETH
    // calculate token amount to be sent
    uint256 tokens = (weiAmount/10**12) * price;//weiamount * price 
    
    

    require(tokens &gt;= 1 * 10 ** 6); //1 token minimum


    // update state
    weiRaised = weiRaised.add(weiAmount);
    

    tokenReward.transfer(beneficiary, tokens);
    tokensSold = tokensSold.add(tokens);//now we can track the number of tokens sold.
    TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    forwardFunds();
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  function forwardFunds() internal {
    // wallet.transfer(msg.value);
    if (!wallet.send(msg.value)) {
      throw;
    }
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal constant returns (bool) {
    bool withinPeriod = started;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod &amp;&amp; nonZeroPurchase;
  }

  function withdrawTokens(uint256 _amount) {
    if(msg.sender!=wallet) throw;
    tokenReward.transfer(wallet,_amount);
  }
}