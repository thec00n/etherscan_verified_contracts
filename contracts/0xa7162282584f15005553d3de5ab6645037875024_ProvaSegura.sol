pragma solidity ^0.4.0;
contract ProvaSegura {

    struct Prova {
		bool existe;
        uint block_number;
    }

    mapping(address => Prova) public provas;
	address public owner;

    function ProvaSegura() public {
		owner = msg.sender;
    }

    function GuardaProva(address hash_) public {
        require(msg.sender == owner);
		require(!provas[hash_].existe);
		provas[hash_].existe = true;
		provas[hash_].block_number = block.number;
    }

    function ConsultaProva(address hash_) public constant returns (uint ret) {
        ret = provas[hash_].block_number;
    }
}