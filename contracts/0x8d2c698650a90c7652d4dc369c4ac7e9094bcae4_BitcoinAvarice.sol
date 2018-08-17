pragma solidity ^0.4.11;



/**
 * @title Bitcoin Avarice
 * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
 * Note they can later distribute these tokens as they wish using `transfer` and other
 * `StandardToken` functions.
 */
contract BitcoinAvarice {

  string public constant name = &quot;Bitcoin Avarice&quot;;
  string public constant symbol = &quot;BTAV&quot;;
  uint8 public constant decimals = 18;

 
  uint256 public constant TOTAL_SUPPLY = 21000 * (10 ** uint256(decimals));
  
  /**
   * @dev Constructor that gives msg.sender all of existing tokens.
   */
 
   
    
  }