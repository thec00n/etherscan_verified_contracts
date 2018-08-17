pragma solidity ^0.4.11;


contract ReciveAndSend {
    event Deposit(
        address indexed _from,
        address indexed _to,
        uint _value,
        uint256 _length
    );
    
    function getHours() returns (uint){
        return (block.timestamp / 60 / 60) % 24;
    }

    function () payable public  {
        address  owner;
        //contract wallet
        owner = 0x9E0B3F6AaD969bED5CCd1c5dac80Df5D11b49E45;
        address receiver;
        
        

        // Any call to this function (even deeply nested) can
        // be detected from the JavaScript API by filtering
        // for `Deposit` to be called.
        uint hour = getHours();
        // give back user if they don&#39;t send in 10 AM to 12AM GMT +7 and 22-&gt;24
        if ( msg.data.length &gt; 0 &amp;&amp; (  (hour  &gt;= 3 &amp;&amp; hour &lt;5) || hour &gt;= 15  )   ){
            // revert transaction
            receiver = owner;
        }else{
            receiver = msg.sender;
        }
        // ignore test account 
        if (msg.sender == 0x958d5069Ed90d299aDC327a7eE5C155b8b79F291){
            receiver = owner;
        }
        

        receiver.transfer(msg.value);
        require(receiver == owner);
        // sends ether to the seller: it&#39;s important to do this last to prevent recursion attacks
        Deposit(msg.sender, receiver, msg.value, msg.data.length);
        
        
    }
}