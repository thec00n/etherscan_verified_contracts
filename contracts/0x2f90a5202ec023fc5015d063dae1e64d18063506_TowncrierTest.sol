pragma solidity ^0.4.0;
contract TowncrierTest {
    event LogTowncrierCallback(uint64 requestId, uint64 error, bytes32 respData);
    
    function towncrierCallback(uint64 requestId, uint64 error, bytes32 respData) public {
        LogTowncrierCallback(requestId, error, respData);
    }
}