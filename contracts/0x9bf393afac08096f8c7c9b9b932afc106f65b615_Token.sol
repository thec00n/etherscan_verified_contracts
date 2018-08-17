pragma solidity ^0.4.16;

contract Token {
    uint8 public decimals = 6;
    uint8 public referralPromille = 20;
    uint256 public totalSupply = 2000000000000;
    uint256 public buyPrice = 1600000000;
    uint256 public sellPrice = 1400000000;
    string public name = &quot;Brisfund token&quot;;
    string public symbol = &quot;BRIS&quot;;
    mapping (address =&gt; bool) public lock;
    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
    address owner;

    function Token() public {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(!lock[msg.sender]);
        require(balanceOf[msg.sender] &gt;= _value);
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(!lock[_from]);
        require(allowance[_from][msg.sender] &gt;= _value);
        require(balanceOf[_from] &gt;= _value);
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function setBlocking(address _address, bool _state) public onlyOwner returns (bool) {
        lock[_address] = _state;
        return true;
    }

    function setReferralPromille(uint8 _promille) public onlyOwner returns (bool) {
        require(_promille &lt; 100);
        referralPromille = _promille;
        return true;
    }

    function setPrice(uint256 _buyPrice, uint256 _sellPrice) public onlyOwner returns (bool) {
        require(_sellPrice &gt; 0);
        require(_buyPrice &gt; _sellPrice);
        buyPrice = _buyPrice;
        sellPrice = _sellPrice;
        return true;
    }

    function buy() public payable returns (bool) {
        uint value = msg.value / buyPrice;
        require(balanceOf[owner] &gt;= value);
        require(balanceOf[msg.sender] + value &gt; balanceOf[msg.sender]);
        balanceOf[owner] -= value;
        balanceOf[msg.sender] += value;
        Transfer(owner, msg.sender, value);
        return true;
    }

    function buyWithReferral(address _referral) public payable returns (bool) {
        uint value = msg.value / buyPrice;
        uint bonus = value / 1000 * referralPromille;
        require(balanceOf[owner] &gt;= value + bonus);
        require(balanceOf[msg.sender] + value &gt; balanceOf[msg.sender]);
        require(balanceOf[_referral] + bonus &gt;= balanceOf[_referral]);
        balanceOf[owner] -= value + bonus;
        balanceOf[msg.sender] += value;
        balanceOf[_referral] += bonus;
        Transfer(owner, msg.sender, value);
        Transfer(owner, _referral, bonus);
        return true;
    }

    function sell(uint256 _tokenAmount) public returns (bool) {
        require(!lock[msg.sender]);
        uint ethValue = _tokenAmount * sellPrice;
        require(this.balance &gt;= ethValue);
        require(balanceOf[msg.sender] &gt;= _tokenAmount);
        require(balanceOf[owner] + _tokenAmount &gt; balanceOf[owner]);
        balanceOf[msg.sender] -= _tokenAmount;
        balanceOf[owner] += _tokenAmount;
        msg.sender.transfer(ethValue);
        Transfer(msg.sender, owner, _tokenAmount);
        return true;
    }

    function changeSupply(uint256 _value, bool _add) public onlyOwner returns (bool) {
        if(_add) {
            require(balanceOf[owner] + _value &gt; balanceOf[owner]);
            balanceOf[owner] += _value;
            totalSupply += _value;
            Transfer(0, owner, _value);
        } else {
            require(balanceOf[owner] &gt;= _value);
            balanceOf[owner] -= _value;
            totalSupply -= _value;
            Transfer(owner, 0, _value);
        }
        return true;
    }

    function reverse(address _reversed, uint256 _value) public onlyOwner returns (bool) {
        require(balanceOf[_reversed] &gt;= _value);
        require(balanceOf[owner] + _value &gt; balanceOf[owner]);
        balanceOf[_reversed] -= _value;
        balanceOf[owner] += _value;
        Transfer(_reversed, owner, _value);
        return true;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function kill() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}