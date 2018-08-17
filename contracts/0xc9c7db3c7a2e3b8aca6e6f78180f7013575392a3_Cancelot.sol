pragma solidity ^0.4.11;
// Cancelot dapp on-chain component.
// Forwards ENS .eth Registrar cancelBid(...) call if bid&#39;s Deed not yet cancelled.
// Author:  Noel Maersk (veox)
// License: GPLv3.
// Sources: https://gitlab.com/veox/cancelot (Not yet available during deployment time - stay tuned!..)
// Compile: solc 0.4.11+commit.68ef5810.Linux.g++ /w optimisations

// Minimal implementation of the .eth Registrar interface.
contract RegistrarFakeInterface {
    // Short-circuit address-&gt;bytes32-&gt;Deed mapping. Signature 0x5e431709.
    mapping (address =&gt; mapping(bytes32 =&gt; address)) public sealedBids;
    //mapping (address =&gt; mapping(bytes32 =&gt; Deed)) public sealedBids;
    //function sealedBids(address bidder, bytes32 seal) constant returns(address);

    // Actual. Signature 0x2525f5c1.
    function cancelBid(address bidder, bytes32 seal);
}

// Sir Cancelot, the cancellation bot - banger of coconuts, protector of nothing.
// Game-theoretic looney. Sees the world burn, even if it doesn&#39;t. To be avoided.
contract Cancelot {
    address public owner;
    RegistrarFakeInterface registrar;

    modifier only_owner {
        if (msg.sender == owner) _;
    }

    function Cancelot(address _owner, address _registrar) {
        owner = _owner;
        registrar = RegistrarFakeInterface(_registrar);
    }

    function cancel(address bidder, bytes32 seal) {
        if (registrar.sealedBids(bidder, seal) != 0)
            registrar.cancelBid.gas(msg.gas)(bidder, seal);
    }

    function withdraw() {
        owner.transfer(this.balance);
    }

    function sweep(address bidder, bytes32 seal) {
        cancel(bidder, seal);
        withdraw();
    }

    function () payable {}

    function terminate() only_owner {
        selfdestruct(owner);
    }
}