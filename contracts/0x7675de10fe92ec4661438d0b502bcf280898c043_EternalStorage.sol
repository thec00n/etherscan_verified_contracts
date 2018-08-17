pragma solidity ^0.4.18;


contract Ownable {

    address public owner;
    address public acceptableAddress;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function Ownable() public {
        owner = msg.sender;
        acceptableAddress = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAcceptable() {
        require(msg.sender == acceptableAddress);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function transferAcceptable(address newAcceptable) public onlyOwner {
        require(newAcceptable != address(0));
        OwnershipTransferred(acceptableAddress, newAcceptable);
        acceptableAddress = newAcceptable;
    }

}


contract EternalStorage is Ownable {

    function () public payable {
        require(msg.sender == acceptableAddress || msg.sender == owner);
    }

    mapping(bytes32 =&gt; uint) public uintStorage;

    function getUInt(bytes32 record) public view returns (uint) {
        return uintStorage[record];
    }

    function setUInt(bytes32 record, uint value) public onlyAcceptable {
        uintStorage[record] = value;
    }

    mapping(bytes32 =&gt; string) public stringStorage;

    function getString(bytes32 record) public view returns (string) {
        return stringStorage[record];
    }

    function setString(bytes32 record, string value) public onlyAcceptable {
        stringStorage[record] = value;
    }

    mapping(bytes32 =&gt; address) public addressStorage;

    function getAdd(bytes32 record) public view returns (address) {
        return addressStorage[record];
    }

    function setAdd(bytes32 record, address value) public onlyAcceptable {
        addressStorage[record] = value;
    }

    mapping(bytes32 =&gt; bytes) public bytesStorage;

    function getBytes(bytes32 record) public view returns (bytes) {
        return bytesStorage[record];
    }

    function setBytes(bytes32 record, bytes value) public onlyAcceptable {
        bytesStorage[record] = value;
    }

    mapping(bytes32 =&gt; bytes32) public bytes32Storage;

    function getBytes32(bytes32 record) public view returns (bytes32) {
        return bytes32Storage[record];
    }

    function setBytes32(bytes32 record, bytes32 value) public onlyAcceptable {
        bytes32Storage[record] = value;
    }

    mapping(bytes32 =&gt; bool) public booleanStorage;

    function getBool(bytes32 record) public view returns (bool) {
        return booleanStorage[record];
    }

    function setBool(bytes32 record, bool value) public  onlyAcceptable {
        booleanStorage[record] = value;
    }

    mapping(bytes32 =&gt; int) public intStorage;

    function getInt(bytes32 record) public view returns (int) {
        return intStorage[record];
    }

    function setInt(bytes32 record, int value) public onlyAcceptable {
        intStorage[record] = value;
    }

    function getBalance() public constant returns (uint) {
        return this.balance;
    }

    function withdraw(address beneficiary) public onlyAcceptable {
        uint balance = getUInt(keccak256(beneficiary, &quot;balance&quot;));
        setUInt(keccak256(beneficiary, &quot;balance&quot;), 0);
        beneficiary.transfer(balance);
    }
}