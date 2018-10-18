pragma solidity ^0.4.24;


library itMaps {

    /* itMapAddressUint

    address => Uint

    */

    struct entryAddressUint {

    // Equal to the index of the key of this item in keys, plus 1.

    uint keyIndex;

    uint value;

    }

    struct itMapAddressUint {

    mapping(address => entryAddressUint) data;

    address[] keys;

    }

    function insert(itMapAddressUint storage self, address key, uint value) internal returns (bool replaced) {

        entryAddressUint storage e = self.data[key];

        e.value = value;

        if (e.keyIndex > 0) {

            return true;

        } else {

            e.keyIndex = ++self.keys.length;

            self.keys[e.keyIndex - 1] = key;

            return false;

        }

    }

    function remove(itMapAddressUint storage self, address key) internal returns (bool success) {

        entryAddressUint storage e = self.data[key];

        if (e.keyIndex == 0)

        return false;

        if (e.keyIndex <= self.keys.length) {

            // Move an existing element into the vacated key slot.

            self.data[self.keys[self.keys.length - 1]].keyIndex = e.keyIndex;

            self.keys[e.keyIndex - 1] = self.keys[self.keys.length - 1];

            self.keys.length -= 1;

            delete self.data[key];

            return true;

        }

    }

    function destroy(itMapAddressUint storage self) internal {

        for (uint i; i<self.keys.length; i++) {

            delete self.data[ self.keys[i]];

        }

        delete self.keys;

        return ;
    }

    function contains(itMapAddressUint storage self, address key) internal constant returns (bool exists) {
        return self.data[key].keyIndex > 0;
    }

    function size(itMapAddressUint storage self) internal constant returns (uint) {

        return self.keys.length;

    }

    function get(itMapAddressUint storage self, address key) internal constant returns (uint) {
        return self.data[key].value;
    }

    function getKeyByIndex(itMapAddressUint storage self, uint idx) internal constant returns (address) {
        return self.keys[idx];
    }

    function getValueByIndex(itMapAddressUint storage self, uint idx) internal constant returns (uint) {
        return self.data[self.keys[idx]].value;
    }

}

contract ERC20 {
    function totalSupply() public constant returns (uint256 supply);
    function balanceOf(address who) public constant returns (uint value);
    function allowance(address owner, address spender) public constant returns (uint permited);

    function transfer(address to, uint value) public returns (bool ok);
    function transferFrom(address from, address to, uint value) public returns (bool ok);
    function approve(address spender, uint value) public returns (bool ok);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract HyipProfit is ERC20{
    using itMaps for itMaps.itMapAddressUint;

    string public constant name = "HYIP Profit";
    string public constant symbol = "HYIP";
    uint8 public constant decimals = 0;

    uint256 initialSupply = 4500000;

    uint256 constant preSaleSoftCap = 312500;

    uint256 public preSaleFund = 0;
    uint256 public spentFunds = 0;
    uint256 public IcoFund = 0;

    uint public soldTokens = 0; //reduces when somebody returns money

    itMaps.itMapAddressUint tokenBalances; //amount of tokens each address holds
    mapping (address => uint256) preSaleWeiBalances;
    mapping (address => uint256) weiBalances; //amount of Wei, paid for tokens that smb holds. Used only before project completed.
    mapping (address => uint256) dividends;
    mapping (address => uint256) lastWithdraw;

    uint public currentStage = 0;

    bool public isICOfinalized = false;

    address public HyipProfitTokenTeamAddress;
    address public dividendsPoolAddress = 0x0;
    addressGetter ag;

    modifier onlyTeam {
        if (msg.sender == HyipProfitTokenTeamAddress) {
            _;
        }
    }

    mapping (address => mapping (address => uint256)) allowed;
    mapping (uint => address) teamAddresses;

    event StageSubmittedAndEtherPassedToTheTeam(uint stage, uint when, uint weiAmount);
    event etherWithdrawFromTheContract(address tokenHolder, uint numberOfTokensSoldBack, uint weiValue);
    event Burned(address indexed from, uint amount);
    event DividendsTransfered(address to, uint weiAmount);

    // ERC20 interface implementation

    function totalSupply() public constant returns (uint256) {
        return initialSupply;
    }

    function balanceOf(address tokenHolder) public view returns (uint256 balance) {
        return tokenBalances.get(tokenHolder);
    }

    function allowance(address owner, address spender) public constant returns (uint256) {
        return allowed[owner][spender];
    }

    function transfer(address to, uint value) public returns (bool success) {
        if (tokenBalances.get(msg.sender) >= value && value > 0) {
            if (to == address(this)) { // if you send even 1 token back to the contract, it will return all available funds to you
                returnAllAvailableFunds();
                return true;
            }
            else {
                return transferTokensAndEtherValue(msg.sender, to, value, getHoldersAverageTokenPrice(msg.sender) * value, getUsersPreSalePercentage(msg.sender));
            }
        } else return false;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool success) {
        if (tokenBalances.get(from)>=value && allowed[from][to] >= value && value > 0) {
            if (transferTokensAndEtherValue(from, to, value, getHoldersAverageTokenPrice(from) * value, getUsersPreSalePercentage(from))){
                allowed[from][to] -= value;
                return true;
            }
            return false;
        }
        return false;
    }

    function approve(address spender, uint value) public returns (bool success) {
        if ((value != 0) && (tokenBalances.get(msg.sender) >= value)){
            allowed[msg.sender][spender] = value;
            emit Approval (msg.sender, spender, value);
            return true;
        } else{
            return false;
        }
    }

    // Constructor, fallback, return funds

    constructor () public {
        HyipProfitTokenTeamAddress = msg.sender;
        tokenBalances.insert(address(this), initialSupply);
        teamAddresses[0] = HyipProfitTokenTeamAddress;
        teamAddresses[1] = HyipProfitTokenTeamAddress;
        teamAddresses[2] = 0x1F16BE21574FA46846fCfeae5ef587c29200f93e;
        teamAddresses[3] = HyipProfitTokenTeamAddress;
        teamAddresses[4] = 0x71bAfdD5bd44D3e1038fE4c0Bc486fb4BB67b806;
    }

    function () public payable {
        require (!isICOfinalized);
        uint currentPrice = getCurrentSellPrice();
        uint valueInWei = 0;
        uint tokensToPass = 0;
        uint preSalePercent = 0;

        require (msg.value >= currentPrice);

        if (!tokenBalances.contains(msg.sender))
        tokenBalances.insert(msg.sender, 0);

        tokensToPass = msg.value / currentPrice;

        require (tokenBalances.get(address(this))>= tokensToPass);

        valueInWei = tokensToPass * currentPrice;
        soldTokens += tokensToPass;

        if (currentStage == 0) {
            preSaleWeiBalances [address(this)] += valueInWei;
            preSalePercent = 100;
            preSaleFund += msg.value;
        }
        else {
            weiBalances[address(this)] += valueInWei;
            preSalePercent = 0;
            IcoFund += msg.value;
        }

        transferTokensAndEtherValue(address(this), msg.sender, tokensToPass, valueInWei, preSalePercent);
    }

    function returnAllAvailableFunds() public {
        require (tokenBalances.contains(msg.sender)); //you need to be a tokenHolder
        require (!isICOfinalized); //you can not return tokens after project is completed

        uint preSaleWei = getPreSaleWeiToReturn(msg.sender);
        uint IcoWei = getIcoWeiToReturn(msg.sender);
        uint weiToReturn = preSaleWei + IcoWei;

        uint amountOfTokensToReturn = tokenBalances.get(msg.sender);

        require (amountOfTokensToReturn>0);

        uint preSalePercentage = getUsersPreSalePercentage(msg.sender);

        transferTokensAndEtherValue(msg.sender, address(this), amountOfTokensToReturn, weiToReturn, preSalePercentage);
        emit etherWithdrawFromTheContract(msg.sender, amountOfTokensToReturn, IcoWei + preSaleWei);
        preSaleWeiBalances[address(this)] -= preSaleWei;
        weiBalances[address(this)] -= IcoWei;
        soldTokens -= amountOfTokensToReturn;
        msg.sender.transfer(weiToReturn);

        preSaleFund -= preSaleWei;
        IcoFund -= IcoWei;
    }

    // View functions

    function getWeiBalance(address a) public view returns (uint) {
        return weiBalances[a];
    }

    function getPreSaleFund() public view returns (uint fund) {
        return preSaleFund;
    }

    function getIcoFund() public view returns (uint fund) {
        return IcoFund;
    }

    function getUsersPreSalePercentage(address a) public view returns (uint preSaleTokensPercent) {
        return (100 * preSaleWeiBalances[a]) / (preSaleWeiBalances[a] + weiBalances[a]);
    }

    function getDividends(address a) public view returns (uint) {
        return dividends[a];
    }

    function getTotalWeiAvailableToReturn(address a) public view returns (uint amount) {
        return getPreSaleWeiToReturn(a) + getIcoWeiToReturn(a);
    }

    function getPreSaleWeiToReturn (address holder) public view returns (uint amount) {
        if (currentStage == 0) return preSaleWeiBalances[holder];
        if (currentStage == 1) return preSaleWeiBalances[holder] * 70 / 100;
        if (currentStage == 2) return preSaleWeiBalances[holder] * 40 / 100;
        return 0;
    }

    function getIcoWeiToReturn (address holder) public view returns (uint amount) {
        if (currentStage <= 3) return weiBalances[holder];
        if (currentStage == 4) return weiBalances[holder] * 70 / 100;
        if (currentStage == 5) return weiBalances[holder] * 40 / 100;
        return 0;
    }

    function getHoldersAverageTokenPrice(address holder) public view returns (uint avPriceInWei) {
        return (weiBalances[holder] + preSaleWeiBalances[holder])/ tokenBalances.get(holder);
    }

    function getCurrentSellPrice() public view returns (uint priceInWei) {
        if (currentStage == 0) return 10**14 * 8 ; //this is equal to 0.0008 ETH

        if (currentStage == 1) return 10**14 * 16;
        if (currentStage == 2) return 10**14 * 24;
        if (currentStage == 3) return 10**14 * 32;

        return 0;
    }

    function getCurrentStage() public view returns (uint stage) {
        return currentStage;
    }

    function getAvailableFundsForTheTeam() public view returns (uint amount) {
        if (currentStage == 1) return preSaleFund * 3 / 10;
        if (currentStage == 2) return (preSaleFund  - spentFunds) / 2;
        if (currentStage == 3) return preSaleFund - spentFunds;

        if (currentStage == 4) return IcoFund * 3 / 10;
        if (currentStage == 5) return (IcoFund   - spentFunds) / 2;
        if (currentStage == 6) return address(this).balance;
    }

    // Team functions
    function setDividendsPoolAddressOnce(address a) public onlyTeam {
        if (dividendsPoolAddress == 0x0) {
            dividendsPoolAddress = a;
            ag = addressGetter(a);
        }
    }

    function finalizeICO() internal onlyTeam {
        require(!isICOfinalized); // this function can be called only once
        passTokensToTheTeam();
        burnUndistributedTokens(); // undistributed tokens are destroyed
        isICOfinalized = true;
    }

    function passTokensToTheTeam() internal returns (uint tokenAmount) { //This function passes tokens to the team without weiValue, so the team can not withdraw ether by returning tokens to the contract
        uint tokensToPass = soldTokens / 4;
        uint tokensForEachMember = tokensToPass / 5;

        for (uint i = 0; i< 5; i += 1) {
            address teamMember = teamAddresses[i];
            if (!tokenBalances.contains(teamMember))
                tokenBalances.insert(teamMember, tokensForEachMember);
            else (tokenBalances.insert(teamMember, tokenBalances.get(teamMember) + tokensForEachMember));
            emit Transfer(address(this), teamMember, tokensForEachMember);
        }

        soldTokens += tokensToPass;
        return tokensToPass;
    }

    function checkIfMissionCompleted() public view returns (bool success) {
        if (currentStage == 0 && soldTokens >= preSaleSoftCap) return true;

        if (currentStage == 1 && (preSaleFund*3/10)*2 <= IcoFund) return true;
        if (currentStage == 2 && (preSaleFund*6/10)*2 <= IcoFund) return true;

        if (currentStage>=3 &&
        (dividendsPoolAddress == 0x0 ||
        ag.getDividendsTokenAddress() != address(this))) return false;

        if (currentStage == 3 && preSaleFund*2 <= IcoFund) return true;

        if (currentStage == 4 && dividendsPoolAddress.balance >= (IcoFund * 3/10)*2 ) return true;
        if (currentStage == 5 && dividendsPoolAddress.balance >= (IcoFund * 6/10)*2 ) return true;
        if (currentStage == 6 && dividendsPoolAddress.balance >= (IcoFund)*2 ) return true;

        return false;
    }

    function submitNextStage() public onlyTeam returns (bool success) {
        if (!checkIfMissionCompleted()) return false;
        if (currentStage==3) spentFunds = 0;
        if (currentStage == 6) finalizeICO();

        currentStage += 1;
        passEtherToTheTeam();

        return true;
    }

    function passEtherToTheTeam() internal returns (bool success) {
        uint weiAmount = getAvailableFundsForTheTeam();
        HyipProfitTokenTeamAddress.transfer(weiAmount);
        spentFunds += weiAmount;
        emit StageSubmittedAndEtherPassedToTheTeam(currentStage, now, weiAmount);
        return true;
    }

    function transferTokensAndEtherValue(address from, address to, uint value, uint weiValue, uint preSalePercent) internal returns (bool success){
        if (tokenBalances.contains(from) && tokenBalances.get(from) >= value) {
            tokenBalances.insert(to, tokenBalances.get(to) + value);
            tokenBalances.insert(from, tokenBalances.get(from) - value);

            if (tokenBalances.get(from) == 0)
                tokenBalances.remove(from);

            if (!isICOfinalized) {
                preSaleWeiBalances[from] -= weiValue * preSalePercent / 100;
                preSaleWeiBalances[to] += weiValue * preSalePercent / 100;

                weiBalances[from] -= weiValue * (100 - preSalePercent) / 100;
                weiBalances[to] += weiValue * (100 - preSalePercent) / 100;
            }

            lastWithdraw[to] = now;

            emit Transfer(from, to, value);
            return true;
        }
        return false;
    }

    function burnUndistributedTokens() internal {
        uint toBurn = initialSupply - soldTokens;
        initialSupply -=  toBurn;
        tokenBalances.insert(address(this), 0);
        emit Burned(address(this), toBurn);
    }
}

contract addressGetter {
    function getDividendsTokenAddress() public constant returns (address);
}