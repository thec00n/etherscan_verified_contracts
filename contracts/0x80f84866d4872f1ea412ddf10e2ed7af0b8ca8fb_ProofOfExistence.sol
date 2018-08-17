/*
This smartcontract used to store documents text on the Ethereum blockchain
and to get the document by document&#39;s hash (sha256).

*/

contract ProofOfExistence{

    /* ---- Public variables: */
    string public created;
    address public manager; // account that adds info to this smartcontract
    uint256 public docIndex;   // record&#39;s numbers and number of records

    mapping (uint256 =&gt; Doc) public indexedDocs; // docIndex =&gt; Doc
    // to get Doc obj call ProofOfExistence.indexedDocs(docIndex);

    mapping (bytes32 =&gt; Doc) public sha256Docs; // docHash =&gt; Doc
    // to get Doc obj call ProofOfExistence.docs(docHash);
    mapping (bytes32 =&gt; Doc) public sha3Docs; // docHash =&gt; Doc
    // to get Doc obj call ProofOfExistence.docs(docHash);


    /* ---- Stored document structure: */

    struct Doc {
        uint256 docIndex; // .............................................1
        string publisher; // publisher&#39;s email............................2
        uint256 publishedOnUnixTime; // block timestamp (block.timestamp).3
        uint256 publishedInBlockNumber; // block.number...................4
        string docText; // text of the document...........................5
        bytes32 sha256Hash; // ...........................................6
        bytes32 sha3Hash; // .............................................7
    }

    /* ---- Constructor: */

    function ProofOfExistence(){
        manager = msg.sender;
        created = &quot;cryptonomica.net&quot;;
    }

    /* ---- Event:  */
    // This generates a public event on the blockchain that will notify clients.
    // In &#39;Mist&#39; SmartContract page enable &#39;Watch contract events&#39;
    event DocumentAdded(uint256 docIndex,
                        string publisher,
                        uint256 publishedOnUnixTime);


    /* ----- Main method: */

    function addDoc(
                    string _publisher,
                    string _docText) returns (bytes32) {
        // authorization
        if (msg.sender != manager){
            // throw;
            return sha3(&quot;not authorized&quot;); //
            // &lt;- is &#39;bytes32&#39; too:
            // &quot;0x8aed0440c9cacb4460ecdd12f6aff03c27cace39666d71f0946a6f3e9022a4a1&quot;
        }

        // chech if exists
        if (sha256Docs[sha256(_docText)].docIndex &gt; 0){
            // throw;
            return sha3(&quot;text already exists&quot;); //
            // &lt;- is &#39;bytes32&#39; too:
            // &quot;0xd42b321cfeadc9593d0a28c4d013aaad8e8c68fc8e0450aa419a130a53175137&quot;
        }
        // document number
        docIndex = docIndex + 1;
        // add document data:
        indexedDocs[docIndex] = Doc(docIndex,
                                    _publisher,
                                    now,
                                    block.number,
                                    _docText,
                                    sha256(_docText),
                                    sha3(_docText)
                                    );
        sha256Docs[sha256(_docText)] = indexedDocs[docIndex];
        sha3Docs[sha3(_docText)]   = indexedDocs[docIndex];
        // add event
        DocumentAdded(indexedDocs[docIndex].docIndex,
                      indexedDocs[docIndex].publisher,
                      indexedDocs[docIndex].publishedOnUnixTime
                      );
        // return sha3 of the stored document
        // (sha3 is better for in web3.js)
        return indexedDocs[docIndex].sha3Hash;
    }

    /* ---- Utilities: */

    function () {
        // This function gets executed if a
        // transaction with invalid data is sent to
        // the contract or just ether without data.
        // We revert the send so that no-one
        // accidentally loses money when using the
        // contract.
        throw;
    }

}