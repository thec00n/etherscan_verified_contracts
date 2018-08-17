contract Ownable {
  address public owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  function Ownable() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract SampleStorage is Ownable {
    
    struct Sample {
        string ipfsHash;
        uint rarity;
    }
    
    mapping (uint =&gt; Sample) sampleTypes;
    
    uint public numOfSampleTypes;
    
    uint public numOfCommon;
    uint public numOfRare;
    uint public numOfLegendary;
    uint public numOfMythical;
    
    function addNewSampleType(string _ipfsHash, uint _rarityType) public onlyOwner {
        
        if (_rarityType == 0) {
            numOfCommon++;
        } else if (_rarityType == 1) {
            numOfRare++;
        } else if(_rarityType == 2) {
            numOfLegendary++;
        } else if(_rarityType == 3) {
            numOfMythical++;
        }
        
        sampleTypes[numOfSampleTypes] = Sample({
           ipfsHash: _ipfsHash,
           rarity: _rarityType
        });
        
        numOfSampleTypes++;
    }
    
    function getType(uint _randomNum) public view returns (uint) {
        uint range = 0;
        
        if (_randomNum &gt; 0 &amp;&amp; _randomNum &lt; 600) {
            range = 600 / numOfCommon;
            return _randomNum / range;
            
        } else if(_randomNum &gt;= 600 &amp;&amp; _randomNum &lt; 900) {
            range = 300 / numOfRare;
            return _randomNum / range;
        } else {
            range = 100 / numOfLegendary;
            return _randomNum / range;
        }
    }
    
}