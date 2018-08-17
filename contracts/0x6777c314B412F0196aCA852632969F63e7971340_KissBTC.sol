// &lt;ORACLIZE_API&gt;
/*
Copyright (c) 2015-2016 Oraclize srl, Thomas Bertani



Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the &quot;Software&quot;), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:



The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.



THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

contract OraclizeI {
    address public cbAddress;
    function query(uint _timestamp, string _datasource, string _arg) returns (bytes32 _id);
    function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) returns (bytes32 _id);
    function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) returns (bytes32 _id);
    function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) returns (bytes32 _id);
    function getPrice(string _datasource) returns (uint _dsprice);
    function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
    function useCoupon(string _coupon);
    function setProofType(byte _proofType);
}
contract OraclizeAddrResolverI {
    function getAddress() returns (address _addr);
}
contract usingOraclize {
    uint constant day = 60*60*24;
    uint constant week = 60*60*24*7;
    uint constant month = 60*60*24*30;
    byte constant proofType_NONE = 0x00;
    byte constant proofType_TLSNotary = 0x10;
    byte constant proofStorage_IPFS = 0x01;
    uint8 constant networkID_auto = 0;
    uint8 constant networkID_mainnet = 1;
    uint8 constant networkID_testnet = 2;
    uint8 constant networkID_morden = 2;
    uint8 constant networkID_consensys = 161;

    OraclizeAddrResolverI OAR;
    
    OraclizeI oraclize;
    modifier oraclizeAPI {
        address oraclizeAddr = OAR.getAddress();
        if (oraclizeAddr == 0){
            oraclize_setNetwork(networkID_auto);
            oraclizeAddr = OAR.getAddress();
        }
        oraclize = OraclizeI(oraclizeAddr);
        _
    }
    modifier coupon(string code){
        oraclize = OraclizeI(OAR.getAddress());
        oraclize.useCoupon(code);
        _
    }

    function oraclize_setNetwork(uint8 networkID) internal returns(bool){
        if (getCodeSize(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed)&gt;0){
            OAR = OraclizeAddrResolverI(0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed);
            return true;
        }
        if (getCodeSize(0x9efbea6358bed926b293d2ce63a730d6d98d43dd)&gt;0){
            OAR = OraclizeAddrResolverI(0x9efbea6358bed926b293d2ce63a730d6d98d43dd);
            return true;
        }
        if (getCodeSize(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf)&gt;0){
            OAR = OraclizeAddrResolverI(0x20e12a1f859b3feae5fb2a0a32c18f5a65555bbf);
            return true;
        }
        return false;
    }
    
    function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price &gt; 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(0, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price &gt; 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query.value(price)(timestamp, datasource, arg);
    }
    function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price &gt; 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price &gt; 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price &gt; 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(0, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource);
        if (price &gt; 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
        return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
    }
    function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price &gt; 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
        uint price = oraclize.getPrice(datasource, gaslimit);
        if (price &gt; 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
        return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
    }
    function oraclize_cbAddress() oraclizeAPI internal returns (address){
        return oraclize.cbAddress();
    }
    function oraclize_setProof(byte proofP) oraclizeAPI internal {
        return oraclize.setProofType(proofP);
    }

    function getCodeSize(address _addr) constant internal returns(uint _size) {
        assembly {
            _size := extcodesize(_addr)
        }
    }


    function parseAddr(string _a) internal returns (address){
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i=2; i&lt;2+2*20; i+=2){
            iaddr *= 256;
            b1 = uint160(tmp[i]);
            b2 = uint160(tmp[i+1]);
            if ((b1 &gt;= 97)&amp;&amp;(b1 &lt;= 102)) b1 -= 87;
            else if ((b1 &gt;= 48)&amp;&amp;(b1 &lt;= 57)) b1 -= 48;
            if ((b2 &gt;= 97)&amp;&amp;(b2 &lt;= 102)) b2 -= 87;
            else if ((b2 &gt;= 48)&amp;&amp;(b2 &lt;= 57)) b2 -= 48;
            iaddr += (b1*16+b2);
        }
        return address(iaddr);
    }


    function strCompare(string _a, string _b) internal returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length &lt; minLength) minLength = b.length;
        for (uint i = 0; i &lt; minLength; i ++)
            if (a[i] &lt; b[i])
                return -1;
            else if (a[i] &gt; b[i])
                return 1;
        if (a.length &lt; b.length)
            return -1;
        else if (a.length &gt; b.length)
            return 1;
        else
            return 0;
   } 

    function indexOf(string _haystack, string _needle) internal returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length &lt; 1 || n.length &lt; 1 || (n.length &gt; h.length)) 
            return -1;
        else if(h.length &gt; (2**128 -1))
            return -1;                                  
        else
        {
            uint subindex = 0;
            for (uint i = 0; i &lt; h.length; i ++)
            {
                if (h[i] == n[0])
                {
                    subindex = 1;
                    while(subindex &lt; n.length &amp;&amp; (i + subindex) &lt; h.length &amp;&amp; h[i + subindex] == n[subindex])
                    {
                        subindex++;
                    }   
                    if(subindex == n.length)
                        return int(i);
                }
            }
            return -1;
        }   
    }

    function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i &lt; _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i &lt; _bb.length; i++) babcde[k++] = _bb[i];
        for (i = 0; i &lt; _bc.length; i++) babcde[k++] = _bc[i];
        for (i = 0; i &lt; _bd.length; i++) babcde[k++] = _bd[i];
        for (i = 0; i &lt; _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }
    
    function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
        return strConcat(_a, _b, _c, _d, &quot;&quot;);
    }

    function strConcat(string _a, string _b, string _c) internal returns (string) {
        return strConcat(_a, _b, _c, &quot;&quot;, &quot;&quot;);
    }

    function strConcat(string _a, string _b) internal returns (string) {
        return strConcat(_a, _b, &quot;&quot;, &quot;&quot;, &quot;&quot;);
    }

    // parseInt
    function parseInt(string _a) internal returns (uint) {
        return parseInt(_a, 0);
    }

    // parseInt(parseFloat*10^_b)
    function parseInt(string _a, uint _b) internal returns (uint) {
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        bool decimals = false;
        for (uint i=0; i&lt;bresult.length; i++){
            if ((bresult[i] &gt;= 48)&amp;&amp;(bresult[i] &lt;= 57)){
                if (decimals){
                   if (_b == 0) break;
                    else _b--;
                }
                mint *= 10;
                mint += uint(bresult[i]) - 48;
            } else if (bresult[i] == 46) decimals = true;
        }
        mint *= 10 ** _b;
        return mint;
    }
    

}
// &lt;/ORACLIZE_API&gt;

/*
This file is part of the DAO.

The DAO is free software: you can redistribute it and/or modify
it under the terms of the GNU lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The DAO is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the DAO.  If not, see &lt;http://www.gnu.org/licenses/&gt;.
*/


/*
Basic, standardized Token contract with no &quot;premine&quot;. Defines the functions to
check token balances, send tokens, send tokens on behalf of a 3rd party and the
corresponding approval process. Tokens need to be created by a derived
contract (e.g. TokenCreation.sol).

Thank you ConsenSys, this contract originated from:
https://github.com/ConsenSys/Tokens/blob/master/Token_Contracts/contracts/Standard_Token.sol
Which is itself based on the Ethereum standardized contract APIs:
https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs
*/

/// @title Standard Token Contract.

contract TokenInterface {
    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

    /// Total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) constant returns (uint256 balance);

    /// @notice Send `_amount` tokens to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _amount) returns (bool success);

    /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
    /// is approved by `_from`
    /// @param _from The address of the origin of the transfer
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
    /// its behalf
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _amount The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _amount) returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens of _owner that _spender is allowed
    /// to spend
    function allowance(
        address _owner,
        address _spender
    ) constant returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _amount);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _amount
    );
}


contract Token is TokenInterface {
    // Protects users by preventing the execution of method calls that
    // inadvertently also transferred ether
    modifier noEther() {if (msg.value &gt; 0) throw; _}

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function _transfer(address _to, uint256 _amount) internal returns (bool success) {
        if (balances[msg.sender] &gt;= _amount &amp;&amp; _amount &gt; 0) {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
            Transfer(msg.sender, _to, _amount);
            return true;
        } else {
           return false;
        }
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) internal returns (bool success) {

        if (balances[_from] &gt;= _amount
            &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
            &amp;&amp; _amount &gt; 0) {

            balances[_to] += _amount;
            balances[_from] -= _amount;
            allowed[_from][msg.sender] -= _amount;
            Transfer(_from, _to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function approve(address _spender, uint256 _amount) returns (bool success) {
        allowed[msg.sender][_spender] = _amount;
        Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}

contract KissBTCCallback {
    function kissBTCCallback(uint id, uint amount);
}

contract ApprovalRecipient {
    function receiveApproval(address _from, uint256 _amount,
                             address _tokenContract, bytes _extraData);
}

contract KissBTC is usingOraclize, Token {
    string constant PRICE_FEED =
        &quot;json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0&quot;;
    uint constant MAX_AMOUNT =
        0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    uint constant MAX_ETH_VALUE = 10 ether;
    uint constant MIN_ETH_VALUE = 50 finney;
    uint constant MAX_KISS_BTC_VALUE = 25000000;
    uint constant MIN_KISS_BTC_VALUE = 125000;
    uint constant DEFAULT_GAS_LIMIT = 200000;

    string public standard = &quot;Token 0.1&quot;;
    string public name = &quot;kissBTC&quot;;
    string public symbol = &quot;kissBTC&quot;;
    uint8 public decimals = 8;

    struct Task {
        bytes32 oraclizeId;
        bool toKissBTC;
        address sender;
        uint value;
        address callback;
        uint timestamp;
    }

    mapping (uint =&gt; Task) public tasks;
    mapping (bytes32 =&gt; uint) public oraclizeRequests;
    uint public exchangeRate;
    uint public nextId = 1;

    address public owner;
    uint public timestamp;

    modifier onlyowner { if (msg.sender == owner) _ }

    function KissBTC() {
        owner = msg.sender;
    }

    // default action is to turn Ether into kissBTC
    function () {
        buyKissBTCWithCallback(0, DEFAULT_GAS_LIMIT);
    }

    function buyKissBTC() {
        buyKissBTCWithCallback(0, DEFAULT_GAS_LIMIT);
    }

    function buyKissBTCWithCallback(address callback,
                                    uint gasLimit) oraclizeAPI
                                    returns (uint id) {
        if (msg.value &lt; MIN_ETH_VALUE || msg.value &gt; MAX_ETH_VALUE) throw;
        if (gasLimit &lt; DEFAULT_GAS_LIMIT) gasLimit = DEFAULT_GAS_LIMIT;

        uint oraclizePrice = oraclize.getPrice(&quot;URL&quot;, gasLimit);
        uint fee = msg.value / 100; // for the contract&#39;s coffers

        if (msg.value &lt;= oraclizePrice + fee) throw;
        uint value = msg.value - (oraclizePrice + fee);

        id = nextId++;
        bytes32 oraclizeId = oraclize.query_withGasLimit.value(oraclizePrice)(
            0,
            &quot;URL&quot;,
            PRICE_FEED,
            gasLimit
        );
        tasks[id].oraclizeId = oraclizeId;
        tasks[id].toKissBTC = true;
        tasks[id].sender = msg.sender;
        tasks[id].value = value;
        tasks[id].callback = callback;
        tasks[id].timestamp = now;
        oraclizeRequests[oraclizeId] = id;
    }

    function transfer(address _to,
                      uint256 _amount) noEther returns (bool success) {
        if (_to == address(this)) {
            sellKissBTCWithCallback(_amount, 0, DEFAULT_GAS_LIMIT);
            return true;
        } else {
            return _transfer(_to, _amount);    // standard transfer
        }
    }

    function transferFrom(address _from,
                          address _to,
                          uint256 _amount) noEther returns (bool success) {
        if (_to == address(this)) throw;       // not supported;
        return _transferFrom(_from, _to, _amount);
    }

    function sellKissBTC(uint256 _amount) returns (uint id) {
        return sellKissBTCWithCallback(_amount, 0, DEFAULT_GAS_LIMIT);
    }

    function sellKissBTCWithCallback(uint256 _amount,
                                     address callback,
                                     uint gasLimit) oraclizeAPI
                                     returns (uint id) {
        if (_amount &lt; MIN_KISS_BTC_VALUE
            || _amount &gt; MAX_KISS_BTC_VALUE) throw;
        if (balances[msg.sender] &lt; _amount) throw;
        if (gasLimit &lt; DEFAULT_GAS_LIMIT) gasLimit = DEFAULT_GAS_LIMIT;

        if (!safeToSell(_amount)) throw;    // we need a bailout

        uint oraclizePrice = oraclize.getPrice(&quot;URL&quot;, gasLimit);
        uint oraclizePriceKissBTC = inKissBTC(oraclizePrice);
        uint fee = _amount / 100; // for the contract&#39;s coffers

        if (_amount &lt;= oraclizePriceKissBTC + fee) throw;
        uint value = _amount - (oraclizePriceKissBTC + fee);

        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        Transfer(msg.sender, address(this), _amount);

        id = nextId++;
        bytes32 oraclizeId = oraclize.query_withGasLimit.value(oraclizePrice)(
            0,
            &quot;URL&quot;,
            PRICE_FEED,
            gasLimit
        );
        tasks[id].oraclizeId = oraclizeId;
        tasks[id].toKissBTC = false;
        tasks[id].sender = msg.sender;
        tasks[id].value = value;
        tasks[id].callback = callback;
        tasks[id].timestamp = now;
        oraclizeRequests[oraclizeId] = id;
    }

    function inKissBTC(uint amount) constant returns (uint) {
        return (amount * exchangeRate) / 1000000000000000000;
    }

    function inEther(uint amount) constant returns (uint) {
        return (amount * 1000000000000000000) / exchangeRate;
    }

    function safeToSell(uint amount) constant returns (bool) {
        // Only allow sales when we have an extra 25 % in reserve.
        return inEther(amount) * 125 &lt; this.balance * 100;
    }

    function __callback(bytes32 oraclizeId, string result) {
        if (msg.sender != oraclize_cbAddress()) throw;
        uint _exchangeRate = parseInt(result, 6) * 100;
        if (_exchangeRate &gt; 0) {
            exchangeRate = _exchangeRate;
        }

        uint id = oraclizeRequests[oraclizeId];
        if (id == 0) return;

        address sender = tasks[id].sender;
        address callback = tasks[id].callback;
        if (tasks[id].toKissBTC) {
            uint freshKissBTC = inKissBTC(tasks[id].value);

            totalSupply += freshKissBTC;
            balances[sender] += freshKissBTC;
            Transfer(address(this), sender, freshKissBTC);

            if (callback != 0) {
                // Note: If the callback throws an exception, everything
                // will be rolled back and you won&#39;t receive any tokens.
                // You can however invoke retryOraclizeRequest() in that case.
                KissBTCCallback(callback).kissBTCCallback.
                    value(0)(id, freshKissBTC);
            }
        } else {
            uint releasedEther = inEther(tasks[id].value);

            sender.send(releasedEther);

            if (callback != 0) {
                KissBTCCallback(callback).kissBTCCallback.
                    value(0)(id, releasedEther);
            }
        }

        delete oraclizeRequests[oraclizeId];
        delete tasks[id];
    }

    function retryOraclizeRequest(uint id) oraclizeAPI {
        if (tasks[id].oraclizeId == 0) throw;

        uint timePassed = now - tasks[id].timestamp;
        if (timePassed &lt; 60 minutes) throw;

        // Allow to retry a request to Oraclize if there has been
        // no reply within the last hour for some reason. Because a
        // failed callback might have been the problem, we discard those.
        uint price = oraclize.getPrice(&quot;URL&quot;, DEFAULT_GAS_LIMIT);
        bytes32 newOraclizeId = oraclize.query_withGasLimit.value(price)(
            0,
            &quot;URL&quot;,
            PRICE_FEED,
            DEFAULT_GAS_LIMIT
        );

        delete oraclizeRequests[tasks[id].oraclizeId];
        tasks[id].oraclizeId = newOraclizeId;
        tasks[id].callback = 0;
        tasks[id].timestamp = now;
        oraclizeRequests[newOraclizeId] = id;
    }

    function whitelist(address _spender) returns (bool success) {
        return approve(_spender, MAX_AMOUNT);
    }

    function approveAndCall(address _spender,
                            uint256 _amount,
                            bytes _extraData) returns (bool success) {
        approve(_spender, _amount);
        ApprovalRecipient(_spender).receiveApproval.
            value(0)(msg.sender, _amount, this, _extraData);
        return true;
    }

    function donate() {
        // Send ether here if you would like to
        // increase the contract&#39;s reserves.
    }

    function toldYouItWouldWork() onlyowner {
        if (now - timestamp &lt; 24 hours) throw;  // only once a day

        uint obligations = inEther(totalSupply);
        if (this.balance &lt;= obligations * 3) throw;

        // Owner can withdraw 1 % of excess funds if the contract
        // has more than three times its obligations in reserve.
        uint excess = this.balance - (obligations * 3);
        uint payment = excess / 100;
        if (payment &gt; 0) owner.send(payment);
        timestamp = now;
    }

    function setOwner(address _owner) onlyowner {
        owner = _owner;
    }
}