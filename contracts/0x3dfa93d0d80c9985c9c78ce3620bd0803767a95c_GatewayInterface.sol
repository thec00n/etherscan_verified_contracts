pragma solidity ^0.4.17;

/*

 * source       https://github.com/blockbitsio/

 * @name        Application Entity Generic Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="076a6e646c7e476968706b6e7162297568">[email protected]</a>>

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
    mapping (bytes32 => uint8) public EntityStates;
    mapping (bytes32 => address) public AssetCollection;
    mapping (uint8 => bytes32) public AssetCollectionIdToName;
    mapping (bytes32 => uint256) public BylawsUint256;
    mapping (bytes32 => bytes32) public BylawsBytes32;

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

 * @name        Gateway Interface Contract
 * @package     BlockBitsIO
 * @author      Micky Socaci <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="ff92969c9486bf9190889396899ad18d90">[email protected]</a>>

 Used as a resolver to retrieve the latest deployed version of the Application

 ENS: gateway.main.blockbits.eth will point directly to this contract.

    ADD ENS domain ownership / transfer methods

*/





contract GatewayInterface {

    event EventGatewayNewLinkRequest ( address indexed newAddress );
    event EventGatewayNewAddress ( address indexed newAddress );

    address public currentApplicationEntityAddress;
    ApplicationEntityABI private currentApp;

    address public deployerAddress;

    function GatewayInterface() public {
        deployerAddress = msg.sender;
    }

    /**
    @notice Get current ApplicationEntity Contract address
    @return {
        "currentApplicationEntityAddress": Currently bound application address
    }
    */
    function getApplicationAddress() external view returns (address) {
        return currentApplicationEntityAddress;
    }


    /**
    @notice ApplicationEntity Contract requests to be linked
    @dev modifier validCodeUpgradeInitiator
    @param _newAddress address, The address of the application contract
    @param _sourceCodeUrl bytes32, The url of the application source code on etherscan
    @return {
        "bool": TRUE if successfully processed
    }
    */
    function requestCodeUpgrade( address _newAddress, bytes32 _sourceCodeUrl )
        external
        validCodeUpgradeInitiator
        returns (bool)
    {
        require(_newAddress != address(0x0));

        EventGatewayNewLinkRequest ( _newAddress );

        /*
            case 1 - Newly Deployed Gateway and Application

            gateway links to app and initializes
        */
        if(currentApplicationEntityAddress == address(0x0)) {

            if(!ApplicationEntityABI(_newAddress).initializeAssetsToThisApplication()) {
                revert();
            }
            link(_newAddress);
            return true;
        } else {
            /*
                case 2 - Actual Code Upgrade Request

                - Current app should exist already
                - Current app
                    - Create a proposal
                    - Vote on result
                    - Get Result
                    - Approve Result
            */
            currentApp.createCodeUpgradeProposal(_newAddress, _sourceCodeUrl);
        }
    }

    /**
    @notice ApplicationEntity Contract approves code Upgrade
    @dev modifier onlyCurrentApplicationEntity
    @param _newAddress address, The address of the new application contract
    @return {
        "bool": TRUE if successfully processed
    }
    */
    function approveCodeUpgrade( address _newAddress ) external returns (bool) {
        require(msg.sender == currentApplicationEntityAddress);
        uint8 atState = currentApp.CurrentEntityState();
        lockCurrentApp();
        if(!currentApp.transferAssetsToNewApplication(_newAddress)) {
            revert();
        }
        link(_newAddress);
        currentApp.setUpgradeState( atState );
        return true;
    }

    /**
    @notice Locks current application entity
    @dev Internally used by gateway to lock current application entity before switching to the new one
    */
    function lockCurrentApp() internal {
        if(!currentApp.lock()) {
            revert();
        }
    }

    /**
    @notice Link to new Application Entity
    @param _newAddress address, The address of the new application contract
    @return {
        "bool": TRUE if successfully processed
    }
    */
    function link( address _newAddress ) internal returns (bool) {

        currentApplicationEntityAddress = _newAddress;
        currentApp = ApplicationEntityABI(currentApplicationEntityAddress);
        if( !currentApp.initialize() ) {
            revert();
        }
        EventGatewayNewAddress(currentApplicationEntityAddress);
        return true;
    }


    /**
    @notice Get current News Contract address
    @return {
        "address": 0x address of the News Contract
    }
    */
    function getNewsContractAddress() external view returns (address) {
        return currentApp.NewsContractEntity();
    }

    /**
    @notice Get current Listing Contract address
    @return {
        "address": 0x address of the Listing Contract
    }
    */
    function getListingContractAddress() external view returns (address) {
        return currentApp.ListingContractEntity();
    }

    /*
    * Validates if new application's deployer is allowed to upgrade current app
    */

    /**
    @notice Validates if new application's deployer is allowed to upgrade current app
    */
    modifier validCodeUpgradeInitiator() {
        bool valid = false;

        ApplicationEntityABI newDeployedApp = ApplicationEntityABI(msg.sender);
        address newDeployer = newDeployedApp.deployerAddress();

        if(newDeployer == deployerAddress) {
            valid = true;
        } else {
            if(currentApplicationEntityAddress != address(0x0)) {
                currentApp = ApplicationEntityABI(currentApplicationEntityAddress);
                if(currentApp.canInitiateCodeUpgrade(newDeployer)) {
                    valid = true;
                }
            }
        }

        // ok if current app accepts newDeployer as a token holder that can do a code upgrade
        // ok if newDeployer is oldDeployer
        require( valid == true );
        _;
    }
}