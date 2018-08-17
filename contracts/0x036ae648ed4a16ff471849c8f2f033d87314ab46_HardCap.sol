pragma solidity 0.4.19;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control 
 * functions, this simplifies the implementation of &quot;user permissions&quot;. 
 */
contract Ownable {
  address public owner;

  /** 
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner. 
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to. 
   */
  function transferOwnership(address newOwner) onlyOwner public {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}


/**
 * Math operations with safety checks
 */
library SafeMath {
  function mul(uint a, uint b) internal returns (uint) {
    uint c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint a, uint b) internal returns (uint) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint a, uint b) internal returns (uint) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint a, uint b) internal returns (uint) {
    uint c = a + b;
    assert(c &gt;= a);
    return c;
  }

  function max64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &gt;= b ? a : b;
  }

  function min64(uint64 a, uint64 b) internal constant returns (uint64) {
    return a &lt; b ? a : b;
  }

  function max256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &gt;= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal constant returns (uint256) {
    return a &lt; b ? a : b;
  }

}


/**
 * @title HardCap
 * @dev Allows updating and retrieveing of Conversion HardCap for ABLE tokens
 *
 * ABI
 * [{&quot;constant&quot;: true,&quot;inputs&quot;: [{&quot;name&quot;: &quot;_symbol&quot;,&quot;type&quot;: &quot;string&quot;}],&quot;name&quot;: &quot;getCap&quot;,&quot;outputs&quot;: [{&quot;name&quot;: &quot;&quot;,&quot;type&quot;: &quot;uint256&quot;}],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;view&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: true,&quot;inputs&quot;: [],&quot;name&quot;: &quot;owner&quot;,&quot;outputs&quot;: [{&quot;name&quot;: &quot;&quot;,&quot;type&quot;: &quot;address&quot;}],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;view&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: false,&quot;inputs&quot;: [{&quot;name&quot;: &quot;_symbol&quot;,&quot;type&quot;: &quot;string&quot;},{&quot;name&quot;: &quot;_cap&quot;,&quot;type&quot;: &quot;uint256&quot;}],&quot;name&quot;: &quot;updateCap&quot;,&quot;outputs&quot;: [],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;nonpayable&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: false,&quot;inputs&quot;: [{&quot;name&quot;: &quot;data&quot;,&quot;type&quot;: &quot;uint256[]&quot;}],&quot;name&quot;: &quot;updateCaps&quot;,&quot;outputs&quot;: [],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;nonpayable&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: true,&quot;inputs&quot;: [],&quot;name&quot;: &quot;getHardCap&quot;,&quot;outputs&quot;: [{&quot;name&quot;: &quot;&quot;,&quot;type&quot;: &quot;uint256&quot;}],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;view&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: true,&quot;inputs&quot;: [{&quot;name&quot;: &quot;&quot;,&quot;type&quot;: &quot;bytes32&quot;}],&quot;name&quot;: &quot;caps&quot;,&quot;outputs&quot;: [{&quot;name&quot;: &quot;&quot;,&quot;type&quot;: &quot;uint256&quot;}],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;view&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;constant&quot;: false,&quot;inputs&quot;: [{&quot;name&quot;: &quot;newOwner&quot;,&quot;type&quot;: &quot;address&quot;}],&quot;name&quot;: &quot;transferOwnership&quot;,&quot;outputs&quot;: [],&quot;payable&quot;: false,&quot;stateMutability&quot;: &quot;nonpayable&quot;,&quot;type&quot;: &quot;function&quot;},{&quot;anonymous&quot;: false,&quot;inputs&quot;: [{&quot;indexed&quot;: false,&quot;name&quot;: &quot;timestamp&quot;,&quot;type&quot;: &quot;uint256&quot;},{&quot;indexed&quot;: false,&quot;name&quot;: &quot;symbol&quot;,&quot;type&quot;: &quot;bytes32&quot;},{&quot;indexed&quot;: false,&quot;name&quot;: &quot;rate&quot;,&quot;type&quot;: &quot;uint256&quot;}],&quot;name&quot;: &quot;CapUpdated&quot;,&quot;type&quot;: &quot;event&quot;}]
 */
contract HardCap is Ownable {
  using SafeMath for uint;
  event CapUpdated(uint timestamp, bytes32 symbol, uint rate);
  
  mapping(bytes32 =&gt; uint) public caps;
  uint hardcap = 0;

  /**
   * @dev Allows the current owner to update a single cap.
   * @param _symbol The symbol to be updated. 
   * @param _cap the cap for the symbol. 
   */
  function updateCap(string _symbol, uint _cap) public onlyOwner {
    caps[sha3(_symbol)] = _cap;
    hardcap = hardcap.add(_cap) ;
    CapUpdated(now, sha3(_symbol), _cap);
  }

  /**
   * @dev Allows the current owner to update multiple caps.
   * @param data an array that alternates sha3 hashes of the symbol and the corresponding cap . 
   */
  function updateCaps(uint[] data) public onlyOwner {
    require(data.length % 2 == 0);
    uint i = 0;
    while (i &lt; data.length / 2) {
      bytes32 symbol = bytes32(data[i * 2]);
      uint cap = data[i * 2 + 1];
      caps[symbol] = cap;
      hardcap = hardcap.add(cap);
      CapUpdated(now, symbol, cap);
      i++;
    }
  }

  /**
   * @dev Allows the anyone to read the current cap.
   * @param _symbol the symbol to be retrieved. 
   */
  function getCap(string _symbol) public constant returns(uint) {
    return caps[sha3(_symbol)];
  }
  
  /**
   * @dev Allows the anyone to read the current hardcap.
   */
  function getHardCap() public constant returns(uint) {
    return hardcap;
  }

}