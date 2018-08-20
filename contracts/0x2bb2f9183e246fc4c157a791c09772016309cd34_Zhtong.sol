contract Zhtong {
    address public owner;
      uint private result;
      function Set(){
          owner = msg.sender;
      }
      function assign(uint x, uint y) returns (uint){
          result = x + y;
      }
}