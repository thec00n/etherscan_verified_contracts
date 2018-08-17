pragma solidity 0.4.24;


contract EternalStorage {

    mapping(bytes32 =&gt; uint256) internal uintStorage;
    mapping(bytes32 =&gt; string) internal stringStorage;
    mapping(bytes32 =&gt; address) internal addressStorage;
    mapping(bytes32 =&gt; bytes) internal bytesStorage;
    mapping(bytes32 =&gt; bool) internal boolStorage;
    mapping(bytes32 =&gt; int256) internal intStorage;

}


contract UpgradeabilityOwnerStorage {
    address private _upgradeabilityOwner;

    function upgradeabilityOwner() public view returns (address) {
        return _upgradeabilityOwner;
    }

    function setUpgradeabilityOwner(address newUpgradeabilityOwner) internal {
        _upgradeabilityOwner = newUpgradeabilityOwner;
    }

}

contract UpgradeabilityStorage {

    string internal _version;

    address internal _implementation;

    function version() public view returns (string) {
        return _version;
    }

    function implementation() public view returns (address) {
        return _implementation;
    }
}



contract OwnedUpgradeabilityStorage is UpgradeabilityOwnerStorage, UpgradeabilityStorage, EternalStorage {}



library SafeMath {


  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }


  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }


  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }


  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}



contract Ownable is EternalStorage {
  
    event OwnershipTransferred(address previousOwner, address newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner());
        _;
    }

    function owner() public view returns (address) {
        return addressStorage[keccak256(&quot;owner&quot;)];
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        setOwner(newOwner);
    }

    function setOwner(address newOwner) internal {
        emit OwnershipTransferred(owner(), newOwner);
        addressStorage[keccak256(&quot;owner&quot;)] = newOwner;
    }
}





contract Claimable is EternalStorage, Ownable {
    function pendingOwner() public view returns (address) {
        return addressStorage[keccak256(&quot;pendingOwner&quot;)];
    }

    
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner());
        _;
    }

    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        addressStorage[keccak256(&quot;pendingOwner&quot;)] = newOwner;
    }

    
    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(owner(), pendingOwner());
        addressStorage[keccak256(&quot;owner&quot;)] = addressStorage[keccak256(&quot;pendingOwner&quot;)];
        addressStorage[keccak256(&quot;pendingOwner&quot;)] = address(0);
    }
}

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}


contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract UpgradebleStormSender is OwnedUpgradeabilityStorage, Claimable {
    using SafeMath for uint256;

    event Multisended(uint256 total, address tokenAddress);
    event ClaimedTokens(address token, address owner, uint256 balance);

    modifier hasFee() {
        if (currentFee(msg.sender) &gt; 0) {
            require(msg.value &gt;= currentFee(msg.sender));
        }
        _;
    }

    function() public payable {}

    function initialize(address _owner) public {
        require(!initialized());
        setOwner(_owner);
        setArrayLimit(200);
        setDiscountStep(0.00002 ether);
        setFee(0.02 ether);
        boolStorage[keccak256(&quot;rs_multisender_initialized&quot;)] = true;
    }

    function initialized() public view returns (bool) {
        return boolStorage[keccak256(&quot;rs_multisender_initialized&quot;)];
    }
 
    function txCount(address customer) public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked(&quot;txCount&quot;, customer))];
    }

    function arrayLimit() public view returns(uint256) {
        return uintStorage[keccak256(abi.encodePacked(&quot;arrayLimit&quot;))];
    }

    function setArrayLimit(uint256 _newLimit) public onlyOwner {
        require(_newLimit != 0);
        uintStorage[keccak256(&quot;arrayLimit&quot;)] = _newLimit;
    }

    function discountStep() public view returns(uint256) {
        return uintStorage[keccak256(&quot;discountStep&quot;)];
    }

    function setDiscountStep(uint256 _newStep) public onlyOwner {
        require(_newStep != 0);
        uintStorage[keccak256(&quot;discountStep&quot;)] = _newStep;
    }

    function fee() public view returns(uint256) {
        return uintStorage[keccak256(&quot;fee&quot;)];
    }

    function currentFee(address _customer) public view returns(uint256) {
        if (fee() &gt; discountRate(msg.sender)) {
            return fee().sub(discountRate(_customer));
        } else {
            return 0;
        }
    }

    function setFee(uint256 _newStep) public onlyOwner {
        require(_newStep != 0);
        uintStorage[keccak256(&quot;fee&quot;)] = _newStep;
    }

    function discountRate(address _customer) public view returns(uint256) {
        uint256 count = txCount(_customer);
        return count.mul(discountStep());
    }

    function multisendToken(address token, address[] _contributors, uint256[] _balances) public hasFee payable {
        if (token == 0x000000000000000000000000000000000000bEEF){
            multisendEther(_contributors, _balances);
        } else {
            uint256 total = 0;
            require(_contributors.length &lt;= arrayLimit());
            ERC20 erc20token = ERC20(token);
            uint8 i = 0;
            for (i; i &lt; _contributors.length; i++) {
                erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
                total += _balances[i];
            }
            setTxCount(msg.sender, txCount(msg.sender).add(1));
            emit Multisended(total, token);
        }
    }

    function multisendEther(address[] _contributors, uint256[] _balances) public payable {
        uint256 total = msg.value;
        uint256 userfee = currentFee(msg.sender);
        require(total &gt;= userfee);
        require(_contributors.length &lt;= arrayLimit());
        total = total.sub(userfee);
        uint256 i = 0;
        for (i; i &lt; _contributors.length; i++) {
            require(total &gt;= _balances[i]);
            total = total.sub(_balances[i]);
            _contributors[i].transfer(_balances[i]);
        }
        setTxCount(msg.sender, txCount(msg.sender).add(1));
        emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
    }

    function claimTokens(address _token) public onlyOwner {
        if (_token == 0x0) {
            owner().transfer(address(this).balance);
            return;
        }
        ERC20 erc20token = ERC20(_token);
        uint256 balance = erc20token.balanceOf(this);
        erc20token.transfer(owner(), balance);
        emit ClaimedTokens(_token, owner(), balance);
    }
    
    function setTxCount(address customer, uint256 _txCount) private {
        uintStorage[keccak256(abi.encodePacked(&quot;txCount&quot;, customer))] = _txCount;
    }

}