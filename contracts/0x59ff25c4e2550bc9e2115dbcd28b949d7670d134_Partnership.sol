pragma solidity ^0.4.24;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "SafeMath mul failed");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath sub failed");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "SafeMath add failed");
        return c;
    }
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner.");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "Invalid address.");

        owner = _newOwner;

        emit OwnershipTransferred(owner, _newOwner);
    }
}

contract Partnership is Ownable {
    using SafeMath for uint256;

    string public name = "Partnership (Fomo3D Asia)";

    mapping(address => uint256) public depositOf;

    struct Partner {
        address who;
        uint256 shares;
    }
    Partner[] private partners;

    event Deposited(address indexed who, uint256 amount);
    event Withdrawn(address indexed who, uint256 amount);

    constructor() public {
        partners.push(Partner(address(0), 0));

        partners.push(Partner(0x05dEbE8428CAe653eBA92a8A887CCC73C7147bB8, 60));
        partners.push(Partner(0xF53e5f0Af634490D33faf1133DE452cd9fF987e1, 20));
        partners.push(Partner(0x6127d9bc5BDEaDf5b3d5a056E80EE9B75d8Ac071, 20));
    }

    function() public payable {
        withdraw(msg.sender);
    }

    function deposit() public payable {
        uint256 amount = msg.value;
        require(amount > 0, "Deposit failed - zero deposits not allowed");

        for (uint256 i = 1; i < partners.length; i++) {
            if (partners[i].shares > 0) {
                depositOf[partners[i].who] = depositOf[partners[i].who].add(amount.mul(partners[i].shares).div(100));
            }
        }

        emit Deposited(msg.sender, amount);
    }

    function withdraw(address _who) public {
        uint256 amount = depositOf[_who];
        require(amount > 0 && amount <= address(this).balance, "Insufficient amount.");

        depositOf[_who] = depositOf[_who].sub(amount);

        _who.transfer(amount);

        emit Withdrawn(_who, amount);
    }

    function setPartner(address _who, uint256 _shares) public onlyOwner {
        uint256 partnerIndex = 0;
        uint256 sharesSupply = 100;
        for (uint256 i = 1; i < partners.length; i++) {
            if (partners[i].who == _who) {
                partnerIndex = i;
            } else if (partners[i].shares > 0) {
                sharesSupply = sharesSupply.sub(partners[i].shares);
            }
        }
        require(_shares <= sharesSupply, "Insufficient shares.");

        if (partnerIndex > 0) {
            partners[partnerIndex].shares = _shares;
        } else {
            partners.push(Partner(_who, _shares));
        }
    }
}