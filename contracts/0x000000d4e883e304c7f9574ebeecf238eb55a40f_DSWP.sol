pragma solidity ^0.4.24;

interface TokenReceiver {
  function tokenFallback(address from, uint256 qty, bytes data) external;
}

library SafeMath {
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b &lt;= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c &gt;= a);
    return c;
  }
}

contract DSWP {
  using SafeMath for uint256;
  mapping (address =&gt; uint256) public balanceOf;
  mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
  uint256 public decimals = 18;
  string public name = &quot;Darkswap&quot;;
  string public symbol = &quot;DSWP&quot;;
  uint256 public totalSupply = 1e22;
  event Transfer(address indexed from, address indexed to, uint256 qty);
  event Approval(address indexed from, address indexed spender, uint256 qty);
  constructor() public {
    balanceOf[msg.sender] = totalSupply;
  }
  function isContract(address target) internal view returns (bool) {
    uint256 codeLength;
    assembly {
      codeLength := extcodesize(target)
    }
    return codeLength &gt; 0;
  }
  function transfer(address target, uint256 qty) external returns (bool) {
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);
    balanceOf[target] = balanceOf[target].add(qty);
    if (isContract(target)) {
      TokenReceiver(target).tokenFallback(target, qty, &quot;&quot;);
    }
    emit Transfer(msg.sender, target, qty);
    return true;
  }
  function transfer(address target, uint256 qty, bytes data) external returns (bool) {
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(qty);
    balanceOf[target] = balanceOf[target].add(qty);
    if (isContract(target)) {
      TokenReceiver(target).tokenFallback(target, qty, data);
    }
    emit Transfer(msg.sender, target, qty);
    return true;
  }
  function transferFrom(address from, address to, uint256 qty) external returns (bool) {
    allowance[from][msg.sender] = allowance[from][msg.sender].sub(qty);
    balanceOf[from] = balanceOf[from].sub(qty);
    balanceOf[to] = balanceOf[to].add(qty);
    emit Transfer(from, to, qty);
    return true;
  }
  function approve(address spender, uint256 qty) external returns (bool) {
    allowance[msg.sender][spender] = qty;
    emit Approval(msg.sender, spender, qty);
    return true;
  }
}