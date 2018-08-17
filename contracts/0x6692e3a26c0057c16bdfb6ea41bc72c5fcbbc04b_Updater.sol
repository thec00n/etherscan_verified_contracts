pragma solidity ^0.4.21;

contract Updater
{
    mapping (address =&gt; bool) public owners;

    struct State {
        bool exchange;
        bool payment;
    }
    mapping(address =&gt; State) public states;

    event InfoUpdated(bytes4 indexed method, address indexed target, bool indexed res, uint256 ETHUSD, uint256 token, uint256 value);
    event OwnerChanged(address indexed previousOwner, bool state);

    modifier onlyOwner() {
        require(owners[msg.sender]);
        _;
    }

    function Updater() public {
        owners[msg.sender] = true;
    }

    function setOwner(address _newOwner,bool _state) onlyOwner public {
        emit OwnerChanged(_newOwner, _state);
        owners[_newOwner] = _state;
    }

    function setStates(address[] _addr, uint8[] _exchange, uint8[] _payment) onlyOwner public {
        for(uint256 i = 0; i &lt; _addr.length; i++){
            states[_addr[i]].exchange = _exchange[i]&gt;0;
            states[_addr[i]].payment = _payment[i]&gt;0;
        }
    }

    function update(address[] _addr, uint256[] _ETHUSD, uint256[] _token, uint256[] _value) onlyOwner public {
        for(uint256 i = 0; i &lt; _addr.length; i++){
            State storage state = states[_addr[i]];
            bool res;
            if(!(state.exchange || state.payment)){
                res=_addr[i].call(bytes4(keccak256(&quot;updateInfo(uint256,uint256,uint256)&quot;)),_ETHUSD[i],_token[i],_value[i]);
                emit InfoUpdated(bytes4(keccak256(&quot;updateInfo(uint256,uint256,uint256)&quot;)),_addr[i],res,_ETHUSD[i],_token[i],_value[i]);
                continue;
            }
            if(state.exchange){
                res=_addr[i].call(bytes4(keccak256(&quot;changeExchange(uint256)&quot;)),_ETHUSD[i]);
                emit InfoUpdated(bytes4(keccak256(&quot;changeExchange(uint256)&quot;)),_addr[i],res,_ETHUSD[i],0x0,0x0);
            }
            if(state.payment){
                res=_addr[i].call(bytes4(keccak256(&quot;paymentsInOtherCurrency(uint256,uint256)&quot;)),_token[i],_value[i]);
                emit InfoUpdated(bytes4(keccak256(&quot;paymentsInOtherCurrency(uint256,uint256)&quot;)),_addr[i],res,0x0,_token[i],_value[i]);
            }
        }
    }
}