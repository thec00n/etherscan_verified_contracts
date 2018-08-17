pragma solidity ^0.4.18;

/*
    Manages ownership and permissions for the whole contract.
*/

contract BLAccess {

    address public mainAddress; //Main Contract Address
    event UpdatedMainAccount(address _newMainAddress);

    function BLAccess() public {
        mainAddress = msg.sender;
    }

    modifier onlyPrimary() {
        require(msg.sender == mainAddress);
        _;
    }

    //Allows to change the primary account for the contract
    function setPrimaryAccount(address _newMainAddress) external onlyPrimary {
        require(_newMainAddress != address(0));
        mainAddress = _newMainAddress;
        UpdatedMainAccount(_newMainAddress);
    }

}

/*
 Interface for our separate eternal storage.
*/

contract DataStorageInterface {
    function getUInt(bytes32 record) public constant returns (uint);
    function setUInt(bytes32 record, uint value) public;
    function getAdd(bytes32 record) public constant returns (address);
    function setAdd(bytes32 record, address value) public;
    function getBytes32(bytes32 record) public constant returns (bytes32);
    function setBytes32(bytes32 record, bytes32 value) public;
    function getBool(bytes32 record) public constant returns (bool);
    function setBool(bytes32 record, bool value) public;
    function withdraw(address beneficiary) public;
}

/*
 Wrapper around Data Storage interface
*/

contract BLStorage is BLAccess {

    DataStorageInterface internal s;
    address public storageAddress;

    event StorageUpdated(address _newStorageAddress);

    function BLStorage() public {
        s = DataStorageInterface(mainAddress);
    }

    // allows to setup a new Storage address. Should never be needed but you never know!
    function setDataStorage(address newAddress) public onlyPrimary {
        s = DataStorageInterface(newAddress);
        storageAddress = newAddress;
        StorageUpdated(newAddress);
    }

    function getKey(uint x, uint y) internal pure returns(bytes32 key) {
        key = keccak256(x, &quot;:&quot;, y);
    }
}


contract BLBalances is BLStorage {

    event WithdrawBalance(address indexed owner, uint amount);
    event AllowanceGranted(address indexed owner, uint _amount);
    event SentFeeToPlatform(uint amount);
    event SentAmountToOwner(uint amount, address indexed owner);

    // get the balance for a given account
    function getBalance() public view returns (uint) {
        return s.getUInt(keccak256(msg.sender, &quot;balance&quot;));
    }

    // get the balance for a given account
    function getAccountBalance(address _account) public view onlyPrimary returns (uint) {
        return s.getUInt(keccak256(_account, &quot;balance&quot;));
    }

    function getAccountAllowance(address _account) public view onlyPrimary returns (uint) {
        return s.getUInt(keccak256(_account, &quot;promoAllowance&quot;));
    }

    function getMyAllowance() public view returns (uint) {
        return s.getUInt(keccak256(msg.sender, &quot;promoAllowance&quot;));
    }

    // allow a block allowance for promo and early beta users
    function grantAllowance(address beneficiary, uint allowance) public onlyPrimary {
        uint existingAllowance = s.getUInt(keccak256(beneficiary, &quot;promoAllowance&quot;));
        existingAllowance += allowance;
        s.setUInt(keccak256(beneficiary, &quot;promoAllowance&quot;), existingAllowance);
        AllowanceGranted(beneficiary, allowance);
    }

    // withdraw the current balance
    function withdraw() public {
        uint balance = s.getUInt(keccak256(msg.sender, &quot;balance&quot;));
        s.withdraw(msg.sender);
        WithdrawBalance(msg.sender, balance);
    }

    // Trading and buying balances flow
    function rewardParties (address owner, uint feePercentage) internal {
        uint fee = msg.value * feePercentage / 100;
        rewardContract(fee);
        rewardPreviousOwner(owner, msg.value - fee);
    }

    // contract commissions
    function rewardContract (uint fee) internal {
        uint mainBalance = s.getUInt(keccak256(mainAddress, &quot;balance&quot;));
        mainBalance += fee;
        s.setUInt(keccak256(mainAddress, &quot;balance&quot;), mainBalance);
        SentFeeToPlatform(fee);
    }

    // reward the previous owner of the block or the contract if the block is bought for the first time
    function rewardPreviousOwner (address owner, uint amount) internal {
        uint rewardBalance;
        if (owner == address(0)) {
            rewardBalance = s.getUInt(keccak256(mainAddress, &quot;balance&quot;));
            rewardBalance += amount;
            s.setUInt(keccak256(mainAddress, &quot;balance&quot;), rewardBalance);
            SentAmountToOwner(amount, mainAddress);
        } else {
            rewardBalance = s.getUInt(keccak256(owner, &quot;balance&quot;));
            rewardBalance += amount;
            s.setUInt(keccak256(owner, &quot;balance&quot;), rewardBalance);
            SentAmountToOwner(amount, owner);
        }
    }
}

contract BLBlocks is BLBalances {

    event CreatedBlock(
        uint x,
        uint y,
        uint price,
        address indexed owner,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL);

    event SetBlockForSale(
        uint x,
        uint y,
        uint price,
        address indexed owner);

    event UnsetBlockForSale(
        uint x,
        uint y,
        address indexed owner);

    event BoughtBlock(
        uint x,
        uint y,
        uint price,
        address indexed owner,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL);

    event SoldBlock(
        uint x,
        uint y,
        uint oldPrice,
        uint newPrice,
        uint feePercentage,
        address indexed owner);

    event UpdatedBlock(uint x,
        uint y,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL,
        address indexed owner);

    // Create a block if it doesn&#39;t exist
    function createBlock(
        uint x,
        uint y,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL
    ) public payable {
        bytes32 key = getKey(x, y);
        uint initialPrice = s.getUInt(&quot;initialPrice&quot;);
        address owner = s.getAdd(keccak256(key, &quot;owner&quot;));
        uint allowance = s.getUInt(keccak256(msg.sender, &quot;promoAllowance&quot;));
        require(msg.value &gt;= initialPrice || allowance &gt; 0);
        require(owner == address(0));
        uint feePercentage = s.getUInt(&quot;buyOutFeePercentage&quot;);
        if (msg.value &gt;= initialPrice) {
            rewardParties(owner, feePercentage);
            s.setUInt(keccak256(key, &quot;price&quot;), msg.value);
        } else {
            allowance--;
            s.setUInt(keccak256(msg.sender, &quot;promoAllowance&quot;), allowance);
            s.setUInt(keccak256(key, &quot;price&quot;), initialPrice);
        }
        s.setBytes32(keccak256(key, &quot;name&quot;), name);
        s.setBytes32(keccak256(key, &quot;description&quot;), description);
        s.setBytes32(keccak256(key, &quot;url&quot;), url);
        s.setBytes32(keccak256(key, &quot;imageURL&quot;), imageURL);
        s.setAdd(keccak256(key, &quot;owner&quot;), msg.sender);
        uint blockCount = s.getUInt(&quot;blockCount&quot;);
        blockCount++;
        s.setUInt(&quot;blockCount&quot;, blockCount);
        storageAddress.transfer(msg.value);
        CreatedBlock(x,
            y,
            msg.value,
            msg.sender,
            name,
            description,
            url,
            imageURL);
    }

    // Get details for a block
    function getBlock (uint x, uint y) public view returns (
        uint price,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL,
        uint forSale,
        uint pricePerDay,
        address owner
    ) {
        bytes32 key = getKey(x, y);
        price = s.getUInt(keccak256(key, &quot;price&quot;));
        name = s.getBytes32(keccak256(key, &quot;name&quot;));
        description = s.getBytes32(keccak256(key, &quot;description&quot;));
        url = s.getBytes32(keccak256(key, &quot;url&quot;));
        imageURL = s.getBytes32(keccak256(key, &quot;imageURL&quot;));
        forSale = s.getUInt(keccak256(key, &quot;forSale&quot;));
        pricePerDay = s.getUInt(keccak256(key, &quot;pricePerDay&quot;));
        owner = s.getAdd(keccak256(key, &quot;owner&quot;));
    }

    // Sets a block up for sale
    function sellBlock(uint x, uint y, uint price) public {
        bytes32 key = getKey(x, y);
        uint basePrice = s.getUInt(keccak256(key, &quot;price&quot;));
        require(s.getAdd(keccak256(key, &quot;owner&quot;)) == msg.sender);
        require(price &lt; basePrice * 2);
        s.setUInt(keccak256(key, &quot;forSale&quot;), price);
        SetBlockForSale(x, y, price, msg.sender);
    }

    // Sets a block not for sale
    function cancelSellBlock(uint x, uint y) public {
        bytes32 key = getKey(x, y);
        require(s.getAdd(keccak256(key, &quot;owner&quot;)) == msg.sender);
        s.setUInt(keccak256(key, &quot;forSale&quot;), 0);
        UnsetBlockForSale(x, y, msg.sender);
    }

    // transfers ownership of an existing block
    function buyBlock(
        uint x,
        uint y,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL
    ) public payable {
        bytes32 key = getKey(x, y);
        uint price = s.getUInt(keccak256(key, &quot;price&quot;));
        uint forSale = s.getUInt(keccak256(key, &quot;forSale&quot;));
        address owner = s.getAdd(keccak256(key, &quot;owner&quot;));
        require(owner != address(0));
        require((forSale &gt; 0 &amp;&amp; msg.value &gt;= forSale) || msg.value &gt;= price * 2);
        uint feePercentage = s.getUInt(&quot;buyOutFeePercentage&quot;);
        rewardParties(owner, feePercentage);
        s.setUInt(keccak256(key, &quot;price&quot;), msg.value);
        s.setBytes32(keccak256(key, &quot;name&quot;), name);
        s.setBytes32(keccak256(key, &quot;description&quot;), description);
        s.setBytes32(keccak256(key, &quot;url&quot;), url);
        s.setBytes32(keccak256(key, &quot;imageURL&quot;), imageURL);
        s.setAdd(keccak256(key, &quot;owner&quot;), msg.sender);
        s.setUInt(keccak256(key, &quot;forSale&quot;), 0);
        s.setUInt(keccak256(key, &quot;pricePerDay&quot;), 0);
        storageAddress.transfer(msg.value);
        BoughtBlock(x, y, msg.value, msg.sender,
            name, description, url, imageURL);
        SoldBlock(x, y, price, msg.value, feePercentage, owner);
    }

    // update details for an existing block
    function updateBlock(
        uint x,
        uint y,
        bytes32 name,
        bytes32 description,
        bytes32 url,
        bytes32 imageURL
    )  public {
        bytes32 key = getKey(x, y);
        address owner = s.getAdd(keccak256(key, &quot;owner&quot;));
        require(msg.sender == owner);
        s.setBytes32(keccak256(key, &quot;name&quot;), name);
        s.setBytes32(keccak256(key, &quot;description&quot;), description);
        s.setBytes32(keccak256(key, &quot;url&quot;), url);
        s.setBytes32(keccak256(key, &quot;imageURL&quot;), imageURL);
        UpdatedBlock(x, y, name, description, url, imageURL, msg.sender);
    }

}

contract BLTenancies is BLBlocks {

    event ToRent(
        uint x,
        uint y,
        uint pricePerDay,
        address indexed owner);

    event NotToRent(
        uint x,
        uint y,
        address indexed owner);

    event LeasedBlock(
        uint x,
        uint y,
        uint paid,
        uint expiry,
        bytes32 tenantName,
        bytes32 tenantDescription,
        bytes32 teantURL,
        bytes32 tenantImageURL,
        address indexed owner);

    event RentedBlock(
        uint x,
        uint y,
        uint paid,
        uint feePercentage,
        address indexed owner);

    // Sets a block up for rent, requires a rental price to be provided
    function setForRent(
        uint x,
        uint y,
        uint pricePerDay
    ) public {
        bytes32 key = getKey(x, y);
        uint price = s.getUInt(keccak256(key, &quot;price&quot;));
        require(s.getAdd(keccak256(key, &quot;owner&quot;)) == msg.sender);
        require(pricePerDay &gt;= price / 10);
        s.setUInt(keccak256(key, &quot;pricePerDay&quot;), pricePerDay);
        ToRent(x, y, pricePerDay, msg.sender);
    }

    // Sets a block not for rent
    function cancelRent(
        uint x,
        uint y
    ) public {
        bytes32 key = getKey(x, y);
        address owner = s.getAdd(keccak256(key, &quot;owner&quot;));
        require(owner == msg.sender);
        s.setUInt(keccak256(key, &quot;pricePerDay&quot;), 0);
        NotToRent(x, y, msg.sender);
    }

    // actually rent a block to a willing tenant
    function leaseBlock(
        uint x,
        uint y,
        uint duration,
        bytes32 tenantName,
        bytes32 tenantDescription,
        bytes32 tenantURL,
        bytes32 tenantImageURL
    ) public payable {
        bytes32 key = getKey(x, y);
        uint pricePerDay = s.getUInt(keccak256(key, &quot;pricePerDay&quot;));
        require(pricePerDay &gt; 0);
        require(msg.value &gt;= pricePerDay * duration);
        require(now &gt;= s.getUInt(keccak256(key, &quot;expiry&quot;)));
        address owner = s.getAdd(keccak256(key, &quot;owner&quot;));
        uint feePercentage = s.getUInt(&quot;buyOutFeePercentage&quot;);
        rewardParties(owner, feePercentage);
        uint expiry = now + 86400 * duration;
        s.setUInt(keccak256(key, &quot;expiry&quot;), expiry);
        s.setBytes32(keccak256(key, &quot;tenantName&quot;), tenantName);
        s.setBytes32(keccak256(key, &quot;tenantDescription&quot;), tenantDescription);
        s.setBytes32(keccak256(key, &quot;tenantURL&quot;), tenantURL);
        s.setBytes32(keccak256(key, &quot;tenantImageURL&quot;), tenantImageURL);
        storageAddress.transfer(msg.value);
        RentedBlock(x, y, msg.value, feePercentage, owner);
        LeasedBlock(x, y, msg.value, expiry, tenantName, tenantDescription, tenantURL, tenantImageURL, msg.sender);
    }

    // get details for a tenancy
    function getTenancy (uint x, uint y) public view returns (
        uint expiry,
        bytes32 tenantName,
        bytes32 tenantDescription,
        bytes32 tenantURL,
        bytes32 tenantImageURL
    ) {
        bytes32 key = getKey(x, y);
        expiry = s.getUInt(keccak256(key, &quot;tenantExpiry&quot;));
        tenantName = s.getBytes32(keccak256(key, &quot;tenantName&quot;));
        tenantDescription = s.getBytes32(keccak256(key, &quot;tenantDescription&quot;));
        tenantURL = s.getBytes32(keccak256(key, &quot;tenantURL&quot;));
        tenantImageURL = s.getBytes32(keccak256(key, &quot;tenantImageURL&quot;));
    }
}

/*
    Main Blocklord contract. It exposes some commodity functions and functions from its subcontracts.
*/

contract BLMain is BLTenancies {

    event ChangedInitialPrice(uint price);
    event ChangedFeePercentage(uint fee);

    // provides the total number of purchased blocks
    function totalSupply() public view returns (uint count) {
        count = s.getUInt(&quot;blockCount&quot;);
        return count;
    }

    // allows to change the price of an empty block
    function setInitialPrice(uint price) public onlyPrimary {
        s.setUInt(&quot;initialPrice&quot;, price);
        ChangedInitialPrice(price);
    }

    // allows to change the platform fee percentage
    function setFeePercentage(uint feePercentage) public onlyPrimary {
        s.setUInt(&quot;buyOutFeePercentage&quot;, feePercentage);
        ChangedFeePercentage(feePercentage);
    }

    // provides the starting price for an empty block
    function getInitialPrice() public view returns (uint) {
        return s.getUInt(&quot;initialPrice&quot;);
    }

    // provides the price of an empty block
    function getFeePercentage() public view returns (uint) {
        return s.getUInt(&quot;buyOutFeePercentage&quot;);
    }
}