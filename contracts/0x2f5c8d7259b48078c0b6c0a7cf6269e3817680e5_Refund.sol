pragma solidity ^0.4.24;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
     return a / b;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c &gt;= a);
    return c;
  }
}

contract Ownable {
	address public owner;
	address public newOwner;

	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

	constructor() public {
		owner = msg.sender;
		newOwner = address(0);
	}

	modifier onlyOwner() {
		require(msg.sender == owner, &quot;msg.sender == owner&quot;);
		_;
	}

	function transferOwnership(address _newOwner) public onlyOwner {
		require(address(0) != _newOwner, &quot;address(0) != _newOwner&quot;);
		newOwner = _newOwner;
	}

	function acceptOwnership() public {
		require(msg.sender == newOwner, &quot;msg.sender == newOwner&quot;);
		emit OwnershipTransferred(owner, msg.sender);
		owner = msg.sender;
		newOwner = address(0);
	}
}

contract tokenInterface {
	function balanceOf(address _owner) public constant returns (uint256 balance);
	function transfer(address _to, uint256 _value) public returns (bool);
	function originBurn(uint256 _value) public returns(bool);
}

contract Refund is Ownable{
    using SafeMath for uint256;
    
    tokenInterface public xcc;
    
    mapping (address =&gt; uint256) public refunds;
    
    constructor(address _xcc) public {
        xcc = tokenInterface(_xcc);
    } 

    function () public  {
        require ( msg.sender == tx.origin, &quot;msg.sender == tx.orgin&quot; );
		
		uint256 xcc_amount = xcc.balanceOf(msg.sender);
		require( xcc_amount &gt; 0, &quot;xcc_amount &gt; 0&quot; );
		
		uint256 money = refunds[msg.sender];
		require( money &gt; 0 , &quot;money &gt; 0&quot; );
		
		refunds[msg.sender] = 0;
		
		xcc.originBurn(xcc_amount);
		msg.sender.transfer(money);
		
    }
    
    function setRefund(address _buyer) public onlyOwner payable {
        refunds[_buyer] = refunds[_buyer].add(msg.value);
    }
    
    function cancelRefund(address _buyer) public onlyOwner {
        uint256 money = refunds[_buyer];
        require( money &gt; 0 , &quot;money &gt; 0&quot; );
		refunds[_buyer] = 0;
		
        owner.transfer(money);
    }
    
    function withdrawTokens(address tknAddr, address to, uint256 value) public onlyOwner returns (bool) { //emergency function
        return tokenInterface(tknAddr).transfer(to, value);
    }
    
    function withdraw(address to, uint256 value) public onlyOwner { //emergency function
        to.transfer(value);
    }
}