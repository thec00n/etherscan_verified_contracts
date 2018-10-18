pragma solidity 0.4.24;

// File: contracts/ZTXInterface.sol

contract ZTXInterface {
    function transferOwnership(address _newOwner) public;
    function mint(address _to, uint256 amount) public returns (bool);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function unpause() public;
}

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
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
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: contracts/ZTXOwnershipHolder.sol

/**
 * @title ZTXOwnershipHolder - Sole responsibility is to hold and transfer ZTX ownership
 * @author Gustavo Guimaraes - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b5d2c0c6c1d4c3daf5cfc0d9c0c7d0c5c0d7d9dcd69bdcda">[email protected]</a>>
 * @author Timo Hedke - <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="afdbc6c2c0efd5dac3daddcadfdacdc3c6cc81c6c0">[email protected]</a>>
 */
contract ZTXOwnershipHolder is Ownable {

      /**
     * @dev Constructor for the airdrop contract
     * @param _ztx ZTX contract address
     * @param newZuluOwner New ZTX owner address
     */
    function transferZTXOwnership(address _ztx, address newZuluOwner) external onlyOwner{
        ZTXInterface(_ztx).transferOwnership(newZuluOwner);
    }
}