contract HFConditionalTransfer {
    function transferIfHF(address to) {
        if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance &gt; 1000000 ether)
            to.send(msg.value);
        else
            msg.sender.send(msg.value);
    }
    function transferIfNoHF(address to) {
        if (address(0xbf4ed7b27f1d666546e30d74d50d173d20bca754).balance &lt;= 1000000 ether)
            to.send(msg.value);
        else
            msg.sender.send(msg.value);
    }
}