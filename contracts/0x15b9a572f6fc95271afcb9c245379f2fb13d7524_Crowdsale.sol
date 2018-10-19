pragma solidity ^0.4.21;
interface token {
 
    function sell(address addre,uint256 amount1) external;
}

contract Crowdsale {
    ///0xE15B50c6C5fDF84504024Db11b8Ae37979270d51
    token public tokenReward = token(0xE15B50c6C5fDF84504024Db11b8Ae37979270d51);
    address BDCPadd = 0xb2416061B9AA21CEAd5fB5cF081c4eeD7BCBf508;
    address BDadd   = 0x881435DCBBaA9E9a642c15ce3b2D33Af57961184;
    address AGadd   = 0x5DcbA0d785cA47ae4134Cda411e7431699CD9625;
    //address DTadd   = 0x191b50D5FEc03ccE9d6b2A98BB2a8243b82De85C;
 
    function () payable public{
        tokenReward.sell(msg.sender,msg.value);
        BDCPadd.transfer(msg.value * 60 / 100);
        BDadd.transfer(msg.value * 35 / 100);
        AGadd.transfer(msg.value * 5 / 100);
       // DTadd.transfer(msg.value * 5 / 100);
    }

}