pragma solidity ^0.4.4;
/**
 * @title Contract for object that have an owner
 */
contract Owned {
    /**
     * Contract owner address
     */
    address public owner;

    /**
     * @dev Store owner on creation
     */
    function Owned() { owner = msg.sender; }

    /**
     * @dev Delegate contract to another person
     * @param _owner is another person address
     */
    function delegate(address _owner) onlyOwner
    { owner = _owner; }

    /**
     * @dev Owner check modifier
     */
    modifier onlyOwner { if (msg.sender != owner) throw; _; }
}


/**
 * @title Contract for objects that can be morder
 */
contract Mortal is Owned {
    /**
     * @dev Destroy contract and scrub a data
     * @notice Only owner can kill me
     */
    function kill() onlyOwner
    { suicide(owner); }
}


contract Comission is Mortal {
    address public ledger;
    bytes32 public taxman;
    uint    public taxPerc;

    /**
     * @dev Comission contract constructor
     * @param _ledger Processing ledger contract
     * @param _taxman Tax receiver account
     * @param _taxPerc Processing tax in percent
     */
    function Comission(address _ledger, bytes32 _taxman, uint _taxPerc) {
        ledger  = _ledger;
        taxman  = _taxman;
        taxPerc = _taxPerc;
    }

    /**
     * @dev Refill ledger with comission
     * @param _destination Destination account
     */
    function process(bytes32 _destination) payable returns (bool) {
        // Handle value below 100 isn&#39;t possible
        if (msg.value &lt; 100) throw;

        var tax = msg.value * taxPerc / 100; 
        var refill = bytes4(sha3(&quot;refill(bytes32)&quot;)); 
        if ( !ledger.call.value(tax)(refill, taxman)
          || !ledger.call.value(msg.value - tax)(refill, _destination)
           ) throw;
        return true;
    }
}


library CreatorComission {
    function create(address _ledger, bytes32 _taxman, uint256 _taxPerc) returns (Comission)
    { return new Comission(_ledger, _taxman, _taxPerc); }

    function version() constant returns (string)
    { return &quot;v0.5.0 (a9ea4c6c)&quot;; }

    function abi() constant returns (string)
    { return &#39;[{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_destination&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;name&quot;:&quot;process&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bool&quot;}],&quot;payable&quot;:true,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;kill&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;taxman&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;bytes32&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;ledger&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_owner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;delegate&quot;,&quot;outputs&quot;:[],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;owner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;taxPerc&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;payable&quot;:false,&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[{&quot;name&quot;:&quot;_ledger&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_taxman&quot;,&quot;type&quot;:&quot;bytes32&quot;},{&quot;name&quot;:&quot;_taxPerc&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;constructor&quot;}]&#39;; }
}


/**
 * @title Builder based contract
 */
contract Builder is Mortal {
    /**
     * @dev this event emitted for every builded contract
     */
    event Builded(address indexed client, address indexed instance);
 
    /* Addresses builded contracts at sender */
    mapping(address =&gt; address[]) public getContractsOf;
 
    /**
     * @dev Get last address
     * @return last address contract
     */
    function getLastContract() constant returns (address) {
        var sender_contracts = getContractsOf[msg.sender];
        return sender_contracts[sender_contracts.length - 1];
    }

    /* Building beneficiary */
    address public beneficiary;

    /**
     * @dev Set beneficiary
     * @param _beneficiary is address of beneficiary
     */
    function setBeneficiary(address _beneficiary) onlyOwner
    { beneficiary = _beneficiary; }

    /* Building cost  */
    uint public buildingCostWei;

    /**
     * @dev Set building cost
     * @param _buildingCostWei is cost
     */
    function setCost(uint _buildingCostWei) onlyOwner
    { buildingCostWei = _buildingCostWei; }

    /* Security check report */
    string public securityCheckURI;

    /**
     * @dev Set security check report URI
     * @param _uri is an URI to report
     */
    function setSecurityCheck(string _uri) onlyOwner
    { securityCheckURI = _uri; }
}

//
// AIRA Builder for Comission contract
//

/**
 * @title BuilderComission contract
 */
contract BuilderComission is Builder {
    /**
     * @dev Run script creation contract
     * @return address new contract
     */
    function create(address _ledger, bytes32 _taxman, uint _taxPerc,
                    address _client) payable returns (address) {
        if (buildingCostWei &gt; 0 &amp;&amp; beneficiary != 0) {
            // Too low value
            if (msg.value &lt; buildingCostWei) throw;
            // Beneficiary send
            if (!beneficiary.send(buildingCostWei)) throw;
            // Refund
            if (msg.value &gt; buildingCostWei) {
                if (!msg.sender.send(msg.value - buildingCostWei)) throw;
            }
        } else {
            // Refund all
            if (msg.value &gt; 0) {
                if (!msg.sender.send(msg.value)) throw;
            }
        }

        if (_client == 0)
            _client = msg.sender;
 
        var inst = CreatorComission.create(_ledger, _taxman, _taxPerc);
        inst.delegate(_client);
        Builded(_client, inst);
        getContractsOf[_client].push(inst);
        return inst;
    }
}