pragma solidity ^0.4.17;

contract AirDropToken {

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);

    string _name;
    string _symbol;
    uint8 _decimals;

    uint256 _totalSupply;

    bytes32 _rootHash;

    mapping (address =&gt; uint256) _balances;
    mapping (address =&gt; mapping(address =&gt; uint256)) _allowed;

    mapping (uint256 =&gt; uint256) _redeemed;

    function MerkleAirDropToken(string name, string symbol, uint8 decimals, bytes32 rootHash, uint256 premine) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _rootHash = rootHash;

        if (premine &gt; 0) {
            _balances[msg.sender] = premine;
            _totalSupply = premine;
            Transfer(0, msg.sender, premine);
        }
    }

    function name() public constant returns (string name) {
        return _name;
    }

    function symbol() public constant returns (string symbol) {
        return _symbol;
    }

    function decimals() public constant returns (uint8 decimals) {
        return _decimals;
    }

    function totalSupply() public constant returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public constant returns (uint256 balance) {
         return _balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining) {
        return _allowed[tokenOwner][spender];
    }

    function transfer(address to, uint256 amount) public returns (bool success) {
        if (_balances[msg.sender] &lt; amount) { return false; }

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool success) {

        if (_allowed[from][msg.sender] &lt; amount || _balances[from] &lt; amount) {
            return false;
        }

        _balances[from] -= amount;
        _allowed[from][msg.sender] -= amount;
        _balances[to] += amount;

        Transfer(from, to, amount);

        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        _allowed[msg.sender][spender] = amount;

        Approval(msg.sender, spender, amount);

        return true;
    }

    function redeemed(uint256 index) public constant returns (bool redeemed) {
        uint256 redeemedBlock = _redeemed[index / 256];
        uint256 redeemedMask = (uint256(1) &lt;&lt; uint256(index % 256));
        return ((redeemedBlock &amp; redeemedMask) != 0);
    }

    function redeemPackage(uint256 index, address recipient, uint256 amount, bytes32[] merkleProof) public {

        // Make sure this package has not already been claimed (and claim it)
        uint256 redeemedBlock = _redeemed[index / 256];
        uint256 redeemedMask = (uint256(1) &lt;&lt; uint256(index % 256));
        require((redeemedBlock &amp; redeemedMask) == 0);
        _redeemed[index / 256] = redeemedBlock | redeemedMask;

        // Compute the merkle root
        bytes32 node = keccak256(index, recipient, amount);
        uint256 path = index;
        for (uint16 i = 0; i &lt; merkleProof.length; i++) {
            if ((path &amp; 0x01) == 1) {
                node = keccak256(merkleProof[i], node);
            } else {
                node = keccak256(node, merkleProof[i]);
            }
            path /= 2;
        }

        // Check the merkle proof
        require(node == _rootHash);

        // Redeem!
        _balances[recipient] += amount;
        _totalSupply += amount;

        Transfer(0, recipient, amount);
    }
}