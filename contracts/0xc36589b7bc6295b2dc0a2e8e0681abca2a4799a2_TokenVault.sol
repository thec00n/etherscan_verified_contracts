pragma solidity 0.4.24;

// accepted from zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity
/*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
    uint public totalSupply;
    function balanceOf(address who) constant returns (uint);
    function allowance(address owner, address spender) constant returns (uint);

    function transfer(address to, uint value) returns (bool ok);
    function transferFrom(address from, address to, uint value) returns (bool ok);
    function approve(address spender, uint value) returns (bool ok);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract TokenVault {

    ERC20 public decentBetToken;
    address public decentBetMultisig;

    // October 21st, 00:00 GMT
    uint256 public unlockedAtTime = 1540080000;

    /// @notice Constructor function sets the DecentBet Multisig and token address
    constructor (
        address _decentBetMultisig,
        address _decentBetToken
    ) {
        require(_decentBetMultisig != 0);
        require(_decentBetToken != 0);
        decentBetMultisig = _decentBetMultisig;
        decentBetToken = ERC20(_decentBetToken);
    }

    /// @notice Transfer locked tokens to Decent.bet's multisig wallet
    function unlock() external {
        require(block.timestamp >= unlockedAtTime);
        require(
            decentBetToken.transfer(
                decentBetMultisig,
                decentBetToken.balanceOf(address(this))
            )
        );
    }

}