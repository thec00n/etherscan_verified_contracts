/*
This Contract is free software: you can redistribute it and/or
modify it under the terms of the GNU lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This Contract is distributed WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU lesser General Public License for more details.
You should have received a copy of the GNU lesser General Public License
&lt;http://www.gnu.org/licenses/&gt;.
*/

pragma solidity ^0.4.18;

contract ERC20TokenCPN
{

///PARAMETRS///

    ///ERC20 PARAMETRS///
    
    string public constant name = &quot;STAR COUPON&quot;;
    string public constant symbol = &quot;CPN&quot;;
    uint8 public constant decimals = 0;
    
    ///*ERC20 PARAMETRS///

    address public regulator;
    uint8 public regulatorStatus; /* 0 - stop; 1 - start; 2 - constant regulator and constant status &#39;start&#39;; */
    uint internal amount;

    struct agent
    {
        uint balance;
        mapping (address =&gt; uint) allowed;
        uint8 permission; /* 0 - user; 1 - changeAgentPermission () / changeRegulator () / changeRegulatoryStatus (); 2 - changeRegulatoryStatus () &#39;2&#39;; 3 - destroy; */
    }
    mapping (address =&gt; agent) internal agents;

///*PARAMETRS///

///EVENTS///
    
    ///ERC20 EVENTS///

    event Transfer (address indexed _from, address indexed _to, uint _value);
    event Approval (address indexed _owner, address indexed _spender, uint _value);

    ///*ERC20 EVENTS///

    event Management (address indexed _called, uint8 _function, address indexed _dataA, uint8 dataB);
    event Mint (address indexed _called, address indexed _to, uint _value);
    event Burn (address indexed called, address indexed _to, uint _value);

///EVENTS///

///FUNCTIONS///

    function ERC20TokenCPN ()
    {
        agents[msg.sender].permission = 1;
        changeRegulator(msg.sender);
        changeRegulatorStatus(1);
        mint (msg.sender, 100000);
        changeRegulatorStatus(0);
    }

    function changeAgentPermission (address _agent, uint8 _permission) public returns (bool success)
    {
        if (regulatorStatus != 2)
        {
            if ((agents[msg.sender].permission == 1) &amp;&amp; (_permission &gt;= 0 &amp;&amp; _permission &lt;= 3) &amp;&amp; (msg.sender != _agent))
            {
                agents[_agent].permission = _permission;
                Management (msg.sender, 1, _agent, _permission);
                return true;
            }
        }
        return false;
    }
    
    function changeRegulator (address _regulator) public returns (bool success)
    {
        if (regulatorStatus != 2)
        {
            if (agents[msg.sender].permission == 1)
            {
                regulator = _regulator;
                Management (msg.sender, 2, _regulator, 0);
                return true;
            }
        }
        return false;
    }
    
    function changeRegulatorStatus (uint8 _status) public returns (bool success)
    {
        if (regulatorStatus != 2)
        {
            if (((agents[msg.sender].permission == 1) &amp;&amp; (_status == 0 || _status == 1)) || ((agents[msg.sender].permission == 2) &amp;&amp; (_status == 2)))
            {
                regulatorStatus = _status;
                Management (msg.sender, 3, regulator, _status);
                return true;
            }
        }
        return false;
    }
    
    function destroy (address _to) public
    {
        if ((agents[msg.sender].permission == 3) &amp;&amp; (regulatorStatus != 2))
        {
            selfdestruct(_to);
        }
    }
    
    function agentPermission (address _agent) public constant returns (uint8 permission)
    {
        return agents[_agent].permission;
    }

    function mint (address _to, uint _value) public returns (bool success)
    {
        if ((msg.sender == regulator) &amp;&amp; (regulatorStatus == 1 || regulatorStatus == 2) &amp;&amp; (amount + _value &gt; amount))
        {
            amount += _value;
            agents[msg.sender].balance += _value;
            transfer (_to, _value);
            Mint (msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    function burn (address _to, uint _value) public returns (bool success)
    {
        if ((msg.sender == regulator) &amp;&amp; (regulatorStatus == 1 || regulatorStatus == 2) &amp;&amp; (agents[_to].balance &gt;= _value))
        {
            Transfer (_to, msg.sender, _value);
            agents[_to].balance -= _value;
            amount -= _value;
            Burn (msg.sender, _to, _value);
            return true;
        }
        return false;
    }

    ///ERC20 FUNCTIONS///

    function totalSupply () public constant returns (uint)
    {
        return amount;
    }

    function balanceOf (address _owner) public constant returns (uint balance)
    {
        return agents[_owner].balance;
    }

    function transfer (address _to, uint _value) public returns (bool success)
    {
        if (agents[msg.sender].balance &gt;= _value &amp;&amp; agents[_to].balance + _value &gt;= agents[_to].balance)
        {
            agents[msg.sender].balance -= _value; 
            agents[_to].balance += _value;
            Transfer (msg.sender, _to, _value);
            return true;
        } 
        return false;
    }
    
    function transferFrom (address _from, address _to, uint _value) public returns (bool success)
    {
        if (agents[_from].allowed[msg.sender] &gt;= _value &amp;&amp; agents[_from].balance &gt;= _value &amp;&amp; agents[_to].balance + _value &gt;= agents[_to].balance)
        {
            agents[_from].allowed[msg.sender] -= _value;
            agents[_from].balance -= _value; 
            agents[_to].balance += _value;
            Transfer (_from, _to, _value);
            return true;
        } 
        return false;
    }

    function approve (address _spender, uint _value) public returns (bool success)
    {
        if (_value &gt; 0)
        {
            agents[msg.sender].allowed[_spender] = _value;
            Approval (msg.sender, _spender, _value);
            return true;
        }
        return false;
    }

    function allowance (address _owner, address _spender) public constant returns (uint remaining)
    {
        return agents[_owner].allowed[_spender];
    }

    ///*ERC20 FUNCTIONS///

///FUNCTIONS///

}