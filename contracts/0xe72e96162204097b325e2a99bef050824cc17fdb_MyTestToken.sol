pragma solidity ^0.4.16;

    contract owned {
        address public owner;

        function owned() public {
            owner = msg.sender;
        }

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        function transferOwnership(address newOwner) onlyOwner public {
            owner = newOwner;
        }
    }

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

contract MyTestToken is owned {
    /* This creates an array with all balances */
    mapping (address =&gt; uint256) public balanceOf;
    bool b_enableTransfer = true;
    uint256 creationDate;
    string public name;
    string public symbol;
    uint8 public decimals = 18;    
    uint256 public totalSupply;
    uint8 public tipoCongelamento = 0;
        // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
        // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
        
    event Transfer(address indexed from, address indexed to, uint256 value);        

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyTestToken (
                           uint256 initialSupply,
                           string tokenName,
                           string tokenSymbol
        ) owned() public 
    {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;              // Give the creator all initial tokens
        creationDate = now;
        name = tokenName;
        symbol = tokenSymbol;
    }

    /* Send coins */
    function transfer2(address _to, uint256 _value) public
    {
        require(b_enableTransfer); 
        //require(balanceOf[msg.sender] &gt;= _value);           // Check if the sender has enough
        //require(balanceOf[_to] + _value &gt;= balanceOf[_to]); // Check for overflows
        
        _transfer(_to, _value);
    }

    function transfer(address _to, uint256 _value) public
    {
        // testa periodos de congelamento
        // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
        // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
        if(tipoCongelamento == 0) // unfrozen
        {
            _transfer(_to, _value);
        }
        if(tipoCongelamento == 1) // 10 minutes
        {
            if(now &gt;= creationDate + 10 * 1 minutes) _transfer(_to, _value);
        }
        if(tipoCongelamento == 2) // 30 minutes
        {
            if(now &gt;= creationDate + 30 * 1 minutes) _transfer(_to, _value);
        }        
        if(tipoCongelamento == 3) // 1 hour
        {
            if(now &gt;= creationDate + 1 * 1 hours) _transfer(_to, _value);
        }        
        if(tipoCongelamento == 4) // 2 hours
        {
            if(now &gt;= creationDate + 2 * 1 hours) _transfer(_to, _value);
        }        
        if(tipoCongelamento == 5) // 1 day
        {
            if(now &gt;= creationDate + 1 * 1 days) _transfer(_to, _value);
        }        
        if(tipoCongelamento == 6) // 2 days
        {
            if(now &gt;= creationDate + 2 * 1 days) _transfer(_to, _value);
        }        
    }

    function freezingStatus() view public returns (string)
    {
        // 0 = unfreeze; 1 = frozen by 10 minutes; 2 = frozen by 30 minutes; 3 = frozen by 1 hour
        // 4 = frozen by 2 hours; 5 = frozen by 1 day; 6 = frozen by 2 days
        
        if(tipoCongelamento == 0) return ( &quot;Tokens free to transfer!&quot;);
        if(tipoCongelamento == 1) return ( &quot;Tokens frozen by 10 minutes.&quot;);
        if(tipoCongelamento == 2) return ( &quot;Tokens frozen by 30 minutes.&quot;);
        if(tipoCongelamento == 3) return ( &quot;Tokens frozen by 1 hour.&quot;);
        if(tipoCongelamento == 4) return ( &quot;Tokens frozen by 2 hours.&quot;);        
        if(tipoCongelamento == 5) return ( &quot;Tokens frozen by 1 day.&quot;);        
        if(tipoCongelamento == 6) return ( &quot;Tokens frozen by 2 days.&quot;);                

    }

    function setFreezingStatus(uint8 _mode) onlyOwner public
    {
        require(_mode&gt;=0 &amp;&amp; _mode &lt;=6);
        tipoCongelamento = _mode;
    }

    function _transfer(address _to, uint256 _value) private 
    {
        require(balanceOf[msg.sender] &gt;= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]); // Check for overflows
        
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        Transfer(msg.sender, _to, _value);
    }
    
    function enableTransfer(bool _enableTransfer) onlyOwner public
    {
        b_enableTransfer = _enableTransfer;
    }
}