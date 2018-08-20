pragma solidity ^0.4.18;

contract calculator{
    
    uint number;
    uint multiply;
    uint divide;
    uint plus;
    uint subtract;
    
    function Integer(uint theNumber){
        number = theNumber;
    }
    
    function Multiplier(uint multiplyAmount){
        multiply = multiplyAmount;
        number = number * multiplyAmount;
    }
    
    function Divider(uint divideAmount){
        divide = divideAmount;
        number = number / divideAmount;
    }
    
    function AddAmount(uint addAmount){
        plus = addAmount;
        number = number + addAmount;
    }
    
    function SubtractAmount(uint subtractAmount){
        subtract = subtractAmount;
        number = number - subtractAmount;
    }
    
    function getAnswer() constant returns (uint){
        return number; 
    }
}