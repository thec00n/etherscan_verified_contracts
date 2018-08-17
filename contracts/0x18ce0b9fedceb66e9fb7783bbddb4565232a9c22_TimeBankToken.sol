pragma solidity ^0.4.11;


contract ERC20 {
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
}

contract TimeBankToken {

    struct tokenDeposit{
    uint256 timeToWithdraw;
    uint256 numTokens;
    }

    mapping (address =&gt; mapping(address =&gt; tokenDeposit)) tokenBalances;

    function getInfo(address _tokenAddress, address _holder) constant returns(uint, uint, uint){
        return(tokenBalances[_tokenAddress][_holder].timeToWithdraw,tokenBalances[_tokenAddress][_holder].numTokens, block.timestamp);
    }

    function depositTokens(ERC20 _token, uint256 _time, uint256 _amount) returns (bool){
        require(_amount &gt; 0 &amp;&amp; _time &gt; block.timestamp &amp;&amp; _time &lt; block.timestamp + 157680000);

        if (!(tokenBalances[_token][msg.sender].timeToWithdraw &gt; 0)) tokenBalances[_token][msg.sender].timeToWithdraw = _time;

        tokenBalances[_token][msg.sender].numTokens += _amount;

        require(_token.transferFrom(msg.sender, this, _amount));

        return true;
    }

    function withdrawTokens(ERC20 _token) returns (bool){

        uint tokens = tokenBalances[_token][msg.sender].numTokens;
        tokenBalances[_token][msg.sender].numTokens = 0;

        require(tokenBalances[_token][msg.sender].timeToWithdraw &lt; block.timestamp &amp;&amp; tokens &gt; 0);

        tokenBalances[_token][msg.sender].timeToWithdraw = 0;

        require(_token.transfer(msg.sender, tokens));

        return true;
    }
}