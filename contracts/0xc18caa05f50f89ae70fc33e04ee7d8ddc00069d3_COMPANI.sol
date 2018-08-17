pragma solidity ^0.4.4;

contract Token {

    function totalSupply() constant returns (uint256 supply) {}

    function balanceOf(address _owner) constant returns (uint256 balance) {}

    function transfer(address _to, uint256 _value) returns (bool success) {}

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}

    function approve(address _spender, uint256 _value) returns (bool success) {}


    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}



contract StandardToken is Token {

    function transfer(address _to, uint256 _value) returns (bool success) {
        
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
      
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address =&gt; uint256) balances;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;
    uint256 public totalSupply;
}



contract COMPANI is StandardToken {

    function () {
       
        throw;
    }

    string public name;                   
    uint8 public decimals;               
    string public symbol;                 
    string public version = &#39;H1.0&#39;;       
 /* สมาร์ทคอนแทร็ก โดยบริษัท คัมปานี จำกัด, กรุงเทพฯ, ประเทศไทย เพื่อใช้ผลิตเหรียญสินค้าสกุลดิจิตอลชื่อ
 ทีเอชบีซี โดยใช้เพื่อกิจการทางธุรกิจและเศรษฐสังคมทั่วไปทั้งในและต่างประเทศ อนึ่งไม่ใช่เพื่อการแลกเปลี่ยนเงิน
 ตราหรือกิจกรรมอื่นใดที่อาจขัดแย้งกับพรบ.การเงิน และขอสงวนสิทธิ์ในการรับผิดจากการที่บุคคลนำไปใช้โดยผิดวัตถุประสงค์
 ทุกกรณี */
    function COMPANI(
        ) {
        balances[msg.sender] = 161803398875;               
        totalSupply = 161803398875;                        
        name = &quot;Compani Ltd., (http://compani.org) - Common Token&quot;;                                   
        decimals = 2;                            
        symbol = &quot;THBC&quot;;                               
    }

    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        if(!_spender.call(bytes4(bytes32(sha3(&quot;receiveApproval(address,uint256,address,bytes)&quot;))), msg.sender, _value, this, _extraData)) { throw; }
        return true;
    }
}