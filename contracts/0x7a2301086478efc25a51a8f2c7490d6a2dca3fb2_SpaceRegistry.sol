pragma solidity ^0.4.15;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of &quot;user permissions&quot;.
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
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
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

/**
 * @title Stoppable
 * @dev Base contract which allows children to implement a permanent stop mechanism.
 */
contract Stoppable is Ownable {
  event Stop();  

  bool public stopped = false;

  /**
   * @dev Modifier to make a function callable only when the contract is not stopped.
   */
  modifier whenNotStopped() {
    require(!stopped);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is stopped.
   */
  modifier whenStopped() {
    require(stopped);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function stop() onlyOwner whenNotStopped public {
    stopped = true;
    Stop();
  }
}

contract SpaceRegistry is Stoppable {
    
    event Add();
    uint constant START_INDEX = 1;
    Space[] spaces;
    mapping(uint =&gt; uint) spaceMap;
    mapping(uint =&gt; uint[]) userSpaceLookup;
    
    struct Space {
        uint id;
        uint userId;
        bytes userHash;
        uint bottomLeft;
        uint topLeft;
        uint topRight;
        uint bottomRight;
        string txType;
        string txId;
        uint txTime;
        uint created;
    }

    function SpaceRegistry() {
        spaces.length = START_INDEX;
    }

    function addSpace(
        uint id, uint userId, bytes userHash, uint bottomLeft, uint topLeft, 
        uint topRight, uint bottomRight, string txType, string txId, uint txTime) 
        onlyOwner whenNotStopped {

        require(id &gt; 0);
        require(spaceMap[id] == 0);
        require(userId &gt; 0);
        require(userHash.length &gt; 0);
        require(bottomLeft &gt; 0);
        require(topLeft &gt; 0);
        require(topRight &gt; 0);
        require(bottomRight &gt; 0);
        require(bytes(txType).length &gt; 0);
        require(bytes(txId).length &gt; 0);
        require(txTime &gt; 0);
        
        var space = Space({
            id: id,
            userId: userId,
            userHash: userHash,
            bottomLeft: bottomLeft,
            topLeft: topLeft,
            topRight: topRight,
            bottomRight: bottomRight,
            txType: txType,
            txId: txId,
            txTime: txTime,
            created: block.timestamp
        });

        var _index = spaces.push(space) - 1;
        assert(_index &gt;= START_INDEX);
        spaceMap[id] = _index;
        userSpaceLookup[userId].push(id);
        Add();
    }

    function getSpaceByIndex(uint index) external constant returns(
        uint id,
        uint userId,
        bytes userHash,
        uint bottomLeft,
        uint topLeft,
        uint topRight, 
        uint bottomRight,
        string txType,
        string txId, 
        uint txTime,
        uint created) {

        var _index = index + START_INDEX;
        require(spaces.length &gt; _index);
        var space = spaces[_index];
        id = space.id;
        userId = space.userId;
        userHash = space.userHash;
        bottomLeft = space.bottomLeft;
        topLeft = space.topLeft;
        topRight = space.topRight;
        bottomRight = space.bottomRight;
        txType = space.txType;
        txId = space.txId;
        txTime = space.txTime;
        created = space.created;
    }    

    function getSpaceById(uint _id) external constant returns(
        uint id,
        uint userId,
        bytes userHash,
        uint bottomLeft,
        uint topLeft,
        uint topRight, 
        uint bottomRight,
        string txType,
        string txId,
        uint txTime,
        uint created) {

        require(_id &gt; 0);
        id = _id;
        var index = spaceMap[id];
        var space = spaces[index];
        userId = space.userId;
        userHash = space.userHash;
        bottomLeft = space.bottomLeft;
        topLeft = space.topLeft;
        topRight = space.topRight;
        bottomRight = space.bottomRight;
        txType = space.txType;
        txId = space.txId;
        txTime = space.txTime;
        created = space.created;
    }

    function getUserSpaceIds(uint userId) external constant returns(uint[]) {
        require(userId &gt; 0);
        return userSpaceLookup[userId]; 
    }

    function getUserId(uint id) external constant returns(uint) {
        require(id &gt; 0);
        var index = spaceMap[id];
        require(index &gt; 0);
        var space = spaces[index];
        return space.userId; 
    }

    function exists(uint id) external constant returns(bool) {
        require(id &gt; 0);
        return spaceMap[id] != 0;
    }
    
    function spaceCount() constant returns (uint) {
        return spaces.length - START_INDEX;
    }   
}