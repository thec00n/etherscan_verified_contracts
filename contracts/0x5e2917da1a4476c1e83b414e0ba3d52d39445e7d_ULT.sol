pragma solidity ^0.4.19;

contract ULT {
    string public name = 'ULT';
    string public symbol = 'ULT';
    uint8 public decimals = 18;
    uint public totalSupply = 1000000000000000000000000;
    uint public reducer = 1000000000000;
    uint public minPayment = 100000000000000000;
    address public owner;
    uint private ownerBalance;
    
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }
    
    function transferOwnership(address newOwner) external onlyOwner {
        owner = newOwner;
    }
    
    /* Initializes contract with initial supply tokens to the creator of the contract */
    function ULT() public {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }
    
    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value > balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    /* Send coins */
    function transfer(address _to, uint256 _value) external {
        _transfer(msg.sender, _to, _value);
    }
    
    /* Transfer tokens from other address */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    
    /* Set allowance for other address */
    function approve(address _spender, uint256 _value) external returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    function withdrawEther() external onlyOwner {
        owner.transfer(ownerBalance);
        ownerBalance = 0;
    }
    
    function () external payable {
        if (msg.value < minPayment) {
            revert();
        }
        ownerBalance += msg.value;
        uint reward = msg.value / reducer;
        balanceOf[msg.sender] += reward;
        totalSupply += reward;
        Transfer(0, this, reward);
        Transfer(this, msg.sender, reward);
        reducer = reducer * 101 / 100;
    }
}