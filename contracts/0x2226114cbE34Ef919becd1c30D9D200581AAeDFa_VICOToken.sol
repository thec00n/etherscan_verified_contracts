pragma solidity ^0.4.19;
contract tokenRecipient { 
    
    function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) public; 
    }

contract VICOToken {

	string public name = &#39;VICO Vote Token&#39;;
    	string public symbol = &#39;VICO&#39;;
    	uint256 public decimals = 0;
    	uint256 public totalSupply = 100000000;
    	address public VicoOwner;
        mapping (address =&gt; uint256) public balanceOf;
        mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
        event Transfer(address indexed from, address indexed to, uint256 value);

    function VICOToken(address ownerAddress) public {
        balanceOf[msg.sender] = totalSupply;
        VicoOwner = ownerAddress;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require (_to != 0x0);                               
        require (_value &gt;0);
        require (balanceOf[msg.sender] &gt;= _value);           
        require (balanceOf[_to] + _value &gt; balanceOf[_to]); 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                           
        Transfer(msg.sender, _to, _value);                   
        return true;
    }

    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
        require (_to != 0x0);                             
        require (_value &gt;0);
        require (balanceOf[_from] &gt;= _value);
        require (balanceOf[_to] + _value &gt; balanceOf[_to]);
        require (_value &lt;= allowance[_from][msg.sender]);    
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value; 
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

}