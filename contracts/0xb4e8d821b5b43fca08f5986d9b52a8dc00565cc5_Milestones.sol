pragma solidity ^0.4.17;

/*

 * source       https://github.com/blockbitsio/

 * @name        Application Entity Generic Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e08d89838b99a08e8f978c899685ce928f">[email&#160;protected]</a>&gt;

    Used for the ABI interface when assets need to call Application Entity.

    This is required, otherwise we end up loading the assets themselves when we load the ApplicationEntity contract
    and end up in a loop
*/



contract ApplicationEntityABI {

    address public ProposalsEntity;
    address public FundingEntity;
    address public MilestonesEntity;
    address public MeetingsEntity;
    address public BountyManagerEntity;
    address public TokenManagerEntity;
    address public ListingContractEntity;
    address public FundingManagerEntity;
    address public NewsContractEntity;

    bool public _initialized = false;
    bool public _locked = false;
    uint8 public CurrentEntityState;
    uint8 public AssetCollectionNum;
    address public GatewayInterfaceAddress;
    address public deployerAddress;
    address testAddressAllowUpgradeFrom;
    mapping (bytes32 =&gt; uint8) public EntityStates;
    mapping (bytes32 =&gt; address) public AssetCollection;
    mapping (uint8 =&gt; bytes32) public AssetCollectionIdToName;
    mapping (bytes32 =&gt; uint256) public BylawsUint256;
    mapping (bytes32 =&gt; bytes32) public BylawsBytes32;

    function ApplicationEntity() public;
    function getEntityState(bytes32 name) public view returns (uint8);
    function linkToGateway( address _GatewayInterfaceAddress, bytes32 _sourceCodeUrl ) external;
    function setUpgradeState(uint8 state) public ;
    function addAssetProposals(address _assetAddresses) external;
    function addAssetFunding(address _assetAddresses) external;
    function addAssetMilestones(address _assetAddresses) external;
    function addAssetMeetings(address _assetAddresses) external;
    function addAssetBountyManager(address _assetAddresses) external;
    function addAssetTokenManager(address _assetAddresses) external;
    function addAssetFundingManager(address _assetAddresses) external;
    function addAssetListingContract(address _assetAddresses) external;
    function addAssetNewsContract(address _assetAddresses) external;
    function getAssetAddressByName(bytes32 _name) public view returns (address);
    function setBylawUint256(bytes32 name, uint256 value) public;
    function getBylawUint256(bytes32 name) public view returns (uint256);
    function setBylawBytes32(bytes32 name, bytes32 value) public;
    function getBylawBytes32(bytes32 name) public view returns (bytes32);
    function initialize() external returns (bool);
    function getParentAddress() external view returns(address);
    function createCodeUpgradeProposal( address _newAddress, bytes32 _sourceCodeUrl ) external returns (uint256);
    function acceptCodeUpgradeProposal(address _newAddress) external;
    function initializeAssetsToThisApplication() external returns (bool);
    function transferAssetsToNewApplication(address _newAddress) external returns (bool);
    function lock() external returns (bool);
    function canInitiateCodeUpgrade(address _sender) public view returns(bool);
    function doStateChanges() public;
    function hasRequiredStateChanges() public view returns (bool);
    function anyAssetHasChanges() public view returns (bool);
    function extendedAnyAssetHasChanges() internal view returns (bool);
    function getRequiredStateChanges() public view returns (uint8, uint8);
    function getTimestamp() view public returns (uint256);

}

/*

 * source       https://github.com/blockbitsio/

 * @name        Application Asset Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="412c28222a38012f2e362d2837246f332e">[email&#160;protected]</a>&gt;

 Any contract inheriting this will be usable as an Asset in the Application Entity

*/




contract ApplicationAsset {

    event EventAppAssetOwnerSet(bytes32 indexed _name, address indexed _owner);
    event EventRunBeforeInit(bytes32 indexed _name);
    event EventRunBeforeApplyingSettings(bytes32 indexed _name);


    mapping (bytes32 =&gt; uint8) public EntityStates;
    mapping (bytes32 =&gt; uint8) public RecordStates;
    uint8 public CurrentEntityState;

    event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
    event DebugEntityRequiredChanges( bytes32 _assetName, uint8 indexed _current, uint8 indexed _required );

    bytes32 public assetName;

    /* Asset records */
    uint8 public RecordNum = 0;

    /* Asset initialised or not */
    bool public _initialized = false;

    /* Asset settings present or not */
    bool public _settingsApplied = false;

    /* Asset owner ( ApplicationEntity address ) */
    address public owner = address(0x0) ;
    address public deployerAddress;

    function ApplicationAsset() public {
        deployerAddress = msg.sender;
    }

    function setInitialApplicationAddress(address _ownerAddress) public onlyDeployer requireNotInitialised {
        owner = _ownerAddress;
    }

    function setInitialOwnerAndName(bytes32 _name) external
        requireNotInitialised
        onlyOwner
        returns (bool)
    {
        // init states
        setAssetStates();
        assetName = _name;
        // set initial state
        CurrentEntityState = getEntityState(&quot;NEW&quot;);
        runBeforeInitialization();
        _initialized = true;
        EventAppAssetOwnerSet(_name, owner);
        return true;
    }

    function setAssetStates() internal {
        // Asset States
        EntityStates[&quot;__IGNORED__&quot;]     = 0;
        EntityStates[&quot;NEW&quot;]             = 1;
        // Funding Stage States
        RecordStates[&quot;__IGNORED__&quot;]     = 0;
    }

    function getRecordState(bytes32 name) public view returns (uint8) {
        return RecordStates[name];
    }

    function getEntityState(bytes32 name) public view returns (uint8) {
        return EntityStates[name];
    }

    function runBeforeInitialization() internal requireNotInitialised  {
        EventRunBeforeInit(assetName);
    }

    function applyAndLockSettings()
        public
        onlyDeployer
        requireInitialised
        requireSettingsNotApplied
        returns(bool)
    {
        runBeforeApplyingSettings();
        _settingsApplied = true;
        return true;
    }

    function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {
        EventRunBeforeApplyingSettings(assetName);
    }

    function transferToNewOwner(address _newOwner) public requireInitialised onlyOwner returns (bool) {
        require(owner != address(0x0) &amp;&amp; _newOwner != address(0x0));
        owner = _newOwner;
        EventAppAssetOwnerSet(assetName, owner);
        return true;
    }

    function getApplicationAssetAddressByName(bytes32 _name)
        public
        view
        returns(address)
    {
        address asset = ApplicationEntityABI(owner).getAssetAddressByName(_name);
        if( asset != address(0x0) ) {
            return asset;
        } else {
            revert();
        }
    }

    function getApplicationState() public view returns (uint8) {
        return ApplicationEntityABI(owner).CurrentEntityState();
    }

    function getApplicationEntityState(bytes32 name) public view returns (uint8) {
        return ApplicationEntityABI(owner).getEntityState(name);
    }

    function getAppBylawUint256(bytes32 name) public view requireInitialised returns (uint256) {
        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);
        return CurrentApp.getBylawUint256(name);
    }

    function getAppBylawBytes32(bytes32 name) public view requireInitialised returns (bytes32) {
        ApplicationEntityABI CurrentApp = ApplicationEntityABI(owner);
        return CurrentApp.getBylawBytes32(name);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyApplicationEntity() {
        require(msg.sender == owner);
        _;
    }

    modifier requireInitialised() {
        require(_initialized == true);
        _;
    }

    modifier requireNotInitialised() {
        require(_initialized == false);
        _;
    }

    modifier requireSettingsApplied() {
        require(_settingsApplied == true);
        _;
    }

    modifier requireSettingsNotApplied() {
        require(_settingsApplied == false);
        _;
    }

    modifier onlyDeployer() {
        require(msg.sender == deployerAddress);
        _;
    }

    modifier onlyAsset(bytes32 _name) {
        address AssetAddress = getApplicationAssetAddressByName(_name);
        require( msg.sender == AssetAddress);
        _;
    }

    function getTimestamp() view public returns (uint256) {
        return now;
    }


}

/*

 * source       https://github.com/blockbitsio/

 * @name        Application Asset Contract ABI
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="660b0f050d1f260809110a0f1003481409">[email&#160;protected]</a>&gt;

 Any contract inheriting this will be usable as an Asset in the Application Entity

*/



contract ABIApplicationAsset {

    bytes32 public assetName;
    uint8 public CurrentEntityState;
    uint8 public RecordNum;
    bool public _initialized;
    bool public _settingsApplied;
    address public owner;
    address public deployerAddress;
    mapping (bytes32 =&gt; uint8) public EntityStates;
    mapping (bytes32 =&gt; uint8) public RecordStates;

    function setInitialApplicationAddress(address _ownerAddress) public;
    function setInitialOwnerAndName(bytes32 _name) external returns (bool);
    function getRecordState(bytes32 name) public view returns (uint8);
    function getEntityState(bytes32 name) public view returns (uint8);
    function applyAndLockSettings() public returns(bool);
    function transferToNewOwner(address _newOwner) public returns (bool);
    function getApplicationAssetAddressByName(bytes32 _name) public returns(address);
    function getApplicationState() public view returns (uint8);
    function getApplicationEntityState(bytes32 name) public view returns (uint8);
    function getAppBylawUint256(bytes32 name) public view returns (uint256);
    function getAppBylawBytes32(bytes32 name) public view returns (bytes32);
    function getTimestamp() view public returns (uint256);


}

/*

 * source       https://github.com/blockbitsio/

 * @name        Funding Contract ABI
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e28f8b81899ba28c8d958e8b9487cc908d">[email&#160;protected]</a>&gt;

 Contains the Funding Contract code deployed and linked to the Application Entity

*/





contract ABIFundingManager is ABIApplicationAsset {

    bool public fundingProcessed;
    bool FundingPoolBalancesAllocated;
    uint8 public VaultCountPerProcess;
    uint256 public lastProcessedVaultId;
    uint256 public vaultNum;
    uint256 public LockedVotingTokens;
    bytes32 public currentTask;
    mapping (bytes32 =&gt; bool) public taskByHash;
    mapping  (address =&gt; address) public vaultList;
    mapping  (uint256 =&gt; address) public vaultById;

    function receivePayment(address _sender, uint8 _payment_method, uint8 _funding_stage) payable public returns(bool);
    function getMyVaultAddress(address _sender) public view returns (address);
    function setVaultCountPerProcess(uint8 _perProcess) external;
    function getHash(bytes32 actionType, bytes32 arg1) public pure returns ( bytes32 );
    function getCurrentMilestoneProcessed() public view returns (bool);
    function processFundingFailedFinished() public view returns (bool);
    function processFundingSuccessfulFinished() public view returns (bool);
    function getCurrentMilestoneIdHash() internal view returns (bytes32);
    function processMilestoneFinished() public view returns (bool);
    function processEmergencyFundReleaseFinished() public view returns (bool);
    function getAfterTransferLockedTokenBalances(address vaultAddress, bool excludeCurrent) public view returns (uint256);
    function VaultRequestedUpdateForLockedVotingTokens(address owner) public;
    function doStateChanges() public;
    function hasRequiredStateChanges() public view returns (bool);
    function getRequiredStateChanges() public view returns (uint8, uint8);
    function ApplicationInFundingOrDevelopment() public view returns(bool);

}

/*

 * source       https://github.com/blockbitsio/

 * @name        Meetings Contract ABI
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e984808a8290a987869e85809f8cc79b86">[email&#160;protected]</a>&gt;

 Contains the Meetings Contract code deployed and linked to the Application Entity

*/





contract ABIMeetings is ABIApplicationAsset {
    struct Record {
        bytes32 hash;
        bytes32 name;
        uint8 state;
        uint256 time_start;                     // start at unixtimestamp
        uint256 duration;
        uint8 index;
    }
    mapping (uint8 =&gt; Record) public Collection;
}

/*

 * source       https://github.com/blockbitsio/

 * @name        Proposals Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="036e6a60687a436d6c746f6a75662d716c">[email&#160;protected]</a>&gt;

 Contains the Proposals Contract code deployed and linked to the Application Entity

*/





contract ABIProposals is ABIApplicationAsset {

    address public Application;
    address public ListingContractEntity;
    address public FundingEntity;
    address public FundingManagerEntity;
    address public TokenManagerEntity;
    address public TokenEntity;
    address public MilestonesEntity;

    struct ProposalRecord {
        address creator;
        bytes32 name;
        uint8 actionType;
        uint8 state;
        bytes32 hash;                       // action name + args hash
        address addr;
        bytes32 sourceCodeUrl;
        uint256 extra;
        uint256 time_start;
        uint256 time_end;
        uint256 index;
    }

    struct VoteStruct {
        address voter;
        uint256 time;
        bool    vote;
        uint256 power;
        bool    annulled;
        uint256 index;
    }

    struct ResultRecord {
        uint256 totalAvailable;
        uint256 requiredForResult;
        uint256 totalSoFar;
        uint256 yes;
        uint256 no;
        bool    requiresCounting;
    }

    uint8 public ActiveProposalNum;
    uint256 public VoteCountPerProcess;
    bool public EmergencyFundingReleaseApproved;

    mapping (bytes32 =&gt; uint8) public ActionTypes;
    mapping (uint8 =&gt; uint256) public ActiveProposalIds;
    mapping (uint256 =&gt; bool) public ExpiredProposalIds;
    mapping (uint256 =&gt; ProposalRecord) public ProposalsById;
    mapping (bytes32 =&gt; uint256) public ProposalIdByHash;
    mapping (uint256 =&gt; mapping (uint256 =&gt; VoteStruct) ) public VotesByProposalId;
    mapping (uint256 =&gt; mapping (address =&gt; VoteStruct) ) public VotesByCaster;
    mapping (uint256 =&gt; uint256) public VotesNumByProposalId;
    mapping (uint256 =&gt; ResultRecord ) public ResultsByProposalId;
    mapping (uint256 =&gt; uint256) public lastProcessedVoteIdByProposal;
    mapping (uint256 =&gt; uint256) public ProcessedVotesByProposal;
    mapping (uint256 =&gt; uint256) public VoteCountAtProcessingStartByProposal;

    function getRecordState(bytes32 name) public view returns (uint8);
    function getActionType(bytes32 name) public view returns (uint8);
    function getProposalState(uint256 _proposalId) public view returns (uint8);
    function getBylawsProposalVotingDuration() public view returns (uint256);
    function getBylawsMilestoneMinPostponing() public view returns (uint256);
    function getBylawsMilestoneMaxPostponing() public view returns (uint256);
    function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 );
    function process() public;
    function hasRequiredStateChanges() public view returns (bool);
    function getRequiredStateChanges() public view returns (uint8);
    function addCodeUpgradeProposal(address _addr, bytes32 _sourceCodeUrl) external returns (uint256);
    function createMilestoneAcceptanceProposal() external returns (uint256);
    function createMilestonePostponingProposal(uint256 _duration) external returns (uint256);
    function getCurrentMilestonePostponingProposalDuration() public view returns (uint256);
    function getCurrentMilestoneProposalStatusForType(uint8 _actionType ) public view returns (uint8);
    function createEmergencyFundReleaseProposal() external returns (uint256);
    function createDelistingProposal(uint256 _projectId) external returns (uint256);
    function RegisterVote(uint256 _proposalId, bool _myVote) public;
    function hasPreviousVote(uint256 _proposalId, address _voter) public view returns (bool);
    function getTotalTokenVotingPower(address _voter) public view returns ( uint256 );
    function getVotingPower(uint256 _proposalId, address _voter) public view returns ( uint256 );
    function setVoteCountPerProcess(uint256 _perProcess) external;
    function ProcessVoteTotals(uint256 _proposalId, uint256 length) public;
    function canEndVoting(uint256 _proposalId) public view returns (bool);
    function getProposalType(uint256 _proposalId) public view returns (uint8);
    function expiryChangesState(uint256 _proposalId) public view returns (bool);
    function needsProcessing(uint256 _proposalId) public view returns (bool);
    function getMyVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
    function getHasVoteForCurrentMilestoneRelease(address _voter) public view returns (bool);
    function getMyVote(uint256 _proposalId, address _voter) public view returns (bool);

}

/*

 * source       https://github.com/blockbitsio/

 * @name        Milestones Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e28f8b81899ba28c8d958e8b9487cc908d">[email&#160;protected]</a>&gt;

 Contains the Milestones Contract code deployed and linked to the Application Entity

*/









contract Milestones is ApplicationAsset {

    ABIFundingManager FundingManagerEntity;
    ABIProposals ProposalsEntity;
    ABIMeetings MeetingsEntity;

    struct Record {
        bytes32 name;
        string description;                     // will change to hash pointer ( external storage )
        uint8 state;
        uint256 duration;
        uint256 time_start;                     // start at unixtimestamp
        uint256 last_state_change_time;         // time of last state change
        uint256 time_end;                       // estimated end time &gt;&gt; can be increased by proposal
        uint256 time_ended;                     // actual end time
        uint256 meeting_time;
        uint8 funding_percentage;
        uint8 index;
    }

    mapping (uint8 =&gt; Record) public Collection;
    uint8 public currentRecord = 1;

    event DebugRecordRequiredChanges( bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required );
    event DebugCallAgain(uint8 indexed _who);

    event EventEntityProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);
    event EventRecordProcessor(bytes32 indexed _assetName, uint8 indexed _current, uint8 indexed _required);

    event DebugAction(bytes32 indexed _name, bool indexed _allowed);


    function setAssetStates() internal {

        // Contract States
        EntityStates[&quot;__IGNORED__&quot;]                  = 0;
        EntityStates[&quot;NEW&quot;]                          = 1;
        EntityStates[&quot;WAITING&quot;]                      = 2;

        EntityStates[&quot;IN_DEVELOPMENT&quot;]               = 5;

        EntityStates[&quot;WAITING_MEETING_TIME&quot;]         = 10;
        EntityStates[&quot;DEADLINE_MEETING_TIME_YES&quot;]    = 11;
        EntityStates[&quot;DEADLINE_MEETING_TIME_FAILED&quot;] = 12;

        EntityStates[&quot;VOTING_IN_PROGRESS&quot;]           = 20;
        // EntityStates[&quot;VOTING_ENDED&quot;]              = 21;
        EntityStates[&quot;VOTING_ENDED_YES&quot;]             = 22;
        EntityStates[&quot;VOTING_ENDED_NO&quot;]              = 23;
        EntityStates[&quot;VOTING_ENDED_NO_FINAL&quot;]        = 25;

        EntityStates[&quot;VOTING_FUNDS_PROCESSED&quot;]       = 30;
        EntityStates[&quot;FINAL&quot;]                        = 50;

        EntityStates[&quot;CASHBACK_OWNER_MIA&quot;]           = 99;
        EntityStates[&quot;DEVELOPMENT_COMPLETE&quot;]         = 250;

        // Funding Stage States
        RecordStates[&quot;__IGNORED__&quot;]     = 0;
        RecordStates[&quot;NEW&quot;]             = 1;
        RecordStates[&quot;IN_PROGRESS&quot;]     = 2;
        RecordStates[&quot;FINAL&quot;]           = 3;
    }

    function runBeforeInitialization() internal requireNotInitialised {
        FundingManagerEntity = ABIFundingManager( getApplicationAssetAddressByName(&#39;FundingManager&#39;) );
        MeetingsEntity = ABIMeetings( getApplicationAssetAddressByName(&#39;Meetings&#39;) );
        ProposalsEntity = ABIProposals( getApplicationAssetAddressByName(&#39;Proposals&#39;) );
        EventRunBeforeInit(assetName);
    }

    function runBeforeApplyingSettings() internal requireInitialised requireSettingsNotApplied  {
        // setup first milestone
        Record storage rec = Collection[currentRecord];
            rec.time_start = getBylawsProjectDevelopmentStart();
            rec.time_end = rec.time_start + rec.duration;
        EventRunBeforeApplyingSettings(assetName);
    }

    function getBylawsProjectDevelopmentStart() public view returns (uint256) {
        return getAppBylawUint256(&quot;development_start&quot;);
    }

    function getBylawsMinTimeInTheFutureForMeetingCreation() public view returns (uint256) {
        return getAppBylawUint256(&quot;meeting_time_set_req&quot;);
    }

    function getBylawsCashBackVoteRejectedDuration() public view returns (uint256) {
        return getAppBylawUint256(&quot;cashback_investor_no&quot;);
    }

    /*
    * Add Record
    *
    * @param        bytes32 _name
    * @param        string _description
    * @param        uint256 _duration
    * @param        uint256 _funding_percentage
    *
    * @access       public
    * @type         method
    * @modifiers    onlyDeployer, requireNotInitialised
    */
    function addRecord(
        bytes32 _name,
        string _description,
        uint256 _duration,
        uint8   _perc
    )
        public
        onlyDeployer
        requireSettingsNotApplied
    {

        Record storage rec = Collection[++RecordNum];

        rec.name                = _name;
        rec.description         = _description;
        rec.duration            = _duration;
        rec.funding_percentage  = _perc;
        rec.state               = getRecordState(&quot;NEW&quot;);
        rec.index               = RecordNum;
    }

    function getMilestoneFundingPercentage(uint8 recordId) public view returns (uint8){
        return Collection[recordId].funding_percentage;
    }

    function doStateChanges() public {

        var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
        bool callAgain = false;

        DebugRecordRequiredChanges( assetName, CurrentRecordState, RecordStateRequired );
        DebugEntityRequiredChanges( assetName, CurrentEntityState, EntityStateRequired );

        if( RecordStateRequired != getRecordState(&quot;__IGNORED__&quot;) ) {
            // process record changes.
            RecordProcessor(CurrentRecordState, RecordStateRequired);
            DebugCallAgain(2);
            callAgain = true;
        }

        if(EntityStateRequired != getEntityState(&quot;__IGNORED__&quot;) ) {
            // process entity changes.
            EntityProcessor(EntityStateRequired);
            DebugCallAgain(1);
            callAgain = true;
        }


    }

    function MilestonesCanChange() internal view returns (bool) {
        if(
            CurrentEntityState == getEntityState(&quot;WAITING&quot;) ||
            CurrentEntityState == getEntityState(&quot;IN_DEVELOPMENT&quot;) ||
            CurrentEntityState == getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;)
        ) {
            return true;
        }
        return false;
    }


    /*
     * Method: Get Record Required State Changes
     *
     * @access       public
     * @type         method
     *
     * @return       uint8 RecordStateRequired
     */
    function getRecordStateRequiredChanges() public view returns (uint8) {
        Record memory record = Collection[currentRecord];
        uint8 RecordStateRequired = getRecordState(&quot;__IGNORED__&quot;);

        if( ApplicationIsInDevelopment() &amp;&amp; MilestonesCanChange() ) {

            if( record.state == getRecordState(&quot;NEW&quot;) ) {

                if( getTimestamp() &gt;= record.time_start ) {
                    RecordStateRequired = getRecordState(&quot;IN_PROGRESS&quot;);
                }

            } else if( record.state == getRecordState(&quot;IN_PROGRESS&quot;) ) {

                if( getTimestamp() &gt;= record.time_end || ( getTimestamp() &gt;= record.meeting_time &amp;&amp; record.meeting_time &gt; 0 ) ) {
                    RecordStateRequired = getRecordState(&quot;FINAL&quot;);
                }
            }

            if( record.state == RecordStateRequired ) {
                RecordStateRequired = getRecordState(&quot;__IGNORED__&quot;);
            }
        }
        return RecordStateRequired;
    }


    function hasRequiredStateChanges() public view returns (bool) {
        bool hasChanges = false;
        var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();
        CurrentRecordState = 0;

        if( RecordStateRequired != getRecordState(&quot;__IGNORED__&quot;) ) {
            hasChanges = true;
        }
        if(EntityStateRequired != getEntityState(&quot;__IGNORED__&quot;) ) {
            hasChanges = true;
        }

        return hasChanges;
    }

    // view methods decide if changes are to be made
    // in case of tasks, we do them in the Processors.

    function RecordProcessor(uint8 CurrentRecordState, uint8 RecordStateRequired) internal {
        EventRecordProcessor( assetName, CurrentRecordState, RecordStateRequired );
        updateRecord( RecordStateRequired );
    }


    function EntityProcessor(uint8 EntityStateRequired) internal {
        EventEntityProcessor( assetName, CurrentEntityState, EntityStateRequired );

        // Do State Specific Updates
        // Update our Entity State
        CurrentEntityState = EntityStateRequired;

        if ( CurrentEntityState == getEntityState(&quot;DEADLINE_MEETING_TIME_YES&quot;) ) {
            // create meeting
            // Meetings.create(&quot;internal&quot;, &quot;MILESTONE_END&quot;, &quot;&quot;);

        } else if( CurrentEntityState == getEntityState(&quot;VOTING_IN_PROGRESS&quot;) ) {
            // create proposal and start voting on it
            createMilestoneAcceptanceProposal();

        } else if( CurrentEntityState == getEntityState(&quot;WAITING_MEETING_TIME&quot;) ) {

            PostponeMeetingIfApproved();

        } else if( CurrentEntityState == getEntityState(&quot;VOTING_ENDED_YES&quot;) ) {

        } else if( CurrentEntityState == getEntityState(&quot;VOTING_ENDED_NO&quot;) ) {

            // possible cashback time starts from now
            MilestoneCashBackTime = getTimestamp();

        } else if( CurrentEntityState == getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;) ) {
            MilestoneCashBackTime = 0;
            startNextMilestone();
        }

    }

    mapping (bytes32 =&gt; bool) public MilestonePostponingHash;

    function PostponeMeetingIfApproved() internal {
        if(MilestonePostponingHash[ bytes32(currentRecord) ] == false ) {
            if(PostponeForCurrentMilestoneIsApproved()) {
                uint256 time = ProposalsEntity.getCurrentMilestonePostponingProposalDuration();
                Record storage record = Collection[currentRecord];
                record.time_end = record.time_end + time;
                MilestonePostponingHash[ bytes32(currentRecord) ] = true;
            }
        }
    }

    function PostponeForCurrentMilestoneIsApproved() internal view returns ( bool ) {
        uint8 ProposalActionType = ProposalsEntity.getActionType(&quot;MILESTONE_POSTPONING&quot;);
        uint8 ProposalRecordState = ProposalsEntity.getCurrentMilestoneProposalStatusForType( ProposalActionType  );
        if(ProposalRecordState == ProposalsEntity.getRecordState(&quot;VOTING_RESULT_YES&quot;) ) {
            return true;
        }
        return false;
    }

    uint256 public MilestoneCashBackTime = 0;

    function afterVoteNoCashBackTime() public view returns ( bool ) {
        uint256 time =  MilestoneCashBackTime + getBylawsCashBackVoteRejectedDuration();
        // after cash back time
        if(getTimestamp() &gt; time) {
            return true;
        }
        return false;
    }

    function getHash(uint8 actionType, bytes32 arg1, bytes32 arg2) public pure returns ( bytes32 ) {
        return keccak256(actionType, arg1, arg2);
    }

    function getCurrentHash() public view returns ( bytes32 ) {
        return getHash(1, bytes32(currentRecord), 0);
    }

    mapping (bytes32 =&gt; uint256) public ProposalIdByHash;
    function createMilestoneAcceptanceProposal() internal {
        if(ProposalIdByHash[ getCurrentHash() ] == 0x0 ) {
            ProposalIdByHash[ getCurrentHash() ] = ProposalsEntity.createMilestoneAcceptanceProposal();
        }
    }

    function getCurrentProposalId() internal view returns ( uint256 ) {
        return ProposalIdByHash[ getCurrentHash() ];
    }

    function setCurrentMilestoneMeetingTime(uint256 _meeting_time) public onlyDeployer {
        if ( CurrentEntityState == getEntityState(&quot;WAITING_MEETING_TIME&quot;) ) {
            if(MeetingTimeSetFailure() == false ) {
                Record storage record = Collection[currentRecord];
                // minimum x days into the future
                uint256 min = getTimestamp() + getBylawsMinTimeInTheFutureForMeetingCreation();
                // minimum days before end date
                uint256 max = record.time_end + 24 * 3600;
                if(_meeting_time &gt; min &amp;&amp; _meeting_time &lt; max ) {
                    record.meeting_time = _meeting_time;
                }
            } else {
                revert();
            }
        } else {
            revert();
        }
    }

    function startNextMilestone() internal {
        Record storage rec = Collection[currentRecord];

        // set current record end date etc
        rec.time_ended = getTimestamp();
        rec.state = getRecordState(&quot;FINAL&quot;);

        if(currentRecord &lt; RecordNum) {
            // jump to next milestone
            currentRecord++;

            Record storage nextRec = Collection[currentRecord];
                nextRec.time_start = rec.time_ended;
                nextRec.time_end = rec.time_ended + nextRec.duration;
        }

    }

    /*
    * Update Existing Record
    *
    * @param        uint8 _record_id
    * @param        uint8 _new_state
    * @param        uint8 _duration
    *
    * @access       public
    * @type         method
    * @modifiers    onlyOwner, requireInitialised, RecordUpdateAllowed
    *
    * @return       void
    */

    function updateRecord( uint8 _new_state )
        internal
        requireInitialised
        RecordUpdateAllowed(_new_state)
        returns (bool)
    {
        Record storage rec = Collection[currentRecord];
        rec.state       = _new_state;
        return true;
    }


    /*
    * Modifier: Validate if record updates are allowed
    *
    * @type         modifier
    *
    * @param        uint8 _record_id
    * @param        uint8 _new_state
    * @param        uint256 _duration
    *
    * @return       bool
    */

    modifier RecordUpdateAllowed(uint8 _new_state) {
        require( isRecordUpdateAllowed( _new_state )  );
        _;
    }

    /*
     * Method: Validate if record can be updated to requested state
     *
     * @access       public
     * @type         method
     *
     * @param        uint8 _record_id
     * @param        uint8 _new_state
     *
     * @return       bool
     */
    function isRecordUpdateAllowed(uint8 _new_state ) public view returns (bool) {

        var (CurrentRecordState, RecordStateRequired, EntityStateRequired) = getRequiredStateChanges();

        CurrentRecordState = 0;
        EntityStateRequired = 0;

        if(_new_state == uint8(RecordStateRequired)) {
            return true;
        }
        return false;
    }

    /*
     * Method: Get Record and Entity State Changes
     *
     * @access       public
     * @type         method
     *
     * @return       ( uint8 CurrentRecordState, uint8 RecordStateRequired, uint8 EntityStateRequired)
     */
    function getRequiredStateChanges() public view returns (uint8, uint8, uint8) {

        Record memory record = Collection[currentRecord];

        uint8 CurrentRecordState = record.state;
        uint8 RecordStateRequired = getRecordStateRequiredChanges();
        uint8 EntityStateRequired = getEntityState(&quot;__IGNORED__&quot;);

        if( ApplicationIsInDevelopment() ) {

            // Do Entity Checks

            if ( CurrentEntityState == getEntityState(&quot;WAITING&quot;) ) {

                if(RecordStateRequired == getRecordState(&quot;IN_PROGRESS&quot;) ) {
                    // both record and entity states need to move to IN_PROGRESS
                    EntityStateRequired = getEntityState(&quot;IN_DEVELOPMENT&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;IN_DEVELOPMENT&quot;) ) {

                EntityStateRequired = getEntityState(&quot;WAITING_MEETING_TIME&quot;);

            } else if ( CurrentEntityState == getEntityState(&quot;WAITING_MEETING_TIME&quot;) ) {

                if(record.meeting_time &gt; 0) {

                    EntityStateRequired = getEntityState(&quot;DEADLINE_MEETING_TIME_YES&quot;);

                } else {

                    if(MilestonePostponingHash[ bytes32(currentRecord) ] == false) {
                        if(PostponeForCurrentMilestoneIsApproved()) {
                            EntityStateRequired = getEntityState(&quot;WAITING_MEETING_TIME&quot;);
                        }
                    }

                    if(MeetingTimeSetFailure()) {
                        // Force Owner Missing in Action - Cash Back Procedure
                        EntityStateRequired = getEntityState(&quot;DEADLINE_MEETING_TIME_FAILED&quot;);
                    }
                }

            } else if ( CurrentEntityState == getEntityState(&quot;DEADLINE_MEETING_TIME_FAILED&quot;) ) {


            } else if ( CurrentEntityState == getEntityState(&quot;DEADLINE_MEETING_TIME_YES&quot;) ) {

                // create proposal
                // start voting if time passed
                if(getTimestamp() &gt;= record.meeting_time ) {
                    EntityStateRequired = getEntityState(&quot;VOTING_IN_PROGRESS&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;VOTING_IN_PROGRESS&quot;) ) {

                uint8 ProposalRecordState = ProposalsEntity.getProposalState( getCurrentProposalId() );

                if ( ProposalRecordState == ProposalsEntity.getRecordState(&quot;VOTING_RESULT_YES&quot;) ) {
                    EntityStateRequired = getEntityState(&quot;VOTING_ENDED_YES&quot;);
                }

                if (ProposalRecordState == ProposalsEntity.getRecordState(&quot;VOTING_RESULT_NO&quot;) ) {
                    EntityStateRequired = getEntityState(&quot;VOTING_ENDED_NO&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;VOTING_ENDED_YES&quot;) ) {

                if( FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState(&quot;MILESTONE_PROCESS_DONE&quot;)) {
                    EntityStateRequired = getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;VOTING_ENDED_NO&quot;) ) {

                // check if milestone cashout period has passed and if so process fund releases
                if(afterVoteNoCashBackTime()) {
                    EntityStateRequired = getEntityState(&quot;VOTING_ENDED_NO_FINAL&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;VOTING_ENDED_NO_FINAL&quot;) ) {

                if( FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState(&quot;MILESTONE_PROCESS_DONE&quot;)) {
                    EntityStateRequired = getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;);
                }

            } else if ( CurrentEntityState == getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;) ) {


                if(currentRecord &lt; RecordNum) {
                    EntityStateRequired = getEntityState(&quot;IN_DEVELOPMENT&quot;);
                } else {

                    if(FundingManagerEntity.getCurrentMilestoneProcessed() == true) {
                        if(FundingManagerEntity.CurrentEntityState() == FundingManagerEntity.getEntityState(&quot;COMPLETE_PROCESS_DONE&quot;)) {
                            EntityStateRequired = getEntityState(&quot;DEVELOPMENT_COMPLETE&quot;);
                        } else {
                            EntityStateRequired = getEntityState(&quot;VOTING_FUNDS_PROCESSED&quot;);
                        }
                    } else {
                        EntityStateRequired = getEntityState(&quot;IN_DEVELOPMENT&quot;);
                    }
                }

            }
            /*
            else if ( CurrentEntityState == getEntityState(&quot;DEVELOPMENT_COMPLETE&quot;) ) {

            }
            */

        } else {

            if( CurrentEntityState == getEntityState(&quot;NEW&quot;) ) {
                EntityStateRequired = getEntityState(&quot;WAITING&quot;);
            }
        }

        return (CurrentRecordState, RecordStateRequired, EntityStateRequired);
    }

    function ApplicationIsInDevelopment() public view returns(bool) {
        if( getApplicationState() == getApplicationEntityState(&quot;IN_DEVELOPMENT&quot;) ) {
            return true;
        }
        return false;
    }

    function MeetingTimeSetFailure() public view returns (bool) {
        Record memory record = Collection[currentRecord];
        uint256 meetingCreationMaxTime = record.time_end - getBylawsMinTimeInTheFutureForMeetingCreation();
        if(getTimestamp() &gt;= meetingCreationMaxTime ) {
            return true;
        }
        return false;
    }

}