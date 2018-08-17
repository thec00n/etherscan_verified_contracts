pragma solidity ^0.4.15;
contract ERC20Basic {
 uint256 public totalSupply;
 function balanceOf(address who) constant returns (uint256);
 function transfer(address to, uint256 value) returns (bool);
 event Transfer(address indexed from, address indexed to, uint256 value);
}
contract ERC20 is ERC20Basic {
 function allowance(address owner, address spender) constant returns (uint256);
 function transferFrom(address from, address to, uint256 value) returns (bool);
 function approve(address spender, uint256 value) returns (bool);
 event Approval(address indexed owner, address indexed spender, uint256 value);
}
library SafeMath {
 function mul(uint256 a, uint256 b) internal constant returns (uint256) {
   uint256 c = a * b;
   assert(a == 0 || c / a == b);
   return c;
 }
 function div(uint256 a, uint256 b) internal constant returns (uint256) {
   uint256 c = a / b;
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
contract BasicToken is ERC20Basic {
 using SafeMath for uint256;
 mapping(address =&gt; uint256) balances;
 function transfer(address _to, uint256 _value) returns (bool) {
   balances[msg.sender] = balances[msg.sender].sub(_value);
   balances[_to] = balances[_to].add(_value);
   Transfer(msg.sender, _to, _value);
   return true;
 }
 function balanceOf(address _owner) constant returns (uint256 balance) {
   return balances[_owner];
 }
}
contract StandardToken is ERC20, BasicToken {
 mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
 function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
   var _allowance = allowed[_from][msg.sender];
   balances[_to] = balances[_to].add(_value);
   balances[_from] = balances[_from].sub(_value);
   allowed[_from][msg.sender] = _allowance.sub(_value);
   Transfer(_from, _to, _value);
   return true;
 }
 function approve(address _spender, uint256 _value) returns (bool) {
   require((_value == 0) || (allowed[msg.sender][_spender] == 0));
   allowed[msg.sender][_spender] = _value;
   Approval(msg.sender, _spender, _value);
   return true;
 }
 function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
   return allowed[_owner][_spender];
 }
}
contract Ownable {
 address public owner;
 function Ownable() {
   owner = msg.sender;
 }
 modifier onlyOwner() {
   require(msg.sender == owner);
   _;
 }
 function transferOwnership(address newOwner) onlyOwner {
   require(newOwner != address(0));
   owner = newOwner;
 }
}
contract MintableToken is StandardToken, Ownable {
 event Mint(address indexed to, uint256 amount);
 event MintFinished();
 bool public mintingFinished = false;
 modifier canMint() {
   require(!mintingFinished);
   _;
 }
 function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
   totalSupply = totalSupply.add(_amount);
   balances[_to] = balances[_to].add(_amount);
   Mint(_to, _amount);
   return true;
 }
 function finishMinting() onlyOwner returns (bool) {
   mintingFinished = true;
   MintFinished();
   return true;
 }
}
contract GlobalCryptoBank is MintableToken {
   string public constant name = &quot;Global Crypto Bank&quot;;
   string public constant symbol = &quot;BANK&quot;;
   uint32 public constant decimals = 18;
   uint public INITIAL_SUPPLY = 50000000 * 1 ether;
   function GlobalCryptoBank() {
       mint(owner, INITIAL_SUPPLY);
       transfer(0x0e2Bec7F14F244c5D1b4Ce14f48dcDb88fB61690, 2000000 * 1 ether);
       finishMinting();
   }
}
contract Crowdsale is Ownable {
   using SafeMath for uint;
   address founderAddress;
   address bountyAddress;
   uint preIsoTokenLimit;
   uint isoTokenLimit;
   uint preIsoStartDate;
   uint preIsoEndDate;
   uint isoStartDate;
   uint isoEndDate;
   uint rate;
   uint founderPercent;
   uint bountyPercent;
   uint public soldTokens = 0;
   GlobalCryptoBank public token = new GlobalCryptoBank();
   function Crowdsale () payable {
       founderAddress = 0xF12B75857E56727c90fc473Fe18C790B364468eD;
       bountyAddress = 0x0e2Bec7F14F244c5D1b4Ce14f48dcDb88fB61690;
       founderPercent = 90;
       bountyPercent = 10;
       rate = 300 * 1 ether;
       preIsoStartDate = 1509321600;
       preIsoEndDate = 1511049600;
       isoStartDate = 1511568000;
       isoEndDate = 1514678399;
       preIsoTokenLimit = 775000 * 1 ether;
       isoTokenLimit = 47225000 * 1 ether;
   }
   modifier isUnderPreIsoLimit(uint value) {
       require((soldTokens+rate.mul(value).div(1 ether)+rate.mul(value).div(1 ether).mul(getPreIsoBonusPercent(value).div(100))) &lt;= preIsoTokenLimit);
       _;
   }
   modifier isUnderIsoLimit(uint value) {
       require((soldTokens+rate.mul(value).div(1 ether)+rate.mul(value).div(1 ether).mul(getIsoBonusPercent(value).div(100))) &lt;= isoTokenLimit);
       _;
   }
   function getPreIsoBonusPercent(uint value) private returns (uint) {
       uint eth = value.div(1 ether);
       uint bonusPercent = 0;
       if (now &gt;= preIsoStartDate &amp;&amp; now &lt;= preIsoStartDate + 2 days) {
           bonusPercent += 35;
       } else if (now &gt;= preIsoStartDate + 2 days &amp;&amp; now &lt;= preIsoStartDate + 7 days) {
           bonusPercent += 33;
       } else if (now &gt;= preIsoStartDate + 7 days &amp;&amp; now &lt;= preIsoStartDate + 14 days) {
           bonusPercent += 31;
       } else if (now &gt;= preIsoStartDate + 14 days &amp;&amp; now &lt;= preIsoStartDate + 21 days) {
           bonusPercent += 30;
       }
       
       
       if (eth &gt;= 1 &amp;&amp; eth &lt; 10) {
           bonusPercent += 2;
       } else if (eth &gt;= 10 &amp;&amp; eth &lt; 50) {
           bonusPercent += 4;
       } else if (eth &gt;= 50 &amp;&amp; eth &lt; 100) {
           bonusPercent += 8;
       } else if (eth &gt;= 100) {
           bonusPercent += 10;
       }
       return bonusPercent;
   }
   function getIsoBonusPercent(uint value) private returns (uint) {
       uint eth = value.div(1 ether);
       uint bonusPercent = 0;
       if (now &gt;= isoStartDate &amp;&amp; now &lt;= isoStartDate + 2 days) {
           bonusPercent += 20;
       } else if (now &gt;= isoStartDate + 2 days &amp;&amp; now &lt;= isoStartDate + 7 days) {
           bonusPercent += 18;
       } else if (now &gt;= isoStartDate + 7 days &amp;&amp; now &lt;= isoStartDate + 14 days) {
           bonusPercent += 15;
       } else if (now &gt;= isoStartDate + 14 days &amp;&amp; now &lt;= isoStartDate + 21 days) {
           bonusPercent += 10;
       }
       if (eth &gt;= 1 &amp;&amp; eth &lt; 10) {
           bonusPercent += 2;
       } else if (eth &gt;= 10 &amp;&amp; eth &lt; 50) {
           bonusPercent += 4;
       } else if (eth &gt;= 50 &amp;&amp; eth &lt; 100) {
           bonusPercent += 8;
       } else if (eth &gt;= 100) {
           bonusPercent += 10;
       }
       return bonusPercent;
   }
   function buyPreICOTokens(uint value, address sender) private isUnderPreIsoLimit(value) {
       founderAddress.transfer(value.div(100).mul(founderPercent));
       bountyAddress.transfer(value.div(100).mul(bountyPercent));
       uint tokens = rate.mul(value).div(1 ether);
       uint bonusTokens = 0;
       uint bonusPercent = getPreIsoBonusPercent(value);
       bonusTokens = tokens.mul(bonusPercent).div(100);
       tokens += bonusTokens;
       soldTokens += tokens;
       token.transfer(sender, tokens);
   }
   function buyICOTokens(uint value, address sender) private isUnderIsoLimit(value) {
       founderAddress.transfer(value.div(100).mul(founderPercent));
       bountyAddress.transfer(value.div(100).mul(bountyPercent));
       uint tokens = rate.mul(value).div(1 ether);
       uint bonusTokens = 0;
       uint bonusPercent = getIsoBonusPercent(value);
       bonusTokens = tokens.mul(bonusPercent).div(100);
       tokens += bonusTokens;
       soldTokens += tokens;
       token.transfer(sender, tokens);
   }
   function() external payable {
       if (now &gt;= preIsoStartDate &amp;&amp; now &lt; preIsoEndDate) {
           buyPreICOTokens(msg.value, msg.sender);
       } else if (now &gt;= isoStartDate &amp;&amp; now &lt; isoEndDate) {
           buyICOTokens(msg.value, msg.sender);
       }
   }
}