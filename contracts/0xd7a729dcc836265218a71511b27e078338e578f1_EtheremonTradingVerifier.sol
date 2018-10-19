pragma solidity ^0.4.16;

interface EtheremonTradeData {
    function isOnTrade(uint _objId) constant external returns(bool);
}

contract EtheremonTradingVerifier {
    address public tradingData;
    
    function EtheremonTradingVerifier(address _tradingData) public {
        tradingData = _tradingData;
    }
    
    function isOnTrading(uint64 _objId) constant external returns(bool) {
        EtheremonTradeData monTradeData = EtheremonTradeData(tradingData);
        return monTradeData.isOnTrade(_objId);
    }
}