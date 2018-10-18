pragma solidity ^0.4.23;

contract DigitalPrintImage {
	struct ImageMetadata {
        uint finalSeed;
        bytes32[] potentialAssets;
        uint timestamp;
        address creator;
        string ipfsHash;
        string extraData;
    }

    mapping(uint => ImageMetadata) public imageMetadata;

	function totalSupply() public view returns (uint256);
	function getImageMetadata(uint _imageId) public view
    	returns(address, string, uint, string, uint, bytes32[]);
}

contract AssetManager {
	struct AssetPack {
        bytes32 packCover;
        uint[] assetIds;
        address creator;
        uint price;
        string ipfsHash;
    }

    uint public numberOfAssetPacks;
    AssetPack[] public assetPacks;

	function pickUniquePacks(uint [] assetIds) public view returns (uint[]);
}

contract Functions {
	function pickRandomAssets(uint _finalSeed, bytes32[] _potentialAssets) public pure returns(uint[] finalPicked);
}

contract CryptographicsGetter {
	AssetManager public manager;
	DigitalPrintImage public dpm;
	Functions public functions;

	constructor (address _manager, address _dpm, address _functions) public {

		manager = AssetManager(_manager);
		dpm = DigitalPrintImage(_dpm);
		functions = Functions(_functions);
	}

	function getImagesUsingAssetPack(uint _assetPackId) public view returns(uint[] ids) {
		uint count = 0;
		uint totalSupply = dpm.totalSupply();
		uint finalSeed;
		bytes32[] memory potentialAssets;
		uint[] memory assetIds;
		uint[] memory assetPackIds;

		for (uint i=0; i<totalSupply; i++) {
			(,,finalSeed,,,potentialAssets) = dpm.getImageMetadata(i);
			assetIds = functions.pickRandomAssets(finalSeed, potentialAssets);
			assetPackIds = manager.pickUniquePacks(assetIds);
			
			for (uint j=0; j<assetPackIds.length; j++) {
				if (assetPackIds[j] == _assetPackId) {
					count++;
					break;
				}
			}
		}

		ids = new uint[](count);
	
		count = 0;
		for (i=0; i<totalSupply; i++) {
			(,,finalSeed,,,potentialAssets) = dpm.getImageMetadata(i);
			assetIds = functions.pickRandomAssets(finalSeed, potentialAssets);
			assetPackIds = manager.pickUniquePacks(assetIds);

			for (j=0; j<assetPackIds.length; j++) {
				if (assetPackIds[j] == _assetPackId) {
					ids[count] = i;
					count++;
				}
			}
		}
	}

	function getImagesCreatedByAddress(address _creator) public view returns(uint[] ids) {
		uint count = 0;
		uint totalSupply = dpm.totalSupply();
		address creator;

		for (uint i=0; i<totalSupply; i++) {
			(,,creator,,) = dpm.imageMetadata(i);
			
			if (creator == _creator){
				count++;
			}
		}

		ids = new uint[](count);

		count = 0;
		for (i=0; i<totalSupply; i++) {
			(,,creator,,) = dpm.imageMetadata(i);
			
			if (creator == _creator){
				ids[count] = i;
				count++;
			}
		}
	}

	function getAllCreators() public view returns(address[] creators) {
		uint totalSupply = dpm.totalSupply();
		uint totalAssetPacks = manager.numberOfAssetPacks();
		uint count = 0;
		bool exists = false;
		address creator;

		address[] memory allCreators = new address[](totalSupply+totalAssetPacks);

		for (uint i=0; i<totalSupply; i++) {
			(,,creator,,) = dpm.imageMetadata(i);
			exists = false;

			for (uint j=0; j<count; j++) {
				if (allCreators[j] == creator) {
					exists = true;
					break;
				}
			}

			if (!exists) {
				allCreators[count] = creator;
				count++;
			}
		}

		for (i=0; i<totalAssetPacks; i++) {
			(,creator,,) = manager.assetPacks(i);
			exists = false;

			for (j=0; j<count; j++) {
				if (allCreators[j] == creator) {
					exists = true;
					break;
				}
			}

			if (!exists) {
				allCreators[count] = creator;
				count++;
			}
		}

		creators = new address[](count);

		for (i=0; i<count; i++) {
			creators[i] = allCreators[i];
		}
	}

}