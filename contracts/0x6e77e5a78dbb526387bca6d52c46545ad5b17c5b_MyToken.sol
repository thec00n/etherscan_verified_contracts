pragma solidity ^0.4.18;

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c &gt;= a);
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b &lt;= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b &gt; 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event TransferSell(address indexed from, uint tokens, uint eth);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;
    

    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
        owner = newOwner;
    }
    // function acceptOwnership() public {
    //     require(msg.sender == newOwner);
    //     OwnershipTransferred(owner, newOwner);
    //     owner = newOwner;
    //     newOwner = address(0);
    // }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals
// Receives ETH and generates tokens
// ----------------------------------------------------------------------------
contract MyToken is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public totalSupply;
    uint public sellRate;
    uint public buyRate;
    uint public startTime;
    uint public endTime;
    
    address[] admins;
    
    struct lockPosition{
        uint time;
        uint count;
        uint releaseRate;
        uint lockTime;
    }
    
    struct lockPosition1{
        uint8 typ; // 1 2 3 4
        uint count;
        uint time1;
        uint8 releaseRate1;
        uint time2;
        uint8 releaseRate2;
        uint time3;
        uint8 releaseRate3;
        uint time4;
        uint8 releaseRate4;
    }
    
    
    mapping(address =&gt; lockPosition) private lposition;
    mapping(address =&gt; lockPosition1) public lposition1;
    
    // locked account dictionary that maps addresses to boolean
    mapping (address =&gt; bool) public lockedAccounts;
    mapping (address =&gt; bool) public isAdmin;

    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;
    
    modifier is_not_locked(address _address) {
        if (lockedAccounts[_address] == true) revert();
        _;
    }
    
    modifier validate_address(address _address) {
        if (_address == address(0)) revert();
        _;
    }
    
    modifier is_admin {
        if (isAdmin[msg.sender] != true &amp;&amp; msg.sender != owner) revert();
        _;
    }
    
    modifier validate_position(address _address,uint count) {
        if(count &lt;= 0) revert();
        if(balances[_address] &lt; count) revert();
        if(lposition[_address].count &gt; 0 &amp;&amp; safeSub(balances[_address],count) &lt; lposition[_address].count &amp;&amp; now &lt; lposition[_address].time) revert();
        if(lposition1[_address].count &gt; 0 &amp;&amp; safeSub(balances[_address],count) &lt; lposition1[_address].count &amp;&amp; now &lt; lposition1[_address].time1) revert();
        checkPosition1(_address,count);
        checkPosition(_address,count);
        _;
    }
    
    function checkPosition(address _address,uint count) private view {
        if(lposition[_address].releaseRate &lt; 100 &amp;&amp; lposition[_address].count &gt; 0){
            uint _rate = safeDiv(100,lposition[_address].releaseRate);
            uint _time = lposition[_address].time;
            uint _tmpRate = lposition[_address].releaseRate;
            uint _tmpRateAll = 0;
            uint _count = 0;
            for(uint _a=1;_a&lt;=_rate;_a++){
                if(now &gt;= _time){
                    _count = _a;
                    _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
                    _time = safeAdd(_time,lposition[_address].lockTime);
                }
            }
            uint _tmp1 = safeSub(balances[_address],count);
            uint _tmp2 = safeSub(lposition[_address].count,safeDiv(lposition[_address].count*_tmpRateAll,100));
            if(_count &lt; _rate &amp;&amp; _tmp1 &lt; _tmp2  &amp;&amp; now &gt;= lposition[_address].time) revert();
        }
    }
    
    function checkPosition1(address _address,uint count) private view {
        if(lposition1[_address].releaseRate1 &lt; 100 &amp;&amp; lposition1[_address].count &gt; 0){
            uint _tmpRateAll = 0;
            
            if(lposition1[_address].typ == 2 &amp;&amp; now &lt; lposition1[_address].time2){
                if(now &gt;= lposition1[_address].time1){
                    _tmpRateAll = lposition1[_address].releaseRate1;
                }
            }
            
            if(lposition1[_address].typ == 3 &amp;&amp; now &lt; lposition1[_address].time3){
                if(now &gt;= lposition1[_address].time1){
                    _tmpRateAll = lposition1[_address].releaseRate1;
                }
                if(now &gt;= lposition1[_address].time2){
                    _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
                }
            }
            
            if(lposition1[_address].typ == 4 &amp;&amp; now &lt; lposition1[_address].time4){
                if(now &gt;= lposition1[_address].time1){
                    _tmpRateAll = lposition1[_address].releaseRate1;
                }
                if(now &gt;= lposition1[_address].time2){
                    _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
                }
                if(now &gt;= lposition1[_address].time3){
                    _tmpRateAll = safeAdd(lposition1[_address].releaseRate3,_tmpRateAll);
                }
            }
            
            uint _tmp1 = safeSub(balances[_address],count);
            uint _tmp2 = safeSub(lposition1[_address].count,safeDiv(lposition1[_address].count*_tmpRateAll,100));
            
            if(_tmpRateAll &gt; 0){
                if(_tmp1 &lt; _tmp2) revert();
            }
        }
    }
    
    event _lockAccount(address _add);
    event _unlockAccount(address _add);
    
    function () public payable{
        uint tokens;
        require(owner != msg.sender);
        require(now &gt;= startTime &amp;&amp; now &lt; endTime);
        require(buyRate &gt; 0);
        require(msg.value &gt;= 0.1 ether &amp;&amp; msg.value &lt;= 1000 ether);
        
        tokens = safeDiv(msg.value,(1 ether * 1 wei / buyRate));
        require(balances[owner] &gt;= tokens * 10**uint(decimals));
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens * 10**uint(decimals));
        balances[owner] = safeSub(balances[owner], tokens * 10**uint(decimals));
        Transfer(owner,msg.sender,tokens * 10**uint(decimals));
    }

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    function MyToken(uint _sellRate,uint _buyRate,string _symbo1,string _name,uint _startTime,uint _endTime) public payable {
        require(_sellRate &gt;0 &amp;&amp; _buyRate &gt; 0);
        require(_startTime &lt; _endTime);
        symbol = _symbo1;
        name = _name;
        decimals = 8;
        totalSupply = 2000000000 * 10**uint(decimals);
        balances[owner] = totalSupply;
        Transfer(address(0), owner, totalSupply);
        sellRate = _sellRate;
        buyRate = _buyRate;
        endTime = _endTime;
        startTime = _startTime;
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return totalSupply  - balances[address(0)];
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner&#39;s account to `to` account
    // - Owner&#39;s account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public is_not_locked(msg.sender) validate_position(msg.sender,tokens) returns (bool success) {
        require(to != msg.sender);
        require(tokens &gt; 0);
        require(balances[msg.sender] &gt;= tokens);
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner&#39;s account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public is_not_locked(msg.sender) is_not_locked(spender) validate_position(msg.sender,tokens) returns (bool success) {
        require(spender != msg.sender);
        require(tokens &gt; 0);
        require(balances[msg.sender] &gt;= tokens);
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public is_not_locked(msg.sender) is_not_locked(from) validate_position(from,tokens) returns (bool success) {
        require(transferFromCheck(from,to,tokens));
        return true;
    }
    
    function transferFromCheck(address from,address to,uint tokens) private returns (bool success) {
        require(tokens &gt; 0);
        require(from != msg.sender &amp;&amp; msg.sender != to &amp;&amp; from != to);
        require(balances[from] &gt;= tokens &amp;&amp; allowed[from][msg.sender] &gt;= tokens);
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender&#39;s account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner&#39;s account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
    

    // ------------------------------------------------------------------------
    // Sall a token from a contract
    // ------------------------------------------------------------------------
    function sellCoin(address seller, uint amount) public onlyOwner is_not_locked(seller) validate_position(seller,amount* 10**uint(decimals)) {
        require(balances[seller] &gt;= safeMul(amount,10**uint(decimals)));
        require(sellRate &gt; 0);
        require(seller != msg.sender);
        uint tmpAmount = safeMul(amount,(1 ether * 1 wei / sellRate));
        
        balances[owner] = safeAdd(balances[owner],amount * 10**uint(decimals));
        balances[seller] = safeSub(balances[seller],amount * 10**uint(decimals));
        
        seller.transfer(tmpAmount);
        TransferSell(seller, amount * 10**uint(decimals), tmpAmount);
    }
    
    // set rate
    function setConfig(uint _buyRate,uint _sellRate,string _symbol,string _name,uint _startTime,uint _endTime) public onlyOwner {
        require((_buyRate == 0 &amp;&amp; _sellRate == 0) || (_buyRate &lt; _sellRate &amp;&amp; _buyRate &gt; 0 &amp;&amp; _sellRate &gt; 0) || (_buyRate &lt; sellRate &amp;&amp; _buyRate &gt; 0 &amp;&amp; _sellRate == 0) || (buyRate &lt; _sellRate &amp;&amp; _buyRate == 0 &amp;&amp; _sellRate &gt; 0));
        
        if(_buyRate &gt; 0){
            buyRate = _buyRate;
        }
        if(sellRate &gt; 0){
            sellRate = _sellRate;
        }
        if(_startTime &gt; 0){
            startTime = _startTime;
        }
        if(_endTime &gt; 0){
            endTime = _endTime;
        }
        symbol = _symbol;
        name = _name;
    }
    
    // lockAccount
    function lockStatus(address _add,bool _success) public validate_address(_add) is_admin {
        lockedAccounts[_add] = _success;
        _lockAccount(_add);
    }
    
    // setIsAdmin
    function setIsAdmin(address _add,bool _success) public validate_address(_add) onlyOwner {
        isAdmin[_add] = _success;
        if(_success == true){
            admins[admins.length++] = _add;
        }else{
            for (uint256 i;i &lt; admins.length;i++){
                if(admins[i] == _add){
                    delete admins[i];
                }
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    
    //set lock position
    function setLockPostion(address _add,uint _count,uint _time,uint _releaseRate,uint _lockTime) public is_not_locked(_add) onlyOwner {
        require(lposition1[_add].count == 0);
        require(balances[_add] &gt;= safeMul(_count,10**uint(decimals)));
        require(_time &gt; now);
        require(_count &gt; 0 &amp;&amp; _lockTime &gt; 0);
        require(_releaseRate &gt; 0 &amp;&amp; _releaseRate &lt; 100);
        require(_releaseRate == 2 || _releaseRate == 4 || _releaseRate == 5 || _releaseRate == 10 || _releaseRate == 20 || _releaseRate == 25 || _releaseRate == 50);
        lposition[_add].time = _time;
        lposition[_add].count = _count * 10**uint(decimals);
        lposition[_add].releaseRate = _releaseRate;
        lposition[_add].lockTime = _lockTime;
    }
    
    //get lockPosition info
    function getLockPosition(address _add) public view returns(uint time,uint count,uint rate,uint scount,uint _lockTime) {
        return (lposition[_add].time,lposition[_add].count,lposition[_add].releaseRate,positionScount(_add),lposition[_add].lockTime);
    }
    
    function positionScount(address _add) private view returns (uint count){
        uint _rate = safeDiv(100,lposition[_add].releaseRate);
        uint _time = lposition[_add].time;
        uint _tmpRate = lposition[_add].releaseRate;
        uint _tmpRateAll = 0;
        for(uint _a=1;_a&lt;=_rate;_a++){
            if(now &gt;= _time){
                _tmpRateAll = safeAdd(_tmpRateAll,_tmpRate);
                _time = safeAdd(_time,lposition[_add].lockTime);
            }
        }
        
        return (lposition[_add].count - safeDiv(lposition[_add].count*_tmpRateAll,100));
    }
    
    
    //set lock position
    function setLockPostion1(address _add,uint _count,uint8 _typ,uint _time1,uint8 _releaseRate1,uint _time2,uint8 _releaseRate2,uint _time3,uint8 _releaseRate3,uint _time4,uint8 _releaseRate4) public is_not_locked(_add) onlyOwner {
        require(_count &gt; 0);
        require(_time1 &gt; now);
        require(_releaseRate1 &gt; 0);
        require(_typ &gt;= 1 &amp;&amp; _typ &lt;= 4);
        require(balances[_add] &gt;= safeMul(_count,10**uint(decimals)));
        require(safeAdd(safeAdd(_releaseRate1,_releaseRate2),safeAdd(_releaseRate3,_releaseRate4)) == 100);
        require(lposition[_add].count == 0);
        
        if(_typ == 1){
            require(_time2 == 0 &amp;&amp; _releaseRate2 == 0 &amp;&amp; _time3 == 0 &amp;&amp; _releaseRate3 == 0 &amp;&amp; _releaseRate4 == 0 &amp;&amp; _time4 == 0);
        }
        if(_typ == 2){
            require(_time2 &gt; _time1 &amp;&amp; _releaseRate2 &gt; 0 &amp;&amp; _time3 == 0 &amp;&amp; _releaseRate3 == 0 &amp;&amp; _releaseRate4 == 0 &amp;&amp; _time4 == 0);
        }
        if(_typ == 3){
            require(_time2 &gt; _time1 &amp;&amp; _releaseRate2 &gt; 0 &amp;&amp; _time3 &gt; _time2 &amp;&amp; _releaseRate3 &gt; 0 &amp;&amp; _releaseRate4 == 0 &amp;&amp; _time4 == 0);
        }
        if(_typ == 4){
            require(_time2 &gt; _time1 &amp;&amp; _releaseRate2 &gt; 0 &amp;&amp; _releaseRate3 &gt; 0 &amp;&amp; _time3 &gt; _time2 &amp;&amp; _time4 &gt; _time3 &amp;&amp; _releaseRate4 &gt; 0);
        }
        lockPostion1Add(_typ,_add,_count,_time1,_releaseRate1,_time2,_releaseRate2,_time3,_releaseRate3,_time4,_releaseRate4);
    }
    
    function lockPostion1Add(uint8 _typ,address _add,uint _count,uint _time1,uint8 _releaseRate1,uint _time2,uint8 _releaseRate2,uint _time3,uint8 _releaseRate3,uint _time4,uint8 _releaseRate4) private {
        lposition1[_add].typ = _typ;
        lposition1[_add].count = _count * 10**uint(decimals);
        lposition1[_add].time1 = _time1;
        lposition1[_add].releaseRate1 = _releaseRate1;
        lposition1[_add].time2 = _time2;
        lposition1[_add].releaseRate2 = _releaseRate2;
        lposition1[_add].time3 = _time3;
        lposition1[_add].releaseRate3 = _releaseRate3;
        lposition1[_add].time4 = _time4;
        lposition1[_add].releaseRate4 = _releaseRate4;
    }
    
    //get lockPosition1 info
    function getLockPosition1(address _add) public view returns(uint count,uint Scount,uint8 _typ,uint8 _rate1,uint8 _rate2,uint8 _rate3,uint8 _rate4) {
        return (lposition1[_add].count,positionScount1(_add),lposition1[_add].typ,lposition1[_add].releaseRate1,lposition1[_add].releaseRate2,lposition1[_add].releaseRate3,lposition1[_add].releaseRate4);
    }
    
    function positionScount1(address _address) private view returns (uint count){
        uint _tmpRateAll = 0;
        
        if(lposition1[_address].typ == 2 &amp;&amp; now &lt; lposition1[_address].time2){
            if(now &gt;= lposition1[_address].time1){
                _tmpRateAll = lposition1[_address].releaseRate1;
            }
        }
        
        if(lposition1[_address].typ == 3 &amp;&amp; now &lt; lposition1[_address].time3){
            if(now &gt;= lposition1[_address].time1){
                _tmpRateAll = lposition1[_address].releaseRate1;
            }
            if(now &gt;= lposition1[_address].time2){
                _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
            }
        }
        
        if(lposition1[_address].typ == 4 &amp;&amp; now &lt; lposition1[_address].time4){
            if(now &gt;= lposition1[_address].time1){
                _tmpRateAll = lposition1[_address].releaseRate1;
            }
            if(now &gt;= lposition1[_address].time2){
                _tmpRateAll = safeAdd(lposition1[_address].releaseRate2,_tmpRateAll);
            }
            if(now &gt;= lposition1[_address].time3){
                _tmpRateAll = safeAdd(lposition1[_address].releaseRate3,_tmpRateAll);
            }
        }
        
        if((lposition1[_address].typ == 1 &amp;&amp; now &gt;= lposition1[_address].time1) || (lposition1[_address].typ == 2 &amp;&amp; now &gt;= lposition1[_address].time2) || (lposition1[_address].typ == 3 &amp;&amp; now &gt;= lposition1[_address].time3) || (lposition1[_address].typ == 4 &amp;&amp; now &gt;= lposition1[_address].time4)){
            return 0;
        }
        
        if(_tmpRateAll &gt; 0){
            return (safeSub(lposition1[_address].count,safeDiv(lposition1[_address].count*_tmpRateAll,100)));
        }else{
            return lposition1[_address].count;
        }
    }
    
    // batchTransfer
    function batchTransfer(address[] _adds,uint256 _tokens) public is_admin returns(bool success) {
        require(balances[msg.sender] &gt;= safeMul(_adds.length,_tokens*10**uint(decimals)));
        require(lposition[msg.sender].count == 0 &amp;&amp; lposition1[msg.sender].count == 0);
        
        for (uint256 i = 0; i &lt; _adds.length; i++) {
            uint256 _tmpTokens = _tokens * 10**uint(decimals);
            address _tmpAdds = _adds[i];
            balances[msg.sender] = safeSub(balances[msg.sender], _tmpTokens);
            balances[_tmpAdds] = safeAdd(balances[_tmpAdds], _tmpTokens);
            Transfer(msg.sender,_tmpAdds,_tmpTokens);
        }
        
        return true;
    }
}