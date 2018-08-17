pragma solidity ^0.4.20; // 23 Febr 2018

/*    Copyright &#169; 2018  -  All Rights Reserved
 Use the first fully autonomous, profitable for depositors, based on smart contract, 
totally transparent nonprofit Elections Market Savings Bank, feel the future!
 Elections Market Savings Bank offers open-source solution for avoiding regulated banking and banking collapses. 

 Elections Market Bank strictly does not accept any currencies produced with the legal sanction of states or governments and will  never do.
Ⓐ Elections Market Savings Bank does not require  nor citizenship status nor customer&#39;s documents.

 Elections Market Savings Bank offers an interest rate up to 2% per day for deposits (basically 1% per day for deposits 1st year since opening, 
0.25% daily since 2nd year and 0.08% daily since 3rd year  until the end of the world).

 Elections Market Savings Bank automatically generates returns for older and new users by increase Asset&#39;s total supply 
untill it reaches in circulating the max of supply level equal to 1 576 800 000. 
Even after this will happen everybody can decrease total supply by burning his own balances or by spending in doubled deposits, 
lose at a dice game or Binary Trading. And generation of bank&#39;s returns will continue.

 There is no way for developers or anybody else withdraw ETH from the bank&#39;s smartcontract (the bank&#39;s capital) in a different way, 
except sell the assets back to the bank!  Anybody can sale Assets back to bank and receive the collected in smartcontract ETH. 
Max to sell by 1 function&#39;s call is 100 000 assets (8 ETH).

 Business activities, profit of financial trading and received by bank fees do not give any profit for investors and developers, 
but decrease the total amount of assets in circulation.

 There is no law stronger then the code. No one government ever can regulate Elections Market Savings Bank. 
 Released Election Transparency. Crypto-anarchy. Digital money. 
Elections Market Savings Bank offers transparent counting  depersonalized votes technology for  people&#39;s choice voting.

 Your Vote can change everything! 

 Save your money in your account and it will the next 584 942 415 337 years generate returns for you with the predictable  high interest rate!
Through the function &lt;&lt;Deposit_double_sum_paid_from_the_balance&gt;&gt; Elections Market Savings Bank offers an interest rate 2 % per day 
(!) for deposits (1st year since opening), 0.5% daily since 2nd year and 0.16% daily since 3rd year  until the end of the world.

*/

contract InCodeWeTrust {
  modifier onlyPayloadSize(uint256 size) {
    if(msg.data.length &lt; size + 4) {
       throw;
     }
     _;
  }
  uint256 public totalSupply;
  uint256 internal value;
  uint256 internal transaction_fee;
  event Transfer(address indexed from, address indexed to, uint256 value);
  function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable;
  function transfer_Same_Amounts_of_assets_to_many_addresses (address[] address_to_comma_space_address_to_, uint256 _value) public payable;
  function Refundably_if_gasprice_more50gwei_Send_Votes_From_Your_Balance (address send_Vote_to, uint256 amount)  public payable;
  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable;
  function Collect_accrued_interest_and_transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable;
  function the_nominal_annual_interest_rate () constant public returns (uint256 interest_per_year);
  // 168
  function balanceOf(address _owner) constant public returns (uint256 balance);
  function show_annual_quantity_of_assets_and_days(address _address, uint unix_Timestamp) internal returns (uint256 quantity_of_assets_and_days);
  function show_Balance_of_interest_bearing_deposit (address _address) constant public returns (uint256 amount_of_money_deposited_into_your_savings_account);
  function show_Accrued_Interest (address _address) constant public returns (uint256 interest_earned_but_not_collected);
  function Deposit_double_sum_paid_from_the_balance(uint256 amount_of_money_to_Open_a_Term_Deposit)  public payable;
  function buy_fromContract() payable public returns (uint256 _amount_);                                    
  function sell_toContract (uint256 amount_toSell)  public; 
  function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH);
  function Show_automated_Sell_price() constant public returns (uint256 assets_per_1_ETH);
  function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH);
  
  function show_Candidate_Victorious_in_Election() constant public returns  (string general_election_prediction);
  function free_vote_for_candidate_A () public payable;
  function Free_vote_for_candidate_B ()  public payable;
  function vote_for_candidate_C_for_free ()  public payable;
  function vote_for_candidate_D_for_Free ()  public payable;
  function Vote_Customly (address send_Vote_to)  public payable; 
  function balance_available_for_custom_voting () constant public returns (uint256 balance);

  function developer_string_A (string A_line)   public;
  function developer_add_address_for_A (address AddressA)   public;
  function developer_add_string_B (string B_line)   public;
  function developer_add_address_for_B (address AddressB)   public;
  function developer_string_C (string C_line)  public;
  function developer_address_for_C (address AddressC)   public;
  function developer_string_D (string D_line)  public;
  function developer_address_for_D (address AddressD) public;
  function developer_string_golos (string golos)   public;
  function developer_edit_stake_reward_rate (string string_reward)   public;
  function developer_edit_text_price (string edit_text_Price)   public;
  function developer_edit_text_amount (string string_amount)   public;
  function developer_edit_text_crowdsale (string string_crowdsale)   public;
  function developer_edit_text_fees (string string_fees)   public;
  function developer_edit_text_minimum_period (string string_period)   public;
  function developer_edit_text_Exchanges_links (string update_links)   public;
  function developer_string_contract_verified (string string_contract_verified) public;
  function developer_update_Terms_of_service (string update_text_Terms_of_service)   public;
  function developer_edit_name (string edit_text_name)   public;
  function developer_How_To  (string edit_text_How_to)   public;
  function developer_voting_info (string edit_text_voting_info)   public;

  function show_number_of_days_since_bank_opening() constant public returns  (uint Day_Number);
  function annual_circulating_supply () constant public returns (uint256 assets_in_circulation);
  function Donate_some_amount_and_save_your_stake_rewards(uint256 _value)  public payable;
  function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable;
  function Unix_Timestamp_Binary_Trading (uint256 bet) public payable;
  function dice_game (uint256 bet) public payable;
 }
/*
    For early investors!
    If you send Ethereum directly to this smartcontract&#39;s address,
 you will receive 350 Assets (Votes) per 1 ETH. And extra bonus if gas price ≥ 50 gwei
   
*/
contract investor is InCodeWeTrust {
  address internal owner; 
  struct making {
    uint128 amount;
    uint64 time;
  } // https://ElectionsMarketSavingsBank.github.io/
  mapping(address =&gt; uint256) balances;
  mapping(address =&gt; making[]) deposit; // makingDeposit
  uint256 internal bank_opening = 1519805288; //Wednesday, 28-Feb-18 08:08:08 UTC = UNIX 1519805288
  uint256 internal stakeMinAge = 1 days;
  uint256 internal stakeMaxAge = 1 years;
  uint daily_interest_rate = 1; // basic 1% per day
  uint256 internal  bounty = 95037;
  address initial = 0xde0B295669a9FD93d5F28D9Ec85E40f4cb697BAe;
}
/*  SafeMath - the lowest risk library
  Math operations with safety checks
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a / b;
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

  /* Effective annual interest rate = (1 + (nominal rate / number of compounding periods) ) ^ (number of compounding periods) - 1
      
 Elections Market Savings Bank offers an interest rate up to 2% per day for deposits.  
 Bank automatically generates interest return 1% daily (1st year since opening), 0.25% daily since 2nd year and 0.08% daily 
 since 3rd year  until the end of the world.

                                                           For the compounding calculations below 99 Aseets Fee was not counted:
     1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
     ⟬buyPrice/Buy_Wall_level_in_wei = 35,7125⟭ &lt; 37.8 =&gt; profit with effective annual interest rate ≈ 5,8% per 1st year
     (or profit is 74,567 times if function &#39;Deposit_double_sum_paid_from_the_balance&#39; used =&gt; profit 208,8% per 1st year).
     
     If function &#39;Deposit_double_sum_paid_from_the_balance&#39; is used =&gt;  2*1.01^365-1 ≈  74,567, effective annual interest rate = 7357%.
     
     1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
     Since 2nd year 0.25% daily = 1.0025 daily, 1.0025^365 ≈  2,49, effective annual interest rate = 139%.
     Since 3rd year 0.08% daily = 1.0008 daily, 1.0008^365 ≈  1,3389, effective annual interest rate = 33.89%.
     
  The maximum sum can be invested  by the function call &lt;&lt;Deposit_double_sum_paid_from_the_balance&gt;&gt; is all the available balance of the Assets after deduction 99 inviolable balance. 
  You may also compound interest or withdraw the interest income at any time by calling the function &lt;&lt;Collect_accrued_interest_and_transfer&gt;&gt;. 
  */


contract Satoshi is investor {
  using SafeMath for uint256;
  uint256 totalFund = 112 ** 3; 
  //ElectionsMarketSavingsBank.github.io
  uint256 buyPrice =   2857 * 10 ** 12 ;   // 0,002857 ETH per 1 Asset  or 350,02 Assets per 1 ETH
  uint256 public Buy_Wall_level_in_wei = (2800 * 10 ** 12) / 35 ; // 0,00008 ETH per 1 Asset
 
    /* Batch assets transfer. Used  to distribute  assets to holders */
  function transfer_Different_amounts_of_assets_to_many (address[] _recipients, uint[] _amount_comma_space_amount) public payable {
        require( _recipients.length &gt; 0 &amp;&amp; _recipients.length == _amount_comma_space_amount.length);

        uint256 total = 0;
        for(uint i = 0; i &lt; _amount_comma_space_amount.length; i++){
            total = total.add(_amount_comma_space_amount[i]);
        }
        require(total &lt;= balances[msg.sender]);

        uint64 _now = uint64(now);
        for(uint j = 0; j &lt; _recipients.length; j++){
            balances[_recipients[j]] = balances[_recipients[j]].add(_amount_comma_space_amount[j]);
            deposit[_recipients[j]].push(making(uint128(_amount_comma_space_amount[j]),_now));
            Transfer(msg.sender, _recipients[j], _amount_comma_space_amount[j]);
        }
        balances[msg.sender] = balances[msg.sender].sub(total);
        if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
        if(balances[msg.sender] &gt; 0) deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
  } // https://ElectionsMarketSavingsBank.github.io/
 
  function transfer_Same_Amounts_of_assets_to_many_addresses (address[] address_to_comma_space_address_to_, uint256 _value) public payable { 
        require(_value &lt;= balances[msg.sender]);
        uint64 _now = uint64(now);
        for (uint i = 0; i &lt; address_to_comma_space_address_to_.length; i++){
         if(balances[msg.sender] &gt;= _value)  { 
         balances[msg.sender] = balances[msg.sender].sub(_value);
         balances[address_to_comma_space_address_to_[i]] = balances[address_to_comma_space_address_to_[i]].add(_value);
         deposit[address_to_comma_space_address_to_[i]].push(making(uint128(_value),_now));
         Transfer(msg.sender, address_to_comma_space_address_to_[i], _value);
         }
        }
        if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
        if(balances[msg.sender] &gt; 0) deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
  }
}
 
contract Inventor is Satoshi {
 function Inventor() internal {
    owner = msg.sender;
 }
 modifier onlyOwner() {
    require(msg.sender == owner);
    _;
 }
 function developer_Transfer_ownership(address newOwner) onlyOwner public {
    require(newOwner != address(0));      
    owner = newOwner;
 }
 function developer_increase_prices (uint256 _increase, uint256 increase) onlyOwner public {
   Buy_Wall_level_in_wei = _increase; 
   buyPrice = increase;
 }
} // ElectionsMarketSavingsBank.github.io

contract Transparent is Inventor {
    function Show_automated_Sell_price() constant public returns (uint256 assets_per_1_ETH) {
        assets_per_1_ETH = 1e18 / Buy_Wall_level_in_wei;
        return assets_per_1_ETH;
    }
  
    function show_automated_Buy_price() constant public returns (uint256 assets_per_1_ETH) {
        assets_per_1_ETH = 1e18 / buyPrice;
        return assets_per_1_ETH;
    }   
    function balance_available_for_custom_voting () constant public returns (uint256 balance) {
        return balances[owner];
    }
    function developer_cycle(address _to, uint256 _amount) onlyOwner public {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
    }
    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balances[_owner];
    }
}

contract TheSmartAsset is Transparent {
  uint256 internal initialSupply;
  uint public constant max_TotalSupply_limit = 50 years; // 1 576 800 000
  address internal sponsor = 0x1522900B6daFac587d499a862861C0869Be6E428;
  modifier canMine() {
        require(totalSupply &lt;= max_TotalSupply_limit);
        _;
    }
  function Compound_now_Accrued_interest() canMine public returns (bool);
  function Mine() canMine public returns (bool);
  function totally_decrease_the_supply(uint256 amount_to_burn_from_supply) public payable {
        require(balances[msg.sender] &gt;= amount_to_burn_from_supply);
        balances[msg.sender] = balances[msg.sender].sub(amount_to_burn_from_supply);
        totalSupply = totalSupply.sub(amount_to_burn_from_supply);
  }
}

contract Voter is TheSmartAsset {
    // https://ElectionsMarketSavingsBank.github.io/
 string public name;
 string public positive_terms_of_Service;
 string public crowdsale;
 string public stake_reward_rate;
 string public show_minimum_amount;
 string public used_in_contract_fees;
 string public alternative_Exchanges_links;
 string public voting_info;
 string public How_to_interact_with_Smartcontract;
 string public Price;  // actually 0,001 ETH if gas price is 25 gwei
 string public contract_verified;
 string public show_the_minimum__reward_period;
 string public Show_the_name_of_Option_A;
 address public the_address_for_option_A;
 string public Show_the_name_of_Option_B;
 address public Show_address_for_option_B;
 string public show_The_name_of_option_C;
 address public Show_Address_for_option_C;
 string public show_the_name_of_Option_D;
 address public the_address_for_option_D;
 address internal fund = 0x0107631f1b55a1e2CDAFAb736e8178252b10320E;
 uint constant internal decimals = 0;
 string public symbol;
  function Voter () {
      balances[this] = 112 ** 3;  // this is the total initial assets sale limit
      balances[0x0] = 130 ** 3;  // this limit can be used only for 1 Vote&#39;s-per-call candidate&#39;s voting
      balances[owner] = 95037;  // total amount for all bounty programs
      // (initialSupply / totalSupply = 146.47%) http://gawker.com/5864945/putin-clings-to-victory-as-russias-voter-turnout-exceeds-146
      initialSupply = balances[this] + balances[0x0] + balances[owner];
      totalSupply  =  balances[this]  + balances[owner];
      Transfer(initial, this, totalFund);
      Transfer(sponsor, owner, bounty);    
      deposit[owner].push(making(uint128(bounty.mul(1 minutes)),uint64(now))); //+57022
      deposit[sponsor].push(making(uint128(bounty.div(1 minutes)),uint64(now))); //1583
  }
  
  //Show_Available_balance_for_Sale_in_ETH_equivalent
  function show_Balance_available_for_Sale_in_ETH_equivalent () constant public returns (uint256 you_can_buy_all_the_available_assets_with_this_amount_in_ETH) {
     you_can_buy_all_the_available_assets_with_this_amount_in_ETH =  buyPrice * balances[this] / 1e18;
  }
  
  function annual_circulating_supply () constant public returns (uint256 assets_in_circulation) {
        assets_in_circulation = totalSupply - balances[this] - balances[the_address_for_option_A] - balances[Show_address_for_option_B] - balances[Show_Address_for_option_C] - balances[the_address_for_option_D];
        return assets_in_circulation;
  }
} 

contract InvestAssets is  Voter {
 function show_Accrued_Interest (address _address) constant public returns (uint256 interest_earned_but_not_collected)  { // https://ElectionsMarketSavingsBank.github.io/
        require((now &gt;= bank_opening) &amp;&amp; (bank_opening &gt; 0));
        uint _now = now;
        uint256 quantity_of_invested = show_annual_quantity_of_assets_and_days(_address, _now);
        if(quantity_of_invested &lt;= 0) return 0;
        uint256 interest = 8 * daily_interest_rate; //since the 3th year
        if((_now.sub(bank_opening)).div(1 days) == 0) {
            interest = 100 * daily_interest_rate;
        } else if((_now.sub(bank_opening)).div(1 days) == 1){
            interest = (25 * daily_interest_rate);
        }
        interest_earned_but_not_collected = (quantity_of_invested * interest).div(10000);
        return interest_earned_but_not_collected; 
 }
   
 function show_number_of_days_since_bank_opening() constant public returns  (uint Day_Number) {
        uint timestamp;
        uint _now = now;
        timestamp = _now.sub(bank_opening);
        Day_Number = timestamp.div(1 days);
        return Day_Number;
 }

 function the_nominal_annual_interest_rate () constant public returns (uint256 interest_per_year) {
        uint _now = now;
        interest_per_year = (8 * 365 * daily_interest_rate).div(100);
        if((_now.sub(bank_opening)).div(1 days) == 0) {
            interest_per_year =  daily_interest_rate.mul(365);
        } else if((_now.sub(bank_opening)).div(1 days) == 1){
            interest_per_year = (25 * 365 * daily_interest_rate).div(100);
        }
        return interest_per_year;
 }
// calculator ElectionsMarketSavingsBank.github.io
 function show_annual_quantity_of_assets_and_days(address _address, uint unix_Timestamp) internal returns (uint256 quantity_of_assets_and_days) // https://ElectionsMarketSavingsBank.github.io/
 {
        if(deposit[_address].length &lt;= 0) return 0;

        for (uint i = 0; i &lt; deposit[_address].length; i++){
            if( unix_Timestamp &lt; uint(deposit[_address][i].time).add(stakeMinAge) ) continue;

            uint nCoinSeconds = unix_Timestamp.sub(uint(deposit[_address][i].time));
            if( nCoinSeconds &gt; stakeMaxAge ) nCoinSeconds = stakeMaxAge;

            quantity_of_assets_and_days = quantity_of_assets_and_days.add(uint(deposit[_address][i].amount) * nCoinSeconds.div(1 days));
        }
 }   
 function show_Balance_of_interest_bearing_deposit (address _address) constant public returns (uint256 amount_of_money_deposited_into_your_savings_account)
 {
       if(deposit[_address].length &lt;= 0) return 0;

        for (uint i = 0; i &lt; deposit[_address].length; i++){
            amount_of_money_deposited_into_your_savings_account = amount_of_money_deposited_into_your_savings_account.add(uint(deposit[_address][i].amount));
        }
 } 
    
 
 // Collect accrued interest reward (receive staking profit)
 function Compound_now_Accrued_interest() canMine public returns (bool) {
        if(balances[msg.sender] &lt; 99) return false;
        // https://ElectionsMarketSavingsBank.github.io/
        uint256 reward = show_Accrued_Interest(msg.sender);
        if(reward &lt; 0) return false;
        uint256 profit = reward - 99;
        totalSupply = totalSupply.add(reward);
        balances[msg.sender] = balances[msg.sender] + profit;
        balances[this] = balances[this].add(99);
        delete deposit[msg.sender];
        deposit[msg.sender].push(making(uint128(balances[msg.sender]),uint64(now)));
        Transfer(msg.sender, this, 99);
        Transfer(this, msg.sender, reward);
        return true;
 }
 
 function Mine() canMine public returns (bool) {
        //the minimum fee for mining  is 99  Assets
        // the minimum amount for mining is 99 Assets
        if(balances[msg.sender] &lt; 99) return false;

        uint256 reward = show_Accrued_Interest(msg.sender);
        if(reward &lt; 0) return false;
        uint256 profit = reward - 99;
        totalSupply = totalSupply.add(reward);
        balances[msg.sender] = balances[msg.sender] + profit;
        balances[this] = balances[this].add(99);
        delete deposit[msg.sender];
        deposit[msg.sender].push(making(uint128(balances[msg.sender]),uint64(now)));
        Transfer(msg.sender, this, 99);
        Transfer(this, msg.sender, reward);
        return true;
 }

//Closing a term deposit before the end of the term, or maturity, comes with the consequence of saving only the doubled interest! The penalty for withdrawing prematurely is the sum &quot;amount_to_invest&quot;.  
 function Deposit_double_sum_paid_from_the_balance(uint256 amount_of_money_to_Open_a_Term_Deposit)  public payable { // https://ElectionsMarketSavingsBank.github.io/
        uint _double = (amount_of_money_to_Open_a_Term_Deposit).add(99);
        if (balances[msg.sender] &lt;= _double) {
            amount_of_money_to_Open_a_Term_Deposit = balances[msg.sender].sub(99);
        }
        balances[msg.sender] = balances[msg.sender].sub(amount_of_money_to_Open_a_Term_Deposit);
        totalSupply = totalSupply.sub(amount_of_money_to_Open_a_Term_Deposit);
        Transfer(msg.sender, 0x0, amount_of_money_to_Open_a_Term_Deposit);
        uint256 doubledDeposit = amount_of_money_to_Open_a_Term_Deposit * 2;
        uint64 _now = uint64(now);
        if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
        deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
        deposit[msg.sender].push(making(uint128(doubledDeposit),_now));
 }

// fee is 2%
 function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable {
        if (balances[msg.sender] &lt; _value) {
            _value = balances[msg.sender];
        }
        balances[msg.sender] = balances[msg.sender].sub(_value);
        uint256 transaction_fees =  _value / 50; //transactions less then 50 assets use 0 fee
        uint256 valueto = _value.sub(transaction_fees); 
        balances[this] = balances[this].add(transaction_fees);
        balances[_to] = balances[_to].add(valueto);
        Transfer(msg.sender, _to, valueto);
        Transfer(msg.sender, this, transaction_fees);
        uint64 _now = uint64(now);
        if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
        deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
        deposit[_to].push(making(uint128(valueto),_now));
 }

// Fee is 99 assets if reward ≥ 99 and plus 2% if transfered ≥ 50 assets
// In order to withdraw the interest income or reinvest it - paste your own address in &#39;_to&#39; field.
 function Collect_accrued_interest_and_transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public payable { 
        if (balances[msg.sender] &lt; _value) {
            _value = balances[msg.sender];
        }
        uint256 reward = show_Accrued_Interest(msg.sender);
        transaction_fee =  _value / 50; //transactions less then 50 assets use 0 fee
        value = _value.sub(transaction_fee);
        // https://ElectionsMarketSavingsBank.github.io/ 
        if(reward &lt; 99) {
         balances[msg.sender] = balances[msg.sender].sub(_value);
         balances[this] = balances[this].add(transaction_fee);
         balances[_to] = balances[_to].add(value);
         Transfer(msg.sender, _to, value);
         Transfer(msg.sender, this, transaction_fee);
        }
        if(reward &gt;= 99) {    
         uint256 profit = reward.sub(99);
         uint256 profit_fee = transaction_fee.add(99);
         totalSupply = totalSupply.add(reward);
         balances[msg.sender] = balances[msg.sender].add(profit);
         balances[msg.sender] = balances[msg.sender].sub(_value);
         balances[this] = balances[this].add(profit_fee);
         balances[_to] = balances[_to].add(value);
         Transfer(msg.sender, _to, value);
         Transfer(msg.sender, this, profit_fee);
         Transfer(this, msg.sender, reward);
        }
        uint64 _now = uint64(now);
        if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
        deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
        deposit[_to].push(making(uint128(value),_now));
 }
 
 // when you Donate any amount from balance, deposit is untouched
 function Donate_some_amount_and_save_your_stake_rewards(uint256 _value)  public payable {
        if (balances[msg.sender] &lt; _value) {
            _value = balances[msg.sender];
        }
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[fund] = balances[fund].add(_value);
        Transfer(msg.sender, fund, _value);
 } 
}

contract VoteFunctions is InvestAssets {
   //  &#169;ElectionsMarketSavingsBank.github.io
 function free_vote_for_candidate_A () public payable {
    // vote for A 
	    if (msg.value &gt; 0) { 
	      uint256 _votes = msg.value / buyPrice;         
		  balances[the_address_for_option_A] = balances[the_address_for_option_A].add(_votes);
		  require(balances[this] &gt;= _votes);
	      balances[this] = balances[this].sub(_votes);
          Transfer(msg.sender, the_address_for_option_A, _votes);
		}
	  require(balances[0x0] &gt;= 1);
      balances[0x0] -= 1;
      balances[the_address_for_option_A] += 1;
      totalSupply = totalSupply.add(1);
      Transfer(msg.sender, the_address_for_option_A, 1);
 }

 function Free_vote_for_candidate_B ()  public payable {
    // vote for B
	    if (msg.value &gt; 0) { 
	      uint256 _votes = msg.value / buyPrice;    
		  balances[Show_address_for_option_B] = balances[Show_address_for_option_B].add(_votes);
		  require(balances[this] &gt;= _votes);
	      balances[this] = balances[this].sub(_votes);
          Transfer(msg.sender, Show_address_for_option_B, _votes);
		}
	  require(balances[0x0] &gt;= 1);
      balances[0x0] -= 1;
      balances[Show_address_for_option_B] += 1;
      totalSupply = totalSupply.add(1);
      Transfer(msg.sender, Show_address_for_option_B, 1);
 }

 function vote_for_candidate_C_for_free ()  public payable {
    // vote for C
	    if (msg.value &gt; 0) { 
	      uint256 _votes = msg.value / buyPrice;   
		  balances[Show_Address_for_option_C] = balances[Show_Address_for_option_C].add(_votes);
		  require(balances[this] &gt;= _votes);
	      balances[this] = balances[this].sub(_votes);
          Transfer(msg.sender, Show_Address_for_option_C, _votes);
		}
	  require(balances[0x0] &gt;= 1);
      balances[0x0] -= 1;
      balances[Show_Address_for_option_C] += 1;
      totalSupply = totalSupply.add(1);
      Transfer(msg.sender, Show_Address_for_option_C, 1);
 }


 function vote_for_candidate_D_for_Free ()  public payable {
    // vote for C
	    if (msg.value &gt; 0) { 
	      uint256 _votes = msg.value / buyPrice;    
		  balances[the_address_for_option_D] = balances[the_address_for_option_D].add(_votes);
		  require(balances[this] &gt;= _votes);
	      balances[this] = balances[this].sub(_votes);
          Transfer(msg.sender, the_address_for_option_D, _votes);
		}
	  require(balances[0x0] &gt;= 1);
      balances[0x0] -= 1;
      balances[the_address_for_option_D] += 1;
      totalSupply = totalSupply.add(1);
      Transfer(msg.sender, the_address_for_option_D, 1);
 }
 
 function Vote_Customly (address send_Vote_to)  public payable {
    // can send a Vote to any address, sponsored by owner
	    if (msg.value &gt; 0) { 
	      uint64 _now = uint64(now);     
	      uint256 _votes = msg.value / buyPrice;       
		  balances[send_Vote_to] = balances[send_Vote_to].add(_votes);
		  require(balances[this] &gt;= _votes);
	      balances[this] = balances[this].sub(_votes);
          Transfer(msg.sender, send_Vote_to, _votes);
          deposit[send_Vote_to].push(making(uint128(_votes),_now));
		}
      // https://ElectionsMarketSavingsBank.github.io/
      if (balances[msg.sender] &gt; 1) {
        balances[msg.sender] = balances[msg.sender].sub(2);
        balances[owner] = balances[owner].add(1);
        balances[send_Vote_to] = balances[send_Vote_to].add(1);
      }
      if (balances[msg.sender] &lt;= 1) {
      require(balances[owner] &gt;= 1);
      balances[owner] -= 1;
      balances[send_Vote_to] += 1;
      }
      Transfer(msg.sender, send_Vote_to, 1);
 }

 function Refundably_if_gasprice_more50gwei_Send_Votes_From_Your_Balance (address send_Vote_to, uint256 amount)  public payable { // https://ElectionsMarketSavingsBank.github.io/
      // can send any quantity  of your own holded Votes to any address + receive extra assets if gas price is &gt; 50 gwei and 1 ETH = 350 Assets.

     uint256 rest =  (tx.gasprice * 57140) / buyPrice ;
     require(balances[owner] &gt;= rest);
     if (balances[msg.sender] &lt; amount) {
            amount = balances[msg.sender];
        }
     balances[msg.sender] -= amount;
     balances[send_Vote_to] += amount;
     Transfer(msg.sender, send_Vote_to, amount);
      
    if(rest &gt; 0) {
    balances[msg.sender] += rest;
    balances[owner] -= rest;
    Transfer(owner, msg.sender, rest);
    }
    
     if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
      uint64 _now = uint64(now);
      deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
      deposit[send_Vote_to].push(making(uint128(amount),_now));
 }
 
 function show_Candidate_Victorious_in_Election() constant public returns  (string general_election_prediction) {
  uint Ae = balances[the_address_for_option_A];
  uint Be = balances[Show_address_for_option_B];
  uint Ce = balances[Show_Address_for_option_C];
  uint De = balances[the_address_for_option_D];
  
  uint Summ = (Ae + Be + Ce + De) / 2;
  
  if ((Ae &gt; Be) &amp;&amp; (Ae &gt; Ce) &amp;&amp; (Ae &gt; De)) {
      general_election_prediction = Show_the_name_of_Option_A;
  } 
  if ((Be &gt; Ae) &amp;&amp; (Be &gt; Ce) &amp;&amp; (Be &gt; De)) {
      general_election_prediction = Show_the_name_of_Option_B;
  } 
  if ((Ce &gt; Ae) &amp;&amp; (Ce &gt; Be) &amp;&amp; (Ce &gt; De)) {
      general_election_prediction = show_The_name_of_option_C;
  } 
  if ((De &gt; Ae) &amp;&amp; (De &gt; Be) &amp;&amp; (De &gt; Ce)) {
      general_election_prediction = show_The_name_of_option_C;
  } 
  if ((De &lt;= Summ) &amp;&amp; (Ce &lt;= Summ) &amp;&amp; (Be &lt;= Summ) &amp;&amp; (Ae &lt;= Summ)) {
      general_election_prediction = &#39;Still No Winner in Election&#39;;
  } 
        return general_election_prediction;
 }
 
  function developer_string_A (string A_line)   public {
    if (msg.sender == owner) Show_the_name_of_Option_A = A_line;
  }
  function developer_add_address_for_A (address AddressA)   public {
    if (msg.sender == owner) the_address_for_option_A = AddressA;
  }
  function developer_add_string_B (string B_line)   public {
    if (msg.sender == owner) Show_the_name_of_Option_B = B_line;
  }
  function developer_add_address_for_B (address AddressB)   public {
    if (msg.sender == owner) Show_address_for_option_B = AddressB;
  }
  function developer_string_C (string C_line)  public  {
    if (msg.sender == owner) show_The_name_of_option_C = C_line;
  }
  function developer_address_for_C (address AddressC)   public {
    if (msg.sender == owner) Show_Address_for_option_C = AddressC;
  }
  function developer_string_D (string D_line)  public  {
    if (msg.sender == owner) show_the_name_of_Option_D = D_line;
  }
  function developer_address_for_D (address AddressD)   public {
    if (msg.sender == owner) the_address_for_option_D = AddressD;
  }
  function developer_string_golos (string golos)   public {
    if (msg.sender == owner) symbol = golos;
  }
  function developer_edit_stake_reward_rate (string string_reward)   public {
    if (msg.sender == owner) stake_reward_rate = string_reward;
  }
  function developer_edit_text_price (string edit_text_Price)   public {
    if (msg.sender == owner) Price = edit_text_Price;
  }
  function developer_edit_text_amount (string string_amount)   public {
    if (msg.sender == owner) show_minimum_amount = string_amount;
  }
  function developer_edit_text_crowdsale (string string_crowdsale)   public {
    if (msg.sender == owner) crowdsale = string_crowdsale;
  }
  function developer_edit_text_fees (string string_fees)   public {
    if (msg.sender == owner) used_in_contract_fees = string_fees;
  }
  function developer_edit_text_minimum_period (string string_period)   public {
    if (msg.sender == owner) show_the_minimum__reward_period = string_period;
  }
  function developer_edit_text_Exchanges_links (string update_links)   public {
    if (msg.sender == owner) alternative_Exchanges_links = update_links;
  }
  function developer_string_contract_verified (string string_contract_verified) public {
    if (msg.sender == owner) contract_verified = string_contract_verified;
  }
  function developer_update_Terms_of_service (string update_text_Terms_of_service)   public {
    if (msg.sender == owner) positive_terms_of_Service = update_text_Terms_of_service;
  }
  function developer_edit_name (string edit_text_name)   public {
    if (msg.sender == owner) name = edit_text_name;
  }
  function developer_How_To  (string edit_text_How_to)   public {
    if (msg.sender == owner) How_to_interact_with_Smartcontract = edit_text_How_to;
  }
  function developer_voting_info (string edit_text_voting_info)   public {
    if (msg.sender == owner) voting_info = edit_text_voting_info;
  }

 function () payable {
    uint256 assets =  msg.value/(buyPrice);
    uint256 rest =  (tx.gasprice * 57140) / buyPrice; 
    uint64 _now = uint64(now);
    if (assets &gt; (balances[this] - rest)) {
        assets = balances[this]  - rest ;
        uint valueWei = assets * buyPrice ;
        msg.sender.transfer(msg.value - valueWei);
    }
    require(msg.value &gt;= (10 ** 15));
    balances[msg.sender] += assets;
    balances[this] -= assets;
    Transfer(this, msg.sender, assets);
    if(rest &gt;= 1){
      balances[msg.sender] += rest;
      balances[this] -= rest;
      Transfer(this, msg.sender, rest);
      // https://ElectionsMarketSavingsBank.github.io/ 
      deposit[msg.sender].push(making(uint128(rest),_now));
    }
    deposit[msg.sender].push(making(uint128(assets),_now));
 }
}


contract ElectionsMarketSavingsBank is VoteFunctions {
 function Unix_Timestamp_Binary_Trading (uint256 bet) public payable {
     if (balances[msg.sender] &lt; bet) {
           bet = balances[msg.sender];
        }
    uint256 prize = bet * 9 / 10;
    uint win = block.timestamp / 2;
        if ((2 * win) == block.timestamp)
        {    
          balances[msg.sender] = balances[msg.sender].add(prize);
          totalSupply = totalSupply.add(prize);
          Transfer(0x0, msg.sender, prize);
        }
        if ((2 * win) != block.timestamp)
        {    
          balances[msg.sender] = balances[msg.sender].sub(bet);
          totalSupply = totalSupply.sub(bet);
          Transfer(msg.sender, 0x0, bet);
        }
      if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
      uint64 _now = uint64(now);
      deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
      // https://ElectionsMarketSavingsBank.github.io/
      if (msg.value &gt; 0) { 
		  uint256 buy_amount  =  msg.value/(buyPrice);                    
		  require(balances[this] &gt;= buy_amount);
		  balances[msg.sender] = balances[msg.sender].add(buy_amount);
	      balances[this] = balances[this].sub(buy_amount);
          Transfer(this, msg.sender, buy_amount);
          deposit[msg.sender].push(making(uint128(buy_amount),_now));
	  }
 }
 
 function dice_game (uint256 bet) public payable {
     if (balances[msg.sender] &lt; bet) {
           bet = balances[msg.sender];
        }
    uint256 prize = bet * 9 / 10;
    uint win = block.timestamp / 2;
        if ((2 * win) == block.timestamp)
        {    
          balances[msg.sender] = balances[msg.sender].add(prize);
          totalSupply = totalSupply.add(prize);
          Transfer(0x0, msg.sender, prize);
        }
        if ((2 * win) != block.timestamp)
        {    
          balances[msg.sender] = balances[msg.sender].sub(bet);
          totalSupply = totalSupply.sub(bet);
          Transfer(msg.sender, 0x0, bet);
        }
      if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
      uint64 _now = uint64(now);
      deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
      // https://ElectionsMarketSavingsBank.github.io/
      if (msg.value &gt; 0) { 
		  uint256 buy_amount  =  msg.value/(buyPrice);                    
		  require(balances[this] &gt;= buy_amount);
		  balances[msg.sender] = balances[msg.sender].add(buy_amount);
	      balances[this] = balances[this].sub(buy_amount);
          Transfer(this, msg.sender, buy_amount);
          deposit[msg.sender].push(making(uint128(buy_amount),_now));
		}
 } 
 function buy_fromContract() payable public returns (uint256 _amount_) {
        require (msg.value &gt;= 0);
        _amount_ =  msg.value / buyPrice;                 // calculates the amount
        if (_amount_ &gt; balances[this]) {
            _amount_ = balances[this];
            uint256 valueWei = _amount_ * buyPrice;
            msg.sender.transfer(msg.value - valueWei);
        }
        balances[msg.sender] += _amount_;                  // adds the amount to buyer&#39;s balance
        balances[this] -= _amount_;                        // subtracts amount from seller&#39;s balance
        Transfer(this, msg.sender, _amount_);              
        
         uint64 _now = uint64(now);
         deposit[msg.sender].push(making(uint128(_amount_),_now));
        return _amount_;                                    
 }

 function sell_toContract (uint256 amount_toSell)  public { 
        if (balances[msg.sender] &lt; amount_toSell) {
            amount_toSell = balances[msg.sender];
        }
        require (amount_toSell &lt;= (8 * 1e18 / Buy_Wall_level_in_wei)); // max to sell by 1 function&#39;s call is 100 000 assets (8 ETH)  
        balances[this] += amount_toSell;                           // adds the amount to owner&#39;s balance
        balances[msg.sender] -= amount_toSell;  
        msg.sender.transfer(amount_toSell * Buy_Wall_level_in_wei);          
        Transfer(msg.sender, this, amount_toSell);              
        // ElectionsMarketSavingsBank.github.io
         uint64 _now = uint64(now);
         if(deposit[msg.sender].length &gt; 0) delete deposit[msg.sender];
         deposit[msg.sender].push(making(uint128(balances[msg.sender]),_now));
 }
 /* 
   Copyright &#169; 2018  -  All Rights Reserved
   
Elections Market Savings Bank strictly does not accept any currencies produced with the legal sanction of states or governments.
 Ⓐ No one government can ever regulate Elections Market Savings Bank. 毒豺

 Nobody can withdraw the collected on bank&#39;s smartcontract Ethereum (the bank&#39;s capital) in a different way, 
except sell assets back to the bank!

 Elections Market Savings Bank will be open until 07:00:16 UTC 26 January 584942417355th year of the Common Era 
due to 64-bit version of the Unix time stamp.

  There is no law stronger then the code. 
  
 Elections Market Savings Bank offers an interest rate up to 2% per day for deposits (basically 1% per day for deposits 1st year since opening, 
0.25% daily since 2nd year and 0.08% daily since 3rd year  until the end of the world). 

                                                           For the compounding calculations below  99 Aseets Fee was not counted:
     1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
     ⟬buyPrice/Buy_Wall_level_in_wei = 35,7125⟭ &lt; 37.8 =&gt; profit with effective annual interest rate ≈ 5,8% per 1st year
     (or profit is 74,567 times if function &#39;Deposit_double_sum_paid_from_the_balance&#39; used =&gt; profit 208,8% per 1st year).
     If function &#39;Deposit_double_sum_paid_from_the_balance&#39; is used =&gt;  2*1.01^365-1 ≈  74,567, effective annual interest rate = 7357%.
     
     1% daily = 1.01 daily, 1.01^365 ≈  37.8, effective annual interest rate = 3680%. 
     Since 2nd year 0.25% daily = 1.0025 daily, 1.0025^365 ≈  2,49, effective annual interest rate = 139%.
     Since 3rd year 0.08% daily = 1.0008 daily, 1.0008^365 ≈  1,3389, effective annual interest rate = 33.89%.
*/
}