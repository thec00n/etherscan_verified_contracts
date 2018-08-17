contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}

contract FreezerAuthority is DSAuthority {
    address[] internal c_freezers;
    // sha3(&quot;setFreezing(address,uint256,uint256,uint8)&quot;).slice(0,10)
    bytes4 constant setFreezingSig = bytes4(0x51c3b8a6);
    // sha3(&quot;transferAndFreezing(address,uint256,uint256,uint256,uint8)&quot;).slice(0,10)
    bytes4 constant transferAndFreezingSig = bytes4(0xb8a1fdb6);

    function canCall(address caller, address, bytes4 sig) public view returns (bool) {
        // freezer can call setFreezing, transferAndFreezing
        if (isFreezer(caller) &amp;&amp; sig == setFreezingSig || sig == transferAndFreezingSig) {
            return true;
        } else {
            return false;
        }
    }

    function addFreezer(address freezer) public {
        int i = indexOf(c_freezers, freezer);
        if (i &lt; 0) {
            c_freezers.push(freezer);
        }
    }

    function removeFreezer(address freezer) public {
        int index = indexOf(c_freezers, freezer);
        if (index &gt;= 0) {
            uint i = uint(index);
            while (i &lt; c_freezers.length - 1) {
                c_freezers[i] = c_freezers[i + 1];
            }
            c_freezers.length--;
        }
    }

    /** Finds the index of a given value in an array. */
    function indexOf(address[] values, address value) internal pure returns (int) {
        uint i = 0;
        while (i &lt; values.length) {
            if (values[i] == value) {
                return int(i);
            }
            i++;
        }
        return int(- 1);
    }

    function isFreezer(address addr) public constant returns (bool) {
        return indexOf(c_freezers, addr) &gt;= 0;
    }
}