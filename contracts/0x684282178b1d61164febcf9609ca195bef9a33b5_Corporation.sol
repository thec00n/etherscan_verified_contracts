/*
Corporation SmartContract.
developed by: cryptonomica.net, 2016

used sources:
https://www.ethereum.org/token // example of the token standart
https://github.com/ethereum/EIPs/issues/20 // token standart description
https://www.ethereum.org/dao // voting example
*/

/*
How to deploy (estimated: 1,641,268 gas):
1) For development: use https://ethereum.github.io/browser-solidity/
2) For testing on Testnet: Open the default (&#39;Mist&#39;) wallet (if you are only testing, go to the menu develop &gt; network &gt; testnet), go to the Contracts tab and then press deploy contract, and on the solidity code box, paste the code above.
3) For prodaction, like in 2) but on Main Network.
To verify your deployed smartcontract source code for public go to:
https://etherscan.io/verifyContract
*/

// &#39;interface&#39;:
//  this is expected from another contract,
//  if it wants to spend tokens (shares) of behalf of the token owner
//  in our contract
//  f.e.: a &#39;multisig&#39; SmartContract for transfering shares from seller
//  to buyer
contract tokenRecipient {
    function receiveApproval(address _from,     // sharehoder
                             uint256 _value,    // number of shares
                             address _share,    // - will be this contract
                             bytes _extraData); //
}

contract Corporation {

    /* Standard public variables of the token */
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* ------------------- Corporate Stock Ledger ---------- */
    // Shares, shareholders, balances ect.

    // list of all sharehoders (represented by Ethereum accounts)
    // in this Corporation&#39;s history, # is ID
    address[] public shareholder;
    // this helps to find address by ID without loop
    mapping (address =&gt; uint256) public shareholderID;
    // list of adresses, that who currently own at least share
    // not public, use getCurrentShareholders()
    address[] activeShareholdersArray;
    // balances:
    mapping (address =&gt; uint256) public balanceOf;
    // shares that have to be managed by external contract
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;

    /*  --------------- Constructor --------- */
    // Initializes contract with initial supply tokens to the creator of the contract
    function Corporation () { // - truffle compiles only no args Constructor
        uint256 initialSupply = 12000; // shares quantity, constant
        balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
        totalSupply = initialSupply;  // Update total supply
        name = &quot;shares&quot;; //tokenName; // Set the name for display purposes
        symbol = &quot;sh&quot;; // tokenSymbol; // Set the symbol for display purposes
        decimals = 0; // Amount of decimals for display purposes

        // -- start corporate stock ledger
        shareholderID[this] = shareholder.push(this)-1; // # 0
        shareholderID[msg.sender] = shareholder.push(msg.sender)-1; // #1
        activeShareholdersArray.push(msg.sender); // add to active shareholders
    }

    /* --------------- Shares management ------ */

    // This generates a public event on the blockchain that will notify clients. In &#39;Mist&#39; SmartContract page enable &#39;Watch contract events&#39;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function getCurrentShareholders() returns (address[]){
        delete activeShareholdersArray;
        for (uint256 i=0; i &lt; shareholder.length; i++){
            if (balanceOf[shareholder[i]] &gt; 0){
                activeShareholdersArray.push(shareholder[i]);
            }
            } return activeShareholdersArray;
        }

    /*  -- can be used to transfer shares to new contract
    together with getCurrentShareholders() */
    function getBalanceByAdress(address _address) returns (uint256) {
        return balanceOf[_address];
    }

    function getMyShareholderID() returns (uint256) {
        return shareholderID[msg.sender];
    }

    function getShareholderAdressByID(uint256 _id) returns (address){
        return shareholder[_id];
    }

    function getMyShares() returns (uint256) {
        return balanceOf[msg.sender];
    }


    /* ---- Transfer shares to another adress ----
    (shareholder&#39;s address calls this)
    */
    function transfer(address _to, uint256 _value) {
        // check arguments:
        if (_value &lt; 1) throw;
        if (this == _to) throw; // do not send shares to contract itself;
        if (balanceOf[msg.sender] &lt; _value) throw; // Check if the sender has enough

        // make transaction
        balanceOf[msg.sender] -= _value; // Subtract from the sender
        balanceOf[_to] += _value;       // Add the same to the recipient

        // if new address, add it to shareholders history (stock ledger):
        if (shareholderID[_to] == 0){ // ----------- check if works
            shareholderID[_to] = shareholder.push(_to)-1;
        }

        // Notify anyone listening that this transfer took place
        Transfer(msg.sender, _to, _value);
    }

    /* Allow another contract to spend some shares in your behalf
    (shareholder calls this) */
    function approveAndCall(address _spender, // another contract&#39;s adress
                            uint256 _value, // number of shares
                            bytes _extraData) // data for another contract
    returns (bool success) {
        // msg.sender - account owner who gives allowance
        // _spender   - address of another contract
        // it writes in &quot;allowance&quot; that this owner allows another
        // contract (_spender) to spend thi amont (_value) of shares
        // in his behalf
        allowance[msg.sender][_spender] = _value;
        // &#39;spender&#39; is another contract that implements code
        //  prescribed in &#39;shareRecipient&#39; above
        tokenRecipient spender = tokenRecipient(_spender);
        // this contract calls &#39;receiveApproval&#39; function
        // of another contract to send information about
        // allowance
        spender.receiveApproval(msg.sender, // shares owner
                                _value,     // number of shares
                                this,       // this contract&#39;s adress
                                _extraData);// data from shares owner
        return true;
    }

    /* this function can be called from another contract, after it
    have allowance to transfer shares in behalf of sharehoder  */
    function transferFrom(address _from,
                          address _to,
                          uint256 _value)
    returns (bool success) {

        // Check arguments:
        // should one share or more
        if (_value &lt; 1) throw;
        // do not send shares to this contract itself;
        if (this == _to) throw;
        // Check if the sender has enough
        if (balanceOf[_from] &lt; _value) throw;

        // Check allowance
        if (_value &gt; allowance[_from][msg.sender]) throw;

        // if transfer to new address -- add him to ledger
        if (shareholderID[_to] == 0){
            shareholderID[_to] = shareholder.push(_to)-1; // push function returns the new length
        }

        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;

        // Change allowances correspondingly
        allowance[_from][msg.sender] -= _value;
        // Notify anyone listening that this transfer took place
        Transfer(_from, _to, _value);

        return true;
    }

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }

    /*  --------- Voting  --------------  */
    // we only count &#39;yes&#39; votes, not voting &#39;yes&#39;
    // considered as voting &#39;no&#39; (as stated in Bylaws)

    // each proposal should contain it&#39;s text
    // index of text in this array is a proposal ID
    string[] public proposalText;
    // proposalID =&gt; (shareholder =&gt; &quot;if already voted for this proposal&quot;)
    mapping (uint256 =&gt; mapping (address =&gt; bool)) voted;
    // proposalID =&gt; addresses voted &#39;yes&#39;
    // exact number of votes according to shares will be counted
    // after deadline
    mapping (uint256 =&gt; address[]) public votes;
    // proposalID =&gt; deadline
    mapping (uint256 =&gt; uint256) public deadline;
    // proposalID =&gt; final &#39;yes&#39; votes
    mapping (uint256 =&gt; uint256) public results;
    // proposals of every shareholder
    mapping (address =&gt; uint256[]) public proposalsByShareholder;


    event ProposalAdded(uint256 proposalID,
                        address initiator,
                        string description,
                        uint256 deadline);

    event VotingFinished(uint256 proposalID, uint256 votes);

    function makeNewProposal(string _proposalDescription,
                             uint256 _debatingPeriodInMinutes)
    returns (uint256){
        // only shareholder with one or more shares can make a proposal
        // !!!! can be more then one share required
        if (balanceOf[msg.sender] &lt; 1) throw;

        uint256 id = proposalText.push(_proposalDescription)-1;
        deadline[id] = now + _debatingPeriodInMinutes * 1 minutes;

        // add to proposals of this shareholder:
        proposalsByShareholder[msg.sender].push(id);

        // initiator always votes &#39;yes&#39;
        votes[id].push(msg.sender);
        voted[id][msg.sender] = true;

        ProposalAdded(id, msg.sender, _proposalDescription, deadline[id]);

        return id; // returns proposal id
    }

    function getMyProposals() returns (uint256[]){
        return proposalsByShareholder[msg.sender];
    }

    function voteForProposal(uint256 _proposalID) returns (string) {

        // if no shares currently owned - no right to vote
        if (balanceOf[msg.sender] &lt; 1) return &quot;no shares, vote not accepted&quot;;

        // if already voted - throw, else voting can be spammed
        if (voted[_proposalID][msg.sender]){
            return &quot;already voted, vote not accepted&quot;;
        }

        // no votes after deadline
        if (now &gt; deadline[_proposalID] ){
            return &quot;vote not accepted after deadline&quot;;
        }

        // add to list of voted &#39;yes&#39;
        votes[_proposalID].push(msg.sender);
        voted[_proposalID][msg.sender] = true;
        return &quot;vote accepted&quot;;
    }

    // to count votes this transaction should be started manually
    // from _any_ Ethereum address after deadline
    function countVotes(uint256 _proposalID) returns (uint256){

        // if not after deadline - throw
        if (now &lt; deadline[_proposalID]) throw;

        // if already counted return result;
        if (results[_proposalID] &gt; 0) return results[_proposalID];

        // else should count results and store in public variable
        uint256 result = 0;
        for (uint256 i = 0; i &lt; votes[_proposalID].length; i++){

            address voter = votes[_proposalID][i];
            result = result + balanceOf[voter];
        }

        // Log and notify anyone listening that this voting finished
        // with &#39;result&#39; - number of &#39;yes&#39; votes
        VotingFinished(_proposalID, result);

        return result;
    }

}