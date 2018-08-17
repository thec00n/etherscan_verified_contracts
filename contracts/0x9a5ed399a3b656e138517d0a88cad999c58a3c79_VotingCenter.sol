pragma solidity ^0.4.13;

contract DependentOnIPFS {
  /**
   * @dev Validate a multihash bytes value
   */
  function isValidIPFSMultihash(bytes _multihashBytes) internal pure returns (bool) {
    require(_multihashBytes.length &gt; 2);

    uint8 _size;

    // There isn&#39;t another way to extract only this byte into a uint8
    // solhint-disable no-inline-assembly
    assembly {
      // Seek forward 33 bytes beyond the solidity length value and the hash function byte
      _size := byte(0, mload(add(_multihashBytes, 33)))
    }

    return (_multihashBytes.length == _size + 2);
  }
}

contract Poll is DependentOnIPFS {
  // There isn&#39;t a way around using time to determine when votes can be cast
  // solhint-disable not-rely-on-time

  bytes public pollDataMultihash;
  uint16 public numChoices;
  uint256 public startTime;
  uint256 public endTime;
  address public author;

  mapping(address =&gt; uint16) public votes;

  event VoteCast(address indexed voter, uint16 indexed choice);

  function Poll(
    bytes _ipfsHash,
    uint16 _numChoices,
    uint256 _startTime,
    uint256 _endTime,
    address _author
  ) public {
    require(_startTime &gt;= now &amp;&amp; _endTime &gt; _startTime);
    require(isValidIPFSMultihash(_ipfsHash));

    numChoices = _numChoices;
    startTime = _startTime;
    endTime = _endTime;
    pollDataMultihash = _ipfsHash;
    author = _author;
  }

  /**
   * @dev Cast or change your vote
   * @param _choice The index of the option in the corresponding IPFS document.
   */
  function vote(uint16 _choice) public duringPoll {
    // Choices are indexed from 1 since the mapping returns 0 for &quot;no vote cast&quot;
    require(_choice &lt;= numChoices &amp;&amp; _choice &gt; 0);

    votes[msg.sender] = _choice;
    VoteCast(msg.sender, _choice);
  }

  modifier duringPoll {
    require(now &gt;= startTime &amp;&amp; now &lt;= endTime);
    _;
  }
}

contract VotingCenter {
  Poll[] public polls;

  event PollCreated(address indexed poll, address indexed author);

  /**
   * @dev create a poll and store the address of the poll in this contract
   * @param _ipfsHash Multihash for IPFS file containing poll information
   * @param _numOptions Number of choices in this poll
   * @param _startTime Time after which a user can cast a vote in the poll
   * @param _endTime Time after which the poll no longer accepts new votes
   * @return The address of the new Poll
   */
  function createPoll(
    bytes _ipfsHash,
    uint16 _numOptions,
    uint256 _startTime,
    uint256 _endTime
  ) public returns (address) {
    Poll newPoll = new Poll(_ipfsHash, _numOptions, _startTime, _endTime, msg.sender);
    polls.push(newPoll);

    PollCreated(address(newPoll), msg.sender);

    return address(newPoll);
  }

  function allPolls() view public returns (Poll[]) {
    return polls;
  }

  function numPolls() view public returns (uint256) {
    return polls.length;
  }
}