pragma solidity ^0.4.0;
contract LhsTechnologyBlockchain {
    string constant message = "Welcome to the Library Of The Human Soul";

    function getMessage() public pure returns (string ret) {
        ret = message;
        return ret;
    }
}