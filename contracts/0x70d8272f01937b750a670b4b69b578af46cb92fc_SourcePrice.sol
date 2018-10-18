contract SourcePrice {
    mapping (bytes32 => address) public sourceContract;

    constructor (address _sourceContract) public {
        sourceContract[ keccak256( abi.encodePacked( "usd" ) ) ] = _sourceContract;
    }
    
    function read(bytes32 _currency) view public returns (uint256 value) {
        address source = sourceContract[ _currency ];
        if( source != address(0) ) { 
            value = uint256( EndPointInterface(source).read()  );
        } else {
            revert("Not implemented source's price.");
        }
    }
}

contract EndPointInterface {
    function read() view public returns (bytes32);
}