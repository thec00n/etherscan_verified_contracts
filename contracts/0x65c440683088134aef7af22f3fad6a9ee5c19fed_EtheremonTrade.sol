pragma solidity ^0.4.16;

interface EtheremonTradeInterface {
    function isOnTrading(uint64 _objId) constant external returns(bool);
}

contract EtheremonTrade is EtheremonTradeInterface {
    function isOnTrading(uint64 _objId) constant external returns(bool) {
        return false;
    }
}