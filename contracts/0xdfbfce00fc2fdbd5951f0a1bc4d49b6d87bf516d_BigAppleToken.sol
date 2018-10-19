pragma solidity ^0.4.23;
// produced by the Solididy File Flattener (c) David Appleton 2018
// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="82e6e3f4e7c2e3e9edefe0e3ace1edef">[email protected]</a>
// released under Apache 2.0 licence
contract Owned {

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function setOwner(address _newOwner) public onlyOwner {
        emit onOwnershipTransferred(owner, _newOwner);
        owner = _newOwner; 
    }
    
    event onOwnershipTransferred (address indexed _from, address indexed _to);
    
}
contract ERC20 {
    /* This is a slight change to the ERC20 vip standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the vip contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    uint256 public totalSupply;

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }

    function toUINT112(uint256 a) internal pure returns(uint112) {
        assert(uint112(a) == a);
        return uint112(a);
    }

    function toUINT120(uint256 a) internal pure returns(uint120) {
        assert(uint120(a) == a);
        return uint120(a);
    }

    function toUINT128(uint256 a) internal pure returns(uint128) {
        assert(uint128(a) == a);
        return uint128(a);
    }
}

contract BigAppleToken is ERC20, Owned {

    using SafeMath for uint256;

    string public constant name    = "BigApple";        //The Token's name
    uint8 public constant decimals = 18;                //Number of decimals of the smallest unit
    string public constant symbol  = "BA";
    string public constant version = "v0.1";

    bool public transferEnabled;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    /**
    * @dev Enable/disalbe the transferring of tokens of all addresses.
    * @param _enable Determines whether or not enable token transferring.
    */
    function enableTransfer(bool _enable) external onlyOwner {
        transferEnabled = _enable;
    }
    
    /**
    * @dev Transfer token to the specified address.
    * @param _to The address token will be transferred to.
    * @param _value The amout of token will be transferred.
    * @return Returns true if the transfer succeedes, otherwise false.
    */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        
        // Not power items, transfer from the balance.
        require(transferEnabled);

        //Default assumes totalSupply can't be over max (2^256 - 1).
        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
        //Replace the if with this one instead.
        //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[msg.sender] >= _value && _value > 0) {

            balances[msg.sender] = balances[msg.sender].sub(_value);
            balances[_to] = balances[_to].add(_value);
            emit Transfer(msg.sender, _to, _value);
        }
    }

    /**
    * @dev Transfer tokens from one address to another.
    * @param _from Address from which the sender want to transfer.
    * @param _to Address to which the send want to transfer.
    * @return Returns true if the transfer succeeds, otherwise false.
    */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(transferEnabled);
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else {
            return false;
        }
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address used to query the balance.
    * @return Returns the balance of the specified address.
    */
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    * @dev Get the remained amount of tokens the specified owner approved for the specifed spender.
    * @param _owner Address of the owner of the funds.
    * @param _spender Address of the approved spender.
    * @return A uint256 specifying the remained amount of tokens available for the spender.
    */
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
        //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
        //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
        //if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
        ApprovalReceiver(_spender).receiveApproval(msg.sender, _value, this, _extraData);
        return true;
    }

    function mintToBalance(address _to, uint256 _amount) external onlyOwner {

        require(_amount >= 0);

        balances[_to] = balances[_to].add(_amount);
        totalSupply = totalSupply.add(_amount);

        // Emiting Transfer event so that wallets support ERC20 
        // can show the this minting(transferring) record to the user.
        emit Transfer(0, _to, _amount);
    }

    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    function destroy() external onlyOwner {
        selfdestruct(owner);
    }
}

contract ApprovalReceiver {
    function receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData) public;
}