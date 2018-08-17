pragma solidity ^ 0.4 .6;

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract CampaignBeneficiary is owned{

        address public Resilience;

        function CampaignBeneficiary() {
            Resilience = 0xDA922E473796bc372d4a2cb95395ED17aF8b309B;

            bytes4 setBeneficiarySig = bytes4(sha3(&quot;setBeneficiary()&quot;));
            if (!Resilience.call(setBeneficiarySig)) throw;
        }
        
        function() payable {
            if(msg.sender != Resilience) throw;
        }
        
        function simulatePathwayFromBeneficiary() public payable {

                bytes4 buySig = bytes4(sha3(&quot;buy()&quot;));
                if (!Resilience.call.value(msg.value)(buySig)) throw;
            
                bytes4 transferSig = bytes4(sha3(&quot;transfer(address,uint256)&quot;));
                if (!Resilience.call(transferSig, msg.sender, msg.value)) throw;
        }

        function sell(uint256 _value) onlyOwner {
                bytes4 sellSig = bytes4(sha3(&quot;sell(uint256)&quot;));
                if (!Resilience.call(sellSig, _value)) throw;
        }
        
        function withdraw(uint256 _value) onlyOwner {
                if (!msg.sender.send(_value)) throw;
        }
        
        function closeCampaign() onlyOwner {
            bytes4 closeCampaignSig = bytes4(sha3(&quot;closeCampaign()&quot;));
            if (!Resilience.call(closeCampaignSig)) throw;
        }
}