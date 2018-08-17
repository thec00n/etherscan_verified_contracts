pragma solidity ^0.4.19;

/**
 * @title MyFriendships
 * @dev A contract for managing one&#39;s friendships.
 */
contract MyFriendships {
    address public me;
    uint public numberOfFriends;
    address public latestFriend;
    
    mapping(address =&gt; bool) myFriends;

    /**
    * @dev Create a contract to keep track of my friendships.
    */
    function MyFriendships() public {
        me = msg.sender;
    }
 
    /**
    * @dev Start an exciting new friendship with me.
    */
    function becomeFriendsWithMe () public {
        require(msg.sender != me); // I won&#39;t be friends with myself.
        myFriends[msg.sender] = true;
        latestFriend = msg.sender;
        numberOfFriends++;
    }
    
    /**
    * @dev Am I friends with this address?
    */
    function friendsWith (address addr) public view returns (bool) {
        return myFriends[addr];
    }
}