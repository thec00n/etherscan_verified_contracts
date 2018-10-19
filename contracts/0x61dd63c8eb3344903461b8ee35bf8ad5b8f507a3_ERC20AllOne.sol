pragma solidity ^0.4.24;

contract ERC20AllOne {

    string public constant name = "AllAddressesHave1Balance";
    string public constant symbol = "VOTERS";
    uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
    
    function balanceOf(address) external pure returns (uint) {
        return 1 * 10 ** uint(decimals);
    }

}