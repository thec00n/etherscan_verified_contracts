pragma solidity 0.4.23;

/**
 * @title Graceful
 *
 * This contract provides informative `require` with optional ability to `revert`.
 *
 * _softRequire is used when it's enough to return `false` in case if condition isn't fulfilled.
 * _hardRequire is used when it's necessary to make revert in case if condition isn't fulfilled.
 */
contract Graceful {
    event Error(bytes32 message);

    // Only for functions that return bool success before any changes made.
    function _softRequire(bool _condition, bytes32 _message) internal {
        if (_condition) {
            return;
        }
        emit Error(_message);
        // Return bytes32(0).
        assembly {
            mstore(0, 0)
            return(0, 32)
        }
    }

    // Generic substitution for require().
    function _hardRequire(bool _condition, bytes32 _message) internal pure {
        if (_condition) {
            return;
        }
        // Revert with bytes32(_message).
        assembly {
            mstore(0, _message)
            revert(0, 32)
        }
    }

    function _not(bool _condition) internal pure returns(bool) {
        return !_condition;
    }
}

/**
 * @title Owned
 *
 * This contract keeps and transfers contract ownership.
 *
 * After deployment msg.sender becomes an owner which is checked in modifier onlyContractOwner().
 *
 * Features:
 * Modifier onlyContractOwner() restricting access to function for all callers except the owner.
 * Functions of transferring ownership to another address.
 *
 * Note:
 * Function forceChangeContractOwnership allows to transfer the ownership to an address without confirmation.
 * Which is very convenient in case the ownership transfers to a contract.
 * But when using this function, it's important to be very careful when entering the address.
 * Check address three times to make sure that this is the address that you need
 * because you can't cancel this operation.
 */
contract Owned is Graceful {
    bool public isConstructedOwned;
    address public contractOwner;
    address public pendingContractOwner;

    event ContractOwnerChanged(address newContractOwner);
    event PendingContractOwnerChanged(address newPendingContractOwner);

    constructor() public {
        constructOwned();
    }

    function constructOwned() public returns(bool) {
        if (isConstructedOwned) {
            return false;
        }
        isConstructedOwned = true;
        contractOwner = msg.sender;
        emit ContractOwnerChanged(msg.sender);
        return true;
    }

    modifier onlyContractOwner() {
        _softRequire(contractOwner == msg.sender, 'Not a contract owner');
        _;
    }

    function changeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
        pendingContractOwner = _to;
        emit PendingContractOwnerChanged(_to);
        return true;
    }

    function claimContractOwnership() public returns(bool) {
        _softRequire(pendingContractOwner == msg.sender, 'Not a pending contract owner');
        contractOwner = pendingContractOwner;
        delete pendingContractOwner;
        emit ContractOwnerChanged(contractOwner);
        return true;
    }

    function forceChangeContractOwnership(address _to) public onlyContractOwner() returns(bool) {
        contractOwner = _to;
        emit ContractOwnerChanged(contractOwner);
        return true;
    }
}

contract ERC20Interface {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from, address indexed spender, uint256 value);

    function totalSupply() public view returns(uint256 supply);
    function balanceOf(address _owner) public view returns(uint256 balance);
    function transfer(address _to, uint256 _value) public returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success);
    function approve(address _spender, uint256 _value) public returns(bool success);
    function allowance(address _owner, address _spender) public view returns(uint256 remaining);
    function decimals() public view returns(uint8);
}

contract AssetProxyInterface is ERC20Interface {
    function _forwardApprove(address _spender, uint _value, address _sender) public returns(bool);
    function _forwardTransferFromWithReference(address _from, address _to, uint _value, string _reference, address _sender) public returns(bool);
    function _forwardTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
    function recoverTokens(ERC20Interface _asset, address _receiver, uint _value) public returns(bool);
    function etoken2() public pure returns(address) {} // To be replaced by the implicit getter;
    function etoken2Symbol() public pure returns(bytes32) {} // To be replaced by the implicit getter;
}

contract RegistryICAPInterface {
    function parse(bytes32 _icap) public view returns(address, bytes32, bool);
    function institutions(bytes32 _institution) public view returns(address);
}

contract EToken2Interface {
    function registryICAP() public view returns(RegistryICAPInterface);
    function baseUnit(bytes32 _symbol) public view returns(uint8);
    function description(bytes32 _symbol) public view returns(string);
    function owner(bytes32 _symbol) public view returns(address);
    function isOwner(address _owner, bytes32 _symbol) public view returns(bool);
    function totalSupply(bytes32 _symbol) public view returns(uint);
    function balanceOf(address _holder, bytes32 _symbol) public view returns(uint);
    function isLocked(bytes32 _symbol) public view returns(bool);
    function issueAsset(bytes32 _symbol, uint _value, string _name, string _description, uint8 _baseUnit, bool _isReissuable) public returns(bool);
    function reissueAsset(bytes32 _symbol, uint _value) public returns(bool);
    function revokeAsset(bytes32 _symbol, uint _value) public returns(bool);
    function setProxy(address _address, bytes32 _symbol) public returns(bool);
    function lockAsset(bytes32 _symbol) public returns(bool);
    function proxyTransferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference, address _sender) public returns(bool);
    function proxyApprove(address _spender, uint _value, bytes32 _symbol, address _sender) public returns(bool);
    function allowance(address _from, address _spender, bytes32 _symbol) public view returns(uint);
    function proxyTransferFromWithReference(address _from, address _to, uint _value, bytes32 _symbol, string _reference, address _sender) public returns(bool);
    function changeOwnership(bytes32 _symbol, address _newOwner) public returns(bool);
}

contract OldAssetProxyInterface {
    function recoverTokens(uint _value) public returns(bool);
}

/**
 * @title MRKOwnership
 *
 * This contract allows to recover tokens from asset proxy address and reissue more tokens if allowed.
 */
contract MRKOwnership is Owned {
    AssetProxyInterface public proxy;
    bool public isOldRecover;
    bool public isReissueAllowed;

    constructor(address _proxyOwner, AssetProxyInterface _proxy, bool _isOldRecover, bool _isReissueAllowed) public {
        forceChangeContractOwnership(_proxyOwner);
        proxy = _proxy;
        isOldRecover = _isOldRecover;
        isReissueAllowed = _isReissueAllowed;
    }

    function reissueAsset(uint _value) public onlyContractOwner() returns(bool) {
        _softRequire(isReissueAllowed, 'Reissue is not allowed');
        EToken2Interface etoken2 = EToken2Interface(proxy.etoken2());
        bytes32 symbol = proxy.etoken2Symbol();
        _softRequire(etoken2.reissueAsset(symbol, _value), 'Asset reissue failed');
        _hardRequire(proxy.transfer(contractOwner, _value), 'Forward tokens to owner failed');
        return true;
    }

    function recoverTokens(ERC20Interface _token, address _receiver, uint _value) public onlyContractOwner() returns(bool) {
        if (isOldRecover) {
            _softRequire(address(_token) == address(proxy), 'Can only recover own asset');
            _softRequire(OldAssetProxyInterface(proxy).recoverTokens(_value), 'Recover failed');
            _hardRequire(proxy.transfer(_receiver, _value), 'Forward tokens to owner failed');
        } else {
            _softRequire(proxy.recoverTokens(_token, _receiver, _value), 'Recover failed');
        }
        return true;
    }
}