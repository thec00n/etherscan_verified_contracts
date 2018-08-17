pragma solidity ^0.4.20;

// Upload URL contract for Item Market game. Everyone can upload URLs for all ID&#39;s (cannot be prevented on blockchain) 
// However, UI will only check owner data.

contract UploadIMG{
    
    // Addres =&gt; ID =&gt; URL
    mapping(address =&gt; mapping(uint256 =&gt; string)) public Data;
    
    function UploadIMG() public {
 
    }
    // This can be changed!
    function UploadURL(uint256 ID, string URL) public {
        Data[msg.sender][ID] = URL;
    }

    function GetURL(address ADDR, uint256 ID) public returns (string) {
        return Data[ADDR][ID];
    }
    
    // If someone sends eth, send back immediately.
    function() payable public{
        if (msg.value &gt; 0){
            msg.sender.transfer(msg.value);
        }
    }
}