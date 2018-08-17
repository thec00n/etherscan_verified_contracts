/*************************************************************************
 * This contract has been merged with solidify
 * https://github.com/tiesnetwork/solidify
 *************************************************************************/
 
 pragma solidity ^0.4.10;

/*************************************************************************
 * import &quot;./FloorInvestRestrictions.sol&quot; : start
 *************************************************************************/

/*************************************************************************
 * import &quot;./IInvestRestrictions.sol&quot; : start
 *************************************************************************/

/*************************************************************************
 * import &quot;../common/Manageable.sol&quot; : start
 *************************************************************************/

/*************************************************************************
 * import &quot;../common/Owned.sol&quot; : start
 *************************************************************************/


contract Owned {
    address public owner;        

    function Owned() {
        owner = msg.sender;
    }

    // allows execution by the owner only
    modifier ownerOnly {
        assert(msg.sender == owner);
        _;
    }

    /**@dev allows transferring the contract ownership. */
    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner);
        owner = _newOwner;
    }
}
/*************************************************************************
 * import &quot;../common/Owned.sol&quot; : end
 *************************************************************************/

///A token that have an owner and a list of managers that can perform some operations
///Owner is always a manager too
contract Manageable is Owned {

    event ManagerSet(address manager, bool state);

    mapping (address =&gt; bool) public managers;

    function Manageable() Owned() {
        managers[owner] = true;
    }

    /**@dev Allows execution by managers only */
    modifier managerOnly {
        assert(managers[msg.sender]);
        _;
    }

    function transferOwnership(address _newOwner) public ownerOnly {
        super.transferOwnership(_newOwner);

        managers[_newOwner] = true;
        managers[msg.sender] = false;
    }

    function setManager(address manager, bool state) ownerOnly {
        managers[manager] = state;
        ManagerSet(manager, state);
    }
}/*************************************************************************
 * import &quot;../common/Manageable.sol&quot; : end
 *************************************************************************/

/** @dev Restrictions on investment */
contract IInvestRestrictions is Manageable {
    /**@dev Returns true if investmet is allowed */
    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
        investor; amount; result; tokensLeft;
    }

    /**@dev Called when investment was made */
    function investHappened(address investor, uint amount) managerOnly {}    
}/*************************************************************************
 * import &quot;./IInvestRestrictions.sol&quot; : end
 *************************************************************************/

/**@dev Allows only investments with large enough amount only  */
contract FloorInvestRestrictions is IInvestRestrictions {

    /**@dev The smallest acceptible ether amount */
    uint256 public floor;

    /**@dev True if address already invested */
    mapping (address =&gt; bool) public investors;


    function FloorInvestRestrictions(uint256 _floor) {
        floor = _floor;
    }

    /**@dev IInvestRestrictions implementation */
    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
        
        //allow investment if it isn&#39;t the first one 
        if (investors[investor]) {
            result = true;
        } else {
            //otherwise check the floor
            result = (amount &gt;= floor);
        }
    }

    /**@dev IInvestRestrictions implementation */
    function investHappened(address investor, uint amount) managerOnly {
        investors[investor] = true;
    }

    /**@dev Changes investment low cap */
    function changeFloor(uint256 newFloor) managerOnly {
        floor = newFloor;
    }
}/*************************************************************************
 * import &quot;./FloorInvestRestrictions.sol&quot; : end
 *************************************************************************/
/*************************************************************************
 * import &quot;./ICrowdsaleFormula.sol&quot; : start
 *************************************************************************/

/**@dev Abstraction of crowdsale token calculation function */
contract ICrowdsaleFormula {

    /**@dev Returns amount of tokens that can be bought with given weiAmount */
    function howManyTokensForEther(uint256 weiAmount) constant returns(uint256 tokens, uint256 excess) {
        weiAmount; tokens; excess;
    }

    /**@dev Returns how many tokens left for sale */
    function tokensLeft() constant returns(uint256 _left) { _left;}    
}/*************************************************************************
 * import &quot;./ICrowdsaleFormula.sol&quot; : end
 *************************************************************************/

/**@dev In addition to &#39;floor&#39; behavior restricts investments if there are already too many investors. 
Contract owner can reserve some places for future investments:
1. It is possible to reserve a place for unknown address using &#39;reserve&#39; function. 
    When invest happens you should &#39;unreserve&#39; that place manually
2. It is also possible to reserve a certain address using &#39;reserveFor&#39;. 
    When such investor invests, the place becomes unreserved  */
contract ParticipantInvestRestrictions is FloorInvestRestrictions {

    struct ReservedInvestor {
        bool reserved;        
        uint256 tokens;
    }

    event ReserveKnown(bool state, address investor, uint256 weiAmount, uint256 tokens);
    event ReserveUnknown(bool state, uint32 index, uint256 weiAmount, uint256 tokens);

    /**@dev Array of unknown investors */
    ReservedInvestor[] public unknownInvestors;

    /**@dev Formula to calculate amount of tokens to buy*/
    ICrowdsaleFormula public formula;

    /**@dev Maximum number of allowed investors */
    uint32 public maxInvestors;    

    /**@dev Current number of investors */
    uint32 public investorsCount;

    /**@dev Current number of known reserved investors */
    uint32 public knownReserved;

    /**@dev Current number of unknown reserved investors */
    uint32 public unknownReserved;

    /**@dev If address is reserved, shows how much tokens reserved for him */
    mapping (address =&gt; uint256) public reservedInvestors;

    /**@dev How much tokens reserved */
    uint256 public tokensReserved;

    function ParticipantInvestRestrictions(uint256 _floor, uint32 _maxTotalInvestors)
        FloorInvestRestrictions(_floor)
    {
        maxInvestors = _maxTotalInvestors;
    }

    /**@dev Sets formula */
    function setFormula(ICrowdsaleFormula _formula) managerOnly {
        formula = _formula;        
    }

    /**@dev Returns true if there are still free places for investors */
    function hasFreePlaces() constant returns (bool) {
        return getInvestorCount() &lt; maxInvestors;
    }

    /**@dev Returns number of investors, including reserved */
    function getInvestorCount() constant returns(uint32) {
        return investorsCount + knownReserved + unknownReserved;
    }

    /**@dev IInvestRestrictions override */
    function canInvest(address investor, uint amount, uint tokensLeft) constant returns (bool result) {
        //First check ancestor&#39;s restriction. 
        //Allow only if it is reserved investor or it invested earlier or there is still room for new investors
        if (super.canInvest(investor, amount, tokensLeft)) {
            if (reservedInvestors[investor] &gt; 0) {
                return true;
            } else {
                var (tokens, excess) = formula.howManyTokensForEther(amount);
                if (tokensLeft &gt;= tokensReserved + tokens) {
                    return investors[investor] || hasFreePlaces();
                }
            }
        }

        return false;
    }
 
    /**@dev IInvestRestrictions override */
    function investHappened(address investor, uint amount) managerOnly {
        if (!investors[investor]) {
            investors[investor] = true;
            investorsCount++;
            
            //if that investor was already reserved, unreserve the place
            if (reservedInvestors[investor] &gt; 0) {
                unreserveFor(investor);
            }
        }
    }

    /**@dev Reserves a place for investor */
    function reserveFor(address investor, uint256 weiAmount) managerOnly {
        require(!investors[investor] &amp;&amp; hasFreePlaces());

        if(reservedInvestors[investor] == 0) {
            knownReserved++;
        }

        reservedInvestors[investor] += reserveTokens(weiAmount);
        ReserveKnown(true, investor, weiAmount, reservedInvestors[investor]);
    }

    /**@dev Unreserves special address. For example if investor haven&#39;t sent ether */
    function unreserveFor(address investor) managerOnly {
        require(reservedInvestors[investor] != 0);

        knownReserved--;
        unreserveTokens(reservedInvestors[investor]);
        reservedInvestors[investor] = 0;

        ReserveKnown(false, investor, 0, 0);
    }

    /**@dev Reserves place for unknown address */
    function reserve(uint256 weiAmount) managerOnly {
        require(hasFreePlaces());
        unknownReserved++;
        uint32 id = uint32(unknownInvestors.length++);
        unknownInvestors[id].reserved = true;        
        unknownInvestors[id].tokens = reserveTokens(weiAmount);

        ReserveUnknown(true, id, weiAmount, unknownInvestors[id].tokens);
    }

    /**@dev Unreserves place for unknown address specified by an index in array */
    function unreserve(uint32 index) managerOnly {
        require(index &lt; unknownInvestors.length &amp;&amp; unknownInvestors[index].reserved);
        
        assert(unknownReserved &gt; 0);
        unknownReserved--;
        unreserveTokens(unknownInvestors[index].tokens);        
        unknownInvestors[index].reserved = false;

        ReserveUnknown(false, index, 0, 0);
    }

    /**@dev Reserved tokens for given amount of ether, returns reserved amount */
    function reserveTokens(uint256 weiAmount) 
        internal 
        managerOnly 
        returns(uint256) 
    {
        uint256 tokens;
        uint256 excess;
        (tokens, excess) = formula.howManyTokensForEther(weiAmount);
        
        if (tokensReserved + tokens &gt; formula.tokensLeft()) {
            tokens = formula.tokensLeft() - tokensReserved;
        }
        tokensReserved += tokens;

        return tokens;
    }

    /**@dev Unreserves specified amount of tokens */
    function unreserveTokens(uint256 tokenAmount) 
        internal 
        managerOnly 
    {
        if (tokenAmount &gt; tokensReserved) {
            tokensReserved = 0;
        } else {
            tokensReserved = tokensReserved - tokenAmount;
        }
    }
}