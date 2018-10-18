pragma solidity ^0.4.7;
contract MobaBase {
    address public owner = 0x0;
    bool public isLock = false;
    constructor ()  public  {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner,"only owner can call this function");
        _;
    }
    
    modifier notLock {
        require(isLock == false,"contract current is lock status");
        _;
    }
    
    modifier msgSendFilter() {
        address addr = msg.sender;
        uint size;
        assembly { size := extcodesize(addr) }
        require(size <= 0,"address must is not contract");
        require(msg.sender == tx.origin, "msg.sender must equipt tx.origin");
        _;
    }
    
    function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
    
    function updateLock(bool b) onlyOwner public {
        
        require(isLock != b," updateLock new status == old status");
        isLock = b;
    }
}
contract BRPerSellData is MobaBase {
    
    struct PerSell {
      bool isOver;
      uint16 id;
      uint256 price;
    }
    
    constructor ()  public  {
        owner = msg.sender;
        addPerSell(0,0  finney,true);
        addPerSell(1,990 finney,false);
        addPerSell(2,90 finney,false);
        addPerSell(3,9 finney,false);
    }
    
    PerSell[]  mPerSellList;
    mapping (uint16 => uint16) public mIdToIndex;
 

    
    modifier noPerSellId(uint16 id) {
        uint16 index = mIdToIndex[id];
        if(index < mPerSellList.length ) {
            PerSell storage curPerSell = mPerSellList[index];
            require(curPerSell.id == 0,"current PerSell.Id isnot exist");
        }
        _;  
    }
    modifier hasPerSellId(uint16 id) {
        PerSell storage curPerSell = mPerSellList[mIdToIndex[id]];
        require(curPerSell.id > 0,"current PerSell.Id isnot exist");
        _;
    }
    
    function addPerSell(uint16 id,uint256 price,bool isOver) 
    onlyOwner 
    msgSendFilter 
    noPerSellId(id)
    public {
        mPerSellList.push( PerSell(isOver,id,price));
        uint16 index   = uint16(mPerSellList.length-1);
        mIdToIndex[id] = index;
        require(mPerSellList[index].id == id);
    }
    
    function updatePerSell(uint16 id,uint256 price,bool isOver) 
    onlyOwner 
    msgSendFilter 
    hasPerSellId(id)
    public {
         PerSell storage curPerSell = mPerSellList[mIdToIndex[id]];
         curPerSell.price  = price;
         curPerSell.isOver = isOver;
    }
    
    function PerSellOver(uint16[] array) 
    onlyOwner 
    msgSendFilter 
    public {
        for(uint16 i = 0 ; i < array.length;i++) {
            uint16 id = array[i];
            PerSell storage curPerSell = mPerSellList[mIdToIndex[id]];
            if(curPerSell.isOver == false) {
                curPerSell.isOver = true;
            }
        }
    } 
    
    function OverAllPerSell() 
    onlyOwner 
    msgSendFilter 
    public {
        for(uint16 i = 0 ; i < mPerSellList.length;i++) {
            PerSell storage curPerSell = mPerSellList[i];
            if(curPerSell.isOver == false) {
                curPerSell.isOver = true;
            }
        }
    }

    
    function GetPerSellInfo(uint16 id) public view returns (uint16,uint256 price,bool isOver) {
        
        PerSell storage curPerSell = mPerSellList[mIdToIndex[id]];
        return (curPerSell.id,curPerSell.price,curPerSell.isOver);
    }
    
}