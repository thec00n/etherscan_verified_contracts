pragma solidity ^0.4.16;

// copyright <span class="__cf_email__" data-cfemail="d2b1bdbca6b3b1a69297a6bab7a0b7bfbdbcfcb1bdbf">[email protected]</span>

contract SafeMath {

    /* function assert(bool assertion) internal { */
    /*   if (!assertion) { */
    /*     throw; */
    /*   } */
    /* }      // assert no longer needed once solidity is on 0.4.10 */

    function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {
      uint256 z = x + y;
      assert((z >= x) && (z >= y));
      return z;
    }

    function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {
      assert(x >= y);
      uint256 z = x - y;
      return z;
    }

    function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {
      uint256 z = x * y;
      assert((x == 0)||(z/x == y));
      return z;
    }

}

contract BasicAccessControl {
    address public owner;
    // address[] public moderators;
    uint16 public totalModerators = 0;
    mapping (address => bool) public moderators;
    bool public isMaintaining = true;

    function BasicAccessControl() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlyModerators() {
        require(moderators[msg.sender] == true);
        _;
    }

    modifier isActive {
        require(!isMaintaining);
        _;
    }

    function ChangeOwner(address _newOwner) onlyOwner public {
        if (_newOwner != address(0)) {
            owner = _newOwner;
        }
    }


    function AddModerator(address _newModerator) onlyOwner public {
        if (moderators[_newModerator] == false) {
            moderators[_newModerator] = true;
            totalModerators += 1;
        }
    }
    
    function RemoveModerator(address _oldModerator) onlyOwner public {
        if (moderators[_oldModerator] == true) {
            moderators[_oldModerator] = false;
            totalModerators -= 1;
        }
    }

    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
        isMaintaining = _isMaintaining;
    }
}

contract EtheremonEnum {

    enum ResultCode {
        SUCCESS,
        ERROR_CLASS_NOT_FOUND,
        ERROR_LOW_BALANCE,
        ERROR_SEND_FAIL,
        ERROR_NOT_TRAINER,
        ERROR_NOT_ENOUGH_MONEY,
        ERROR_INVALID_AMOUNT,
        ERROR_OBJ_NOT_FOUND,
        ERROR_OBJ_INVALID_OWNERSHIP
    }
    
    enum ArrayType {
        CLASS_TYPE,
        STAT_STEP,
        STAT_START,
        STAT_BASE,
        OBJ_SKILL
    }

    enum PropertyType {
        ANCESTOR,
        XFACTOR
    }
}

contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {
    
    uint64 public totalMonster;
    uint32 public totalClass;
    
    // read
    function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);
    function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);
    function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
    function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
    function getMonsterName(uint64 _objId) constant public returns(string name);
    function getExtraBalance(address _trainer) constant public returns(uint256);
    function getMonsterDexSize(address _trainer) constant public returns(uint);
    function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);
    function getExpectedBalance(address _trainer) constant public returns(uint256);
    function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);
}

contract EtheremonBattle is EtheremonEnum, BasicAccessControl, SafeMath {
    uint8 constant public NO_MONSTER = 3;
    uint8 constant public STAT_COUNT = 6;
    uint8 constant public GEN0_NO = 24;

    struct MonsterClassAcc {
        uint32 classId;
        uint256 price;
        uint256 returnPrice;
        uint32 total;
        bool catchable;
    }

    struct MonsterObjAcc {
        uint64 monsterId;
        uint32 classId;
        address trainer;
        string name;
        uint32 exp;
        uint32 createIndex;
        uint32 lastClaimIndex;
        uint createTime;
    } 
    
    uint8 public maxLevel = 100;
    
    // linked smart contract
    address public dataContract;
    
    // modifier
    modifier requireDataContract {
        require(dataContract != address(0));
        _;
    }

    function EtheremonBattle(address _dataContract) public {
        dataContract = _dataContract;
    }
     
    
    function setContract(address _dataContract) onlyModerators external {
        dataContract = _dataContract;
    }
    
    // public 
    
    function getLevel(uint32 exp) view public returns (uint8) {
        uint8 level = 1;
        uint32 requirement = maxLevel;
        while(level < maxLevel && exp > requirement) {
            exp -= requirement;
            level += 1;
            requirement = requirement * 11 / 10 + 5;
        }
        return level;
    }

    
    function getMonsterLevel(uint64 _objId) constant external returns(uint32, uint8) {
        EtheremonDataBase data = EtheremonDataBase(dataContract);
        MonsterObjAcc memory obj;
        uint32 _ = 0;
        (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
     
        return (obj.exp, getLevel(obj.exp));
    }
    
    function getMonsterCP(uint64 _objId) constant external returns(uint64) {
        uint16[6] memory stats;
        uint32 classId = 0;
        uint32 exp = 0;
        (classId, exp, stats) = getCurrentStats(_objId);
        
        uint256 total;
        for(uint i=0; i < STAT_COUNT; i+=1) {
            total += stats[i];
        }
        return uint64(total/STAT_COUNT);
    }

    function getObjExp(uint64 _objId) constant public returns(uint32, uint32) {
        EtheremonDataBase data = EtheremonDataBase(dataContract);
        MonsterObjAcc memory obj;
        uint32 _ = 0;
        (_objId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);
        return (obj.classId, obj.exp);
    }    
    
    function getCurrentStats(uint64 _objId) constant public returns(uint32, uint32, uint16[6]){
        EtheremonDataBase data = EtheremonDataBase(dataContract);
        uint16[6] memory stats;
        uint32 classId;
        uint32 exp;
        (classId, exp) = getObjExp(_objId);
        if (classId == 0)
            return (classId, exp, stats);
        
        uint i = 0;
        uint8 level = getLevel(exp);
        uint baseSize = data.getSizeArrayType(ArrayType.STAT_BASE, _objId);
        if (baseSize != STAT_COUNT) {
            for(i=0; i < STAT_COUNT; i+=1) {
                stats[i] += data.getElementInArrayType(ArrayType.STAT_START, uint64(classId), i);
                stats[i] += uint16(safeMult(data.getElementInArrayType(ArrayType.STAT_STEP, uint64(classId), i), level));
            }
        } else {
            for(i=0; i < STAT_COUNT; i+=1) {
                stats[i] += data.getElementInArrayType(ArrayType.STAT_BASE, _objId, i);
                stats[i] += uint16(safeMult(data.getElementInArrayType(ArrayType.STAT_STEP, uint64(classId), i), level));
            }
        }
        return (classId, exp, stats);
    }
 
}