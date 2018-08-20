pragma solidity ^0.4.16;

contract Teste 
{
    uint creationDate;
    
    function Teste() public 
    {
        creationDate = now;
    }
    
   function segundos() view public returns (uint)
   {
       return (now / 1 seconds) - (creationDate / 1 seconds);
   }
   
   function minutos() view public returns (uint)
   {
       return (now / 1 minutes) - (creationDate / 1 minutes);
   }
   
   function horas() view public returns (uint)
   {
       return (now / 1 hours) - (creationDate / 1 hours);
   }
   
   function dias() view public returns (uint)
   {
       return today() - (creationDate / 1 days);
   }
   
   function today() view public returns (uint)
   {
       return now / 1 days;
   }
   
}