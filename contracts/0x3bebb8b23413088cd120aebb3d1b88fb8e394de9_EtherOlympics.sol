pragma solidity ^0.4.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of &quot;user permissions&quot;.
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


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
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract EtherOlympics is Ownable {
    mapping(bytes3 =&gt; uint16) iocCountryCodesToPriceMap;
    event newTeamCreated(bytes32 teamName, bytes3 country1, bytes3 country2, bytes3 country3,
        bytes3 country4, bytes3 country5, bytes3 country6);
    
    function() public payable { }

    function EtherOlympics() public {
        iocCountryCodesToPriceMap[&#39;GER&#39;] = 9087;
        iocCountryCodesToPriceMap[&#39;NOR&#39;] = 8748;
        iocCountryCodesToPriceMap[&#39;USA&#39;] = 7051;
        iocCountryCodesToPriceMap[&#39;FRA&#39;] = 6486;
        iocCountryCodesToPriceMap[&#39;CAN&#39;] = 6486;
        iocCountryCodesToPriceMap[&#39;NED&#39;] = 4412;
        iocCountryCodesToPriceMap[&#39;JPN&#39;] = 3544;
        iocCountryCodesToPriceMap[&#39;AUT&#39;] = 3507;
        iocCountryCodesToPriceMap[&#39;SWE&#39;] = 3507;
        iocCountryCodesToPriceMap[&#39;SUI&#39;] = 3431;
        iocCountryCodesToPriceMap[&#39;KOR&#39;] = 3318;
        iocCountryCodesToPriceMap[&#39;CHN&#39;] = 2941;
        iocCountryCodesToPriceMap[&#39;CZE&#39;] = 1961;
        iocCountryCodesToPriceMap[&#39;ITA&#39;] = 1395;
        iocCountryCodesToPriceMap[&#39;AUS&#39;] = 1207;
        iocCountryCodesToPriceMap[&#39;POL&#39;] = 867;
        iocCountryCodesToPriceMap[&#39;GBR&#39;] = 792;
        iocCountryCodesToPriceMap[&#39;FIN&#39;] = 792;
        iocCountryCodesToPriceMap[&#39;BEL&#39;] = 490;
        iocCountryCodesToPriceMap[&#39;SLO&#39;] = 490;
        iocCountryCodesToPriceMap[&#39;SVK&#39;] = 452;
        iocCountryCodesToPriceMap[&#39;LAT&#39;] = 377;
        iocCountryCodesToPriceMap[&#39;LIE&#39;] = 377;
        iocCountryCodesToPriceMap[&#39;BLR&#39;] = 339;
        iocCountryCodesToPriceMap[&#39;HUN&#39;] = 339;
        iocCountryCodesToPriceMap[&#39;ESP&#39;] = 339;
        iocCountryCodesToPriceMap[&#39;NZL&#39;] = 113;
        iocCountryCodesToPriceMap[&#39;UKR&#39;] = 113;
        iocCountryCodesToPriceMap[&#39;KAZ&#39;] = 113;
        iocCountryCodesToPriceMap[&#39;IRL&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;JAM&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;SRB&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;PHI&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;IND&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;THA&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;MEX&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;PRK&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;BRA&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;EST&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;GHA&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;GRE&#39;] = 50;
        iocCountryCodesToPriceMap[&#39;ISL&#39;] = 50;

    }

    function createTeam(bytes32 _teamName, bytes3 _country1, bytes3 _country2, bytes3 _country3,   bytes3 _country4, bytes3 _country5, bytes3 _country6) public payable {
        require (msg.value &gt; 99999999999999999);
        
        require (block.number &lt; 5100000);

        require (_country1 != _country2);
        require (_country1 != _country3);
        require (_country1 != _country4);
        require (_country1 != _country5);
        require (_country1 != _country6);
        require (_country2 != _country3);
        require (_country2 != _country4);
        require (_country2 != _country5);
        require (_country2 != _country6);
        require (_country3 != _country4);
        require (_country3 != _country5);
        require (_country3 != _country6);
        require (_country4 != _country5);
        require (_country4 != _country6);
        require (_country5 != _country6);

        require (iocCountryCodesToPriceMap[_country1] &gt; 0);
        require (iocCountryCodesToPriceMap[_country2] &gt; 0);
        require (iocCountryCodesToPriceMap[_country3] &gt; 0);
        require (iocCountryCodesToPriceMap[_country4] &gt; 0);
        require (iocCountryCodesToPriceMap[_country5] &gt; 0);
        require (iocCountryCodesToPriceMap[_country6] &gt; 0);

        require (iocCountryCodesToPriceMap[_country1] +
        iocCountryCodesToPriceMap[_country2] +
        iocCountryCodesToPriceMap[_country3] +
        iocCountryCodesToPriceMap[_country4] +
        iocCountryCodesToPriceMap[_country5] +
        iocCountryCodesToPriceMap[_country6] &lt; 12000);
        
        newTeamCreated( _teamName, _country1, _country2, _country3, _country4, _country5, _country6);

    }

    function withdraw(address payTo, uint256 amount) onlyOwner {
        require(amount &lt;= this.balance);
        assert(payTo.send(amount));
    }

}