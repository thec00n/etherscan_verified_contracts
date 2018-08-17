// Simple smart contract that allows anyone to send ether from one address to
// another in certain branch of the blockchain only.  This contract is supposed
// to be used after hard forks to clearly separate &quot;classic&quot; ether from &quot;new&quot;
// ether.
contract BranchSender {
  // Is set to true if and only if we are currently in the &quot;right&quot; branch of
  // the blockchain, i.e. the branch this contract allows sending money in.
  bool public isRightBranch;

  // Instantiate the contract.
  //
  // @param blockNumber number of block in the &quot;right&quot; blockchain whose hash is
  //        known
  // @param blockHash known hash of the given block in the &quot;right&quot; blockchain
  function BranchSender(uint blockNumber, bytes32 blockHash) {
    if (msg.value &gt; 0) throw; // We do not accept any money here

    isRightBranch = (block.number &lt; 256 || blockNumber &gt; block.number - 256) &amp;&amp;
                    (blockNumber &lt; block.number) &amp;&amp;
                    (block.blockhash (blockNumber) == blockHash);
  }

  // Default function just throw.
  function () {
    throw;
  }

  // If we are currently in the &quot;right&quot; branch of the blockchain, send money to
  // the given recipient.  Otherwise, throw.
  //
  // @param recipient address to send money to if we are currently in the
  //                  &quot;right&quot; branch of the blockchain
  function send (address recipient) {
    if (!isRightBranch) throw;
    if (!recipient.send (msg.value)) throw;
  }
}