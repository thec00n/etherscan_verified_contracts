pragma solidity ^0.4.13;

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

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

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address =&gt; uint256) balances;

  uint256 totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

}

contract StandardToken is ERC20, BasicToken {

  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value &lt;= balances[_from]);
    require(_value &lt;= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender&#39;s allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue &gt; oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract Fysical is StandardToken {
    using SafeMath for uint256;

    // To increase consistency and reduce the opportunity for human error, the &#39;*sById&#39; mappings, &#39;*Count&#39; values,
    // &#39;get*ById&#39; function declarations/implementations, and &#39;create*&#39; function declarations/implementations have been
    // programmatically-generated based on the each struct&#39;s name, member types/names, and the comments sharing a line
    // with a member.
    //
    // This programmatic generation builds &#39;require&#39; function calls based on the following rules:
    //      - &#39;string&#39; values must have length &gt; 0
    //      - &#39;bytes&#39; and uint256[] values may have any length
    //      - &#39;uint256&#39; values representing a quantity must be &gt; 0 (identifiers and Ethereum block numbers do not represent a quantity)
    //
    // The implementation of &#39;createProposal&#39; contains one operation not found in the other programmatically-generated
    // &#39;create*&#39; functions, a call to &#39;transferTokensToEscrow&#39;.
    //
    // None of the other members or functions have been programmatically generated.

    // See https://en.wikipedia.org/wiki/Uniform_Resource_Identifier.
    // The risk of preventing support for a future addition to the URI syntax outweighs the benefit of validating URI
    // values within this immutable smart contract, so readers of Uri values should expect values that do not conform
    // to the formal syntax of a URI.
    struct Uri {
        string value;
    }

    // A set of URIs may describe multiple methods to access a particular resource.
    struct UriSet {
        uint256[] uniqueUriIdsSortedAscending;    // each value must be key in &#39;urisById&#39;
    }

    // See https://en.wikipedia.org/wiki/Checksum#Algorithms. The description of the algorithm referred to by each URI
    // in the set should give a reader enough information to interpret the &#39;value&#39; member of a &#39;Checksum&#39; object
    // referring to this algorithm object.
    struct ChecksumAlgorithm {
        uint256 descriptionUriSetId;    // must be key in &#39;uriSetsById&#39;
    }

    // See https://en.wikipedia.org/wiki/Checksum. The &#39;resourceByteCount&#39; indicates the number of bytes contained in
    // the resource. Though this is not strictly part of most common Checksum algorithms, its validation may also be
    // useful. The &#39;value&#39; field should contain the expected output of passing the resource content to the checksum
    // algorithm.
    struct Checksum {
        uint256 algorithmId; // must be key in &#39;checksumAlgorithmsById&#39;
        uint256 resourceByteCount;
        bytes value;
    }

    // See https://en.wikipedia.org/wiki/Encryption. The description of the algorithm referred to by each URI
    // in the set should give a reader enough information to access the content of an encrypted resource. The algorithm
    // may be a symmetric encryption algorithm or an asymmetric encryption algorithm
    struct EncryptionAlgorithm {
        uint256 descriptionUriSetId;    // must be key in &#39;uriSetsById&#39;
    }

    // For each resource, an Ethereum account may describe a checksum for the encrypted content of a resource and a
    // checksum for the decrypted content of a resource. When the resource is encrypted with a null encryption
    // algorithm, the resource is effectively unencrypted, so these two checksums should be identical
    // (See https://en.wikipedia.org/wiki/Null_encryption).
    struct ChecksumPair {
        uint256 encryptedChecksumId; // must be key in &#39;checksumsById&#39;
        uint256 decryptedChecksumId; // must be key in &#39;checksumsById&#39;
    }

    // A &#39;Resource&#39; is content accessible with each URI referenced in the &#39;uriSetId&#39;. This content should be
    // encrypted with the algorithm described by the &#39;EncryptionAlgorithm&#39; referenced in &#39;encryptionAlgorithmId&#39;. Each
    // resource referenced in &#39;metaResourceSetId&#39; should describe the decrypted content in some way.
    //
    // For example, if the decrypted content conforms to a Protocol Buffers schema, the corresponding proto definition
    // file should be included in the meta-resources. Likewise, that proto definition resource should refer to a
    // resource like https://en.wikipedia.org/wiki/Protocol_Buffers among its meta-resources.
    struct Resource {
        uint256 uriSetId;                // must be key in &#39;uriSetsById&#39;
        uint256 encryptionAlgorithmId;   // must be key in &#39;encryptionAlgorithmsById&#39;
        uint256 metaResourceSetId;       // must be key in &#39;resourceSetsById&#39;
    }

    // See https://en.wikipedia.org/wiki/Public-key_cryptography. This value should be the public key used in an
    // asymmetric encryption operation. It should be useful for encrypting an resource destined for the holder of the
    // corresponding private key or for decrypting a resource encrypted with the corresponding private key.
    struct PublicKey {
        bytes value;
    }

    // A &#39;ResourceSet&#39; groups together resources that may be part of a trade proposal involving Fysical tokens. The
    // creator of a &#39;ResourceSet&#39; must include a public key for use in the encryption operations of creating and
    // accepting a trade proposal. The creator must also specify the encryption algorithm a proposal creator should
    // use along with this resource set creator&#39;s public key. Just as a single resource may have meta-resources
    // describing the content of a resource, a &#39;ResourceSet&#39; may have resources describing the whole resource set.
    //
    // Creators should be careful to not include so many resources that an Ethereum transaction to accept a proposal
    // might run out of gas while storing the corresponding encrypted decryption keys.
    //
    // While developing reasonable filters for un-useful data in this collection, developers should choose a practical
    // maximum depth of traversal through the meta-resources, since an infinite loop is possible.
    struct ResourceSet {
        address creator;
        uint256 creatorPublicKeyId;                     // must be key in &#39;publicKeysById&#39;
        uint256 proposalEncryptionAlgorithmId;          // must be key in &#39;encryptionAlgorithmsById&#39;
        uint256[] uniqueResourceIdsSortedAscending;     // each value must be key in &#39;resourcesById&#39;
        uint256 metaResourceSetId;                      // must be key in &#39;resourceSetsById&#39;
    }

    // The creator of a trade proposal may include arbitrary content to be considered part of the agreement the
    // resource set is accepting. This may be useful for license agreements to be enforced within a jurisdiction
    // governing the trade partners. The content available through each URI in the set should be encrypted first with
    // the public key of a resource set&#39;s creator and then with the private key of a proposal&#39;s creator.
    struct Agreement {
        uint256 uriSetId;           // must be key in &#39;uriSetsById&#39;
        uint256 checksumPairId;     // must be key in &#39;checksumPairsById&#39;
    }

    // Many agreements may be grouped together in an &#39;AgreementSet&#39;
    struct AgreementSet {
        uint256[] uniqueAgreementIdsSortedAscending; // each value must be key in &#39;agreementsById&#39;
    }

    // A &#39;TokenTransfer&#39; describes a transfer of tokens to occur between two Ethereum accounts.
    struct TokenTransfer {
        address source;
        address destination;
        uint256 tokenCount;
    }

    // Many token transfers may be grouped together in a &quot;TokenTransferSet&#39;
    struct TokenTransferSet {
        uint256[] uniqueTokenTransferIdsSortedAscending; // each value must be key in &#39;tokenTransfersById&#39;
    }

    // A &#39;Proposal&#39; describes the conditions for the atomic exchange of Fysical tokens and a keys to decrypt resources
    // in a resource set. The creator must specify the asymmetric encryption algorithm for use when accepting the
    // proposal, along with this creator&#39;s public key. The creator may specify arbitrary agreements that should be
    // considered a condition of the trade.
    //
    // During the execution of &#39;createProposal&#39;, the count of tokens specified in each token transfer will be transfered
    // from the specified source account to the account with the Ethereum address of 0. When the proposal state changes
    // to a final state, these tokens will be returned to the source accounts or tranfserred to the destination account.
    //
    // By including a &#39;minimumBlockNumberForWithdrawal&#39; value later than the current Ethereum block, the proposal
    // creator can give the resource set creator a rough sense of how long the proposal will remain certainly
    // acceptable. This is particularly useful because the execution of an Ethereum transaction to accept a proposal
    // exposes the encrypted decryption keys to the Ethereum network regardless of whether the transaction succeeds.
    // Within the time frame that a proposal acceptance transaction will certainly succeed, the resource creator need
    // not be concerned with the possibility that an acceptance transaction might execute after a proposal withdrawal
    // submitted to the Ethereum network at approximately the same time.
    struct Proposal {
        uint256 minimumBlockNumberForWithdrawal;
        address creator;
        uint256 creatorPublicKeyId;                 // must be key in &#39;publicKeysById&#39;
        uint256 acceptanceEncryptionAlgorithmId;    // must be key in &#39;encryptionAlgorithmsById&#39;
        uint256 resourceSetId;                      // must be key in &#39;resourceSetsById&#39;
        uint256 agreementSetId;                     // must be key in &#39;agreementSetsById&#39;
        uint256 tokenTransferSetId;                 // must be key in &#39;tokenTransferSetsById&#39;
    }

    // When created, the proposal is in the &#39;Pending&#39; state. All other states are final states, so a proposal may change
    // state exactly one time based on a call to &#39;withdrawProposal&#39;, &#39;acceptProposal&#39;, or &#39;rejectProposal&#39;.
    enum ProposalState {
        Pending,
        WithdrawnByCreator,
        RejectedByResourceSetCreator,
        AcceptedByResourceSetCreator
    }

    // solium would warn &quot;Constant name &#39;name&#39; doesn&#39;t follow the UPPER_CASE notation&quot;, but this public constant is
    // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we&#39;ll disable warnings for the line.
    //
    /* solium-disable-next-line */
    string public constant name = &quot;Fysical&quot;;

    // solium would warn &quot;Constant name &#39;symbol&#39; doesn&#39;t follow the UPPER_CASE notation&quot;, but this public constant is
    // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we&#39;ll disable warnings for the line.
    //
    /* solium-disable-next-line */
    string public constant symbol = &quot;FYS&quot;;

    // solium would warn &quot;Constant name &#39;decimals&#39; doesn&#39;t follow the UPPER_CASE notation&quot;, but this public constant is
    // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we&#39;ll disable warnings for the line.
    //
    /* solium-disable-next-line */
    uint8 public constant decimals = 9;

    uint256 public constant ONE_BILLION = 1000000000;
    uint256 public constant ONE_QUINTILLION = 1000000000000000000;

    // See https://en.wikipedia.org/wiki/9,223,372,036,854,775,807
    uint256 public constant MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE = 9223372036854775807;

    uint256 public constant EMPTY_PUBLIC_KEY_ID = 0;
    uint256 public constant NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID = 0;
    uint256 public constant NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID = 0;
    uint256 public constant NULL_ENCRYPTION_ALGORITHM_ID = 0;
    uint256 public constant EMPTY_RESOURCE_SET_ID = 0;

    mapping(uint256 =&gt; Uri) internal urisById;
    uint256 internal uriCount = 0;

    mapping(uint256 =&gt; UriSet) internal uriSetsById;
    uint256 internal uriSetCount = 0;

    mapping(uint256 =&gt; ChecksumAlgorithm) internal checksumAlgorithmsById;
    uint256 internal checksumAlgorithmCount = 0;

    mapping(uint256 =&gt; Checksum) internal checksumsById;
    uint256 internal checksumCount = 0;

    mapping(uint256 =&gt; EncryptionAlgorithm) internal encryptionAlgorithmsById;
    uint256 internal encryptionAlgorithmCount = 0;

    mapping(uint256 =&gt; ChecksumPair) internal checksumPairsById;
    uint256 internal checksumPairCount = 0;

    mapping(uint256 =&gt; Resource) internal resourcesById;
    uint256 internal resourceCount = 0;

    mapping(uint256 =&gt; PublicKey) internal publicKeysById;
    uint256 internal publicKeyCount = 0;

    mapping(uint256 =&gt; ResourceSet) internal resourceSetsById;
    uint256 internal resourceSetCount = 0;

    mapping(uint256 =&gt; Agreement) internal agreementsById;
    uint256 internal agreementCount = 0;

    mapping(uint256 =&gt; AgreementSet) internal agreementSetsById;
    uint256 internal agreementSetCount = 0;

    mapping(uint256 =&gt; TokenTransfer) internal tokenTransfersById;
    uint256 internal tokenTransferCount = 0;

    mapping(uint256 =&gt; TokenTransferSet) internal tokenTransferSetsById;
    uint256 internal tokenTransferSetCount = 0;

    mapping(uint256 =&gt; Proposal) internal proposalsById;
    uint256 internal proposalCount = 0;

    mapping(uint256 =&gt; ProposalState) internal statesByProposalId;

    mapping(uint256 =&gt; mapping(uint256 =&gt; bytes)) internal encryptedDecryptionKeysByProposalIdAndResourceId;

    mapping(address =&gt; mapping(uint256 =&gt; bool)) internal checksumPairAssignmentsByCreatorAndResourceId;

    mapping(address =&gt; mapping(uint256 =&gt; uint256)) internal checksumPairIdsByCreatorAndResourceId;

    function Fysical() public {
        assert(ProposalState(0) == ProposalState.Pending);

        // The total number of Fysical tokens is intended to be one billion, with the ability to express values with
        // nine decimals places of precision. The token values passed in ERC20 functions and operations involving
        // TokenTransfer operations must be counts of nano-Fysical tokens (one billionth of one Fysical token).
        //
        // See the initialization of the total supply in https://theethereum.wiki/w/index.php/ERC20_Token_Standard.

        assert(0 &lt; ONE_BILLION);
        assert(0 &lt; ONE_QUINTILLION);
        assert(MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE &gt; ONE_BILLION);
        assert(MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE &gt; ONE_QUINTILLION);
        assert(ONE_BILLION == uint256(10)**decimals);
        assert(ONE_QUINTILLION == ONE_BILLION.mul(ONE_BILLION));

        totalSupply_ = ONE_QUINTILLION;

        balances[msg.sender] = totalSupply_;

        // From &quot;https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1&quot; on 2018-02-08 (commit cea1db05a3444870132ec3cb7dd78a244cba1805):
        //  &quot;A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created.&quot;
        Transfer(0x0, msg.sender, balances[msg.sender]);

        // This mimics the behavior of the &#39;createPublicKey&#39; external function.
        assert(EMPTY_PUBLIC_KEY_ID == publicKeyCount);
        publicKeysById[EMPTY_PUBLIC_KEY_ID] = PublicKey(new bytes(0));
        publicKeyCount = publicKeyCount.add(1);
        assert(1 == publicKeyCount);

        // This mimics the behavior of the &#39;createUri&#39; external function.
        assert(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID == uriCount);
        urisById[NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID] = Uri(&quot;https://en.wikipedia.org/wiki/Null_encryption&quot;);
        uriCount = uriCount.add(1);
        assert(1 == uriCount);

        // This mimics the behavior of the &#39;createUriSet&#39; external function.
        assert(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID == uriSetCount);
        uint256[] memory uniqueIdsSortedAscending = new uint256[](1);
        uniqueIdsSortedAscending[0] = NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID;
        validateIdSet(uniqueIdsSortedAscending, uriCount);
        uriSetsById[NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID] = UriSet(uniqueIdsSortedAscending);
        uriSetCount = uriSetCount.add(1);
        assert(1 == uriSetCount);

        // This mimics the behavior of the &#39;createEncryptionAlgorithm&#39; external function.
        assert(NULL_ENCRYPTION_ALGORITHM_ID == encryptionAlgorithmCount);
        encryptionAlgorithmsById[NULL_ENCRYPTION_ALGORITHM_ID] = EncryptionAlgorithm(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID);
        encryptionAlgorithmCount = encryptionAlgorithmCount.add(1);
        assert(1 == encryptionAlgorithmCount);

        // This mimics the behavior of the &#39;createResourceSet&#39; external function, but allows for a self-reference in
        // the assignment of the &#39;metaResourceSetId&#39; member, which the function would prohibit.
        assert(EMPTY_RESOURCE_SET_ID == resourceSetCount);
        resourceSetsById[EMPTY_RESOURCE_SET_ID] = ResourceSet(
            msg.sender,
            EMPTY_PUBLIC_KEY_ID,
            NULL_ENCRYPTION_ALGORITHM_ID,
            new uint256[](0),
            EMPTY_RESOURCE_SET_ID
        );
        resourceSetCount = resourceSetCount.add(1);
        assert(1 == resourceSetCount);
    }

    function getUriCount() external view returns (uint256) {
        return uriCount;
    }

    function getUriById(uint256 id) external view returns (string) {
        require(id &lt; uriCount);

        Uri memory object = urisById[id];
        return object.value;
    }

    function getUriSetCount() external view returns (uint256) {
        return uriSetCount;
    }

    function getUriSetById(uint256 id) external view returns (uint256[]) {
        require(id &lt; uriSetCount);

        UriSet memory object = uriSetsById[id];
        return object.uniqueUriIdsSortedAscending;
    }

    function getChecksumAlgorithmCount() external view returns (uint256) {
        return checksumAlgorithmCount;
    }

    function getChecksumAlgorithmById(uint256 id) external view returns (uint256) {
        require(id &lt; checksumAlgorithmCount);

        ChecksumAlgorithm memory object = checksumAlgorithmsById[id];
        return object.descriptionUriSetId;
    }

    function getChecksumCount() external view returns (uint256) {
        return checksumCount;
    }

    function getChecksumById(uint256 id) external view returns (uint256, uint256, bytes) {
        require(id &lt; checksumCount);

        Checksum memory object = checksumsById[id];
        return (object.algorithmId, object.resourceByteCount, object.value);
    }

    function getEncryptionAlgorithmCount() external view returns (uint256) {
        return encryptionAlgorithmCount;
    }

    function getEncryptionAlgorithmById(uint256 id) external view returns (uint256) {
        require(id &lt; encryptionAlgorithmCount);

        EncryptionAlgorithm memory object = encryptionAlgorithmsById[id];
        return object.descriptionUriSetId;
    }

    function getChecksumPairCount() external view returns (uint256) {
        return checksumPairCount;
    }

    function getChecksumPairById(uint256 id) external view returns (uint256, uint256) {
        require(id &lt; checksumPairCount);

        ChecksumPair memory object = checksumPairsById[id];
        return (object.encryptedChecksumId, object.decryptedChecksumId);
    }

    function getResourceCount() external view returns (uint256) {
        return resourceCount;
    }

    function getResourceById(uint256 id) external view returns (uint256, uint256, uint256) {
        require(id &lt; resourceCount);

        Resource memory object = resourcesById[id];
        return (object.uriSetId, object.encryptionAlgorithmId, object.metaResourceSetId);
    }

    function getPublicKeyCount() external view returns (uint256) {
        return publicKeyCount;
    }

    function getPublicKeyById(uint256 id) external view returns (bytes) {
        require(id &lt; publicKeyCount);

        PublicKey memory object = publicKeysById[id];
        return object.value;
    }

    function getResourceSetCount() external view returns (uint256) {
        return resourceSetCount;
    }

    function getResourceSetById(uint256 id) external view returns (address, uint256, uint256, uint256[], uint256) {
        require(id &lt; resourceSetCount);

        ResourceSet memory object = resourceSetsById[id];
        return (object.creator, object.creatorPublicKeyId, object.proposalEncryptionAlgorithmId, object.uniqueResourceIdsSortedAscending, object.metaResourceSetId);
    }

    function getAgreementCount() external view returns (uint256) {
        return agreementCount;
    }

    function getAgreementById(uint256 id) external view returns (uint256, uint256) {
        require(id &lt; agreementCount);

        Agreement memory object = agreementsById[id];
        return (object.uriSetId, object.checksumPairId);
    }

    function getAgreementSetCount() external view returns (uint256) {
        return agreementSetCount;
    }

    function getAgreementSetById(uint256 id) external view returns (uint256[]) {
        require(id &lt; agreementSetCount);

        AgreementSet memory object = agreementSetsById[id];
        return object.uniqueAgreementIdsSortedAscending;
    }

    function getTokenTransferCount() external view returns (uint256) {
        return tokenTransferCount;
    }

    function getTokenTransferById(uint256 id) external view returns (address, address, uint256) {
        require(id &lt; tokenTransferCount);

        TokenTransfer memory object = tokenTransfersById[id];
        return (object.source, object.destination, object.tokenCount);
    }

    function getTokenTransferSetCount() external view returns (uint256) {
        return tokenTransferSetCount;
    }

    function getTokenTransferSetById(uint256 id) external view returns (uint256[]) {
        require(id &lt; tokenTransferSetCount);

        TokenTransferSet memory object = tokenTransferSetsById[id];
        return object.uniqueTokenTransferIdsSortedAscending;
    }

    function getProposalCount() external view returns (uint256) {
        return proposalCount;
    }

    function getProposalById(uint256 id) external view returns (uint256, address, uint256, uint256, uint256, uint256, uint256) {
        require(id &lt; proposalCount);

        Proposal memory object = proposalsById[id];
        return (object.minimumBlockNumberForWithdrawal, object.creator, object.creatorPublicKeyId, object.acceptanceEncryptionAlgorithmId, object.resourceSetId, object.agreementSetId, object.tokenTransferSetId);
    }

    function getStateByProposalId(uint256 proposalId) external view returns (ProposalState) {
        require(proposalId &lt; proposalCount);

        return statesByProposalId[proposalId];
    }

    // Check to see if an Ethereum account has assigned a checksum for a particular resource.
    function hasAddressAssignedResourceChecksumPair(address address_, uint256 resourceId) external view returns (bool) {
        require(resourceId &lt; resourceCount);

        return checksumPairAssignmentsByCreatorAndResourceId[address_][resourceId];
    }

    // Retrieve the checksum assigned assigned to particular resource
    function getChecksumPairIdByAssignerAndResourceId(address assigner, uint256 resourceId) external view returns (uint256) {
        require(resourceId &lt; resourceCount);
        require(checksumPairAssignmentsByCreatorAndResourceId[assigner][resourceId]);

        return checksumPairIdsByCreatorAndResourceId[assigner][resourceId];
    }

    // Retrieve the encrypted key to decrypt a resource referenced by an accepted proposal.
    function getEncryptedResourceDecryptionKey(uint256 proposalId, uint256 resourceId) external view returns (bytes) {
        require(proposalId &lt; proposalCount);
        require(ProposalState.AcceptedByResourceSetCreator == statesByProposalId[proposalId]);
        require(resourceId &lt; resourceCount);

        uint256[] memory validResourceIds = resourceSetsById[proposalsById[proposalId].resourceSetId].uniqueResourceIdsSortedAscending;
        require(0 &lt; validResourceIds.length);

        if (1 == validResourceIds.length) {
            require(resourceId == validResourceIds[0]);

        } else {
            uint256 lowIndex = 0;
            uint256 highIndex = validResourceIds.length.sub(1);
            uint256 middleIndex = lowIndex.add(highIndex).div(2);

            while (resourceId != validResourceIds[middleIndex]) {
                require(lowIndex &lt;= highIndex);

                if (validResourceIds[middleIndex] &lt; resourceId) {
                    lowIndex = middleIndex.add(1);
                } else {
                    highIndex = middleIndex.sub(1);
                }

                middleIndex = lowIndex.add(highIndex).div(2);
            }
        }

        return encryptedDecryptionKeysByProposalIdAndResourceId[proposalId][resourceId];
    }

    function createUri(
        string value
    ) external returns (uint256)
    {
        require(0 &lt; bytes(value).length);

        uint256 id = uriCount;
        uriCount = id.add(1);
        urisById[id] = Uri(
            value
        );

        return id;
    }

    function createUriSet(
        uint256[] uniqueUriIdsSortedAscending
    ) external returns (uint256)
    {
        validateIdSet(uniqueUriIdsSortedAscending, uriCount);

        uint256 id = uriSetCount;
        uriSetCount = id.add(1);
        uriSetsById[id] = UriSet(
            uniqueUriIdsSortedAscending
        );

        return id;
    }

    function createChecksumAlgorithm(
        uint256 descriptionUriSetId
    ) external returns (uint256)
    {
        require(descriptionUriSetId &lt; uriSetCount);

        uint256 id = checksumAlgorithmCount;
        checksumAlgorithmCount = id.add(1);
        checksumAlgorithmsById[id] = ChecksumAlgorithm(
            descriptionUriSetId
        );

        return id;
    }

    function createChecksum(
        uint256 algorithmId,
        uint256 resourceByteCount,
        bytes value
    ) external returns (uint256)
    {
        require(algorithmId &lt; checksumAlgorithmCount);
        require(0 &lt; resourceByteCount);

        uint256 id = checksumCount;
        checksumCount = id.add(1);
        checksumsById[id] = Checksum(
            algorithmId,
            resourceByteCount,
            value
        );

        return id;
    }

    function createEncryptionAlgorithm(
        uint256 descriptionUriSetId
    ) external returns (uint256)
    {
        require(descriptionUriSetId &lt; uriSetCount);

        uint256 id = encryptionAlgorithmCount;
        encryptionAlgorithmCount = id.add(1);
        encryptionAlgorithmsById[id] = EncryptionAlgorithm(
            descriptionUriSetId
        );

        return id;
    }

    function createChecksumPair(
        uint256 encryptedChecksumId,
        uint256 decryptedChecksumId
    ) external returns (uint256)
    {
        require(encryptedChecksumId &lt; checksumCount);
        require(decryptedChecksumId &lt; checksumCount);

        uint256 id = checksumPairCount;
        checksumPairCount = id.add(1);
        checksumPairsById[id] = ChecksumPair(
            encryptedChecksumId,
            decryptedChecksumId
        );

        return id;
    }

    function createResource(
        uint256 uriSetId,
        uint256 encryptionAlgorithmId,
        uint256 metaResourceSetId
    ) external returns (uint256)
    {
        require(uriSetId &lt; uriSetCount);
        require(encryptionAlgorithmId &lt; encryptionAlgorithmCount);
        require(metaResourceSetId &lt; resourceSetCount);

        uint256 id = resourceCount;
        resourceCount = id.add(1);
        resourcesById[id] = Resource(
            uriSetId,
            encryptionAlgorithmId,
            metaResourceSetId
        );

        return id;
    }

    function createPublicKey(
        bytes value
    ) external returns (uint256)
    {
        uint256 id = publicKeyCount;
        publicKeyCount = id.add(1);
        publicKeysById[id] = PublicKey(
            value
        );

        return id;
    }

    function createResourceSet(
        uint256 creatorPublicKeyId,
        uint256 proposalEncryptionAlgorithmId,
        uint256[] uniqueResourceIdsSortedAscending,
        uint256 metaResourceSetId
    ) external returns (uint256)
    {
        require(creatorPublicKeyId &lt; publicKeyCount);
        require(proposalEncryptionAlgorithmId &lt; encryptionAlgorithmCount);
        validateIdSet(uniqueResourceIdsSortedAscending, resourceCount);
        require(metaResourceSetId &lt; resourceSetCount);

        uint256 id = resourceSetCount;
        resourceSetCount = id.add(1);
        resourceSetsById[id] = ResourceSet(
            msg.sender,
            creatorPublicKeyId,
            proposalEncryptionAlgorithmId,
            uniqueResourceIdsSortedAscending,
            metaResourceSetId
        );

        return id;
    }

    function createAgreement(
        uint256 uriSetId,
        uint256 checksumPairId
    ) external returns (uint256)
    {
        require(uriSetId &lt; uriSetCount);
        require(checksumPairId &lt; checksumPairCount);

        uint256 id = agreementCount;
        agreementCount = id.add(1);
        agreementsById[id] = Agreement(
            uriSetId,
            checksumPairId
        );

        return id;
    }

    function createAgreementSet(
        uint256[] uniqueAgreementIdsSortedAscending
    ) external returns (uint256)
    {
        validateIdSet(uniqueAgreementIdsSortedAscending, agreementCount);

        uint256 id = agreementSetCount;
        agreementSetCount = id.add(1);
        agreementSetsById[id] = AgreementSet(
            uniqueAgreementIdsSortedAscending
        );

        return id;
    }

    function createTokenTransfer(
        address source,
        address destination,
        uint256 tokenCount
    ) external returns (uint256)
    {
        require(address(0) != source);
        require(address(0) != destination);
        require(0 &lt; tokenCount);

        uint256 id = tokenTransferCount;
        tokenTransferCount = id.add(1);
        tokenTransfersById[id] = TokenTransfer(
            source,
            destination,
            tokenCount
        );

        return id;
    }

    function createTokenTransferSet(
        uint256[] uniqueTokenTransferIdsSortedAscending
    ) external returns (uint256)
    {
        validateIdSet(uniqueTokenTransferIdsSortedAscending, tokenTransferCount);

        uint256 id = tokenTransferSetCount;
        tokenTransferSetCount = id.add(1);
        tokenTransferSetsById[id] = TokenTransferSet(
            uniqueTokenTransferIdsSortedAscending
        );

        return id;
    }

    function createProposal(
        uint256 minimumBlockNumberForWithdrawal,
        uint256 creatorPublicKeyId,
        uint256 acceptanceEncryptionAlgorithmId,
        uint256 resourceSetId,
        uint256 agreementSetId,
        uint256 tokenTransferSetId
    ) external returns (uint256)
    {
        require(creatorPublicKeyId &lt; publicKeyCount);
        require(acceptanceEncryptionAlgorithmId &lt; encryptionAlgorithmCount);
        require(resourceSetId &lt; resourceSetCount);
        require(agreementSetId &lt; agreementSetCount);
        require(tokenTransferSetId &lt; tokenTransferSetCount);

        transferTokensToEscrow(msg.sender, tokenTransferSetId);

        uint256 id = proposalCount;
        proposalCount = id.add(1);
        proposalsById[id] = Proposal(
            minimumBlockNumberForWithdrawal,
            msg.sender,
            creatorPublicKeyId,
            acceptanceEncryptionAlgorithmId,
            resourceSetId,
            agreementSetId,
            tokenTransferSetId
        );

        return id;
    }

    // Each Ethereum account may assign a &#39;ChecksumPair&#39; to a resource exactly once. This ensures that each claim that a
    // checksum should match a resource is attached to a particular authority. This operation is not bound to the
    // creation of the resource because the resource&#39;s creator may not know the checksum when creating the resource.
    function assignResourceChecksumPair(
        uint256 resourceId,
        uint256 checksumPairId
    ) external
    {
        require(resourceId &lt; resourceCount);
        require(checksumPairId &lt; checksumPairCount);
        require(false == checksumPairAssignmentsByCreatorAndResourceId[msg.sender][resourceId]);

        checksumPairIdsByCreatorAndResourceId[msg.sender][resourceId] = checksumPairId;
        checksumPairAssignmentsByCreatorAndResourceId[msg.sender][resourceId] = true;
    }

    // This function moves a proposal to a final state of `WithdrawnByCreator&#39; and returns tokens to the sources
    // described by the proposal&#39;s transfers.
    function withdrawProposal(
        uint256 proposalId
    ) external
    {
        require(proposalId &lt; proposalCount);
        require(ProposalState.Pending == statesByProposalId[proposalId]);

        Proposal memory proposal = proposalsById[proposalId];
        require(msg.sender == proposal.creator);
        require(block.number &gt;= proposal.minimumBlockNumberForWithdrawal);

        returnTokensFromEscrow(proposal.creator, proposal.tokenTransferSetId);
        statesByProposalId[proposalId] = ProposalState.WithdrawnByCreator;
    }

    // This function moves a proposal to a final state of `RejectedByResourceSetCreator&#39; and returns tokens to the sources
    // described by the proposal&#39;s transfers.
    function rejectProposal(
        uint256 proposalId
    ) external
    {
        require(proposalId &lt; proposalCount);
        require(ProposalState.Pending == statesByProposalId[proposalId]);

        Proposal memory proposal = proposalsById[proposalId];
        require(msg.sender == resourceSetsById[proposal.resourceSetId].creator);

        returnTokensFromEscrow(proposal.creator, proposal.tokenTransferSetId);
        statesByProposalId[proposalId] = ProposalState.RejectedByResourceSetCreator;
    }

    // This function moves a proposal to a final state of `RejectedByResourceSetCreator&#39; and sends tokens to the
    // destinations described by the proposal&#39;s transfers.
    //
    // The caller should encrypt each decryption key corresponding
    // to each resource in the proposal&#39;s resource set first with the public key of the proposal&#39;s creator and then with
    // the private key assoicated with the public key referenced in the resource set. The caller should concatenate
    // these encrypted values and pass the resulting byte array as &#39;concatenatedResourceDecryptionKeys&#39;.
    // The length of each encrypted decryption key should be provided in the &#39;concatenatedResourceDecryptionKeyLengths&#39;.
    // The index of each value in &#39;concatenatedResourceDecryptionKeyLengths&#39; must correspond to an index in the resource
    // set referenced by the proposal.
    function acceptProposal(
        uint256 proposalId,
        bytes concatenatedResourceDecryptionKeys,
        uint256[] concatenatedResourceDecryptionKeyLengths
    ) external
    {
        require(proposalId &lt; proposalCount);
        require(ProposalState.Pending == statesByProposalId[proposalId]);

        Proposal memory proposal = proposalsById[proposalId];
        require(msg.sender == resourceSetsById[proposal.resourceSetId].creator);

        storeEncryptedDecryptionKeys(
            proposalId,
            concatenatedResourceDecryptionKeys,
            concatenatedResourceDecryptionKeyLengths
        );

        transferTokensFromEscrow(proposal.tokenTransferSetId);

        statesByProposalId[proposalId] = ProposalState.AcceptedByResourceSetCreator;
    }

    function validateIdSet(uint256[] uniqueIdsSortedAscending, uint256 idCount) private pure {
        if (0 &lt; uniqueIdsSortedAscending.length) {

            uint256 id = uniqueIdsSortedAscending[0];
            require(id &lt; idCount);

            uint256 previousId = id;
            for (uint256 index = 1; index &lt; uniqueIdsSortedAscending.length; index = index.add(1)) {
                id = uniqueIdsSortedAscending[index];
                require(id &lt; idCount);
                require(previousId &lt; id);

                previousId = id;
            }
        }
    }

    function transferTokensToEscrow(address proposalCreator, uint256 tokenTransferSetId) private {
        assert(tokenTransferSetId &lt; tokenTransferSetCount);
        assert(address(0) != proposalCreator);

        uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
        for (uint256 index = 0; index &lt; tokenTransferIds.length; index = index.add(1)) {
            uint256 tokenTransferId = tokenTransferIds[index];
            assert(tokenTransferId &lt; tokenTransferCount);

            TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
            assert(0 &lt; tokenTransfer.tokenCount);
            assert(address(0) != tokenTransfer.source);
            assert(address(0) != tokenTransfer.destination);

            require(tokenTransfer.tokenCount &lt;= balances[tokenTransfer.source]);

            if (tokenTransfer.source != proposalCreator) {
                require(tokenTransfer.tokenCount &lt;= allowed[tokenTransfer.source][proposalCreator]);

                allowed[tokenTransfer.source][proposalCreator] = allowed[tokenTransfer.source][proposalCreator].sub(tokenTransfer.tokenCount);
            }

            balances[tokenTransfer.source] = balances[tokenTransfer.source].sub(tokenTransfer.tokenCount);
            balances[address(0)] = balances[address(0)].add(tokenTransfer.tokenCount);

            Transfer(tokenTransfer.source, address(0), tokenTransfer.tokenCount);
        }
    }

    function returnTokensFromEscrow(address proposalCreator, uint256 tokenTransferSetId) private {
        assert(tokenTransferSetId &lt; tokenTransferSetCount);
        assert(address(0) != proposalCreator);

        uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
        for (uint256 index = 0; index &lt; tokenTransferIds.length; index = index.add(1)) {
            uint256 tokenTransferId = tokenTransferIds[index];
            assert(tokenTransferId &lt; tokenTransferCount);

            TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
            assert(0 &lt; tokenTransfer.tokenCount);
            assert(address(0) != tokenTransfer.source);
            assert(address(0) != tokenTransfer.destination);
            assert(tokenTransfer.tokenCount &lt;= balances[address(0)]);

            balances[tokenTransfer.source] = balances[tokenTransfer.source].add(tokenTransfer.tokenCount);
            balances[address(0)] = balances[address(0)].sub(tokenTransfer.tokenCount);

            Transfer(address(0), tokenTransfer.source, tokenTransfer.tokenCount);
        }
    }

    function transferTokensFromEscrow(uint256 tokenTransferSetId) private {
        assert(tokenTransferSetId &lt; tokenTransferSetCount);

        uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
        for (uint256 index = 0; index &lt; tokenTransferIds.length; index = index.add(1)) {
            uint256 tokenTransferId = tokenTransferIds[index];
            assert(tokenTransferId &lt; tokenTransferCount);

            TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
            assert(0 &lt; tokenTransfer.tokenCount);
            assert(address(0) != tokenTransfer.source);
            assert(address(0) != tokenTransfer.destination);

            balances[address(0)] = balances[address(0)].sub(tokenTransfer.tokenCount);
            balances[tokenTransfer.destination] = balances[tokenTransfer.destination].add(tokenTransfer.tokenCount);
            Transfer(address(0), tokenTransfer.destination, tokenTransfer.tokenCount);
        }
    }

    function storeEncryptedDecryptionKeys(
        uint256 proposalId,
        bytes concatenatedEncryptedResourceDecryptionKeys,
        uint256[] encryptedResourceDecryptionKeyLengths
    ) private
    {
        assert(proposalId &lt; proposalCount);

        uint256 resourceSetId = proposalsById[proposalId].resourceSetId;
        assert(resourceSetId &lt; resourceSetCount);

        ResourceSet memory resourceSet = resourceSetsById[resourceSetId];
        require(resourceSet.uniqueResourceIdsSortedAscending.length == encryptedResourceDecryptionKeyLengths.length);

        uint256 concatenatedEncryptedResourceDecryptionKeysIndex = 0;
        for (uint256 resourceIndex = 0; resourceIndex &lt; encryptedResourceDecryptionKeyLengths.length; resourceIndex = resourceIndex.add(1)) {
            bytes memory encryptedResourceDecryptionKey = new bytes(encryptedResourceDecryptionKeyLengths[resourceIndex]);
            require(0 &lt; encryptedResourceDecryptionKey.length);

            for (uint256 encryptedResourceDecryptionKeyIndex = 0; encryptedResourceDecryptionKeyIndex &lt; encryptedResourceDecryptionKey.length; encryptedResourceDecryptionKeyIndex = encryptedResourceDecryptionKeyIndex.add(1)) {
                require(concatenatedEncryptedResourceDecryptionKeysIndex &lt; concatenatedEncryptedResourceDecryptionKeys.length);
                encryptedResourceDecryptionKey[encryptedResourceDecryptionKeyIndex] = concatenatedEncryptedResourceDecryptionKeys[concatenatedEncryptedResourceDecryptionKeysIndex];
                concatenatedEncryptedResourceDecryptionKeysIndex = concatenatedEncryptedResourceDecryptionKeysIndex.add(1);
            }

            uint256 resourceId = resourceSet.uniqueResourceIdsSortedAscending[resourceIndex];
            assert(resourceId &lt; resourceCount);

            encryptedDecryptionKeysByProposalIdAndResourceId[proposalId][resourceId] = encryptedResourceDecryptionKey;
        }

        require(concatenatedEncryptedResourceDecryptionKeysIndex == concatenatedEncryptedResourceDecryptionKeys.length);
    }
}