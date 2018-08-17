pragma solidity ^0.4.11;

contract PiggyBank
{
    address creator;
    uint deposits;
    uint unlockTime;

    /* Constructor */
    function PiggyBank() public
    {
        creator = msg.sender;
        deposits = 0;
        unlockTime = now + 5 minutes;
    }

    function() payable
    {
        deposit();
    }

    function deposit() payable returns (uint)
    {
        if( msg.value &gt; 0 )
            deposits = deposits + 1;

        return getNumberOfDeposits();
    }

    function getNumberOfDeposits() constant returns (uint)
    {
        return deposits;
    }

    function getUnlockTime() constant returns (uint)
    {
        return unlockTime;
    }

    function kill()
    {
        if( msg.sender == creator &amp;&amp; now &gt;= unlockTime )
            selfdestruct(creator);
    }
}