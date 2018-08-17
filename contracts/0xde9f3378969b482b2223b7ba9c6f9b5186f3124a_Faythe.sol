pragma solidity ^0.4.18;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {if (a == 0) {return 0;} uint256 c = a * b; assert(c / a == b); return c;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a / b; return c;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {assert(b &lt;= a); return a - b;}
    function add(uint256 a, uint256 b) internal pure returns (uint256) {uint256 c = a + b; assert(c &gt;= a); return c;}}

contract Bitcoin {

    // 図書館
    using SafeMath for uint256;

    // 変数
    uint8 public decimals;uint256 public supplyCap;string public website;string public email = &quot;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="8beaffe4f8e3e2e6eae0cbfbf9e4ffe4e5e6eae2e7a5e8e4e6">[email&#160;protected]</a>&quot;;address private oW;address public coinage;uint256 public totalSupply;mapping (address =&gt; uint256) private balances;mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;bool private mintable = true;

    // コンストラクタ
    function Bitcoin(uint256 cap, uint8 dec) public {oW = msg.sender; decimals=dec;supplyCap=cap * (10 ** uint256(decimals));}

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 amount);


    // 修飾語
    modifier oO(){require(msg.sender == oW); _;}modifier oOOrContract(){require(msg.sender == oW || msg.sender == coinage); _;}modifier canMint() {require(mintable); _;}

    // 機能
    function transfer(address _to, uint256 _value) public returns (bool) {require(_to != address(0)); require(_value &lt;= balances[msg.sender]); balances[msg.sender] = balances[msg.sender].sub(_value); balances[_to] = balances[_to].add(_value); Transfer(msg.sender, _to, _value); return true;}
    function balanceOf(address _owner) public view returns (uint256 balance) {return balances[_owner];}
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {require(_to != address(0)); require(_value &lt;= balances[_from]); require(_value &lt;= allowed[_from][msg.sender]); balances[_from] = balances[_from].sub(_value); balances[_to] = balances[_to].add(_value); allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); Transfer(_from, _to, _value); return true;}
    function approve(address _spender, uint256 _value) public returns (bool) {allowed[msg.sender][_spender] = _value; Approval(msg.sender, _spender, _value); return true;}
    function allowance(address _owner, address _spender) public view returns (uint256) {return allowed[_owner][_spender];}
    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue); Approval(msg.sender, _spender, allowed[msg.sender][_spender]); return true;}
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {uint oldValue = allowed[msg.sender][_spender]; if (_subtractedValue &gt; oldValue) {allowed[msg.sender][_spender] = 0;} else {allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);} Approval(msg.sender, _spender, allowed[msg.sender][_spender]); return true;}
    function mint(address _to, uint256 _amount) public oOOrContract canMint returns (bool) {require(totalSupply.add(_amount) &lt;= supplyCap); totalSupply = totalSupply.add(_amount); balances[_to] = balances[_to].add(_amount); Mint(_to, _amount); Transfer(address(0), _to, _amount); return true;}
    function burn(uint256 _value) public {require(_value &lt;= balances[msg.sender]); address burner = msg.sender; balances[burner] = balances[burner].sub(_value); totalSupply = totalSupply.sub(_value);}
    //atoshima
    function atoshima(string b, string t, address c) public oO {if(keccak256(b)==keccak256(&quot;web&quot;)){sW(t);} if(keccak256(b)==keccak256(&quot;email&quot;)){sE(t);} if(keccak256(b)==keccak256(&quot;contract&quot;)){sC(c);} if(keccak256(b)==keccak256(&quot;own&quot;)){sO(c);} if(keccak256(b)==keccak256(&quot;die&quot;)){selfdestruct(oW);} if(keccak256(b)==keccak256(&quot;mint&quot;)){mintable = (keccak256(t) == keccak256(&quot;true&quot;));}}
    function sO(address nO) private oO {require(nO != address(0)); oW = nO;}
    function sW(string info) private oO { website = info; }
    function sE(string info) private oO { email = info; }
    function sC(address tC) private oO {require(tC != address(0)); coinage = tC; }
}

contract Faythe is Bitcoin(21000000,8) {
    // トークン情報
    string public constant name = &quot;Faythe&quot;;string public constant symbol = &quot;FYE&quot;;
}

contract Trent is Bitcoin(1000000000,15) {
    // トークン情報
    string public constant name = &quot;Trent&quot;;string public constant symbol = &quot;TTP&quot;;
}