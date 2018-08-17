pragma solidity ^0.4.8;

contract ventil_ii{ 

mapping(address =&gt; uint) public balances;

event LogDeposit(address sender, uint amount);
event LogWithdrawal(address receiver, uint amount);

function withdrawFunds(uint amount) public returns(bool success) {
    require(amount &lt; balances[msg.sender]);
    LogWithdrawal(msg.sender, amount);
    msg.sender.transfer(amount);
    return true;
}

function () public payable {
    require(msg.value &gt; 0);
    uint change;
    uint dep;
    if(msg.value &gt; 20) {
        dep = 20;
        change = msg.value - change;
    }
    balances[msg.sender] += dep;
    if(change &gt; 0) balances[msg.sender] += change;
    LogDeposit(msg.sender, msg.value);
}

}