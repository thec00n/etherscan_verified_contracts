pragma solidity ^0.4.24;

contract ERC20BasicCutted {
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
}

contract IntermediateWallet {
    
  address public token = 0x2D3E7D4870a51b918919E7B851FE19983E4c38d5;  

  address public wallet =0x0B18Ed2b002458e297ed1722bc5599E98AcEF9a5;

  modifier onlyOwner() {
    require(msg.sender == token);  
    _;
  }

  function () payable public {
    wallet.transfer(msg.value);
  }
  
  function retrieveTokens(address to, address anotherToken) public onlyOwner {
    ERC20BasicCutted alienToken = ERC20BasicCutted(anotherToken);
    alienToken.transfer(to, alienToken.balanceOf(this));
  }
  
  function tokenFallback(address _from, uint _value) public onlyOwner {
    ERC20BasicCutted(token).transfer(wallet, _value);
  }

}