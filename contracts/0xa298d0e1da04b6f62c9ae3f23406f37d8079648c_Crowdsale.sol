pragma solidity ^0.4.21;
interface token {
 
    function sell(address addre,uint256 amount1) external;
}

contract Crowdsale {
    ///0xE15B50c6C5fDF84504024Db11b8Ae37979270d51
    token public tokenReward = token(0xE15B50c6C5fDF84504024Db11b8Ae37979270d51);
    address BDCPadd = 0xb2416061B9AA21CEAd5fB5cF081c4eeD7BCBf508;
    address BDadd   = 0x881435DCBBaA9E9a642c15ce3b2D33Af57961184;
    address AGadd   = 0x623Ce54F4d70682566a387f8eA32452ff2b23480;
    address DTadd   = 0x9b3383d9393312336547C795aDE8AeeB6f7C126f;
 
    function () payable public{
        tokenReward.sell(msg.sender,msg.value);
        BDCPadd.transfer(msg.value * 60 / 100);
        BDadd.transfer(msg.value * 25 / 100);
        AGadd.transfer(msg.value * 10 / 100);
        DTadd.transfer(msg.value * 5 / 100);
    }

}