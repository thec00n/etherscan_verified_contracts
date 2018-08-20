pragma solidity ^0.4.18;
/**
* @title ICO CONTRACT
* @dev ERC-20 Token Standard Compliant
* @author Fares A. Akel C. <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="d1b7ffb0bfa5bebfb8beffb0bab4bd91b6bcb0b8bdffb2bebc">[email protected]</a>
*/

/**
 * @title SafeMath by OpenZeppelin
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract token {

    function balanceOf(address _owner) public constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);

    }

contract DateTimeAPI {
        
        function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) constant returns (uint timestamp);

}

contract FiatContract {

  function USD(uint _id) constant returns (uint256);

}


contract ICO {

    DateTimeAPI dateTimeContract = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);
    FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS

    using SafeMath for uint256;
    enum State {
    //This ico have 4 states
        stage1, //PreSales
        stage2, //PreICo
        stage3, //ICO
        Successful
    }
    //public variables
    State public state = State.stage1; //Set initial stage
    uint256 public startTime = now; //block-time when it was deployed
    uint256 public totalRaised; //eth in wei
    uint256 public totalDistributed; //tokens
    uint256 public ICOdeadline;
    uint256 public completedAt;
    token public tokenReward;
    address public creator;
    string public campaignUrl;
    string public version = '1';

    //events for log
    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
    event LogBeneficiaryPaid(address _beneficiaryAddress);
    event LogFundingSuccessful(uint _totalRaised);
    event LogFunderInitialized(
        address _creator,
        string _url,
        uint256 _ICOdeadline);
    event LogContributorsPayout(address _addr, uint _amount);

    modifier notFinished() {
        require(state != State.Successful);
        _;
    }
    /**
    * @notice ICO constructor
    * @param _campaignUrl is the ICO _url
    * @param _addressOfTokenUsedAsReward is the token totalDistributed
    */
    function ICO ( string _campaignUrl, token _addressOfTokenUsedAsReward ) public {

        creator = msg.sender;
        campaignUrl = _campaignUrl;
        tokenReward = _addressOfTokenUsedAsReward;
        ICOdeadline = dateTimeContract.toTimestamp(2018,7,31,23,59); // Jul 31

        LogFunderInitialized(
            creator,
            campaignUrl,
            ICOdeadline);
            
    }

    /**
    * @notice contribution handler
    */
    function contribute() public notFinished payable {

        uint256 tokenBought = 0;
        uint256 usdCentInWei = price.USD(0);
        uint baseCalc = usdCentInWei.div(10 ** 2); //it will give 2 decimals numbers to the result

        totalRaised = totalRaised.add(msg.value);

        //Rate of exchange depends on stage
        if (state == State.stage1){

            baseCalc = baseCalc.mul(15); //15 cents per token
            tokenBought = msg.value.div(baseCalc);
        
        } else if (state == State.stage2){
        
            baseCalc = baseCalc.mul(27); //27 cents per token
            tokenBought = msg.value.div(baseCalc);
        
        } else if (state == State.stage3){
        
            baseCalc = baseCalc.mul(35); //35 cents per token
            tokenBought = msg.value.div(baseCalc);
        
        }

        if(msg.value >= usdCentInWei.mul(5000000)){ // 5.000.000 cents = 50.000,00 $

            tokenBought = tokenBought.mul(2); // +100%

        } else if(msg.value >= usdCentInWei.mul(2000000)){ // 2.000.000 cents = 20.000,00 $

            tokenBought = tokenBought.mul(18);
            tokenBought = tokenBought.div(10); // +80%            

        } else if(msg.value >= usdCentInWei.mul(1000000)){ // 1.000.000 cents = 10.000,00 $

            tokenBought = tokenBought.mul(16);
            tokenBought = tokenBought.div(10); // +60%            

        } else if(msg.value >= usdCentInWei.mul(500000)){ // 500.000 cents = 5.000,00 $

            tokenBought = tokenBought.mul(14);
            tokenBought = tokenBought.div(10); // +40%            

        } else if(msg.value >= usdCentInWei.mul(100000)){ // 100.000 cents = 1.000,00 $

            tokenBought = tokenBought.mul(12);
            tokenBought = tokenBought.div(10); // +20%            

        }

        totalDistributed = totalDistributed.add(tokenBought);
        
        tokenReward.transfer(msg.sender, tokenBought);

        LogFundingReceived(msg.sender, msg.value, totalRaised);
        LogContributorsPayout(msg.sender, tokenBought);

        checkIfFundingCompleteOrExpired();
    }

    /**
    * @notice check status
    */
    function checkIfFundingCompleteOrExpired() public {

        if(state == State.stage1 && now > dateTimeContract.toTimestamp(2018,5,31,23,59)){ // May 31

            state = State.stage2;

        } else if(state == State.stage2 && now > dateTimeContract.toTimestamp(2018,6,30,23,59)){ // Jun 30

            state = State.stage3;
            
        } else if(state == State.stage3 && now > ICOdeadline && state!=State.Successful){

            state = State.Successful; //ico becomes Successful
            completedAt = now; //ICO is complete

            LogFundingSuccessful(totalRaised); //we log the finish
            finished(); //and execute closure

        }

    }

    /**
    * @notice closure handler
    */
    function finished() public { //When finished eth are transfered to creator

        require(state == State.Successful);
        uint256 remanent = tokenReward.balanceOf(this);

        require(creator.send(this.balance));
        tokenReward.transfer(creator,remanent);

        LogBeneficiaryPaid(creator);
        LogContributorsPayout(creator, remanent);

    }

    /*
    * @dev direct payments handle
    */

    function () public payable {
        
        contribute();

    }
}