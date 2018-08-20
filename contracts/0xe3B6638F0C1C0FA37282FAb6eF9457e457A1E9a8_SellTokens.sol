/*

Author: psdev

<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="99e9d9e9eafdfcefb7f0f6">[email protected]</a>

0x13370CA2e8426a82BcfcCE21C97817A243c521Cf

*/

contract TokenInterface {
  function balanceOf(address _owner) constant returns (uint256 balance);
  function transfer(address _to, uint256 _amount) returns (bool success);
  function receiveEther() returns(bool);
}

contract SellTokens {
    address constant THE_DAO_ADDRESS = 0xbb9bc244d798123fde783fcc1c72d3bb8c189413;

    TokenInterface public theDao;
    mapping (address => uint) public allowedFreeExchanges;

    event TransferEvent(address _from, address _to, uint256 _value);
    event ReturnEvent(uint256 _value);
    event NotEnoughEthErrorEvent(uint trySend, uint available);
    event NotEnoughDaoErrorEvent(uint trySend, uint available);

    function SellTokens(){
        theDao = TokenInterface(THE_DAO_ADDRESS);
        populateAllowedFreeExchanges();
    }

    function requestTokensBack() {
        if (msg.value != 0 || allowedFreeExchanges[msg.sender] == 0) throw;
        if (!theDao.transfer(msg.sender, allowedFreeExchanges[msg.sender])) throw;
        allowedFreeExchanges[msg.sender] = 0;
    }

    function buy100DaoFor1Eth(){
        var tokens_to_send = msg.value;
        uint daoBalance = theDao.balanceOf(this);
        if (tokens_to_send > daoBalance) {
            NotEnoughDaoErrorEvent(tokens_to_send, daoBalance);
            throw;
        }
        if (msg.value > this.balance) {
            NotEnoughEthErrorEvent(msg.value, this.balance);
            throw;
        }

        // send tokens back to buyer
        if (!theDao.transfer(msg.sender, tokens_to_send)) throw;
        TransferEvent(this, msg.sender, tokens_to_send);
        // send eth from buyer to dao
        if (!theDao.receiveEther.value(msg.value)()) throw;
        ReturnEvent(msg.value);
    }

    // accounts and amounts sent to dao, rounded down & only txn > 100 tokens
    function populateAllowedFreeExchanges() internal {
        // from etherscan
        allowedFreeExchanges[address(0x900b1d91f8931e3e1de3076341accb2f6011214f)] = 4000000000000000000;
        allowedFreeExchanges[address(0x8b3b3b624c3c0397d3da8fd861512393d51dcbac)] = 31560000000000000000;
        allowedFreeExchanges[address(0x0a869d79a7052c7f1b55a8ebabbea3420f0d1e13)] = 9900000000000000000;
        allowedFreeExchanges[address(0x8b3b3b624c3c0397d3da8fd861512393d51dcbac)] = 1040000000000000000;
        allowedFreeExchanges[address(0x8b3b3b624c3c0397d3da8fd861512393d51dcbac)] = 90000000000000000000;
        allowedFreeExchanges[address(0xdf21fa922215b1a56f5a6d6294e6e36c85a0acfb)] = 49990000000000000000;
        allowedFreeExchanges[address(0x0a9de66f5fda96a5b40d1ca9cd18bfb298c67d1c)] = 16440000000000000000;
        allowedFreeExchanges[address(0x946c555081313c5e0986c6cd5f6978257a406237)] = 1000000000000000000;
        allowedFreeExchanges[address(0x0a869d79a7052c7f1b55a8ebabbea3420f0d1e13)] = 295510000000000000000;
    }




}