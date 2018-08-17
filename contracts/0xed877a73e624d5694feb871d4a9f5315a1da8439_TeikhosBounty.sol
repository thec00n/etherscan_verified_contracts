contract TeikhosBounty {

    // Proof-of-public-key in format 2xbytes32, to support xor operator and ecrecover r, s v format
    bytes32 proof_of_public_key1 = hex&quot;381c185bf75548b134adc3affd0cc13e66b16feb125486322fa5f47cb80a5bf0&quot;;
    bytes32 proof_of_public_key2 = hex&quot;5f9d1d2152eae0513a4814bd8e6b0dd3ac8f6310c0494c03e9aa08bcd867c352&quot;;

    function authenticate(bytes _publicKey) returns (bool) { // Accepts an array of bytes, for example [&quot;0x00&quot;,&quot;0xaa&quot;, &quot;0xff&quot;]

        // Get address from public key
        address signer = address(keccak256(_publicKey));

        // Split public key in 2xbytes32, to support xor operator and ecrecover r, s v format

        bytes32 publicKey1;
        bytes32 publicKey2;

        assembly {
        publicKey1 := mload(add(_publicKey,0x20))
        publicKey2 := mload(add(_publicKey,0x40))
        }

        // Use xor (reverse cipher) to get signature in r, s v format
        bytes32 r = proof_of_public_key1 ^ publicKey1;
        bytes32 s = proof_of_public_key2 ^ publicKey2;

        bytes32 msgHash = keccak256(&quot;\x19Ethereum Signed Message:\n64&quot;, _publicKey);

        // The value v is not known, try both 27 and 28
        if(ecrecover(msgHash, 27, r, s) == signer) suicide(msg.sender);
        if(ecrecover(msgHash, 28, r, s) == signer) suicide(msg.sender);
    }
    
    function() payable {}                            

}