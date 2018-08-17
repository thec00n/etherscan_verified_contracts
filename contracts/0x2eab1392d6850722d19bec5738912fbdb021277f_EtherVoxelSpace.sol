pragma solidity ^0.4.0;

contract EtherVoxelSpace {
    
    struct Voxel {
        uint8 material;
        address owner;
    }
    
    event VoxelPlaced(address owner, uint8 x, uint8 y, uint8 z, uint8 material);
    event VoxelRepainted(uint8 x, uint8 y, uint8 z, uint8 newMaterial);
    event VoxelDestroyed(uint8 x, uint8 y, uint8 z);
    event VoxelTransferred(address to, uint8 x, uint8 y, uint8 z);
    
    address creator;
    uint constant PRICE = 1000000000000;
    Voxel[256][256][256] public world;
    
    function EtherVoxelSpace() public {
        creator = msg.sender;
    }
    
    function isAvailable(uint8 x, uint8 y, uint8 z) private view returns (bool) {
        if (x &lt; 256 &amp;&amp; y &lt; 256 &amp;&amp; z &lt; 256 &amp;&amp; world[x][y][z].owner == address(0)) {
            return true;
        } 
        return false;
    }
    
    function placeVoxel(uint8 x, uint8 y, uint8 z, uint8 material) payable public {
        require(isAvailable(x, y, z) &amp;&amp; msg.value &gt;= PRICE);
        world[x][y][z] = Voxel(material, msg.sender);
        VoxelPlaced(msg.sender, x, y, z, material);
    }
    
    function repaintVoxel(uint8 x, uint8 y, uint8 z, uint8 newMaterial) payable public {
        require(world[x][y][z].owner == msg.sender &amp;&amp; msg.value &gt;= PRICE);
        world[x][y][z].material = newMaterial;
        VoxelRepainted(x, y, z, newMaterial);
    }
    
    function destroyVoxel(uint8 x, uint8 y, uint8 z) payable public {
        require(world[x][y][z].owner == msg.sender &amp;&amp; msg.value &gt;= PRICE);
        world[x][y][z].owner = address(0);
        VoxelDestroyed(x, y, z);
    } 
    
    function transferVoxel(address to, uint8 x, uint8 y, uint8 z) payable public {
        require(world[x][y][z].owner == msg.sender &amp;&amp; msg.value &gt;= PRICE);
        world[x][y][z].owner = to;
        VoxelTransferred(to, x, y, z);
    }
    
    function withdraw() public {
        require(msg.sender == creator);
        creator.transfer(this.balance);
    }
}