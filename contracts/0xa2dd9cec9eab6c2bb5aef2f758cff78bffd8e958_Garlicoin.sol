pragma solidity ^0.4.18;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c &gt;= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b &lt;= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b &gt; 0);
        c = a / b;
    }
}

contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}

contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() public {
        owner = msg.sender;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Garlicoin is ERC20Interface, Owned {
    using SafeMath for uint;
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    mapping(address =&gt; uint) balances;
    mapping(address =&gt; mapping(address =&gt; uint)) allowed;
    uint etherCost1;
    uint etherCost2;
    uint etherCost3;
    uint deadline1;
    uint deadline2;
    uint deadline3;
    uint etherCostOfEachToken;
    bool burnt = false;

    function Garlicoin() public {
        symbol = &quot;GLC&quot;;
        name = &quot;Garlicoin&quot;;
        decimals = 18;
        etherCost1 = 0.1 finney;
        etherCost2 = 0.15 finney;
        etherCost3 = 0.25 finney;
        _totalSupply = 1000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        Transfer(address(0), owner, _totalSupply);
        deadline1 = now + 1 * 1 days;
        deadline2 = now + 4 * 1 days;
        deadline3 = now + 14 * 1 days;
        
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(msg.sender, to, tokens);
        return true;
    }


    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }


    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        Transfer(from, to, tokens);
        return true;
    }

    function withdraw() public {
        if (msg.sender != owner) {
            return;
        }
        owner.transfer(this.balance);
    }

    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    // ------------------------------------------------------------------------
    // If you&#39;ve made it this far in the code, I probably don&#39;t have to tell you
    // how dogshit this crypto is. You might tell yourself that it&#39;s obviously 
    // a bad investment because of this. But what if it wasn&#39;t? What if its
    // useless, pathetic nature makes it not only special, but legendary? What
    // if years, even decades from now, when economists discuss the network of 
    // manic crazed millenials fueling the great cryptocurrency bubble, they 
    // all use the same example, the epitome of hype, the hobo&#39;s puddle of urine
    // that was Garlicoin? They&#39;d give lectures on how within days it had 
    // reached fifteen times its original value, and in a year it was the world
    // cryptocurrency standard to replace Bitcoin.
    
    // I&#39;m not going to tell you that any of this is going to happen, but what 
    // I will tell you is this is a chance for you to be part of history, 
    // forever engraved into the immutable, pseudo-eternal Ethereum blockchain.
    
    // Now please buy my shitcoin so I can afford dinner tonight.
    // ------------------------------------------------------------------------
    function () public payable {
        require(now &lt;= deadline3);
        if (now &gt; deadline3) {
            revert();
        } else if (now &lt;= deadline1) {
            etherCostOfEachToken = etherCost1;
        } else if (now &lt;= deadline2) {
            etherCostOfEachToken = etherCost2;
        } else if (now &lt;= deadline3) {
            etherCostOfEachToken = etherCost3;
        }
        uint weiAmount = msg.value;
        uint glcAmount = weiAmount / etherCostOfEachToken * 1000000000000000000;
        balances[owner] = balances[owner].sub(glcAmount);
        balances[msg.sender] = balances[msg.sender].add(glcAmount);
        Transfer(owner, msg.sender, glcAmount);
    }
    
    function burn () public {
        if (burnt == true) {
            return;
        } else {
            if (now &lt;= deadline3) {
                return;
            }
            burnt = true;
            balances[owner] = 0;
        }
    }


    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}