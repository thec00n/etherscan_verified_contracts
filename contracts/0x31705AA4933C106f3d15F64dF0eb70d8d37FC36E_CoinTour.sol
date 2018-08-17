pragma solidity ^0.4.13;

contract Ownable {
    
    address owner;
    
    function Ownable() public{
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner{
    require(newOwner != address(0));      
    owner = newOwner;
  }
}

contract CoinTour is Ownable {
    
    string public  name  = &quot;Coin Tour&quot;;
    
    string public  symbol = &quot;COT&quot;;
    
    uint32 public  decimals = 8 ;
    
    uint public totalSupply = 2100000000000000;
    
    uint public etap = 1000000000000000;
    
    uint public forCommand = 100000000000000;
    
    uint public sendCount = 200000000000;
    
    address public commandAddress = 0xA92AdaA9B9C4F2A4219132E6B9bd07B6a1F4e01e;
    
    uint startEtap1 = 1511949600;
    uint endEtap1 = 1512028800;
    
    uint startEtap2 = 1512468000;
    uint endEtap2 = 1512554400;

    mapping (address =&gt; uint) balances;
    
    mapping (address =&gt; mapping(address =&gt; uint)) allowed;
    
    function CoinTour() public {
        balances[commandAddress] = forCommand;
        balances[owner] = totalSupply-forCommand;
    }
    
    function balanceOf(address who) public constant returns (uint balance) {
        return balances[who];
    }

    function transfer(address _to, uint _value) public returns (bool success) {
            if(balances[msg.sender] &gt;= _value &amp;&amp; balances[_to] + _value &gt;= balances[_to]) {
                balances[msg.sender] -= _value; 
                balances[_to] += _value;
                Transfer(msg.sender, _to, _value);
                return true;
            }
        return false;
    }
    
    function multisend(address[] temp) public onlyOwner returns (bool success){
        if((now &gt; startEtap1 &amp;&amp; now &lt; endEtap1)||(now &gt; startEtap2 &amp;&amp; now &lt; endEtap2)){
            for(uint i = 0; i &lt; temp.length; i++) {
                if (now&gt;=startEtap1 &amp;&amp; now &lt;=endEtap1 &amp;&amp; balances[owner]&gt;etap || now&gt;=startEtap2 &amp;&amp; now &lt;=endEtap2 &amp;&amp; balances[owner]&gt;0){
                    balances[owner] -= sendCount;
                    balances[temp[i]] += sendCount;
                    Transfer(owner, temp[i],sendCount);
                }
            }
            return true; 
        }
        return false;
    }
    
    function burn() onlyOwner public {
        require (now&gt;=endEtap1 &amp;&amp; now &lt;=startEtap2 || now &gt;= endEtap2);
        uint _value;
        if (now&gt;=endEtap1 &amp;&amp; now &lt;=startEtap2) {
            _value = balances[owner] - etap;
            require(_value &gt; 0);
        }
        else _value = balances[owner];
        balances[owner] -= _value;
        totalSupply -= _value;
        Burn(owner, _value);
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        if( allowed[_from][msg.sender] &gt;= _value &amp;&amp; balances[_from] &gt;= _value &amp;&amp; balances[_to] + _value &gt;= balances[_to]) {
            allowed[_from][msg.sender] -= _value;
            balances[_from] -= _value; 
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } 
        return false;
    }
     
    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
        
    event Burn(address indexed burner, uint indexed value);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);   
}