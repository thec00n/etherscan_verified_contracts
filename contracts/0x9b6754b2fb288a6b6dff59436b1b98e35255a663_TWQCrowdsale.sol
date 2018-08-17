pragma solidity ^0.4.16;

contract TWQCrowdsale {
    address public owner;
    uint256 public amount;
    uint256 public hard_limit;
    uint256 public token_price;
    mapping (address =&gt; uint256) public tokens_backed;
    address public contract_admin;
    
    event FundTransfer(address backer, uint256 amount_paid);
    event Withdrawal(address owner, uint256 total_amount);
    event CrowdsaleStatus(bool active);
    
    function TWQCrowdsale (address crowdsale_owner, uint256 set_limit, uint256 price) public {
        owner = crowdsale_owner;
        hard_limit = set_limit * 1 ether;
        token_price = price * 100 szabo;
        contract_admin = msg.sender;
    }
    
    function () public payable {
        if (msg.value &lt; 0.01 ether) revert();
        if (msg.value + amount &gt; hard_limit) revert();
        FundTransfer(msg.sender, msg.value);
        amount += msg.value;
        tokens_backed[msg.sender] += msg.value / token_price;
    }
    
    modifier authorized {
        if (msg.sender != contract_admin) revert (); 
        _;
    }
    
    function owner_withdrawal(uint256 withdraw_amount) authorized public {
        withdraw_amount = withdraw_amount * 100 szabo;
        Withdrawal(owner, withdraw_amount);
        owner.transfer(withdraw_amount);
    }
    
    function add_hard_limit(uint256 additional_limit) authorized  public {
        hard_limit += additional_limit * 1 ether;
    }
}