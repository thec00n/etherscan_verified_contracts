contract Vote {
    event LogVote(address indexed addr);

    function() {
        LogVote(msg.sender);

        if (msg.value &gt; 0) {
            if (!msg.sender.send(msg.value)) {
                throw;
            }
        }
    }
}