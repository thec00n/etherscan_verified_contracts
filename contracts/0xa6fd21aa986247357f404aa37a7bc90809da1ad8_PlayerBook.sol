pragma solidity ^0.4.24;

interface PlayerBookReceiverInterface {
    function receivePlayerInfo(uint256 _pID, address _addr, bytes32 _name, uint256 _laff) external;
    function receivePlayerNameList(uint256 _pID, bytes32 _name) external;
}

contract PlayerBook {
    using NameFilter for string;
    using SafeMath for uint256;
    
    address public ceo;
    address public cfo;
    
    uint256 public registrationFee_ = 10 finney;            // 0.01 ETH 注册一个帐号
    mapping(uint256 =&gt; PlayerBookReceiverInterface) public games_;  // mapping of our game interfaces for sending your account info to games
    mapping(address =&gt; bytes32) public gameNames_;          // lookup a games name
    mapping(address =&gt; uint256) public gameIDs_;            // lokup a games ID
    uint256 public gID_;        // total number of games
    uint256 public pID_;        // total number of players
    mapping (address =&gt; uint256) public pIDxAddr_;          // (addr =&gt; pID) returns player id by address
    mapping (bytes32 =&gt; uint256) public pIDxName_;          // (name =&gt; pID) returns player id by name
    mapping (uint256 =&gt; Player) public plyr_;               // (pID =&gt; data) player data
    mapping (uint256 =&gt; mapping (bytes32 =&gt; bool)) public plyrNames_; // (pID =&gt; name =&gt; bool) list of names a player owns.  (used so you can change your display name amoungst any name you own)
    mapping (uint256 =&gt; mapping (uint256 =&gt; bytes32)) public plyrNameList_; // (pID =&gt; nameNum =&gt; name) list of names a player owns
    struct Player {
        address addr;
        bytes32 name;
        uint256 laff;
        uint256 names;
    }

    constructor()
        public
    {
        ceo = msg.sender;
        cfo = msg.sender;
        pID_ = 0;
    }

    modifier isHuman() {
        address _addr = msg.sender;
        uint256 _codeLength;
        
        assembly {_codeLength := extcodesize(_addr)}
        require(_codeLength == 0, &quot;Not Human&quot;);
        _;
    }
    
    modifier isRegisteredGame()
    {
        require(gameIDs_[msg.sender] != 0);
        _;
    }

    event onNewName
    (
        uint256 indexed playerID,
        address indexed playerAddress,
        bytes32 indexed playerName,
        bool isNewPlayer,
        uint256 affiliateID,
        address affiliateAddress,
        bytes32 affiliateName,
        uint256 amountPaid,
        uint256 timeStamp
    );

    function checkIfNameValid(string _nameStr)
        public
        view
        returns(bool)
    {
        bytes32 _name = _nameStr.nameFilter();
        if (pIDxName_[_name] == 0)
            return (true);
        else 
            return (false);
    }

    function modCEOAddress(address newCEO) 
        isHuman() 
        public
    {
        require(address(0) != newCEO, &quot;CEO Can not be 0&quot;);
        require(ceo == msg.sender, &quot;only  ceo can modify ceo&quot;);
        ceo = newCEO;
    }

    function modCFOAddress(address newCFO) 
        isHuman() 
        public
    {
        require(address(0) != newCFO, &quot;CFO Can not be 0&quot;);
        require(cfo == msg.sender, &quot;only cfo can modify cfo&quot;);
        cfo = newCFO;
    } 

    function registerNameXID(string _nameString, uint256 _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        
        bytes32 _name = NameFilter.nameFilter(_nameString);
        address _addr = msg.sender;
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        if (_affCode != 0 &amp;&amp; _affCode != plyr_[_pID].laff &amp;&amp; _affCode != _pID) 
        {
            plyr_[_pID].laff = _affCode;
        } else if (_affCode == _pID) {
            _affCode = 0;
        }
        
        registerNameCore(_pID, _addr, _affCode, _name, _isNewPlayer, _all);
    }
    
    function registerNameXaddr(string _nameString, address _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        bytes32 _name = NameFilter.nameFilter(_nameString);
        address _addr = msg.sender;
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        uint256 _affID;
        if (_affCode != address(0) &amp;&amp; _affCode != _addr)
        {
            _affID = pIDxAddr_[_affCode];
            if (_affID != plyr_[_pID].laff)
            {
                plyr_[_pID].laff = _affID;
            }
        }

        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
    }
    
    function registerNameXname(string _nameString, bytes32 _affCode, bool _all)
        isHuman()
        public
        payable 
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        bytes32 _name = NameFilter.nameFilter(_nameString);
        address _addr = msg.sender;
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        uint256 _affID;
        if (_affCode != &quot;&quot; &amp;&amp; _affCode != _name)
        {
            _affID = pIDxName_[_affCode];
            if (_affID != plyr_[_pID].laff)
            {
                plyr_[_pID].laff = _affID;
            }
        } 
        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
    }
    
    function addMeToGame(uint256 _gameID)
        isHuman()
        public
    {
        require(_gameID &lt;= gID_, &quot;Game Not Exist&quot;);
        address _addr = msg.sender;
        uint256 _pID = pIDxAddr_[_addr];
        require(_pID != 0, &quot;Player Not Found&quot;);
        uint256 _totalNames = plyr_[_pID].names;
        
        games_[_gameID].receivePlayerInfo(_pID, _addr, plyr_[_pID].name, plyr_[_pID].laff);
        
        if (_totalNames &gt; 1)
            for (uint256 ii = 1; ii &lt;= _totalNames; ii++)
                games_[_gameID].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
    }

    function addMeToAllGames()
        isHuman()
        public
    {
        address _addr = msg.sender;
        uint256 _pID = pIDxAddr_[_addr];
        require(_pID != 0, &quot;Player Not Found&quot;);
        uint256 _laff = plyr_[_pID].laff;
        uint256 _totalNames = plyr_[_pID].names;
        bytes32 _name = plyr_[_pID].name;
        
        for (uint256 i = 1; i &lt;= gID_; i++)
        {
            games_[i].receivePlayerInfo(_pID, _addr, _name, _laff);
            if (_totalNames &gt; 1)
                for (uint256 ii = 1; ii &lt;= _totalNames; ii++)
                    games_[i].receivePlayerNameList(_pID, plyrNameList_[_pID][ii]);
        }
                
    }
    
    function useMyOldName(string _nameString)
        isHuman()
        public 
    {
        bytes32 _name = _nameString.nameFilter();
        uint256 _pID = pIDxAddr_[msg.sender];
        
        require(plyrNames_[_pID][_name] == true, &quot;umm... thats not a name you own&quot;);
        
        plyr_[_pID].name = _name;
    }
   
    function registerNameCore(uint256 _pID, address _addr, uint256 _affID, bytes32 _name, bool _isNewPlayer, bool _all)
        private
    {
        if (pIDxName_[_name] != 0)
            require(plyrNames_[_pID][_name] == true, &quot;Name Already Exist!&quot;);
        
        plyr_[_pID].name = _name;
        pIDxName_[_name] = _pID;
        if (plyrNames_[_pID][_name] == false)
        {
            plyrNames_[_pID][_name] = true;
            plyr_[_pID].names++;
            plyrNameList_[_pID][plyr_[_pID].names] = _name;
        }
        
        cfo.transfer(address(this).balance);
        
        if (_all == true)
            for (uint256 i = 1; i &lt;= gID_; i++)
                games_[i].receivePlayerInfo(_pID, _addr, _name, _affID);
        
        emit onNewName(_pID, _addr, _name, _isNewPlayer, _affID, plyr_[_affID].addr, plyr_[_affID].name, msg.value, now);
    }
  
    function determinePID(address _addr)
        private
        returns (bool)
    {
        if (pIDxAddr_[_addr] == 0)
        {
            pID_++;
            pIDxAddr_[_addr] = pID_;
            plyr_[pID_].addr = _addr;
            return (true);
        } else {
            return (false);
        }
    }

    function getPlayerID(address _addr)
        isRegisteredGame()
        external
        returns (uint256)
    {
        determinePID(_addr);
        return (pIDxAddr_[_addr]);
    }

    function getPlayerName(uint256 _pID)
        external
        view
        returns (bytes32)
    {
        return (plyr_[_pID].name);
    }

    function getPlayerLAff(uint256 _pID)
        external
        view
        returns (uint256)
    {
        return (plyr_[_pID].laff);
    }

    function getPlayerAddr(uint256 _pID)
        external
        view
        returns (address)
    {
        return (plyr_[_pID].addr);
    }

    function getNameFee()
        external
        view
        returns (uint256)
    {
        return(registrationFee_);
    }

    function registerNameXIDFromDapp(address _addr, bytes32 _name, uint256 _affCode, bool _all)
        isRegisteredGame()
        external
        payable
        returns(bool, uint256)
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        uint256 _affID = _affCode;
        if (_affID != 0 &amp;&amp; _affID != plyr_[_pID].laff &amp;&amp; _affID != _pID) 
        {
            plyr_[_pID].laff = _affID;
        } 
        else if (_affID == _pID) 
        {
            _affID = 0;
        }

        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
        
        return(_isNewPlayer, _affID);
    }
    function registerNameXaddrFromDapp(address _addr, bytes32 _name, address _affCode, bool _all)
        isRegisteredGame()
        external
        payable
        returns(bool, uint256)
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        uint256 _affID;
        if (_affCode != address(0) &amp;&amp; _affCode != _addr)
        {
            _affID = pIDxAddr_[_affCode];
            if (_affID != plyr_[_pID].laff)
            {
                plyr_[_pID].laff = _affID;
            }
        }
        
        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
        
        return(_isNewPlayer, _affID);
    }
    function registerNameXnameFromDapp(address _addr, bytes32 _name, bytes32 _affCode, bool _all)
        isRegisteredGame()
        external
        payable
        returns(bool, uint256)
    {
        require (msg.value &gt;= registrationFee_, &quot;umm.....  you have to pay the name fee&quot;);
        bool _isNewPlayer = determinePID(_addr);
        uint256 _pID = pIDxAddr_[_addr];
        
        uint256 _affID;
        if (_affCode != &quot;&quot; &amp;&amp; _affCode != _name)
        {
            _affID = pIDxName_[_affCode];
            if (_affID != plyr_[_pID].laff)
            {
                plyr_[_pID].laff = _affID;
            }
        }
        
        registerNameCore(_pID, _addr, _affID, _name, _isNewPlayer, _all);
        
        return(_isNewPlayer, _affID);
    }
    
    function addGame(address _gameAddress, string _gameNameStr)
        public
    {
        require(ceo == msg.sender, &quot;ONLY ceo CAN add game&quot;);
        require(gameIDs_[_gameAddress] == 0, &quot;Game Already Registered!&quot;);
        
        gID_++;
        bytes32 _name = _gameNameStr.nameFilter();
        gameIDs_[_gameAddress] = gID_;
        gameNames_[_gameAddress] = _name;
        games_[gID_] = PlayerBookReceiverInterface(_gameAddress);
    }
    
    function setRegistrationFee(uint256 _fee)
        public
    {
        require(ceo == msg.sender, &quot;ONLY ceo CAN add game&quot;);
        registrationFee_ = _fee;
    }
        
} 

library NameFilter {
    function nameFilter(string _input)
        internal
        pure
        returns(bytes32)
    {
        bytes memory _temp = bytes(_input);
        uint256 _length = _temp.length;
        
        require (_length &lt;= 32 &amp;&amp; _length &gt; 0, &quot;Invalid Length&quot;);
        require(_temp[0] != 0x20 &amp;&amp; _temp[_length-1] != 0x20, &quot;Can NOT start with SPACE&quot;);
        if (_temp[0] == 0x30)
        {
            require(_temp[1] != 0x78, &quot;CAN NOT Start With 0x&quot;);
            require(_temp[1] != 0x58, &quot;CAN NOT Start With 0X&quot;);
        }
        
        bool _hasNonNumber;
        
        for (uint256 i = 0; i &lt; _length; i++)
        {
            // 小写转大写
            if (_temp[i] &gt; 0x40 &amp;&amp; _temp[i] &lt; 0x5b)
            {
                _temp[i] = byte(uint(_temp[i]) + 32);
                if (_hasNonNumber == false)
                    _hasNonNumber = true;
            } else {
                require
                (
                    _temp[i] == 0x20 ||
                    (_temp[i] &gt; 0x60 &amp;&amp; _temp[i] &lt; 0x7b) ||
                    (_temp[i] &gt; 0x2f &amp;&amp; _temp[i] &lt; 0x3a),
                    &quot;Include Illegal characters&quot;
                );
                
                if (_temp[i] == 0x20)
                    require( _temp[i+1] != 0x20, &quot;ONLY One Space Allowed&quot;);
                
                if (_hasNonNumber == false &amp;&amp; (_temp[i] &lt; 0x30 || _temp[i] &gt; 0x39))
                    _hasNonNumber = true;    
            }
        }
        
        require(_hasNonNumber == true, &quot;All Numbers Not Allowed&quot;);
        
        bytes32 _ret;
        assembly {
            _ret := mload(add(_temp, 32))
        }
        return (_ret);
    }
}

library SafeMath {
    function add(uint256 a, uint256 b)
        internal
        pure
        returns (uint256 c) 
    {
        c = a + b;
        require(c &gt;= a, &quot;Add Failed&quot;);
        return c;
    }
}