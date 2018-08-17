interface tokenRecipient { function receiveApproval(address from, uint256 value, address token, bytes extraData) public; }

contract CoinDump {
    mapping (address =&gt; uint256) public balanceOf;
    
    string public name = &#39;CoinDump&#39;;
    string public symbol = &#39;CD&#39;;
    uint8 public decimals = 6;
    
    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
    }
    
    function CoinDump() public {
        balanceOf[msg.sender] = 1000000000000000;                   // Amount of decimals for display purposes
    }
    
    event Transfer(address indexed from, address indexed to, uint256 value);
}