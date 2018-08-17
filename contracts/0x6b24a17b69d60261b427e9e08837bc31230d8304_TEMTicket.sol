pragma solidity ^0.4.18;


contract TEMTicket {
    uint256 constant public FEE = 0.015 ether;

    mapping (uint256 =&gt; address) public id2Addr;
    mapping (address =&gt; uint256) public userId;
    address public TEMWallet;
    uint256 public userAmount;
    uint256 public maxAttendees;
    uint256 public startTime;

    function TEMTicket(address _TEMWallet, uint256 _maxAttendees, uint256 _startTime) public {
        TEMWallet = _TEMWallet;
        maxAttendees = _maxAttendees;
        userAmount = 0;
        startTime = _startTime;
    }

    function () payable external {
        getTicket(msg.sender);
    }

    function getTicket (address _attendee) payable public {
        require(now &gt;= startTime &amp;&amp; msg.value &gt;= FEE &amp;&amp; userId[_attendee] == 0);
        userAmount ++;
        require(userAmount &lt;= maxAttendees);
        userId[_attendee] = userAmount;
        id2Addr[userAmount] = _attendee;
    }

    function withdraw () public {
        TEMWallet.transfer(this.balance);
    }
}