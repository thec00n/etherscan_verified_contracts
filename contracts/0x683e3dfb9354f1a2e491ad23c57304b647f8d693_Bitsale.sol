pragma solidity ^0.4.15;

contract admined {
    address public admin;
	
    function admined(){
        admin = msg.sender;
    }

    modifier onlyAdmin(){
        // if(msg.sender != admin) throw;
        require(msg.sender == admin);
        _;
    }

    function transferAdminship(address newAdmin) onlyAdmin {
        admin = newAdmin;
    }

}

contract BitsaleERC20 {

    mapping (address =&gt; uint256) public balanceOf;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;
    // balanceOf[address] = 5;
    string public standard = &quot;BitsaleERC20 v1.0&quot;;
    string public name = &quot;BitsaleERC20&quot;;
    string public symbol = &quot;BSL&quot;;
    uint8 public decimals = 8; 
    uint256 public totalSupply = 1200000000 ;
    event Transfer(address indexed from, address indexed to, uint256 value);

    function BitsaleERC20(){
        balanceOf[msg.sender] = 1200000000;
    
    }

    function transfer(address _to, uint256 _value){
        // if(balanceOf[msg.sender] &lt; _value) throw;
        // if(balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        require(balanceOf[msg.sender] &gt;= _value);
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        //if(admin)

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function approve(address _spender, uint256 _value) returns (bool success){
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        // if(balanceOf[_from] &lt; _value) throw;
        require(balanceOf[_from] &gt;= _value);
        // if(balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        // if(_value &gt; allowance[_from][msg.sender]) throw;
        require(_value &lt; allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;

    }
}

contract Bitsale is admined, BitsaleERC20{

    uint256 minimumBalanceForAccounts = 5 finney;
    uint256 public sellPrice;
    uint256 public buyPrice;
    mapping (address =&gt; bool) public frozenAccount;

    event FrozenFund(address target, bool frozen);

    function Bitsale() BitsaleERC20 (){
        admin = msg.sender;
        balanceOf[admin] = 1200000000;
        totalSupply = 1200000000;    
    }

    function mintToken(address target, uint256 mintedAmount) onlyAdmin{
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, this, mintedAmount);
        Transfer(this, target, mintedAmount);
    }

    function freezeAccount(address target, bool freeze) onlyAdmin{
        frozenAccount[target] = freeze;
        FrozenFund(target, freeze);
    }

    function transfer(address _to, uint256 _value){
        if(msg.sender.balance &lt; minimumBalanceForAccounts)
        sell((minimumBalanceForAccounts - msg.sender.balance)/sellPrice);

        // if(frozenAccount[msg.sender]) throw;
        require(!frozenAccount[msg.sender]);
        // if(balanceOf[msg.sender] &lt; _value) throw;
        require(balanceOf[msg.sender] &gt;= _value);
        // if(balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        //if(admin)

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        Transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        // if(frozenAccount[_from]) throw;
        require(!frozenAccount[_from]);
        // if(balanceOf[_from] &lt; _value) throw;
        require(balanceOf[_from] &gt;= _value);
        // if(balanceOf[_to] + _value &lt; balanceOf[_to]) throw;
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);
        // if(_value &gt; allowance[_from][msg.sender]) throw;
        require(_value &lt;= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;

    }

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAdmin{
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    function buy() payable {
        uint256 amount = (msg.value/(1 ether)) / buyPrice;
        // if(balanceOf[this] &lt; amount) throw;
        require(balanceOf[this] &gt;= amount);
        balanceOf[msg.sender] += amount;
        balanceOf[this] -= amount;
        Transfer(this, msg.sender, amount);
    }

    function sell(uint256 amount){
        // if(balanceOf[msg.sender] &lt; amount) throw;
        require(balanceOf[msg.sender] &gt;= amount);
        balanceOf[this] +=amount;
        balanceOf[msg.sender] -= amount;
        if(!msg.sender.send(amount * sellPrice * 1 ether)){
            revert();
        } else {
            Transfer(msg.sender, this, amount);
        }
    }

    function giveBlockreward(){
        balanceOf[block.coinbase] += 1;
    }

    bytes32 public currentChallenge;
    uint public timeOfLastProof;
    uint public difficulty = 10**32;

    function proofOfWork(uint nonce){
        bytes8 n = bytes8(sha3(nonce, currentChallenge));

        // if(n &lt; bytes8(difficulty)) throw;
        require(n &gt;= bytes8(difficulty));
        uint timeSinceLastBlock = (now - timeOfLastProof);
        // if(timeSinceLastBlock &lt; 5 seconds) throw;
        require(timeSinceLastBlock &gt;= 5 seconds);

        balanceOf[msg.sender] += timeSinceLastBlock / 60 seconds;
        difficulty = difficulty * 10 minutes / timeOfLastProof + 1;
        timeOfLastProof = now;
        currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1));
     }


}