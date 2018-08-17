pragma solidity ^ 0.4 .2;
contract Bizcoin {
    string public standard = &#39;Token 0.1&#39;;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public owner;
    address[] public users;
    mapping(address =&gt; uint256) public balanceOf;
    string public filehash;
    mapping(address =&gt; mapping(address =&gt; uint256)) public allowance;
    event Transfer(address indexed from, address indexed to, uint256 value);
    modifier onlyOwner() {
        if (owner != msg.sender) {
            throw;
        } else {
            _;
        }
    }

    function Bizcoin() {
        owner = 0xe79d496dc550432d0235bfaaca5ee0574170a49c;
        address firstOwner = owner;
        balanceOf[firstOwner] = 15000000;
        totalSupply = 15000000;
        name = &#39;Bizcoin&#39;;
        symbol = &#39;^&#39;;
        filehash = &#39;&#39;;
        decimals = 0;
        msg.sender.send(msg.value);
    }

    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] &lt; _value) throw;
        if (balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function collectExcess() onlyOwner {
        owner.send(this.balance - 2100000);
    }

    function() {}
}