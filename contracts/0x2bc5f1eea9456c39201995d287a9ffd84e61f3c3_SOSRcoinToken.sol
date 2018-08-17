pragma solidity ^0.4.19;

//*************** SafeMath ***************

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
      uint256 c = a * b;
      assert(a == 0 || c / a == b);
      return c;
  }

  function div(uint256 a, uint256 b) internal pure  returns (uint256) {
      assert(b &gt; 0);
      uint256 c = a / b;
      return c;
  }

  function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
      assert(b &lt;= a);
      return a - b;
  }

  function add(uint256 a, uint256 b) internal pure  returns (uint256) {
      uint256 c = a + b;
      assert(c &gt;= a);
      return c;
  }
}

//*************** Ownable

contract Ownable {
  address public owner;

  function Ownable() public {
      owner = msg.sender;
  }

  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  function transferOwnership(address newOwner)public onlyOwner {
      if (newOwner != address(0)) {
        owner = newOwner;
      }
  }

}

//************* ERC20

contract ERC20 {
  uint256 public totalSupply;
  function balanceOf(address who)public constant returns (uint256);
  function transfer(address to, uint256 value)public returns (bool);
  function transferFrom(address from, address to, uint256 value)public returns (bool);
  function allowance(address owner, address spender)public constant returns (uint256);
  function approve(address spender, uint256 value)public returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event ExchangeTokenPushed(address indexed buyer, uint256 amount);
  event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);  
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

//************* SOSRcoinToken

contract SOSRcoinToken is ERC20,Ownable {
 using SafeMath for uint256;

 // Token Info.
 string public name;
 string public symbol;

 uint8 public constant decimals = 18;

 address[] private walletArr;
 uint walletIdx = 0;
 uint256 public candyTotalSupply = 100000*(10**18);
 uint256 public currentCandyTotalSupply = 0;
 uint256 public candyBalance = 5*(10**18);
 uint256 public date610 = 1528560000;
 uint256 public totalSupply1 = 20000000*(10**18);
 uint256 public totalSupply2 = 40000000*(10**18);
 uint256 public minValue1 = 15 ether;
 uint256 public minValue2 = 0.1 ether;
 uint256 public rate1 = 1620;
 uint256 public rate2 = 1500;
 uint256 public rate3 = 1200;

 mapping (address =&gt; bool) touched;
 mapping (address =&gt; uint256) public balanceOf;
 mapping (address =&gt; mapping (address =&gt; uint256)) allowed;

 event TokenPurchase(address indexed purchaser, uint256 value,uint256 amount);
 event FundTransfer(address fundWallet, uint256 amount);

 function SOSRcoinToken( ) public {
   totalSupply = 50000000*(10**18);         
   balanceOf[msg.sender] = totalSupply ; 
   name = &quot;SOSRcoin&quot;; 
   symbol =&quot;SOSR&quot;; 
   walletArr.push(0x72BA86a847Ead7b69c3e92F88eb2Aa21C3Aa1C58); 
   walletArr.push(0x39DE3fa8976572819b0012B11b506E100a765453);
   touched[owner] = true;
 }

 function balanceOf(address _who)public constant returns (uint256 balance) {
    return getBalance(_who);
 }
 
function getBalance(address _who) internal constant returns(uint256){
	if( currentCandyTotalSupply &lt; candyTotalSupply ){
	    if( touched[_who] )
		return balanceOf[_who];
	    else
		return balanceOf[_who].add( candyBalance );
	} else {
	    return balanceOf[_who];
	}
}
    
 function _transferFrom(address _from, address _to, uint256 _value)  internal {
     require(_to != 0x0);
     
     if( currentCandyTotalSupply &lt; candyTotalSupply &amp;&amp; !touched[_from]  ){
            balanceOf[_from] = balanceOf[_from].add( candyBalance );
            touched[_from] = true;
            currentCandyTotalSupply = currentCandyTotalSupply.add( candyBalance );
     }     
     require(balanceOf[_from] &gt;= _value);
     require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
     balanceOf[_from] = balanceOf[_from].sub(_value);
     balanceOf[_to] = balanceOf[_to].add(_value);
     Transfer(_from, _to, _value);
 }

 function transfer(address _to, uint256 _value) public returns (bool){     
     _transferFrom(msg.sender,_to,_value);
     return true;
 }

 function push(address _buyer, uint256 _amount) public onlyOwner {
     uint256 val=_amount*(10**18);
     _transferFrom(msg.sender,_buyer,val);
     ExchangeTokenPushed(_buyer, val);
 }

 function ()public payable {
     _tokenPurchase( );
 }

 function _tokenPurchase( ) internal {   
     require(saleActive(msg.value));     
     uint256 weiAmount = msg.value;
     uint256 actualRate = getActualRate(); 
     uint256 amount = weiAmount.mul(actualRate);
     _transferFrom(owner, msg.sender,amount);
     TokenPurchase(msg.sender, weiAmount,amount);        
     address wallet = walletArr[walletIdx];
     walletIdx = (walletIdx+1) % walletArr.length;
     wallet.transfer(msg.value);
     FundTransfer(wallet, msg.value);
 }

 function saleActive(uint256 _value) public constant returns (bool) {
     bool res = false;
     uint256 t = getCurrentTimestamp();
     uint256 s = totalSupply - balanceOf[owner];
     if(supply() &gt; 0 &amp;&amp; t &lt; date610){
       if(s &lt; totalSupply2){
           if( _value&gt;=minValue1 ){
              res = true;
           }
       }else{
           if( _value&gt;= minValue2 ){
              res = true;
           }
       }
     }
     return res;
 }

 function getActualRate() internal view returns (uint256){  
    uint256 rate=0;      
    uint256 s = totalSupply - balanceOf[owner];	
    if(s &lt; totalSupply1){
	 rate = rate1;
    }else if(s &lt; totalSupply2){
	 rate = rate2;
    }else{
         rate = rate3;
    }    
    return rate;
 }
 
 function supply()  internal constant  returns (uint256) {
     return balanceOf[owner];
 }

 function getCurrentTimestamp() internal view returns (uint256){
     return now;
 }

 function allowance(address _owner, address _spender)public constant returns (uint256 remaining) {
     return allowed[_owner][_spender];
 }

 function approve(address _spender, uint256 _value)public returns (bool) {
     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
     allowed[msg.sender][_spender] = _value;
     Approval(msg.sender, _spender, _value);
     return true;
 }
 
 function transferFrom(address _from, address _to, uint256 _value)public returns (bool) {
     var _allowance = allowed[_from][msg.sender];
     require (_value &lt;= _allowance);  
      _transferFrom(_from,_to,_value);
     allowed[_from][msg.sender] = _allowance.sub(_value);
     Transfer(_from, _to, _value);
     return true;
   }
 
}