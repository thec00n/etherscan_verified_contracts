pragma solidity ^0.4.18;

/* first version of the FundRequest FundRepository */


/// @dev `Owned` is a base level contract that assigns an `owner` that can be
///  later changed
contract Owned {
  /// @dev `owner` is the only address that can call a function with this
  /// modifier
  modifier onlyOwner { require (msg.sender == owner); _; }

  address public owner;

  /// @notice The Constructor assigns the message sender to be `owner`
  function Owned() public { owner = msg.sender;}

  /// @notice `owner` can step down and assign some other address to this role
  /// @param _newOwner The address of the new owner. 0x0 can be used to create
  ///  an unowned neutral vault, however that cannot be undone
  function changeOwner(address _newOwner) public onlyOwner {
    owner = _newOwner;
  }
}



/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b &lt;= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c &gt;= a);
    return c;
  }
}


/*
 * Database Contract
 * Davy Van Roy
 * Quinten De Swaef
 */
contract FundRepository is Owned {

    using SafeMath for uint256;

    uint256 public totalNumberOfFunders;

    mapping (address =&gt; uint256) funders;

    uint256 public totalFunded;

    uint256 public requestsFunded;

    uint256 public totalBalance;

    mapping (bytes32 =&gt; mapping (string =&gt; Funding)) funds;

    mapping(address =&gt; bool) public callers;

    struct Funding {
        address[] funders;
        mapping (address =&gt; uint256) balances;
        uint256 totalBalance;
    }

    //modifiers
    modifier onlyCaller {
        require(callers[msg.sender]);
        _;
    }

    function FundRepository() {
        //constructor
    }

    function updateFunders(address _from, bytes32 _platform, string _platformId, uint256 _value) public onlyCaller {
        bool existing = funds[_platform][_platformId].balances[_from] &gt; 0;
        if (!existing) {
            funds[_platform][_platformId].funders.push(_from);
        }
        if (funders[_from] &lt;= 0) {
            totalNumberOfFunders = totalNumberOfFunders.add(1);
            funders[_from].add(_value);
        }
    }

    function updateBalances(address _from, bytes32 _platform, string _platformId, uint256 _value) public onlyCaller {
        if (funds[_platform][_platformId].totalBalance &lt;= 0) {
            requestsFunded = requestsFunded.add(1);
        }
        funds[_platform][_platformId].balances[_from] = funds[_platform][_platformId].balances[_from].add(_value);
        funds[_platform][_platformId].totalBalance = funds[_platform][_platformId].totalBalance.add(_value);
        totalBalance = totalBalance.add(_value);
        totalFunded = totalFunded.add(_value);
    }

    function resolveFund(bytes32 platform, string platformId) public onlyCaller returns (uint) {
        var funding = funds[platform][platformId];
        var requestBalance = funding.totalBalance;
        totalBalance = totalBalance.sub(requestBalance);
        for (uint i = 0; i &lt; funding.funders.length; i++) {
            var funder = funding.funders[i];
            delete (funding.balances[funder]);
        }
        delete (funds[platform][platformId]);
        return requestBalance;
    }

    //constants

    function getFundInfo(bytes32 _platform, string _platformId, address _funder) public view returns (uint256, uint256, uint256) {
        return (
        getFunderCount(_platform, _platformId),
        balance(_platform, _platformId),
        amountFunded(_platform, _platformId, _funder)
        );
    }

    function getFunderCount(bytes32 _platform, string _platformId) public view returns (uint){
        return funds[_platform][_platformId].funders.length;
    }

    function amountFunded(bytes32 _platform, string _platformId, address _funder) public view returns (uint256){
        return funds[_platform][_platformId].balances[_funder];
    }

    function balance(bytes32 _platform, string _platformId) view public returns (uint256) {
        return funds[_platform][_platformId].totalBalance;
    }

    //management of the repositories
    function updateCaller(address _caller, bool allowed) public onlyOwner {
        callers[_caller] = allowed;
    }
}