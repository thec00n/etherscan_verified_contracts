pragma solidity 0.4.24;
pragma experimental "v0.5.0";
library SafeMath {

  // We use `pure` bbecause it promises that the value for the function depends ONLY
  // on the function arguments
    function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

interface RTCoinInterface {
    

    /** Functions - ERC20 */
    function transfer(address _recipient, uint256 _amount) external returns (bool);

    function transferFrom(address _owner, address _recipient, uint256 _amount) external returns (bool);

    function approve(address _spender, uint256 _amount) external returns (bool approved);

    /** Getters - ERC20 */
    function totalSupply() external view returns (uint256);

    function balanceOf(address _holder) external view returns (uint256);

    function allowance(address _owner, address _spender) external view returns (uint256);

    /** Getters - Custom */
    function mint(address _recipient, uint256 _amount) external returns (bool);

    function stakeContractAddress() external view returns (address);

    function mergedMinerValidatorAddress() external view returns (address);
    
    /** Functions - Custom */
    function freezeTransfers() external returns (bool);

    function thawTransfers() external returns (bool);
}


/// @title This contract is used to handle vesting of the RTC token
/// @author Postables, RTrade Technologies Ltd
/// @dev We able V5 for safety features, see https://solidity.readthedocs.io/en/v0.4.24/security-considerations.html#take-warnings-seriously
contract Vesting {

    using SafeMath for uint256;

    // these will need to be changed prior to deployment
    address constant public TOKENADDRESS = 0xecc043b92834c1ebDE65F2181B59597a6588D616;
    RTCoinInterface constant public RTI = RTCoinInterface(TOKENADDRESS);
    string constant public VERSION = "production";

    address public admin;

    // keeps track of the state of a vest
    enum VestState {nil, vesting, vested}

    struct Vest {
        // total amount of coins vesting
        uint256 totalVest;
        // the times at which the tokens will unlock
        uint256[] releaseDates;
        // the amount of tokens to unlock at each interval
        uint256[] releaseAmounts;
        VestState state;
        // keeps track of what tokens have been unlocked
        mapping (uint256 => bool) claimed;
    }

    // Keeps track of token vests
    mapping (address => Vest) public vests;

    // make sure that they are using a valid vest index
    modifier validIndex(uint256 _vestIndex) {
        require(_vestIndex < vests[msg.sender].releaseDates.length, "attempting to access invalid vest index must be less than length of array");
        _;
    }

    // make sure that the claim date has been passed
    modifier pastClaimDate(uint256 _vestIndex) {
        require(now >= vests[msg.sender].releaseDates[_vestIndex], "attempting to claim vest before release date");
        _;
    }

    // make sure that the vest is not yet claimed
    modifier unclaimedVest(uint256 _vestIndex) {
        require(!vests[msg.sender].claimed[_vestIndex], "vest must be unclaimed");
        _;
    }

    // make sure that the vest is active
    modifier activeVester() {
        require(vests[msg.sender].state == VestState.vesting, "vest must be active");
        _;
    }

    // make sure that the user has no active vests going on
    modifier nonActiveVester(address _vester) {
        require(vests[_vester].state == VestState.nil, "address must not have an active vest");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "sender must be admin");
        _;
    }

    constructor(address _admin) public {
        // prevent deployments if not properly setup
        require(TOKENADDRESS != address(0), "token address not set");
        admin = _admin;
    }

    /** @notice Used to deposit a vest for someone
        * Mythril will report an overflow here, however it is a false positive
        * @dev Yes we are looping, however we have the ability to ensure that the block gas limit will never be reached
        * @param _vester This is the person for whom vests are being enabled
        * @param _totalAmountToVest This is the total amount of coins being vested
        * @param _releaseDates These are the dates at which tokens will be unlocked
        * @param _releaseAmounts these are the amounts of tokens to be unlocked at each date
     */
    function addVest(
        address _vester,
        uint256 _totalAmountToVest,
        uint256[] _releaseDates, // unix time stamp format `time.Now().Unix()` in golang
        uint256[] _releaseAmounts)
        public
        nonActiveVester(_vester)
        onlyAdmin
        returns (bool)
    {
        require(_releaseDates.length > 0 && _releaseAmounts.length > 0 && _totalAmountToVest > 0, "attempting to use non zero values");
        require(_releaseDates.length == _releaseAmounts.length, "array lengths are not equal");
        uint256 total;
        for (uint256 i = 0; i < _releaseAmounts.length; i++) {
            total = total.add(_releaseAmounts[i]);
            require(now < _releaseDates[i], "release date must be in the future");
        }
        require(total == _totalAmountToVest, "invalid total amount to vest");
        Vest memory v = Vest({
            totalVest: _totalAmountToVest,
            releaseDates: _releaseDates,
            releaseAmounts: _releaseAmounts,
            state: VestState.vesting
        });
        vests[_vester] = v;
        require(RTI.transferFrom(msg.sender, address(this), _totalAmountToVest), "transfer from failed, most likely needs approval");
        return true;
    }


    /** @notice Used to withdraw unlocked vested tokens
        * @dev Yes we are looping, but as we can control the total number of loops, etc.. we can ensure that the block gas limit will never be reached
        * @notice IF YOU ARE WITHDRAWING THE LAST VEST (LAST INDEX) YOU MUST HAVE WITHDRAWN ALL OTHER VESTS FIRST OR THE TX WILL FAIL
        * @param _vestIndex the particular vest to be withdrawn
     */
    function withdrawVestedTokens(
        uint256 _vestIndex)
        public
        activeVester
        validIndex(_vestIndex)
        unclaimedVest(_vestIndex)
        pastClaimDate(_vestIndex)
        returns (bool)
    {
        // if this is the last vest, make sure all others have been claimed and then mark as vested
        if (_vestIndex == vests[msg.sender].releaseAmounts.length.sub(1)) {
            bool check;
            for (uint256 i = 0; i < vests[msg.sender].releaseAmounts.length; i++) {
                // if we detect that even one vest hasn't been claimed, set check to false and break out of loop
                if (!vests[msg.sender].claimed[i]) {
                    // this will preventsituations where the first vest may not be claimed but later ones have been
                    // which would result in a "split brain" type scenario, in which the code thinks all vests have been claimed
                    // but they actually haven't
                    check = false;
                    // break out of the loop
                    break;
                }
                check = true;
            }
            // if they are attempting to withdraw the last vest, this must be true or else the tx will revert
            require(check, "not all vests have been withdrawn before attempting to withdraw final vest");
            // as this is the last vest, we must mark everything as having been vested, preventing further invocations
            vests[msg.sender].state = VestState.vested;
        }
        // mark this particular vest as claimed
        vests[msg.sender].claimed[_vestIndex] = true;
        uint256 amount = vests[msg.sender].releaseAmounts[_vestIndex];
        require(RTI.transfer(msg.sender, amount), "failed to transfer");
        return true;
    }
}