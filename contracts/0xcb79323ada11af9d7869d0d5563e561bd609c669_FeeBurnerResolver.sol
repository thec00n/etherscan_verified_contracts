pragma solidity 0.4.18;


interface ENS {
    function resolver(bytes32 node) public view returns (Resolver);
}

interface Resolver {
    function addr(bytes32 node) view public returns (address);
}


contract KyberNetworkENSResolver {
    ENS constant ENS_CONTRACT = ENS(0x314159265dD8dbb310642f98f50C066173C1259b);

    function calcNode() internal pure returns(bytes32) {
      string[2] memory parts;
      parts[0] = "kybernetwork";
      parts[1] = "eth";
      bytes32 namehash = 0x0000000000000000000000000000000000000000000000000000000000000000;
      for(uint i = 0; i < parts.length; i++) {
          namehash = keccak256(namehash, keccak256(parts[parts.length - i - 1]));
      }

      return namehash;
    }

    function getKyberNetworkAddress() internal view returns(address) {
      return ENS_CONTRACT.resolver(calcNode()).addr(calcNode());
    }

}

interface KyberNetwork {
    function feeBurnerContract() public view returns(address);
}

interface KyberNetworkProxy {
    function kyberNetworkContract() public view returns(KyberNetwork);
}

contract FeeBurnerResolver is KyberNetworkENSResolver {
    function getFeeBurnerAddress() public view returns(address) {
      return KyberNetworkProxy(getKyberNetworkAddress()).kyberNetworkContract().feeBurnerContract();
    }
}