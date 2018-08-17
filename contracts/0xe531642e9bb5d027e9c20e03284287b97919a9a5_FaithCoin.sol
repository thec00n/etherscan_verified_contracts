/**
  
   In God We Trust
   
   God Bless the bearer of this token.
   In the name of Jesus. Amen
   
   10 Commandments of God
  
   1.You shall have no other gods before Me.
   2.You shall not make idols.
   3.You shall not take the name of the LORD your God in vain.
   4.Remember the Sabbath day, to keep it holy.
   5.Honor your father and your mother.
   6.You shall not murder.
   7.You shall not commit adultery.
   8.You shall not steal.
   9.You shall not bear false witness against your neighbor.
   10.You shall not covet.
  
   Our Mission
   
   1 Timothy 6:12 (NIV)
  &quot;Fight the good fight of the faith. 
   Take hold of the eternal life to which you were called 
   when you made your good confession in the presence of many witnesses.&quot;
   
   Matthew 24:14 (NKJV)
  &quot;And this gospel of the kingdom will be preached in all the world as a witness to all the nations,
   and then the end will come.&quot;

   Verse for Good Health
   
   3 John 1:2
  &quot;Dear friend, I pray that you may enjoy good health and that all may go well with you, 
   even as your soul is getting along well.&quot;
 
   Verse about Family
   
   Genesis 28:14
   &quot;Your offspring shall be like the dust of the earth, 
   and you shall spread abroad to the west and to the east and to the north and to the south, 
   and in you and your offspring shall all the families of the earth be blessed.&quot;

   

   Verse About Friends
   
   Proverbs 18:24
   &quot;One who has unreliable friends soon comes to ruin, but there is a friend who sticks closer than a brother.&quot;




   God will Protect you
   
   Isaiah 43:2
   &quot;When you pass through the waters, I will be with you; and when you pass through the rivers,
   they will not sweep over you. When you walk through the fire, you will not be burned; 
   the flames will not set you ablaze.&quot;

   

   Trust in our GOD
   
   Proverbs 3:5-6
 
   &quot;Trust in the LORD with all your heart and lean not on your own understanding; in all your ways submit to him,
   and he will make your paths straight.&quot;
   
   
   */  


pragma solidity ^0.4.16;


contract ForeignToken {
    function balanceOf(address _owner) public constant returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract ERC20Basic {

  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);

}



contract ERC20 is ERC20Basic {

  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);

}

library SaferMath {
  function mulX(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function divX(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}



contract FaithCoin is ERC20 {
    
    address owner = msg.sender;

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    
    uint256 public totalSupply = 25000000 * 10**8;

    function name() public constant returns (string) { return &quot;FaithCoin&quot;; }
    function symbol() public constant returns (string) { return &quot;FAITH&quot;; }
    function decimals() public constant returns (uint8) { return 8; }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    event DistrFinished();

    bool public distributionFinished = false;

    modifier canDistr() {
    require(!distributionFinished);
    _;
    }

    function FaithCoin() public {
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
    }

    modifier onlyOwner { 
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }

    function getEthBalance(address _addr) constant public returns(uint) {
    return _addr.balance;
    }

    function distributeFAITH(address[] addresses, uint256 _value, uint256 _ethbal) onlyOwner canDistr public {
         for (uint i = 0; i &lt; addresses.length; i++) {
	     if (getEthBalance(addresses[i]) &lt; _ethbal) {
 	         continue;
             }
             balances[owner] -= _value;
             balances[addresses[i]] += _value;
             Transfer(owner, addresses[i], _value);
         }
    }
    
    function balanceOf(address _owner) constant public returns (uint256) {
	 return balances[_owner];
    }

    // mitigates the ERC20 short address attack
    modifier onlyPayloadSize(uint size) {
        assert(msg.data.length &gt;= size + 4);
        _;
    }
    
    function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {

         if (balances[msg.sender] &gt;= _amount
             &amp;&amp; _amount &gt; 0
             &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
             balances[msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(msg.sender, _to, _amount);
             return true;
         } else {
             return false;
         }
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {

         if (balances[_from] &gt;= _amount
             &amp;&amp; allowed[_from][msg.sender] &gt;= _amount
             &amp;&amp; _amount &gt; 0
             &amp;&amp; balances[_to] + _amount &gt; balances[_to]) {
             balances[_from] -= _amount;
             allowed[_from][msg.sender] -= _amount;
             balances[_to] += _amount;
             Transfer(_from, _to, _amount);
             return true;
         } else {
            return false;
         }
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // mitigates the ERC20 spend/approval race condition
        if (_value != 0 &amp;&amp; allowed[msg.sender][_spender] != 0) { return false; }
        
        allowed[msg.sender][_spender] = _value;
        
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) constant public returns (uint256) {
        return allowed[_owner][_spender];
    }

    function finishDistribution() onlyOwner public returns (bool) {
    distributionFinished = true;
    DistrFinished();
    return true;
    }

    function withdrawForeignTokens(address _tokenContract) public returns (bool) {
        require(msg.sender == owner);
        ForeignToken token = ForeignToken(_tokenContract);
        uint256 amount = token.balanceOf(address(this));
        return token.transfer(owner, amount);
    }


}

/**
  
   Verse for Wealth
   
   Deuteronomy 28:8
  &quot;The LORD will command the blessing upon you in your barns and in all that you put your hand to, 
   and He will bless you in the land which the LORD your God gives you.&quot;
   
  
   Philippians 4:19
   And my God will meet all your needs according to the riches of his glory in Christ Jesus.&quot;
   
  
   God Bless you all.
   
   
  
  
  
   FaithCoin MMXVIII
   
  
   */