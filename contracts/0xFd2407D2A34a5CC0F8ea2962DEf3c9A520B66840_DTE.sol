contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

contract MyToken {
    uint8 public decimals;
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
    function MyToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
        );
    function transfer(address _to, uint256 _value);
    function approveAndCall(address _spender, uint256 _value, bytes _extraData);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
}

contract DTE {
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint public amountOfHolders;
    uint public totalSellOrders;
    uint public totalBuyOrders;
    uint public totalTokens;
    uint public totalDividendPayOuts;
    string public solidityCompileVersion = &quot;v0.3.6-2016-09-08-acd334c&quot;;
    string public takerFeePercent = &quot;1%&quot;;
    string public tokenAddFee = &quot;0.1 ether&quot;;

    struct sellOrder {
        bool isOpen;
        bool isTaken;
        address seller;
        uint soldTokenNo;
        uint boughtTokenNo;
        uint256 soldAmount;
        uint256 boughtAmount;
    }
    
    struct buyOrder {
        bool isOpen;
        bool isTaken;
        address buyer;
        uint soldTokenNo;
        uint boughtTokenNo;
        uint256 soldAmount;
        uint256 boughtAmount;
    }

    mapping (uint =&gt; MyToken) public tokensAddress;
    mapping (address =&gt; uint) public tokenNoByAddress;
    mapping (uint =&gt; sellOrder) public sellOrders;
    mapping (uint =&gt; buyOrder) public buyOrders;
    mapping (address =&gt; uint) public totalBuyOrdersOf;
    mapping (address =&gt; uint) public totalSellOrdersOf;
    mapping (address =&gt; mapping(uint =&gt; uint)) public BuyOrdersOf;
    mapping (address =&gt; mapping(uint =&gt; uint)) public SellOrdersOf;
    mapping (uint =&gt; uint256) public collectedFees;
    mapping (address =&gt; mapping(uint =&gt; uint256)) public claimableFeesOf;
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
    mapping (uint =&gt; address) public shareHolderByNumber;
    mapping (address =&gt; uint) public shareHolderByAddress;
    mapping (address =&gt; bool) isHolder;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event SellOrder(uint indexed OrderNo, address indexed Seller, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);
    event BuyOrder(uint indexed OrderNo, address indexed Buyer, uint SoldTokenNo, uint256 SoldAmount, uint BoughtTokenNo, uint256 BoughtAmount);
    event OrderTake(uint indexed OrderNo);
    event CancelOrder(uint indexed OrderNo);
    event TokenAdd(uint indexed TokenNumber, address indexed TokenAddress);
    event DividendDistribution(uint indexed TokenNumber, uint256 totalAmount);

    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;
        if (_value == 0) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        if(isHolder[_to] &amp;&amp; balanceOf[msg.sender] == _value) {
            isHolder[msg.sender] = false;
            shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];
            shareHolderByNumber[shareHolderByAddress[_to]] = _to;
        } else if(isHolder[_to] == false &amp;&amp; balanceOf[msg.sender] == _value) {
            isHolder[msg.sender] = false;
            isHolder[_to] = true;
            shareHolderByAddress[_to] = shareHolderByAddress[msg.sender];
            shareHolderByNumber[shareHolderByAddress[_to]] = _to;
        } else if(isHolder[_to] == false) {
            isHolder[_to] = true;
            amountOfHolders = amountOfHolders + 1;
            shareHolderByAddress[_to] = amountOfHolders;
            shareHolderByNumber[amountOfHolders] = _to;
        }
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        tokenRecipient spender = tokenRecipient(_spender);
        spender.receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] &lt; _value) throw;
        if (_value == 0) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        if (_value &gt; allowance[_from][msg.sender]) throw;
        if(isHolder[_to] &amp;&amp; balanceOf[_from] == _value) {
            isHolder[_from] = false;
            shareHolderByAddress[_to] = shareHolderByAddress[_from];
            shareHolderByNumber[shareHolderByAddress[_to]] = _to;
        } else if(isHolder[_to] == false &amp;&amp; balanceOf[_from] == _value) {
            isHolder[_from] = false;
            isHolder[_to] = true;
            shareHolderByAddress[_to] = shareHolderByAddress[_from];
            shareHolderByNumber[shareHolderByAddress[_to]] = _to;
        } else if(isHolder[_to] == false) {
            isHolder[_to] = true;
            amountOfHolders = amountOfHolders + 1;
            shareHolderByAddress[_to] = amountOfHolders;
            shareHolderByNumber[amountOfHolders] = _to;
        }
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function DTE() {
        balanceOf[msg.sender] = 100000000000000000000;
        amountOfHolders = amountOfHolders + 1;
        shareHolderByNumber[amountOfHolders] = msg.sender;
        shareHolderByAddress[msg.sender] = amountOfHolders;
        isHolder[msg.sender] = true;
        totalSupply = 100000000000000000000;
        name = &quot;DTE Shares&quot;;
        symbol = &quot;%&quot;;
        decimals = 18;
        tokensAddress[++totalTokens] = MyToken(this);
        tokenNoByAddress[address(this)] = totalTokens;
    }

    function DistributeDividends(uint token) {
        if((collectedFees[token] / 100000000000000000000) &lt; 1) throw;
        for(uint i = 1; i &lt; amountOfHolders+1; i++) {
            if(shareHolderByNumber[i] == address(this)) {
                collectedFees[token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;
            } else {
                claimableFeesOf[shareHolderByNumber[i]][token] += (collectedFees[token] * balanceOf[shareHolderByNumber[i]]) / 100000000000000000000;
            }
        }
        DividendDistribution(token, collectedFees[token]);
        collectedFees[token] = 0;
    }

    function claimDividendShare(uint tokenNo) {
        if(tokenNo == 0) {
            msg.sender.send(claimableFeesOf[msg.sender][0]);
            claimableFeesOf[msg.sender][0] = 0;
        } else if(tokenNo != 0){
            var token = MyToken(tokensAddress[tokenNo]);
            token.transfer(msg.sender, claimableFeesOf[msg.sender][tokenNo]);
            claimableFeesOf[msg.sender][0] = 0;
        }
    }

    function () {
        if(msg.value &gt; 0) collectedFees[0] += msg.value;
    }

    function addToken(address tokenContractAddress) {
        if(msg.value &lt; 100 finney) throw;
        if(tokenNoByAddress[tokenContractAddress] != 0) throw;
        msg.sender.send(msg.value - 100 finney);
        collectedFees[0] += 100 finney;
        tokensAddress[++totalTokens] = MyToken(tokenContractAddress);
        tokenNoByAddress[tokenContractAddress] = totalTokens;
        TokenAdd(totalTokens, tokenContractAddress);
    }

    function cancelOrder(bool isSellOrder, uint orderNo) {
        if(isSellOrder) {
            if(sellOrders[orderNo].seller != msg.sender) throw;
            sellOrders[orderNo].isOpen = false;
            tokensAddress[sellOrders[orderNo].soldTokenNo].transfer(msg.sender, sellOrders[orderNo].soldAmount);
        } else {
            if(buyOrders[orderNo].buyer != msg.sender) throw;
            buyOrders[orderNo].isOpen = false;
            if(buyOrders[orderNo].soldTokenNo == 0) {
                msg.sender.send(buyOrders[orderNo].soldAmount);
            } else {
                tokensAddress[buyOrders[orderNo].soldTokenNo].transfer(msg.sender, buyOrders[orderNo].soldAmount);
            }
        }
    }

    function takeOrder(bool isSellOrder, uint orderNo, uint256 amount) {
        if(isSellOrder) {
            if(sellOrders[orderNo].isOpen == false) throw;
            var sorder = sellOrders[orderNo];
            uint wantedToken = sorder.boughtTokenNo;
            uint soldToken = sorder.soldTokenNo;
            uint256 soldAmount = sorder.soldAmount;
            uint256 wantedAmount = sorder.boughtAmount;
            if(wantedToken == 0) {
                if(msg.value &gt; (amount + (amount / 100)) || msg.value &lt; amount || msg.value &lt; (amount + (amount / 100)) || amount &gt; wantedAmount) throw;
                if(amount == wantedAmount) {
                    sorder.isTaken = true;
                    sorder.isOpen = false;
                    sorder.seller.send(amount);
                    collectedFees[0] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);
                } else {
                    uint256 transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));
                    sorder.soldAmount -= transferAmount;
                    sorder.boughtAmount -= amount;
                    sorder.seller.send(amount);
                    collectedFees[0] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);
                }
            } else {
                if(msg.value &gt; 0) throw;
                uint256 allowance = tokensAddress[wantedToken].allowance(msg.sender, this);
                if(allowance &gt; (amount + (amount / 100)) || allowance &lt; amount || allowance &lt; (amount + (amount / 100)) || amount &gt; wantedAmount) throw;
                if(amount == wantedAmount) {
                    sorder.isTaken = true;
                    sorder.isOpen = false;
                    tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);
                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
                    collectedFees[wantedToken] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, sorder.soldAmount);
                } else {
                    transferAmount = uint256((int(amount) * int(sorder.soldAmount)) / int(sorder.boughtAmount));
                    sorder.soldAmount -= transferAmount;
                    sorder.boughtAmount -= amount;
                    tokensAddress[wantedToken].transferFrom(msg.sender, sorder.seller, amount);
                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
                    collectedFees[wantedToken] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);
                }
            }
        } else {
            if(buyOrders[orderNo].isOpen == false) throw;
            var border = buyOrders[orderNo];
            wantedToken = border.boughtTokenNo;
            soldToken = border.soldTokenNo;
            soldAmount = border.soldAmount;
            wantedAmount = border.boughtAmount;
            if(wantedToken == 0) {
                if(msg.value &gt; (amount + (amount / 100)) || msg.value &lt; amount || msg.value &lt; (amount + (amount / 100)) || amount &gt; wantedAmount) throw;
                if(amount == wantedAmount) {
                    border.isTaken = true;
                    border.isOpen = false;
                    border.buyer.send(amount);
                    collectedFees[0] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);
                } else {
                    transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));
                    border.soldAmount -= transferAmount;
                    border.boughtAmount -= amount;
                    border.buyer.send(amount);
                    collectedFees[0] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);
                }
            } else {
                if(msg.value &gt; 0) throw;
                allowance = tokensAddress[wantedToken].allowance(msg.sender, this);
                if(allowance &gt; (amount + (amount / 100)) || allowance &lt; amount || allowance &lt; (amount + (amount / 100)) || amount &gt; wantedAmount) throw;
                if(amount == wantedAmount) {
                    border.isTaken = true;
                    border.isOpen = false;
                    tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);
                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
                    collectedFees[wantedToken] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, border.soldAmount);
                } else {
                    transferAmount = uint256((int(amount) * int(border.soldAmount)) / int(border.boughtAmount));
                    border.soldAmount -= transferAmount;
                    border.boughtAmount -= amount;
                    tokensAddress[wantedToken].transferFrom(msg.sender, border.buyer, amount);
                    tokensAddress[wantedToken].transferFrom(msg.sender, this, (amount / 100));
                    collectedFees[wantedToken] += amount / 100;
                    tokensAddress[soldToken].transfer(msg.sender, transferAmount);
                }
            }
        }
    }

    function newOrder(bool isSellOrder,
                      uint soldTokenNo,
                      uint boughtTokenNo,
                      uint256 soldAmount,
                      uint256 boughtAmount
                      ) {
        if(soldTokenNo == boughtTokenNo) throw;
        if(isSellOrder) {
            if(soldTokenNo == 0) throw;
            MyToken token = tokensAddress[soldTokenNo];
            uint256 allowance = token.allowance(msg.sender, this);
            if(soldTokenNo &gt; totalTokens || allowance &lt; soldAmount) throw;
            token.transferFrom(msg.sender, this, soldAmount);
            sellOrders[++totalSellOrders] = sellOrder({
                isOpen: true,
                isTaken: false,
                seller: msg.sender,
                soldTokenNo: soldTokenNo,
                boughtTokenNo: boughtTokenNo,
                soldAmount: soldAmount,
                boughtAmount: boughtAmount
            });
            SellOrdersOf[msg.sender][++totalSellOrdersOf[msg.sender]] = totalSellOrders;
            SellOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);
        } else {
            if(soldTokenNo == 0)  {
                if(msg.value &gt; soldAmount) throw;
                allowance = msg.value;
            } else if(soldTokenNo &gt; totalTokens) {
                throw;
            } else {
                token = tokensAddress[soldTokenNo];
                allowance = token.allowance(msg.sender, this);
                if(soldAmount &lt; allowance) throw;
                token.transferFrom(msg.sender, this, soldAmount);
            }
            buyOrders[++totalBuyOrders] = buyOrder({
                isOpen: true,
                isTaken: false,
                buyer: msg.sender,
                soldTokenNo: soldTokenNo,
                boughtTokenNo: boughtTokenNo,
                soldAmount: soldAmount,
                boughtAmount: boughtAmount
            });
            BuyOrdersOf[msg.sender][++totalBuyOrdersOf[msg.sender]] = totalBuyOrders;
            BuyOrder(totalSellOrders, msg.sender, soldTokenNo, soldAmount, boughtTokenNo, boughtAmount);
        }
    }
}