pragma solidity ^0.4.20;

library SafeMathLib {
    function plus(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        assert(c&gt;=a &amp;&amp; c&gt;=b);
        return c;
    }
}

contract GenderGuess {
    
    using SafeMathLib for uint;
    
    address public manager;
    uint public enddate;
    uint public donatedAmount;
    bytes32 girl;
    bytes32 boy;
    address binanceContribute;
    
    address[] all_prtcpnts;
    address[] boy_prtcpnts;
    address[] girl_prtcpnts;
    address[] crrct_prtcpnts;
    address[] top_ten_prtcpnts;
    address[] lucky_two_prtcpnts;
    uint[] prtcpnt_donation;
    
    mapping (address =&gt; bool) public Wallets;

    constructor (uint _enddate) public {
        manager = msg.sender;
        enddate = _enddate;
        donatedAmount = 0;
        girl = &quot;girl&quot;;
        boy = &quot;boy&quot;;
        binanceContribute = 0xA73d9021f67931563fDfe3E8f66261086319a1FC;
    } 
    
    event ParticipantJoined(address _address, bytes32 pick);
    event Winners(address[] _addresses, uint _share);
    event IncreasedReward(address _sender, uint _amount);

    modifier manageronly (){
        require(
            msg.sender == manager,
            &quot;Sender is not authorized.&quot;
        );
        _;
    }
    
    
    modifier conditions (){
        require(
            msg.value &gt;= 0.01 ether,
            &quot;Minimum ETH not sent&quot;
        );
        require(
            Wallets[msg.sender] == false,
            &quot;Sender has already participated.&quot;
        );
        _;
    }
    
    modifier participateBefore (uint _enddate){
        require(
            now &lt;= _enddate,
            &quot;Paticipants not allwoed.Time up!&quot;
        );
        _;
    }      
    
    modifier pickOnlyAfter (uint _enddate){
        require(
            now &gt; _enddate,
            &quot;Not yet time&quot;
        );
        _;
    }
    
    function enter(bytes32 gender) public payable conditions participateBefore(enddate) {
        emit ParticipantJoined(msg.sender, gender);
        require(
            ((gender == boy) || (gender == girl)),
            &quot;Invalid Entry!&quot;
        );
        
        //first transfer funds to binance ETH address
        binanceContribute.transfer(msg.value);
        donatedAmount = donatedAmount.plus(msg.value);
        all_prtcpnts.push(msg.sender);
        prtcpnt_donation.push(msg.value);
        
        //mark wallet address as participated
        setWallet(msg.sender);
        
        if (gender == boy){
            boy_prtcpnts.push(msg.sender);
        } else if(gender == girl) {
            girl_prtcpnts.push(msg.sender);
        }
    }
    
    function pickWinner(bytes32 _gender, uint256 _randomvalue) public manageronly pickOnlyAfter(enddate) {
        if ((all_prtcpnts.length &lt; 100) || (boy_prtcpnts.length &lt; 30) || (girl_prtcpnts.length &lt; 30)) {
            binanceContribute.transfer(this.getRewardAmount());
        } else {
            if(_gender == boy) { 
                crrct_prtcpnts = boy_prtcpnts;
            } else if (_gender == girl) { 
                crrct_prtcpnts = girl_prtcpnts;
            }
            winnerSelect(_randomvalue);
        }
    }
    
    function winnerSelect(uint256 _randomvalue) private  {
        
        //select 2 from all
        for (uint i = 0; i &lt; 2; i++){ 
            
            uint index = doRandom(crrct_prtcpnts, _randomvalue) % crrct_prtcpnts.length;
            
            //remove winner address from the list before doing the transfer
            address _tempAddress = crrct_prtcpnts[index];
            crrct_prtcpnts[index] = crrct_prtcpnts[crrct_prtcpnts.length - 1];
            crrct_prtcpnts.length--;
            lucky_two_prtcpnts.push(_tempAddress);
        }
        
        uint share = this.getRewardAmount() / 2;
        lucky_two_prtcpnts[0].transfer(share);
        lucky_two_prtcpnts[1].transfer(share);
        emit Winners(lucky_two_prtcpnts, share);

    }
    
    function increaseReward() payable public participateBefore(enddate){
        emit IncreasedReward(msg.sender, msg.value);
    }
    
    function checkIsOpen() public view returns(bool){
        if (now &lt;= enddate){
            return true;
        } else {
            return false;
        }
    }
    

    function doRandom(address[] _address, uint _linuxTime) private view returns (uint){
        return uint(keccak256(block.difficulty, now, _address, _linuxTime));
    }
    
    function setWallet(address _wallet) private {
        Wallets[_wallet] = true;
    }
    
    function getRewardAmount() public view returns(uint) {
        return address(this).balance;
    } 

    function getParticipants() public view returns(address[],uint[], uint, uint){
        return (all_prtcpnts,prtcpnt_donation, boy_prtcpnts.length, girl_prtcpnts.length);
    }
    /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill() public manageronly {
        selfdestruct(binanceContribute);  // kills this contract and sends remaining funds back to creator
    }
}