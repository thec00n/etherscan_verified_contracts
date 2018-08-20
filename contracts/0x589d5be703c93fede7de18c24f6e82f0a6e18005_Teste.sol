pragma solidity ^0.4.16;

contract Teste 
{
    uint creationDate;
    
    function Teste() public 
    {
        creationDate = now;
    }
    
    function today() view public returns (uint)
    {
       return ( now / 1 days);
    }
    
    function pastFiveMinutes() view public returns (bool)
    {
        return (now >= creationDate + 5 * 1 minutes);
    }

    function pastTenMinutes() view public returns (bool)
    {
        return (now >= creationDate + 10 * 1 minutes);
    }

    function pastOneHour() view public returns (bool)
    {
        return (now >= creationDate + 1 * 1 hours);
    }
    
    function pastOneDay() view public returns (bool)
    {
        return (now >= creationDate + 1 * 1 days);
    }

}