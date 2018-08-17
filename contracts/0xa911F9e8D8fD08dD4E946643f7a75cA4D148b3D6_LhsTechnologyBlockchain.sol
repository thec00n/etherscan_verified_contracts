pragma solidity ^0.4.0;
contract LhsTechnologyBlockchain {
    string constant message = &quot;Welcome to the Library Of The Human Soul&quot;;

    function getMessage() public pure returns (string ret) {
        ret = message;
        return ret;
    }
}