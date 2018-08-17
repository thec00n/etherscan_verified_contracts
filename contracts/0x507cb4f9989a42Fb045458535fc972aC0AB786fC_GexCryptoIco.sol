pragma solidity ^0.4.16;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }
}

library SafeMath {
	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
		uint256 c = a * b;
		assert(a == 0 || c / a == b);
		return c;
	}

	function div(uint256 a, uint256 b) internal constant returns (uint256) {
		// assert(b &gt; 0); // Solidity automatically throws when dividing by 0
		uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
		return c;
	}

	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
		assert(b &lt;= a);
		return a - b;
	}

	function add(uint256 a, uint256 b) internal constant returns (uint256) {
		uint256 c = a + b;
		assert(c &gt;= a);
		return c;
	}
}

contract GexCryptoIco is owned {

    uint public saleStart;
    uint public saleEnd;
    uint256 public minInvestment;

    function GexCryptoIco() {
        saleStart = 1517301413;
        saleEnd = 1519862400;
        minInvestment = (1/10) * (10 ** 18);
    }

    event EtherTransfer(address indexed _from,address indexed _to,uint256 _value);

    function changeMinInvestment(uint256 _minInvestment) onlyOwner {
        minInvestment = _minInvestment;
    }

    function withdrawEther(address _account) onlyOwner payable returns (bool success) {
        require(_account.send(this.balance));

        EtherTransfer(this, _account, this.balance);
        return true;
    }

    function destroyContract() {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }

    function () payable {
        if (saleStart &lt; now &amp;&amp; saleEnd &gt; now) {
            require(msg.value &gt;= minInvestment);
        } else {
            revert();
        }
    }

}