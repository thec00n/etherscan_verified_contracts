pragma solidity ^0.4.24;

library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b &lt;= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c &gt;= a);
        return c;
    }
}

contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}

contract SmartRouletteToken
{
    function balanceOf( address who ) external view returns (uint256);
    function transfer( address to, uint256 value) returns (bool);
    function decimals()  external view returns (uint8);
}

contract SaleTokens is Ownable {
    using SafeMath for uint256;

    SmartRouletteToken tokensContract;
    bool isSale;
    uint256 minInvest;

    function SaleTokens(){
        tokensContract = SmartRouletteToken(0xdca4ea5f5c154c4feaf22a38ecafb8c71dad816d);
        isSale = true;
        minInvest = 0.01 ether;
    }

    function stopSale() onlyOwner {
        isSale = false;
        if(tokensContract.balanceOf(this) &gt; 0){
            tokensContract.transfer(msg.sender, tokensContract.balanceOf(this));
        }
        if (this.balance &gt; 0){
            msg.sender.transfer(this.balance);
        }
    }

    function withdraw() onlyOwner {
        assert(this.balance &gt; 0);
        msg.sender.transfer(this.balance);
    }

    function getPrice(uint256 value) view public returns (uint256 price){
        price = 0.00015 ether;
        if (value &gt;= 0.075 ether &amp;&amp; value &lt; 0.135 ether)
        {
            price = 0.000135 ether;
        }
        else if(value &gt;= 0.135 ether &amp;&amp; value &lt; 0.25 ether)
        {
            price = 0.00012 ether;
        }
        else if(value &gt;= 0.25 ether &amp;&amp; value &lt; 1 ether)
        {
            price = 0.00011 ether;
        }
        else if (value &gt;= 1 ether)
        {
            price = 0.0001 ether;
        }
    }

    function () payable {
        assert(isSale);
        assert(tokensContract.balanceOf(this) &gt; 0);
        assert(msg.value &gt; minInvest);

        uint256 countTokens = msg.value.mul(10**uint256(tokensContract.decimals())).div(getPrice(msg.value));
        assert(tokensContract.balanceOf(this) &gt;= countTokens);
        tokensContract.transfer(msg.sender, countTokens);
    }
}