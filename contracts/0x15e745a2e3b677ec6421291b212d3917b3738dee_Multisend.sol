contract Multisend {
    mapping(address =&gt; uint) public balances;
    mapping(address =&gt; uint) public nonces;

    
    function send(address[] addrs, uint[] amounts, uint nonce) {
        if(addrs.length != amounts.length || nonce != nonces[msg.sender]) throw;
        uint val = msg.value;
        
        for(uint i = 0; i&lt;addrs.length; i++){
            if(val &lt; amounts[i]) throw;
            
            if(!addrs[i].send(amounts[i])){
                balances[addrs[i]] += amounts[i];
            }
            val -= amounts[i];
        }
        
        if(!msg.sender.send(val)){
            balances[msg.sender] += val;
        }
        nonces[msg.sender]++;
    }
    
    function withdraw(){
        uint balance = balances[msg.sender];
        balances[msg.sender] = 0;
        if(!msg.sender.send(balance)) throw;
    }
    
    function(){
        withdraw();
    }
}