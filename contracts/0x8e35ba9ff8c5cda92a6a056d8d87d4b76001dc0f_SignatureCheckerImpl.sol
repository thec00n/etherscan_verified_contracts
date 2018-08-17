pragma solidity ^0.4.13;

contract SignatureChecker {
    function checkTransferDelegated(
        address _from,
        address _to,
        uint256 _value,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool);

    function checkTransferAndCallDelegated(
        address _from,
        address _to,
        uint256 _value,
        bytes _data,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool);

    function checkTransferMultipleDelegated(
        address _from,
        address[] _addrs,
        uint256[] _values,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool);
}

contract SignatureCheckerImpl {
    function _bytesToSignature(bytes sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65);
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := and(mload(add(sig, 65)), 0xFF)
        }
        return (v, r, s);
    }

    bytes32 transferDelegatedHash = keccak256(
        &quot;address contract&quot;,
        &quot;string method&quot;,
        &quot;address to&quot;,
        &quot;uint256 value&quot;,
        &quot;uint256 maxReward&quot;,
        &quot;uint256 nonce&quot;
    );

    function checkTransferDelegated(
        address _from,
        address _to,
        uint256 _value,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool) {
        bytes32 hash = keccak256(
            transferDelegatedHash,
            keccak256(msg.sender, &quot;transferDelegated&quot;, _to, _value, _maxReward, _nonce)
        );
        var (v, r, s) = _bytesToSignature(_signature);
        return ecrecover(hash, v, r, s) == _from;
    }

    bytes32 transferAndCallDelegatedHash = keccak256(
        &quot;address contract&quot;,
        &quot;string method&quot;,
        &quot;address to&quot;,
        &quot;uint256 value&quot;,
        &quot;bytes data&quot;,
        &quot;uint256 maxReward&quot;,
        &quot;uint256 nonce&quot;
    );

    function checkTransferAndCallDelegated(
        address _from,
        address _to,
        uint256 _value,
        bytes _data,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool) {
        bytes32 hash = keccak256(
            transferAndCallDelegatedHash,
            keccak256(msg.sender, &quot;transferAndCallDelegated&quot;, _to, _value, _data, _maxReward, _nonce)
        );
        var (v, r, s) = _bytesToSignature(_signature);
        return ecrecover(hash, v, r, s) == _from;
    }

    bytes32 transferMultipleDelegatedHash = keccak256(
        &quot;address contract&quot;,
        &quot;string method&quot;,
        &quot;address[] addrs&quot;,
        &quot;uint256[] values&quot;,
        &quot;uint256 maxReward&quot;,
        &quot;uint256 nonce&quot;
    );

    function checkTransferMultipleDelegated(
        address _from,
        address[] _addrs,
        uint256[] _values,
        uint256 _maxReward,
        uint256 _nonce,
        bytes _signature
    ) public constant returns (bool) {
        bytes32 hash = keccak256(
            transferMultipleDelegatedHash,
            keccak256(msg.sender, &quot;transferMultipleDelegated&quot;, _addrs, _values, _maxReward, _nonce)
        );
        var (v, r, s) = _bytesToSignature(_signature);
        return ecrecover(hash, v, r, s) == _from;
    }
}