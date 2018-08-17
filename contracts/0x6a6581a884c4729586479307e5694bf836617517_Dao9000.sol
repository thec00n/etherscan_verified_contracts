// DAO&gt;9000 (http://dao9000.com) under CC0

contract Dao9000 {
    string message; //This is variable is first for easier interaction with outside world (offset 0x0), contains latest member message
    address[] public members;

    function Dao9000 () {
        members.push (msg.sender); //The contact owner is added as the first member
        message = &quot;Message not yet defined&quot;;
    }
    
    //These two functions are for easier external interaction via api.etherscan.io:
    function getMembers () constant returns (uint256 retVal) {
        return members.length;
    }
    
    function getMessage () constant returns (string retVal) {
        return message;
    }
    
    //This is the default function, this is called when normal transaction is made
    function () {
        //Since this is a DAO parody, we really do not let people invest more than 1.5 ETH max.
        if (msg.value &lt; 1500000000000000000 &amp;&amp; msg.value &gt; 1) {
            //RNG happens here: for the &quot;seed&quot; hash of the previous block is taken, and current timestamp is added
            uint256 randomIndex = (uint256(block.blockhash(block.number-1)) + now) % members.length;
            if (members[randomIndex].send(msg.value)) {
                if (msg.data.length &gt; 0)
                    message = string(msg.data); //If additional message is defined, we save it here
                members.push (msg.sender); //After a successful transaction, new member is added, multiple entries for same member are permitted
            } else {
                throw;
            }
        } else {
            throw;
        }
    }
}