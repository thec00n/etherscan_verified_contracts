pragma solidity ^0.4.22;

contract ERC725 {

    uint256 public constant MANAGEMENT_KEY = 1;
    uint256 public constant ACTION_KEY = 2;
    uint256 public constant CLAIM_SIGNER_KEY = 3;
    uint256 public constant ENCRYPTION_KEY = 4;

    event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
    event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
    event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
    event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
    event Approved(uint256 indexed executionId, bool approved);

    struct Key {
        uint256[] purpose; //e.g., MANAGEMENT_KEY = 1, ACTION_KEY = 2, etc.
        uint256 keyType; // e.g. 1 = ECDSA, 2 = RSA, etc.
        bytes32 key;
    }

    function getKey(bytes32 _key) public constant returns(uint256[] purpose, uint256 keyType, bytes32 key);
    function getKeyPurpose(bytes32 _key) public constant returns(uint256[] purpose);
    function getKeysByPurpose(uint256 _purpose) public constant returns(bytes32[] keys);
    function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) public returns (bool success);
    function removeKey(bytes32 _key, uint256 _purpose) public returns (bool success);
    function execute(address _to, uint256 _value, bytes _data) public returns (uint256 executionId);
    function approve(uint256 _id, bool _approve) public returns (bool success);
}


contract ERC20Basic {
    function balanceOf(address _who) public constant returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
}

contract Identity is ERC725 {

    uint256 constant LOGIN_KEY = 10;
    uint256 constant FUNDS_MANAGEMENT = 11;

    uint256 executionNonce;

    struct Execution {
        address to;
        uint256 value;
        bytes data;
        bool approved;
        bool executed;
    }

    mapping (bytes32 => Key) keys;
    mapping (uint256 => bytes32[]) keysByPurpose;
    mapping (uint256 => Execution) executions;

    event ExecutionFailed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);

    modifier onlyManagement() {
        require(keyHasPurpose(keccak256(msg.sender), MANAGEMENT_KEY), "Sender does not have management key");
        _;
    }

    modifier onlyAction() {
        require(keyHasPurpose(keccak256(msg.sender), ACTION_KEY), "Sender does not have action key");
        _;
    }

    modifier onlyFundsManagement() {
        require(keyHasPurpose(keccak256(msg.sender), FUNDS_MANAGEMENT), "Sender does not have funds key");
        _;
    }

    constructor() public {
        bytes32 _key = keccak256(msg.sender);
        keys[_key].key = _key;
        keys[_key].purpose = [MANAGEMENT_KEY];
        keys[_key].keyType = 1;
        keysByPurpose[MANAGEMENT_KEY].push(_key);
        emit KeyAdded(_key, MANAGEMENT_KEY, 1);
    }

    function getKey(bytes32 _key)
        public
        view
        returns(uint256[] purpose, uint256 keyType, bytes32 key)
    {
        return (keys[_key].purpose, keys[_key].keyType, keys[_key].key);
    }

    function getKeyPurpose(bytes32 _key)
        public
        view
        returns(uint256[] purpose)
    {
        return (keys[_key].purpose);
    }

    function getKeysByPurpose(uint256 _purpose)
        public
        view
        returns(bytes32[] _keys)
    {
        return keysByPurpose[_purpose];
    }

    function addKey(bytes32 _key, uint256 _purpose, uint256 _type)
        public
        onlyManagement
        returns (bool success)
    {
        if (keyHasPurpose(_key, _purpose)) {
            return true;
        }

        keys[_key].key = _key;
        keys[_key].purpose.push(_purpose);
        keys[_key].keyType = _type;

        keysByPurpose[_purpose].push(_key);

        emit KeyAdded(_key, _purpose, _type);

        return true;
    }

    function approve(uint256 _id, bool _approve)
        public
        onlyAction
        returns (bool success)
    {
        emit Approved(_id, _approve);

        if (_approve == true) {
            executions[_id].approved = true;
            success = executions[_id].to.call(executions[_id].data, 0);
            if (success) {
                executions[_id].executed = true;
                emit Executed(
                    _id,
                    executions[_id].to,
                    executions[_id].value,
                    executions[_id].data
                );
            } else {
                emit ExecutionFailed(
                    _id,
                    executions[_id].to,
                    executions[_id].value,
                    executions[_id].data
                );
            }
            return success;
        } else {
            executions[_id].approved = false;
        }
        return true;
    }

    function execute(address _to, uint256 _value, bytes _data)
        public
        returns (uint256 executionId)
    {
        require(!executions[executionNonce].executed, "Already executed");
        executions[executionNonce].to = _to;
        executions[executionNonce].value = _value;
        executions[executionNonce].data = _data;

        emit ExecutionRequested(executionNonce, _to, _value, _data);

        if (keyHasPurpose(keccak256(msg.sender), ACTION_KEY)) {
            approve(executionNonce, true);
        }

        executionNonce++;
        return executionNonce-1;
    }

    function removeKey(bytes32 _key, uint256 _purpose)
        public
        onlyManagement
        returns (bool success)
    {
        require(keys[_key].key == _key, "No such key");

        if (!keyHasPurpose(_key, _purpose)) {
            return false;
        }

        uint256 arrayLength = keys[_key].purpose.length;
        int index = -1;
        for (uint i = 0; i < arrayLength; i++) {
            if (keys[_key].purpose[i] == _purpose) {
                index = int(i);
                break;
            }
        }

        if (index != -1) {
            keys[_key].purpose[uint(index)] = keys[_key].purpose[arrayLength - 1];
            delete keys[_key].purpose[arrayLength - 1];
            keys[_key].purpose.length--;
        }

        uint256 purposesLen = keysByPurpose[_purpose].length;
        for (uint j = 0; j < purposesLen; j++) {
            if (keysByPurpose[_purpose][j] == _key) {
                keysByPurpose[_purpose][j] = keysByPurpose[_purpose][purposesLen - 1];
                delete keysByPurpose[_purpose][purposesLen - 1];
                keysByPurpose[_purpose].length--;
                break;
            }
        }

        emit KeyRemoved(_key, _purpose, keys[_key].keyType);

        return true;
    }

    function keyHasPurpose(bytes32 _key, uint256 _purpose)
        public
        view
        returns(bool result)
    {
        if (keys[_key].key == 0) return false;
        uint256 arrayLength = keys[_key].purpose.length;
        for (uint i = 0; i < arrayLength; i++) {
            if (keys[_key].purpose[i] == _purpose) {
                return true;
            }
        }
        return false;
    }

   /**
     * Send all ether to msg.sender
     * Requires FUNDS_MANAGEMENT purpose for msg.sender
     */
    function withdraw() public onlyFundsManagement {
        msg.sender.transfer(address(this).balance);
    }

    /**
     * Transfer ether to _account
     * @param _amount amount to transfer in wei
     * @param _account recepient
     * Requires FUNDS_MANAGEMENT purpose for msg.sender
     */
    function transferEth(uint _amount, address _account) public onlyFundsManagement {
        require(_amount <= address(this).balance, "Amount should be less than total balance of the contract");
        require(_account != address(0), "must be valid address");
        _account.transfer(_amount);
    }

    /**
     * Returns contract eth balance
     */
    function getBalance() public view returns(uint)  {
        return address(this).balance;
    }

    /**
     * Returns ERC20 token balance for _token
     * @param _token token address
     */
    function getTokenBalance(address _token) public view returns (uint) {
        return ERC20Basic(_token).balanceOf(this);
    }

    /**
     * Send all tokens for _token to msg.sender
     * @param _token ERC20 contract address
     * Requires FUNDS_MANAGEMENT purpose for msg.sender
     */
    function withdrawTokens(address _token) public onlyFundsManagement {
        require(_token != address(0));
        ERC20Basic token = ERC20Basic(_token);
        uint balance = token.balanceOf(this);
        // token returns true on successful transfer
        assert(token.transfer(msg.sender, balance));
    }

    /**
     * Send tokens for _token to _to
     * @param _token ERC20 contract address
     * @param _to recepient
     * @param _amount amount in 
     * Requires FUNDS_MANAGEMENT purpose for msg.sender
     */
    function transferTokens(address _token, address _to, uint _amount) public onlyFundsManagement {
        require(_token != address(0));
        require(_to != address(0));
        ERC20Basic token = ERC20Basic(_token);
        uint balance = token.balanceOf(this);
        require(_amount <= balance);
        assert(token.transfer(_to, _amount));
    }

    function () public payable {}

}