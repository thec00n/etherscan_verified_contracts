contract Faucet {
    uint256 sendAmount;
    mapping (address =&gt; uint) lastSent;
    uint blockLimit;
    function Faucet(){
        
	sendAmount = 10000000000000000;
        blockLimit = 5760;
    }
	
	function getWei() returns (bool){
	    if(lastSent[msg.sender]&lt;(block.number-blockLimit)&amp;&amp;address(this).balance&gt;sendAmount){
	        msg.sender.send(sendAmount);
	        lastSent[msg.sender] = block.number;
	        return true;
	    } else {
	        return false;
	    }
	}
	
}