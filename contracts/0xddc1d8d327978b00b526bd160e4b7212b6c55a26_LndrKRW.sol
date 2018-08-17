pragma solidity 0.4.15;

contract LndrKRW {
    function allowTransaction(address creditor, address debtor, uint256 amount) public returns (bool) {
        return true;
    }
}