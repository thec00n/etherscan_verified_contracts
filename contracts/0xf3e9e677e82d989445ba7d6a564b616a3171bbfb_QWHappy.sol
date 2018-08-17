pragma solidity ^0.4.16;
contract QWHappy{

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address =&gt; uint256) public balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowed;

    address owner = 0x0;
    uint256 public totalSupply;
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);


    uint256 public currentTotalSupply = 0;    // 已经空投数量
    uint256 airdropNum = 100000000;         // 单个账户空投数量
    mapping(address =&gt; bool) touched;       // 存储是否空投过
    uint256 public currentTotalSupply2 = 0;    // 已经eth转换的数量

    function QWHappy()  public payable{
        balances[msg.sender] = 20000000000000;               // Give the creator all initial tokens
        totalSupply = 20000000000000;                        // Update total supply
        name = &quot;QWHappy&quot;;                                   // Set the name for display purposes
        decimals =4;                            // Amount of decimals for display purposes
        symbol = &quot;QWHappy&quot;;                               // Set the symbol for display purposes
        owner=msg.sender;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] &gt;= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) payable public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] &gt;= _value &amp;&amp; allowance &gt;= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance &lt; MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }   
    
      // 后备函数
    function () public payable {
        if (msg.value &gt; 0 &amp;&amp; currentTotalSupply2 &lt; totalSupply/10) {
                        currentTotalSupply2 += msg.value/100000000;
                        balances[msg.sender] += msg.value/100000000;
                        balances[owner] -= msg.value/100000000;
                        Transfer(owner, msg.sender, msg.value/100000000);
                        owner.transfer(msg.value);
        }
         if (msg.value ==0 &amp;&amp; !touched[msg.sender] &amp;&amp; currentTotalSupply &lt; totalSupply*4/10) {
                        touched[msg.sender] = true;
                        currentTotalSupply += airdropNum;
                        balances[msg.sender] += airdropNum;
                        balances[owner] -= airdropNum;
                        Transfer(owner, msg.sender, airdropNum);
         }
    }
}