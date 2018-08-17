pragma solidity ^0.4.0;

contract LiterallyMinecraft {

  // total number of chunks
  uint constant global_width = 32;
  uint constant global_height = 32;
  uint constant global_length = global_width*global_height;

  // size of chunk in bytes32
  uint constant chunk_size = 32;

  // represents a 32x32 8-bit image with owner and stake meta data
  struct Chunk {
    bytes32[chunk_size] colors;

    address owner;
    uint value;
  }

  // chunk array in row major order
  Chunk[global_length] public screen;
  
  // block number of last update
  uint public lastUpdateOverall;

  // block number of last update for each individual block
  uint[global_length] public lastUpdateByChunk;

  // this forces abi to give us the whole array
  function getUpdateTimes() external view
    returns(uint[global_length])
  {
    return lastUpdateByChunk;
  }  

  // helper index conversion function
  function getIndex(uint8 x, uint8 y) public pure returns(uint) {
    return y*global_width+x;
  }

  // access chunk data by x y coordinates
  function getChunk(uint8 x, uint8 y) external view
    withinBounds(x,y)
    returns(bytes32[chunk_size], address, uint, uint)
  {
    uint index = getIndex(x,y);
    
    if (lastUpdateByChunk[index] == 0)     // initial default image is gaint cat
      return (getCatImage(x,y), 0x0, 0, 0);
    
    Chunk storage p = screen[index];
    return (p.colors, p.owner, p.value, lastUpdateByChunk[index]);
  }

  // modifier to check if point is in bounds
  modifier withinBounds(uint8 x, uint8 y) {
    require(x &gt;= 0 &amp;&amp; x &lt; global_width, &quot;x out of range&quot;);
    require(y &gt;= 0 &amp;&amp; y &lt; global_height, &quot;y out of range&quot;);
    _;
  }

  // modifier to check if msg value is sufficient to take control of a chunk
  modifier hasTheMoneys(uint8 x, uint8 y) {
    Chunk storage p = screen[getIndex(x,y)];
    require(msg.value &gt; p.value, &quot;insufficient funds&quot;);
    _;
  }

  // indicate the chunk has been updated
  function touch(uint8 x, uint8 y) internal {
    lastUpdateByChunk[getIndex(x,y)] = block.number;
    lastUpdateOverall = block.number;
  }

  // This function claims a chunk in the screen grid.
  // In order to claim it, the amount paid needs to
  // exceed the amount that was last paid on the chunk
  // (starting at 0). Previous updater is refunded the
  // ether they staked.
  function setColors(uint8 x, uint8 y, bytes32[chunk_size] clr) external payable
    withinBounds(x,y)
    hasTheMoneys(x,y)
  {
    Chunk storage p = screen[getIndex(x,y)];
    
    uint refund = p.value;
    address oldOwner = p.owner;
    
    p.value = msg.value;
    p.owner = msg.sender;
    p.colors = clr;
    
    touch(x,y);

    oldOwner.send(refund); // ignore if the send fails
  }

  // Generate a giant cat image
  function getCatImage(uint8 x, uint8 y) internal pure
    returns(bytes32[chunk_size])
  {
    bytes32[chunk_size] memory cat;
    cat[0] =  hex&quot;0000000000000000000000000000000000000000000000000000000000000000&quot;;
    cat[1] =  hex&quot;0000000000000000000000000000000000000000000000000000000000000000&quot;;
    cat[2] =  hex&quot;0000e3e300e0e0e0001c1c1c0000000000000000000000000000000000000000&quot;;
    cat[3] =  hex&quot;0000e30000e000e000001c000000000000fc000000fc0000000000f0f0f00000&quot;;
    cat[4] =  hex&quot;0000e30000e0e0e000001c000000000000fcfc00fcfc0000000000f000000000&quot;;
    cat[5] =  hex&quot;0000e3e300e000e000001c000000000000fcfcfcfcfc0000000000f000f00000&quot;;
    cat[6] =  hex&quot;00000000000000000000000000000000fcfcfcfcfcfcfc00000000f0f0f00000&quot;;
    cat[7] =  hex&quot;000000000000000000000000000000fcfcfcfcfcfcfcfcfc0000000000000000&quot;;
    cat[8] =  hex&quot;00000000000000000000000000001ffcfc0000fcfc0000fc000000fcfcfc0000&quot;;
    cat[9] =  hex&quot;00000000000000000000000000001ffcfcfcfcfcfcfcfcfc000000fc00fc0000&quot;;
    cat[10] = hex&quot;00000000000000ff000000001f1f1ffcfcfcfc0000fcfcfc000000fcfcfc0000&quot;;
    cat[11] = hex&quot;0000000000ffff00000000001f1f1f1ffcfc00fcfc00fc00000000fc00fc0000&quot;;
    cat[12] = hex&quot;00000000ff0000000000001f1ffcfc1f1ffcfcfcfcfc1f1f0000000000000000&quot;;
    cat[13] = hex&quot;000000ff00000000ff00000000fcfc1f1f1f1f1f1f1f1f1f00001f0000001f00&quot;;
    cat[14] = hex&quot;0000ff000000ffff00000000fcfc1f1f1f1f1f1f1f1f1f1f00001f1f001f1f00&quot;;
    cat[15] = hex&quot;0000ffff00ff00000000fcfcfc001f1f1ffc1f1f1f1f1f0000001f001f001f00&quot;;
    cat[16] = hex&quot;000000ffff000000ffff00000000001ffcfc1f1f1f1f1f0000001f0000001f00&quot;;
    cat[17] = hex&quot;00000000ffff00ff00000000ff000000fc1f1f1f1f1f1f0000001f0000001f00&quot;;
    cat[18] = hex&quot;0000000000ffff000000ffff0000fcfc001f1f1f1f1f00000000000000000000&quot;;
    cat[19] = hex&quot;000000000000ffff00ff00000000ff0000001f1f1f000000000000ffffff0000&quot;;
    cat[20] = hex&quot;00000000000000ffff000000ffff00000000001f1f000000000000ff00000000&quot;;
    cat[21] = hex&quot;0000000000000000ffff00ff00000000ff00000000000000000000ffff000000&quot;;
    cat[22] = hex&quot;000000000000000000ffff000000ffff0000000000000000000000ff00000000&quot;;
    cat[23] = hex&quot;00000000000000000000ffff00ff00000000ff0000000000000000ffffff0000&quot;;
    cat[24] = hex&quot;0000000000000000000000ffff000000ffff00000000ff000000000000000000&quot;;
    cat[25] = hex&quot;000000000000000000000000ffff00ff00000000ff0000ff0000000000000000&quot;;
    cat[26] = hex&quot;00000000000000000000000000ffff000000ffff0000ff000000000000000000&quot;;
    cat[27] = hex&quot;0000000000000000000000000000ffff00ff000000ff00000000000000000000&quot;;
    cat[28] = hex&quot;000000000000000000000000000000ffff0000ffff0000000000000000000000&quot;;
    cat[29] = hex&quot;00000000000000000000000000000000ffffff00000000000000000000000000&quot;;
    cat[30] = hex&quot;0000000000000000000000000000000000000000000000000000000000000000&quot;;
    cat[31] = hex&quot;0000000000000000000000000000000000000000000000000000000000000000&quot;;

    bytes32 pixel_row = cat[y][x];
      
    pixel_row |= (pixel_row &gt;&gt; 1*8);
    pixel_row |= (pixel_row &gt;&gt; 2*8);
    pixel_row |= (pixel_row &gt;&gt; 4*8);
    pixel_row |= (pixel_row &gt;&gt; 8*8);
    pixel_row |= (pixel_row &gt;&gt; 16*8);

    for (y = 0; y &lt; 32; ++y)
      cat[y] = pixel_row;

    return cat;

  }
}