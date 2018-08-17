pragma solidity ^0.4.18;

contract SimpleMultiSig {

  uint public nonce;                 // (only) mutable state
  uint public threshold;             // immutable state
  mapping (address =&gt; bool) isOwner; // immutable state
  address[] public ownersArr;        // immutable state

  function SimpleMultiSig(uint threshold_, address[] owners_) public {
    require(owners_.length &lt;= 10 &amp;&amp; threshold_ &lt;= owners_.length &amp;&amp; threshold_ != 0);

    address lastAdd = address(0); 
    for (uint i = 0; i &lt; owners_.length; i++) {
      require(owners_[i] &gt; lastAdd);
      isOwner[owners_[i]] = true;
      lastAdd = owners_[i];
    }
    ownersArr = owners_;
    threshold = threshold_;
  }

  // Note that address recovered from signatures must be strictly increasing
  function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) public {
    require(sigR.length == threshold);
    require(sigR.length == sigS.length &amp;&amp; sigR.length == sigV.length);

    // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
    bytes32 txHash = keccak256(byte(0x19), byte(0), this, destination, value, data, nonce);

    address lastAdd = address(0); // cannot have address(0) as an owner
    for (uint i = 0; i &lt; threshold; i++) {
      address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
      require(recovered &gt; lastAdd &amp;&amp; isOwner[recovered]);
      lastAdd = recovered;
    }

    // If we make it here all signatures are accounted for
    nonce = nonce + 1;
    require(executeCall(destination, value, data));
  }

  // The address.call() syntax is no longer recommended, see:
  // https://github.com/ethereum/solidity/issues/2884
  function executeCall(address to, uint256 value, bytes data) internal returns (bool success) {
    assembly {
      success := call(gas, to, value, add(data, 0x20), mload(data), 0, 0)
    }
  }

  function () payable public {}
}