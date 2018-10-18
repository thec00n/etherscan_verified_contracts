pragma solidity ^0.4.24;

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract  CheckErc20 { 

    function getMulBalance(address[] erc20,address addr) public view returns (uint256[]){
        uint erc20Length = erc20.length;
        uint256[]  memory balances = new uint256[](erc20Length);
        for(uint i = 0;i<erc20Length;i++){
            IERC20 erc20Contract = IERC20(erc20[i]);
            uint256 erc20Balance = erc20Contract.balanceOf(addr);
            balances[i] = erc20Balance;
        }
        return balances;
    } 
 
}