pragma solidity ^0.4.16;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of &quot;user permissions&quot;.
 */
contract Ownable {
    address public owner;


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    function Ownable() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

}

/**
 * @title Authorizable
 * @dev Allows to authorize access to certain function calls
 *
 * ABI
 * [{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;authorizers&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;addAuthorized&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;isAuthorized&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;constructor&quot;}]
 */
contract Authorizable {

    address[] public authorizers;
    mapping(address =&gt; uint) authorizerIndex;

    /**
     * @dev Throws if called by any account tat is not authorized.
     */
    modifier onlyAuthorized {
        require(isAuthorized(msg.sender));
        _;
    }

    /**
     * @dev Contructor that authorizes the msg.sender.
     */
    function Authorizable() public {
        authorizers.length = 2;
        authorizers[1] = msg.sender;
        authorizerIndex[msg.sender] = 1;
    }

    /**
     * @dev Function to check if an address is authorized
     * @param _addr the address to check if it is authorized.
     * @return boolean flag if address is authorized.
     */
    function isAuthorized(address _addr) public view returns(bool) {
        return authorizerIndex[_addr] &gt; 0;
    }

    /**
     * @dev Function to add a new authorizer
     * @param _addr the address to add as a new authorizer.
     */
    function addAuthorized(address _addr) external onlyAuthorized {
        authorizerIndex[_addr] = authorizers.length;
        authorizers.length++;
        authorizers[authorizers.length - 1] = _addr;
    }
}

/**
 * @title Investors
 * @dev Allows to get investors
 *
 * ABI
 * [{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;authorizers&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;investors&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;addAuthorized&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_inv&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;addInvestor&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;isAuthorized&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;constructor&quot;}]
 */
contract Investors is Authorizable {

    address[] public investors;
    mapping(address =&gt; uint) investorIndex;

    /**
     * @dev Contructor that authorizes the msg.sender.
     */
    function Investors() public {
        investors.length = 2;
        investors[1] = msg.sender;
        investorIndex[msg.sender] = 1;
    }

    /**
     * @dev Function to add a new investor
     * @param _inv the address to add as a new investor.
     */
    function addInvestor(address _inv) public {
        if (investorIndex[_inv] &lt;= 0) {
            investorIndex[_inv] = investors.length;
            investors.length++;
            investors[investors.length - 1] = _inv;
        }

    }
}

/**
 * @title ExchangeRate
 * @dev Allows updating and retrieveing of Conversion Rates for PAY tokens
 *
 * ABI
 * [{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_symbol&quot;,&quot;type&quot;:&quot;string&quot;},{&quot;name&quot;:&quot;_rate&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;updateRate&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;data&quot;,&quot;type&quot;:&quot;uint256[]&quot;}],&quot;name&quot;:&quot;updateRates&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_symbol&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;name&quot;:&quot;getRate&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;owner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;name&quot;:&quot;rates&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;newOwner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;transferOwnership&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;timestamp&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;symbol&quot;,&quot;type&quot;:&quot;bytes32&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;rate&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;RateUpdated&quot;,&quot;type&quot;:&quot;event&quot;}]
 */
contract ExchangeRate is Ownable {

    event RateUpdated(uint timestamp, bytes32 symbol, uint rate);

    mapping(bytes32 =&gt; uint) public rates;

    /**
     * @dev Allows the current owner to update a single rate.
     * @param _symbol The symbol to be updated.
     * @param _rate the rate for the symbol.
     */
    function updateRate(string _symbol, uint _rate) public onlyOwner {
        rates[keccak256(_symbol)] = _rate;
        RateUpdated(now, keccak256(_symbol), _rate);
    }

    /**
     * @dev Allows the current owner to update multiple rates.
     * @param data an array that alternates keccak256 hashes of the symbol and the corresponding rate .
     */
    function updateRates(uint[] data) public onlyOwner {
        if (data.length % 2 &gt; 0)
        revert();
        uint i = 0;
        while (i &lt; data.length / 2) {
            bytes32 symbol = bytes32(data[i * 2]);
            uint rate = data[i * 2 + 1];
            rates[symbol] = rate;
            RateUpdated(now, symbol, rate);
            i++;
        }
    }

    /**
     * @dev Allows the anyone to read the current rate.
     * @param _symbol the symbol to be retrieved.
     */
    function getRate(string _symbol) public view returns(uint) {
        return rates[keccak256(_symbol)];
    }
}

/**
 * Math operations with safety checks
 */
library SafeMath {
    function mul(uint a, uint b) internal returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint a, uint b) internal returns (uint) {
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
        return c;
    }

    function sub(uint a, uint b) internal returns (uint) {
        assert(b &lt;= a);
        return a - b;
    }

    function add(uint a, uint b) internal returns (uint) {
        uint c = a + b;
        assert(c &gt;= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal view returns (uint64) {
        return a &gt;= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal view returns (uint64) {
        return a &lt; b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal view returns (uint256) {
        return a &gt;= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal view returns (uint256) {
        return a &lt; b ? a : b;
    }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Basic {
    uint public totalSupply;
    function balanceOf(address who) public view returns (uint);
    function transfer(address to, uint value) public;
    event Transfer(address indexed from, address indexed to, uint value);
}




/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint);
    function transferFrom(address from, address to, uint value) public;
    function approve(address spender, uint value)  public;
    event Approval(address indexed owner, address indexed spender, uint value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
    using SafeMath for uint;

    mapping(address =&gt; uint) balances;

    /**
     * @dev Fix for the ERC20 short address attack.
     */
    modifier onlyPayloadSize(uint size) {
        if(msg.data.length &lt; size + 4) {
            revert();
        }
        _;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) view returns (uint balance) {
        return balances[_owner];
    }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implemantation of the basic standart token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is BasicToken, ERC20 {

    mapping (address =&gt; mapping (address =&gt; uint)) allowed;


    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint the amout of tokens to be transfered
     */
    function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
        var _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // if (_value &gt; _allowance) throw;

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        Transfer(_from, _to, _value);
    }

    /**
     * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint _value) {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        if ((_value != 0) &amp;&amp; (allowed[msg.sender][_spender] != 0)) revert();

        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
    }

    /**
     * @dev Function to check the amount of tokens than an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint specifing the amount of tokens still avaible for the spender.
     */
    function allowance(address _owner, address _spender) view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

}

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */

contract MintableToken is StandardToken, Ownable {
    event Mint(address indexed to, uint value);
    event MintFinished();
    event MintRestarted();

    bool public mintingFinished = false;
    uint public totalSupply = 0;


    modifier canMint() {
        if(mintingFinished) revert();
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will recieve the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Mint(_to, _amount);
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() onlyOwner returns (bool) {
        mintingFinished = true;
        MintFinished();
        return true;
    }

    /**
     * @dev Function to restart minting new tokens.
     * @return True if the operation was successful.
     */
    function restartMinting() onlyOwner returns (bool) {
        mintingFinished = false;
        MintRestarted();
        return true;
    }
}


/**
 * @title InvestyToken
 * @dev The main PAY token contract
 *
 * ABI
 * [{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;mintingFinished&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;name&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_spender&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;approve&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;totalSupply&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_from&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;transferFrom&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;startTrading&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;decimals&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_amount&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;mint&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;tradingStarted&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_owner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;balanceOf&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;balance&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;finishMinting&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;owner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;symbol&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;transfer&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;restartMinting&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_owner&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_spender&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;allowance&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;remaining&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;newOwner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;transferOwnership&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:true,&quot;name&quot;:&quot;to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;Mint&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;MintFinished&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;MintRestarted&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:true,&quot;name&quot;:&quot;owner&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:true,&quot;name&quot;:&quot;spender&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;Approval&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:true,&quot;name&quot;:&quot;from&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:true,&quot;name&quot;:&quot;to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;Transfer&quot;,&quot;type&quot;:&quot;event&quot;}]
 */
contract InvestyToken is MintableToken {

    string public name = &quot;Investy Coin&quot;;
    string public symbol = &quot;IVC66&quot;;
    uint public decimals = 18;

    bool public tradingStarted = false;

    /**
     * @dev modifier that throws if trading has not started yet
     */
    modifier hasStartedTrading() {
        require(tradingStarted);
        _;
    }

    /**
     * @dev Allows the owner to enable the trading. This can not be undone
     */
    function startTrading() onlyOwner {
        tradingStarted = true;
    }

    /**
     * @dev Allows anyone to transfer the PAY tokens once trading has started
     * @param _to the recipient address of the tokens.
     * @param _value number of tokens to be transfered.
     */
    function transfer(address _to, uint _value) hasStartedTrading {
        super.transfer(_to, _value);
    }

    /**
    * @dev Allows anyone to transfer the PAY tokens once trading has started
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint the amout of tokens to be transfered
    */
    function transferFrom(address _from, address _to, uint _value) hasStartedTrading {
        super.transferFrom(_from, _to, _value);
    }

}

/**
 * @title MainSale
 * @dev The main PAY token sale contract
 *
 * ABI
 * [{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_multisigVault&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;setMultisigVault&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;authorizerIndex&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;getAuthorizer&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;exchangeRate&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;investors&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;recipient&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;tokens&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;authorizedCreateTokens&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;presaleActive&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;transferToken&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;owner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;finishPresale&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_exchangeRate&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;setExchangeRate&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_token&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;retrieveTokens&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;investorIndex&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;getInvestor&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;recipient&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;createTokens&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:true,&quot;stateMutability&quot;:&quot;payable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;addAuthorized&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;multisigVault&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;restartPresale&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_inv&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;addInvestor&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;newOwner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;transferOwnership&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;token&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_addr&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;isAuthorized&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;view&quot;,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;payable&quot;:false,&quot;stateMutability&quot;:&quot;nonpayable&quot;,&quot;type&quot;:&quot;constructor&quot;},{&quot;payable&quot;:true,&quot;stateMutability&quot;:&quot;payable&quot;,&quot;type&quot;:&quot;fallback&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;recipient&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;ether_amount&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;pay_amount&quot;,&quot;type&quot;:&quot;uint256&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;exchangerate&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;TokenSold&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;recipient&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;indexed&quot;:false,&quot;name&quot;:&quot;pay_amount&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;AuthorizedCreate&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;PresaleFinished&quot;,&quot;type&quot;:&quot;event&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;PresaleReStarted&quot;,&quot;type&quot;:&quot;event&quot;}]
 */
contract InvestyPresale is Ownable, Authorizable, Investors {
    using SafeMath for uint;
    event TokenSold(address recipient, uint ether_amount, uint pay_amount, uint exchangerate);
    event AuthorizedCreate(address recipient, uint pay_amount);
    event PresaleFinished();
    event PresaleReStarted();

    InvestyToken public token = new InvestyToken();

    address public multisigVault;
    uint constant MILLI_USD_TO_IVC_RATE = 34;//presale fixed IVC coin cost

    ExchangeRate public exchangeRate;

    bool public presaleActive = true;
    modifier isPresaleActive() {
        if(!presaleActive) revert();
        _;
    }

    /**
     * constructor
     */
    function InvestyPresale() {
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishPresale() public onlyOwner returns (bool) {
        presaleActive = false;
        PresaleFinished();
        return true;
    }

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function restartPresale() public onlyOwner returns (bool) {
        presaleActive = true;
        PresaleReStarted();
        return true;
    }

    /**
     * @dev Allows anyone to create tokens by depositing ether.
     * @param recipient the recipient to receive tokens.
     */
    function createTokens(address recipient) public isPresaleActive payable {
        var einsteinToUsdRate = exchangeRate.getRate(&quot;EinsteinToUSD&quot;);
        uint ivc = (einsteinToUsdRate.mul(msg.value).div(MILLI_USD_TO_IVC_RATE));// 18 signs after comma
        token.mint(recipient, ivc);
        addInvestor(recipient);
        require(multisigVault.send(msg.value));
        TokenSold(recipient, msg.value, ivc, einsteinToUsdRate / 1000);
    }

    /**
   * @dev Allows authorized acces to create tokens. This is used for Bitcoin and ERC20 deposits
   * @param recipient the recipient to receive tokens.
   * @param tokens number of tokens to be created.
   */
    function authorizedCreateTokens(address recipient, uint tokens) public onlyAuthorized {
        token.mint(recipient, tokens);
        addInvestor(recipient);
        AuthorizedCreate(recipient, tokens);
    }

    /**
   * @dev Allows the owner to set the exchangerate contract.
   * @param _exchangeRate the exchangerate address
   */
    function setExchangeRate(address _exchangeRate) public onlyOwner {
        exchangeRate = ExchangeRate(_exchangeRate);
    }

    /**
   * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
   * @param _token the contract address of the ERC20 contract
   */
    function retrieveTokens(address _token) public onlyOwner {
        ERC20 outerToken = ERC20(_token);
        token.transfer(multisigVault, outerToken.balanceOf(this));
    }

    /**
     * @dev Allows the owner to set the multisig contract.
     * @param _multisigVault the multisig contract address
     */
    function setMultisigVault(address _multisigVault) public onlyOwner {
        if (_multisigVault != address(0)) {
            multisigVault = _multisigVault;
        }
    }

    /**
     * @dev Ownership of the PAY token contract is transfered to this owner.
     */
    function transferToken() public onlyOwner {
        token.transferOwnership(owner);
    }

    /**
     * @dev Fallback function which receives ether and created the appropriate number of tokens for the
     * msg.sender.
     */
    function() external payable {
        createTokens(msg.sender);
    }
}