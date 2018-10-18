pragma solidity ^0.4.24;

contract Token
{
    function totalSupply() constant returns (uint supply) {}
    function balanceOf(address _owner) constant returns (uint balance) {}
    function transfer(address _to, uint _value) returns (bool success) {}
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
    function approve(address _spender, uint _value) returns (bool success) {}
    function allowance(address _owner, address _spender) constant returns (uint remaining) {}
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract StandardToken is Token
{
    function transfer(address _to, uint _value) returns (bool success)
    {
        if (balances[msg.sender] >= _value && _value > 0)
        {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        else
        {
            return false;
        }
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success)
    {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0)
        {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        }
        else
        {
            return false;
        }
    }

    function balanceOf(address _owner) constant returns (uint balance)
    {
        return balances[_owner];
    }

    function approve(address _spender, uint _value) returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint remaining)
    {
      return allowed[_owner][_spender];
    }

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint public totalSupply;
}

contract IzzyToken is StandardToken
{
    string public name;
    uint8 public decimals;
    string public symbol;

    address public admin;

    constructor(string _name, string _symbol, uint _totalSupply, address _admin)
    {
        name = _name;
        symbol = _symbol;
        decimals = 18;
        admin = _admin;
        totalSupply = _totalSupply * 10 ** uint(decimals);
        balances[admin] = totalSupply;
    }

    function ()
    {
        revert();
    }

    function approveAndCall(address _spender, uint _value, bytes _extraData) returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint,address,bytes)"))), msg.sender, _value, this, _extraData))
            { revert(); }
        return true;
    }
}

contract IZZYTokenSale
{
    address public beneficiary;
    address public creator;
    IzzyToken public izzyT;
    uint public tokenSold;
    uint public tokeninOneEther;
    uint public minContributionInEther;
    uint public maxContributionInEther;
    bool crowdsaleClosed = false;

    mapping(address => uint) public boughtBy;
    mapping(address => uint) public ethContribution;
    mapping(address => uint) public status; // 0-Invalid 1-Valid

    constructor(
        address _beneficiary,
        uint _tokeninOneEther,
        uint _minContributionInEther,
        uint _maxContributionInEther,
        address addressOfTokenUsedAsReward)
    {
        beneficiary = _beneficiary;
        creator = msg.sender;
        tokeninOneEther = _tokeninOneEther;
        minContributionInEther = _minContributionInEther * 1 ether;
        maxContributionInEther = _maxContributionInEther * 1 ether;
        izzyT = IzzyToken(addressOfTokenUsedAsReward);
    }

    function () payable
    {
        require(!crowdsaleClosed);
        require(status[msg.sender] != 0);
        require(msg.value + ethContribution[msg.sender] >= minContributionInEther);
        require(msg.value + ethContribution[msg.sender] <= maxContributionInEther);

        uint bonus = 35;

        uint amount = msg.value * tokeninOneEther;
        uint amountToSend = amount + (amount * bonus) / 100;

        if(izzyT.balanceOf(address(this)) < amountToSend)
            revert();

        boughtBy[msg.sender] += amountToSend;
        tokenSold += amount;
        ethContribution[msg.sender] += msg.value;
        izzyT.transfer(msg.sender, amountToSend);
        beneficiary.transfer(address(this).balance);
    }

    function updateBeneficiary(address _beneficiary)
    {
        require (msg.sender == creator);
        beneficiary = _beneficiary;
    }

    function addContributor(address _contributor)
    {
        require(msg.sender == beneficiary);
        require(_contributor != address(0));
        require(status[_contributor] == 0);
        status[_contributor] = 1;
    }

    function closeSale()
    {
        require(msg.sender == beneficiary);
        izzyT.transfer(msg.sender, izzyT.balanceOf(address(this)));
        beneficiary.transfer(address(this).balance);
        crowdsaleClosed = true;
    }
}