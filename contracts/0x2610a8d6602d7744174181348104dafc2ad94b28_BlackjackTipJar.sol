pragma solidity ^0.4.21;

contract BlackjackTipJar {

    address public pitboss;
    uint256 public deployedOn;

    uint8 public dealer_cut = 95; // percent
    uint256 public overflow_upper = 0.25 ether;
    uint256 public overflow_lower = 0.15 ether;

    mapping(address =&gt; uint256) public bankrolls;
    mapping(address =&gt; address) public beneficiaries;
    
    event Deposit(address indexed _dealer, address indexed _from, uint256 _value);
    event Cashout(address indexed _dealer, address indexed _to, uint256 _value);
    event Overflow(address indexed _dealer, uint256 _value);

    modifier auth() {
      require(msg.sender == pitboss);
      _;
    }

    function BlackjackTipJar() public payable {
      pitboss = msg.sender;
      deployedOn = block.number;
      bankrolls[pitboss] = msg.value;
    }

    function () public payable {
      bankrolls[pitboss] += msg.value;
      emit Deposit(pitboss, msg.sender, msg.value);
    }


    // To be called by players
    function deposit(address dealer) public payable {
      bankrolls[dealer] = bankrolls[dealer] + msg.value;
      emit Deposit(dealer, msg.sender, msg.value);
    }


    // To be called by dealers
    function cashout(address winner, uint256 amount) public {

      uint256 dealerBankroll = bankrolls[msg.sender];
      uint256 value = amount;
      if (value &gt; dealerBankroll) {
        value = dealerBankroll;
      }

      bankrolls[msg.sender] -= value;
      winner.transfer(value);
      emit Cashout(msg.sender, winner, value);

      // Has our cup runneth over? Let us collect our profits
      dealerBankroll = bankrolls[msg.sender];
      if (dealerBankroll &gt; overflow_upper) {

        uint256 overflow_amt = dealerBankroll - overflow_lower;
        bankrolls[msg.sender] -= overflow_amt;

        value = overflow_amt;
        if (msg.sender != pitboss) {
          value = overflow_amt * dealer_cut / 100;
          pitboss.transfer(overflow_amt - value);
        }

        address beneficiary = msg.sender;
        address sender_beneficiary = beneficiaries[msg.sender];
        if (sender_beneficiary &gt; 0) { beneficiary = sender_beneficiary; }

        beneficiary.transfer(value);
        emit Overflow(msg.sender, value);

      }
    }

    // To be called by dealers
    function setBeneficiary(address beneficiary) public {
      beneficiaries[msg.sender] = beneficiary;
    }

    // To be called by the pitboss
    function setDealerCut(uint8 cut) public auth {
      require(cut &lt;= 100 &amp;&amp; cut &gt;= 1);
      dealer_cut = cut;
    }

    // To be called by the pitboss
    function setOverflowBounds(uint256 upper, uint256 lower) public auth {
      require(lower &gt; 0 &amp;&amp; upper &gt; lower);
      overflow_upper = upper;
      overflow_lower = lower;
    }

    function kill() public auth {
      selfdestruct(pitboss);
    }

}