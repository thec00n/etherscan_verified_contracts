pragma solidity ^ 0.4 .11;

/*
 * @title String & slice utility library for Solidity contracts.
 * @author Nick Johnson <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="48293a292b2026212c0826273c2c273c66262d3c">[email protected]</a>>
 *
 * @dev Functionality in this library is largely implemented using an
 *      abstraction called a 'slice'. A slice represents a part of a string -
 *      anything from the entire string to a single character, or even no
 *      characters at all (a 0-length slice). Since a slice only has to specify
 *      an offset and a length, copying and manipulating slices is a lot less
 *      expensive than copying and manipulating the strings they reference.
 *
 *      To further reduce gas costs, most functions on slice that need to return
 *      a slice modify the original one instead of allocating a new one; for
 *      instance, `s.split(".")` will return the text up to the first '.',
 *      modifying s to only contain the remainder of the string after the '.'.
 *      In situations where you do not want to modify the original slice, you
 *      can make a copy first with `.copy()`, for example:
 *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
 *      Solidity has no memory management, it will result in allocating many
 *      short-lived slices that are later discarded.
 *
 *      Functions that return two slices come in two versions: a non-allocating
 *      version that takes the second slice as an argument, modifying it in
 *      place, and an allocating version that allocates and returns the second
 *      slice; see `nextRune` for example.
 *
 *      Functions that have to copy string data will return strings rather than
 *      slices; these can be cast back to slices for further processing if
 *      required.
 *
 *      For convenience, some functions are provided with non-modifying
 *      variants that create a new slice and return both; for instance,
 *      `s.splitNew('.')` leaves s unmodified, and returns two values
 *      corresponding to the left and right parts of the string.
 */
library strings {
    struct slice {
        uint _len;
        uint _ptr;
    }

    function memcpy(uint dest, uint src, uint len) private {
        // Copy word-length chunks while possible
        for(; len >= 32; len -= 32) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += 32;
            src += 32;
        }

        // Copy remaining bytes
        uint mask = 256 ** (32 - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }

    /*
     * @dev Returns a slice containing the entire string.
     * @param self The string to make a slice from.
     * @return A newly allocated slice containing the entire string.
     */
    function toSlice(string self) internal returns (slice) {
        uint ptr;
        assembly {
            ptr := add(self, 0x20)
        }
        return slice(bytes(self).length, ptr);
    }

    /*
     * @dev Returns the length of a null-terminated bytes32 string.
     * @param self The value to find the length of.
     * @return The length of the string, from 0 to 32.
     */
    function len(bytes32 self) internal returns (uint) {
        uint ret;
        if (self == 0)
            return 0;
        if (self & 0xffffffffffffffffffffffffffffffff == 0) {
            ret += 16;
            self = bytes32(uint(self) / 0x100000000000000000000000000000000);
        }
        if (self & 0xffffffffffffffff == 0) {
            ret += 8;
            self = bytes32(uint(self) / 0x10000000000000000);
        }
        if (self & 0xffffffff == 0) {
            ret += 4;
            self = bytes32(uint(self) / 0x100000000);
        }
        if (self & 0xffff == 0) {
            ret += 2;
            self = bytes32(uint(self) / 0x10000);
        }
        if (self & 0xff == 0) {
            ret += 1;
        }
        return 32 - ret;
    }

    /*
     * @dev Returns a slice containing the entire bytes32, interpreted as a
     *      null-termintaed utf-8 string.
     * @param self The bytes32 value to convert to a slice.
     * @return A new slice containing the value of the input argument up to the
     *         first null.
     */
    function toSliceB32(bytes32 self) internal returns (slice ret) {
        // Allocate space for `self` in memory, copy it there, and point ret at it
        assembly {
            let ptr := mload(0x40)
            mstore(0x40, add(ptr, 0x20))
            mstore(ptr, self)
            mstore(add(ret, 0x20), ptr)
        }
        ret._len = len(self);
    }

    /*
     * @dev Returns a new slice containing the same data as the current slice.
     * @param self The slice to copy.
     * @return A new slice containing the same data as `self`.
     */
    function copy(slice self) internal returns (slice) {
        return slice(self._len, self._ptr);
    }

    /*
     * @dev Copies a slice to a new string.
     * @param self The slice to copy.
     * @return A newly allocated string containing the slice's text.
     */
    function toString(slice self) internal returns (string) {
        var ret = new string(self._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        memcpy(retptr, self._ptr, self._len);
        return ret;
    }

    /*
     * @dev Returns the length in runes of the slice. Note that this operation
     *      takes time proportional to the length of the slice; avoid using it
     *      in loops, and call `slice.empty()` if you only need to know whether
     *      the slice is empty or not.
     * @param self The slice to operate on.
     * @return The length of the slice in runes.
     */
    function len(slice self) internal returns (uint) {
        // Starting at ptr-31 means the LSB will be the byte we care about
        var ptr = self._ptr - 31;
        var end = ptr + self._len;
        for (uint len = 0; ptr < end; len++) {
            uint8 b;
            assembly { b := and(mload(ptr), 0xFF) }
            if (b < 0x80) {
                ptr += 1;
            } else if(b < 0xE0) {
                ptr += 2;
            } else if(b < 0xF0) {
                ptr += 3;
            } else if(b < 0xF8) {
                ptr += 4;
            } else if(b < 0xFC) {
                ptr += 5;
            } else {
                ptr += 6;
            }
        }
        return len;
    }

    /*
     * @dev Returns true if the slice is empty (has a length of 0).
     * @param self The slice to operate on.
     * @return True if the slice is empty, False otherwise.
     */
    function empty(slice self) internal returns (bool) {
        return self._len == 0;
    }

    /*
     * @dev Returns a positive number if `other` comes lexicographically after
     *      `self`, a negative number if it comes before, or zero if the
     *      contents of the two slices are equal. Comparison is done per-rune,
     *      on unicode codepoints.
     * @param self The first slice to compare.
     * @param other The second slice to compare.
     * @return The result of the comparison.
     */
    function compare(slice self, slice other) internal returns (int) {
        uint shortest = self._len;
        if (other._len < self._len)
            shortest = other._len;

        var selfptr = self._ptr;
        var otherptr = other._ptr;
        for (uint idx = 0; idx < shortest; idx += 32) {
            uint a;
            uint b;
            assembly {
                a := mload(selfptr)
                b := mload(otherptr)
            }
            if (a != b) {
                // Mask out irrelevant bytes and check again
                uint mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
                var diff = (a & mask) - (b & mask);
                if (diff != 0)
                    return int(diff);
            }
            selfptr += 32;
            otherptr += 32;
        }
        return int(self._len) - int(other._len);
    }

    /*
     * @dev Returns true if the two slices contain the same text.
     * @param self The first slice to compare.
     * @param self The second slice to compare.
     * @return True if the slices are equal, false otherwise.
     */
    function equals(slice self, slice other) internal returns (bool) {
        return compare(self, other) == 0;
    }

    /*
     * @dev Extracts the first rune in the slice into `rune`, advancing the
     *      slice to point to the next rune and returning `self`.
     * @param self The slice to operate on.
     * @param rune The slice that will contain the first rune.
     * @return `rune`.
     */
    function nextRune(slice self, slice rune) internal returns (slice) {
        rune._ptr = self._ptr;

        if (self._len == 0) {
            rune._len = 0;
            return rune;
        }

        uint len;
        uint b;
        // Load the first byte of the rune into the LSBs of b
        assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
        if (b < 0x80) {
            len = 1;
        } else if(b < 0xE0) {
            len = 2;
        } else if(b < 0xF0) {
            len = 3;
        } else {
            len = 4;
        }

        // Check for truncated codepoints
        if (len > self._len) {
            rune._len = self._len;
            self._ptr += self._len;
            self._len = 0;
            return rune;
        }

        self._ptr += len;
        self._len -= len;
        rune._len = len;
        return rune;
    }

    /*
     * @dev Returns the first rune in the slice, advancing the slice to point
     *      to the next rune.
     * @param self The slice to operate on.
     * @return A slice containing only the first rune from `self`.
     */
    function nextRune(slice self) internal returns (slice ret) {
        nextRune(self, ret);
    }

    /*
     * @dev Returns the number of the first codepoint in the slice.
     * @param self The slice to operate on.
     * @return The number of the first codepoint in the slice.
     */
    function ord(slice self) internal returns (uint ret) {
        if (self._len == 0) {
            return 0;
        }

        uint word;
        uint len;
        uint div = 2 ** 248;

        // Load the rune into the MSBs of b
        assembly { word:= mload(mload(add(self, 32))) }
        var b = word / div;
        if (b < 0x80) {
            ret = b;
            len = 1;
        } else if(b < 0xE0) {
            ret = b & 0x1F;
            len = 2;
        } else if(b < 0xF0) {
            ret = b & 0x0F;
            len = 3;
        } else {
            ret = b & 0x07;
            len = 4;
        }

        // Check for truncated codepoints
        if (len > self._len) {
            return 0;
        }

        for (uint i = 1; i < len; i++) {
            div = div / 256;
            b = (word / div) & 0xFF;
            if (b & 0xC0 != 0x80) {
                // Invalid UTF-8 sequence
                return 0;
            }
            ret = (ret * 64) | (b & 0x3F);
        }

        return ret;
    }

    /*
     * @dev Returns the keccak-256 hash of the slice.
     * @param self The slice to hash.
     * @return The hash of the slice.
     */
    function keccak(slice self) internal returns (bytes32 ret) {
        assembly {
            ret := sha3(mload(add(self, 32)), mload(self))
        }
    }

    /*
     * @dev Returns true if `self` starts with `needle`.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return True if the slice starts with the provided text, false otherwise.
     */
    function startsWith(slice self, slice needle) internal returns (bool) {
        if (self._len < needle._len) {
            return false;
        }

        if (self._ptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let len := mload(needle)
            let selfptr := mload(add(self, 0x20))
            let needleptr := mload(add(needle, 0x20))
            equal := eq(sha3(selfptr, len), sha3(needleptr, len))
        }
        return equal;
    }

    /*
     * @dev If `self` starts with `needle`, `needle` is removed from the
     *      beginning of `self`. Otherwise, `self` is unmodified.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return `self`
     */
    function beyond(slice self, slice needle) internal returns (slice) {
        if (self._len < needle._len) {
            return self;
        }

        bool equal = true;
        if (self._ptr != needle._ptr) {
            assembly {
                let len := mload(needle)
                let selfptr := mload(add(self, 0x20))
                let needleptr := mload(add(needle, 0x20))
                equal := eq(sha3(selfptr, len), sha3(needleptr, len))
            }
        }

        if (equal) {
            self._len -= needle._len;
            self._ptr += needle._len;
        }

        return self;
    }

    /*
     * @dev Returns true if the slice ends with `needle`.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return True if the slice starts with the provided text, false otherwise.
     */
    function endsWith(slice self, slice needle) internal returns (bool) {
        if (self._len < needle._len) {
            return false;
        }

        var selfptr = self._ptr + self._len - needle._len;

        if (selfptr == needle._ptr) {
            return true;
        }

        bool equal;
        assembly {
            let len := mload(needle)
            let needleptr := mload(add(needle, 0x20))
            equal := eq(sha3(selfptr, len), sha3(needleptr, len))
        }

        return equal;
    }

    /*
     * @dev If `self` ends with `needle`, `needle` is removed from the
     *      end of `self`. Otherwise, `self` is unmodified.
     * @param self The slice to operate on.
     * @param needle The slice to search for.
     * @return `self`
     */
    function until(slice self, slice needle) internal returns (slice) {
        if (self._len < needle._len) {
            return self;
        }

        var selfptr = self._ptr + self._len - needle._len;
        bool equal = true;
        if (selfptr != needle._ptr) {
            assembly {
                let len := mload(needle)
                let needleptr := mload(add(needle, 0x20))
                equal := eq(sha3(selfptr, len), sha3(needleptr, len))
            }
        }

        if (equal) {
            self._len -= needle._len;
        }

        return self;
    }

    // Returns the memory address of the first byte of the first occurrence of
    // `needle` in `self`, or the first byte after `self` if not found.
    function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
        uint ptr;
        uint idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                // Optimized assembly for 68 gas per byte on short strings
                assembly {
                    let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
                    let needledata := and(mload(needleptr), mask)
                    let end := add(selfptr, sub(selflen, needlelen))
                    ptr := selfptr
                    loop:
                    jumpi(exit, eq(and(mload(ptr), mask), needledata))
                    ptr := add(ptr, 1)
                    jumpi(loop, lt(sub(ptr, 1), end))
                    ptr := add(selfptr, selflen)
                    exit:
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := sha3(needleptr, needlelen) }
                ptr = selfptr;
                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly { testHash := sha3(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }

    // Returns the memory address of the first byte after the last occurrence of
    // `needle` in `self`, or the address of `self` if not found.
    function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private returns (uint) {
        uint ptr;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                // Optimized assembly for 69 gas per byte on short strings
                assembly {
                    let mask := not(sub(exp(2, mul(8, sub(32, needlelen))), 1))
                    let needledata := and(mload(needleptr), mask)
                    ptr := add(selfptr, sub(selflen, needlelen))
                    loop:
                    jumpi(ret, eq(and(mload(ptr), mask), needledata))
                    ptr := sub(ptr, 1)
                    jumpi(loop, gt(add(ptr, 1), selfptr))
                    ptr := selfptr
                    jump(exit)
                    ret:
                    ptr := add(ptr, needlelen)
                    exit:
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := sha3(needleptr, needlelen) }
                ptr = selfptr + (selflen - needlelen);
                while (ptr >= selfptr) {
                    bytes32 testHash;
                    assembly { testHash := sha3(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr + needlelen;
                    ptr -= 1;
                }
            }
        }
        return selfptr;
    }

    /*
     * @dev Modifies `self` to contain everything from the first occurrence of
     *      `needle` to the end of the slice. `self` is set to the empty slice
     *      if `needle` is not found.
     * @param self The slice to search and modify.
     * @param needle The text to search for.
     * @return `self`.
     */
    function find(slice self, slice needle) internal returns (slice) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
        self._len -= ptr - self._ptr;
        self._ptr = ptr;
        return self;
    }

    /*
     * @dev Modifies `self` to contain the part of the string from the start of
     *      `self` to the end of the first occurrence of `needle`. If `needle`
     *      is not found, `self` is set to the empty slice.
     * @param self The slice to search and modify.
     * @param needle The text to search for.
     * @return `self`.
     */
    function rfind(slice self, slice needle) internal returns (slice) {
        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
        self._len = ptr - self._ptr;
        return self;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and `token` to everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and `token` is set to the entirety of `self`.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @param token An output parameter to which the first token is written.
     * @return `token`.
     */
    function split(slice self, slice needle, slice token) internal returns (slice) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = self._ptr;
        token._len = ptr - self._ptr;
        if (ptr == self._ptr + self._len) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
            self._ptr = ptr + needle._len;
        }
        return token;
    }

    /*
     * @dev Splits the slice, setting `self` to everything after the first
     *      occurrence of `needle`, and returning everything before it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and the entirety of `self` is returned.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @return The part of `self` up to the first occurrence of `delim`.
     */
    function split(slice self, slice needle) internal returns (slice token) {
        split(self, needle, token);
    }

    /*
     * @dev Splits the slice, setting `self` to everything before the last
     *      occurrence of `needle`, and `token` to everything after it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and `token` is set to the entirety of `self`.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @param token An output parameter to which the first token is written.
     * @return `token`.
     */
    function rsplit(slice self, slice needle, slice token) internal returns (slice) {
        uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
        token._ptr = ptr;
        token._len = self._len - (ptr - self._ptr);
        if (ptr == self._ptr) {
            // Not found
            self._len = 0;
        } else {
            self._len -= token._len + needle._len;
        }
        return token;
    }

    /*
     * @dev Splits the slice, setting `self` to everything before the last
     *      occurrence of `needle`, and returning everything after it. If
     *      `needle` does not occur in `self`, `self` is set to the empty slice,
     *      and the entirety of `self` is returned.
     * @param self The slice to split.
     * @param needle The text to search for in `self`.
     * @return The part of `self` after the last occurrence of `delim`.
     */
    function rsplit(slice self, slice needle) internal returns (slice token) {
        rsplit(self, needle, token);
    }

    /*
     * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
     * @param self The slice to search.
     * @param needle The text to search for in `self`.
     * @return The number of occurrences of `needle` found in `self`.
     */
    function count(slice self, slice needle) internal returns (uint count) {
        uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
        while (ptr <= self._ptr + self._len) {
            count++;
            ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
        }
    }

    /*
     * @dev Returns True if `self` contains `needle`.
     * @param self The slice to search.
     * @param needle The text to search for in `self`.
     * @return True if `needle` is found in `self`, false otherwise.
     */
    function contains(slice self, slice needle) internal returns (bool) {
        return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
    }

    /*
     * @dev Returns a newly allocated string containing the concatenation of
     *      `self` and `other`.
     * @param self The first slice to concatenate.
     * @param other The second slice to concatenate.
     * @return The concatenation of the two strings.
     */
    function concat(slice self, slice other) internal returns (string) {
        var ret = new string(self._len + other._len);
        uint retptr;
        assembly { retptr := add(ret, 32) }
        memcpy(retptr, self._ptr, self._len);
        memcpy(retptr + self._len, other._ptr, other._len);
        return ret;
    }

    /*
     * @dev Joins an array of slices, using `self` as a delimiter, returning a
     *      newly allocated string.
     * @param self The delimiter to use.
     * @param parts A list of slices to join.
     * @return A newly allocated string containing all the slices in `parts`,
     *         joined with `self`.
     */
    function join(slice self, slice[] parts) internal returns (string) {
        if (parts.length == 0)
            return "";

        uint len = self._len * (parts.length - 1);
        for(uint i = 0; i < parts.length; i++)
            len += parts[i]._len;

        var ret = new string(len);
        uint retptr;
        assembly { retptr := add(ret, 32) }

        for(i = 0; i < parts.length; i++) {
            memcpy(retptr, parts[i]._ptr, parts[i]._len);
            retptr += parts[i]._len;
            if (i < parts.length - 1) {
                memcpy(retptr, self._ptr, self._len);
                retptr += self._len;
            }
        }

        return ret;
    }
}
contract Contract {function pegHandler( address _from, uint256 _value );}


contract Manager {
    
    
    address owner;
    address  manager;
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyManagement {
        require( msg.sender == owner || msg.sender == manager );
        _;
    }
    
    
    
    
    
    
}

contract Token {

    function balanceOf(address tokenHolder) constant returns(uint256)  {}
    function totalSupply() constant returns(uint256) {}
    function getAccountCount() constant returns(uint256) {}
    function getAddress(uint slot) constant returns(address) {}
    
}

 
 

contract tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
}


library StringUtils {
    /// @dev Does a byte-by-byte lexicographical comparison of two strings.
    /// @return a negative number if `_a` is smaller, zero if they are equal
    /// and a positive numbe if `_b` is smaller.
    function compare(string _a, string _b) returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    /// @dev Compares two strings and returns true iff they are equal.
    function equal(string _a, string _b) returns (bool) {
        return compare(_a, _b) == 0;
    }
    /// @dev Finds the index of the first occurrence of _needle in _haystack
    function indexOf(string _haystack, string _needle) returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
            return -1;
        else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
            return -1;                                  
        else
        {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++)
            {
                if (h[i] == n[0]) // found the first char of b
                {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
                    {
                        subindex++;
                    }   
                    if(subindex == n.length)
                        return int(i);
                }
            }
            return -1;
        }   
    }
}

contract ERC20 {

   function totalSupply() constant returns(uint totalSupply);

    function balanceOf(address who) constant returns(uint256);

    function transfer(address to, uint value) returns(bool ok);

    function transferFrom(address from, address to, uint value) returns(bool ok);

    function approve(address spender, uint value) returns(bool ok);

    function allowance(address owner, address spender) constant returns(uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

}

contract SubToken { 
    function SubTokenCreate ( uint256 _initialSupply, uint8 decimalUnits, string  _name, string   _symbol, address _tokenowner )returns (address){} 
    function transfer ( address _address , uint256 amount ){}
    function share()returns(uint256){}
    function totalSupply()returns(uint256){}
    function initialSupply()returns(uint256){}
}

contract Cents is ERC20 {

    using strings for *;
    
    /* Public variables of the token */
    string public standard = 'Token 1.0';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public initialSupply;

    address public _owner;
    address public owner;
  
    address public manager;

    address public Centspooladdress;
   
    

    
    


    /* This creates an array with all balances */
    mapping( address => uint256) public balanceOf;
    mapping( uint => address) public accountIndex;
    mapping( address =>bool ) public accountFreeze;
    uint accountCount;
    
  
    
   
    mapping(address => mapping(address => uint256)) public allowance;

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event FrozenFunds ( address target, bool frozen );
    
    event TTLAccounts ( uint accounts );
    event TTLSupply ( uint supply ) ;

    /* This notifies clients about the amount burnt */
    event Burn(address indexed from, uint256 value);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function Cents() {

 

    uint256 _initialSupply = 100000000 ; // THIS HERE MAY NEED TO BE ADJUSTED..
            // MYETHERWALLET AND MIST BOTH SHOW DIFERENT QUANTITIES BECAUSE OF THE DECIMAL
            // INFORMATION
        uint8 decimalUnits = 0;
        appendTokenHolders(msg.sender);
        balanceOf[msg.sender] = _initialSupply; // Give the creator all initial tokens
        totalSupply = _initialSupply; // Update total supply
        initialSupply = _initialSupply;
        name = "Cents"; // Set the name for display purposes
        symbol = "Cents"; // Set the symbol for display purposes
        decimals = decimalUnits; // Amount of decimals for display purposes
       
        owner   = msg.sender;
        
    }

    function setCentsPoolAddress( address _Centspooladdress ) {

        Centspooladdress = _Centspooladdress;

    }
    
    function distributionSync( address _tokenholder , bool slowsync ) private {
        
        CentsPool Centspool = CentsPool (  Centspooladdress ); 

        Centspool.syncsync ( _tokenholder, false );
    

    }
    
    function setZeroMarker( address _tokenholder  ) private {
        
        if (balanceOf[ _tokenholder ]  >0 ) return;
        CentsPool Centspool = CentsPool (  Centspooladdress ); 
        Centspool.setZeroMarker ( _tokenholder );
    
    }
    
    
    // Function allows for external access to tokenHoler's Balance
    function balanceOf(address tokenHolder) constant returns(uint256) {

        return balanceOf[tokenHolder];
    }

    function totalSupply() constant returns(uint256) {

        return totalSupply;
    }

    // Function allows for external access to number of accounts that are holding or once held Studio
    //tokens

    function getAccountCount() constant returns(uint256) {

        return accountCount;
    }

    //function allows for external access to tokenHolders
    function getAddress(uint slot) constant returns(address) {

        return accountIndex[slot];

    }

    // checks to see if tokenholder has a balance, if not it appends the tokenholder to the accountIndex
   // which the getAddress() can later access externally

    function appendTokenHolders(address tokenHolder) private {

        if (balanceOf[tokenHolder] == 0) {
            accountIndex[accountCount] = tokenHolder;
            accountCount++;
        }

    }

    /* Send coins */
    function transfer(address _to, uint256 _value) returns(bool ok) {
        if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough

        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if ( accountFreeze[ msg.sender ]  ) throw;
        
       
        
        appendTokenHolders(_to);
        setZeroMarker( _to );
        distributionSync( _to , false );
        distributionSync( msg.sender , false );
        //setZeroMarker( msg.sender );
       
        balanceOf[msg.sender] -= _value; // Subtract from the sender
        balanceOf[_to] += _value; // Add the same to the recipient
        
        
        Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
        //contractCheck( _to , _value );
        return true;
    }
    
    

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value)
    returns(bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval( msg.sender ,_spender, _value);
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
    returns(bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
        return allowance[_owner][_spender];
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
        if (_to == 0x0) throw; // Prevent transfer to 0x0 address. Use burn() instead
        if (balanceOf[_from] < _value) throw; // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw; // Check allowance
        if ( accountFreeze[ _from ]  ) throw;
        
        
        
        appendTokenHolders(_to);
        setZeroMarker( _to );
        setZeroMarker( _from );
        distributionSync( _to , false );
        distributionSync(_from , false );
       
        balanceOf[_from] -= _value; // Subtract from the sender
        balanceOf[_to] += _value; // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
       
        Transfer(_from, _to, _value);
       // contractCheck( _to , _value );
        return true;
    }
  
    function burn(uint256 _value) returns(bool success) {
        if (balanceOf[msg.sender] < _value) throw; // Check if the sender has enough
        if ( (totalSupply - _value) <  ( initialSupply / 2 ) ) throw;
        balanceOf[msg.sender] -= _value; // Subtract from the sender
        totalSupply -= _value; // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    function burnFrom(address _from, uint256 _value) returns(bool success) {
    
        if (balanceOf[_from] < _value) throw; // Check if the sender has enough
        if (_value > allowance[_from][msg.sender]) throw; // Check allowance
        if ( (totalSupply - _value) <  ( initialSupply / 2 )) throw;
        balanceOf[_from] -= _value; // Subtract from the sender
        totalSupply -= _value; // Updates totalSupply
        Burn(_from, _value);
        return true;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
   

    function transferOwnership(address newOwner) public onlyOwner {

        owner = newOwner;
    }
    
   
    
    function assignManagement (address _manager) public onlyOwner {

        manager = _manager;
    }
    
    function freezeAccount ( address _account ) public onlyOwner{
        
        accountFreeze [ _account ] = true;
        FrozenFunds ( _account , true );
        
        
    }
    
    function unfreezeAccount ( address _account ) public onlyOwner{
        
         accountFreeze [ _account ] = false;
         FrozenFunds ( _account , false );
        
        
    }
    
   
    
    
    
}   

contract peg  {  function TokenCreationContract()returns(address); }
contract pegc {  function tokenCount()returns(uint256);
                 function getTokenAddress( uint256 ) returns(address);
}


contract CentsPool{
    
address public CentsTokenAddress;
address public pegaddress;
Cents CentsToken;
peg PEG;
pegc PEGC;
address public pegcaddress;

address owner;

uint256 slowsyncamount;


struct tokenHolderBalances {
    
    uint256 balance;
    uint256 marker;
    

}

event ThBalance (address _address , uint256 _bal);
event Share ( uint256 _bal);
event CentsTokenSupply ( uint256 _bal);
event TokenAddress ( address __tokenaddress );
event TokenHolderShare ( uint256 tokenholdershare  );
event TokenHolderCentsBalance ( uint256 __balance  );
event Loop ( uint256 _i  );
event ZeroBalance ( string _i  , uint256 loopcount );




mapping ( uint256 => address ) public tokenAddress;
mapping ( address => string ) public tokenSymbol;
mapping ( address => uint256 ) public tokenBalance;



mapping ( address => tokenHolderBalances[] ) public thBalances;
//mapping ( address => uint256 ) public zeromarkers;
mapping ( address => bool ) public zeromarker;

mapping ( address => uint256 ) public tokenHolderInfoSync;
mapping ( address => uint256 ) public tokenHolderPaymentSync;

function CentsPool( address _pegaddress,  address _CentsToken ){
    
    CentsTokenAddress = _CentsToken;
    CentsToken = Cents( _CentsToken );
    
    pegaddress = _pegaddress;
    
    PEG = peg( _pegaddress);
    
   
    owner = msg.sender;
    slowsyncamount = 100;


}

 modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

function transferOwnership( address _newowner ) onlyOwner {
    
    owner = _newowner;
    
}




function setSlowSync( uint256 _slowsyncamount ) onlyOwner {
    
    slowsyncamount = _slowsyncamount;
    
}

function setZeroMarker ( address _tokenholder ){
    
    zeromarker[ _tokenholder] = true;
}

function syncsync( address __tokenholder , bool slowsync ){
        
        address _tokenholder;
        PEGC = pegc( PEG.TokenCreationContract());
        uint256 tokens =  PEGC.tokenCount();
        
        
        if ( msg.sender == CentsTokenAddress ){ _tokenholder = __tokenholder;} else _tokenholder=msg.sender;
        
        uint256 count = PEGC.tokenCount() - tokenHolderInfoSync [ _tokenholder ] ;
        
        if ( count < 1 ) return;
        
        uint256 _balance = CentsToken.balanceOf( _tokenholder );
        count = PEGC.tokenCount();
        if ( zeromarker[ _tokenholder ] == true ){  
            
            //zeromarkers[ _tokenholder ] = count; 
            thBalances[ _tokenholder ].push ( tokenHolderBalances (  0 , count  ) ); 
            zeromarker[ _tokenholder ] = false;
            
            tokenHolderInfoSync [ _tokenholder ] = count; 
            ZeroBalance ( "HadZeroBalance" ,  0 );
            return;  }
        
       
            
        uint256 _totalCentssupply = CentsToken.initialSupply();
       
       // CentsTokenSupply( _totalCentssupply  );
            
          
           
            if ( slowsync ){  if ( count < slowsyncamount ) throw;
            
                             count = slowsyncamount + tokenHolderInfoSync [ _tokenholder ];
            }
            
            uint256 tokensperCents;
            
             
            for ( uint i = tokenHolderInfoSync [ _tokenholder ]  ; i< count; i++){
                ZeroBalance ( "NotAZeroBalance" , i );   
                SubToken subtoken = SubToken ( PEGC.getTokenAddress ( i ));
                uint256 share = subtoken.share();
                tokensperCents = share/_totalCentssupply;
                uint256 tokenholdershare = _balance *  tokensperCents;
                thBalances[ _tokenholder ].push ( tokenHolderBalances (  tokenholdershare , 0  ) );
               // ThBalance ( _tokenholder , tokensperCents );
               // Share( share  );
               // CentsTokenSupply( _totalCentssupply  );
                TokenAddress( PEGC.getTokenAddress ( i ) );
               // TokenHolderShare ( tokenholdershare );
               // TokenHolderCentsBalance ( _balance );
                
                
              //  subtoken.transfer ( msg.sender, _balance *  tokensperCents  );
                
            }
            Loop ( i );
            tokenHolderInfoSync [ _tokenholder ] = count  ;  
          
       
        
       
   }
   
   
 function withdrawTokens(  bool slowsync ){
        
        PEGC = pegc( PEG.TokenCreationContract());
        uint256 tokens =  PEGC.tokenCount();
        
        
        uint256 count = tokenHolderInfoSync [ msg.sender ] - tokenHolderPaymentSync [ msg.sender ] ;
        
        if ( count < 1 ) return;
        
        uint256 _balance = CentsToken.balanceOf( msg.sender );
        uint256 _totalCentssupply = CentsToken.initialSupply();
       
        count = tokenHolderInfoSync [ msg.sender ];
            
          
           
            if ( slowsync ){  if ( count < slowsyncamount ) throw;
            
                             count = slowsyncamount + tokenHolderPaymentSync [ msg.sender ];
            }
            
            uint256 tokensperCents;
            
                
            for ( uint i = tokenHolderPaymentSync [ msg.sender ]  ; i< count; i++){
                
                if ( thBalances[msg.sender ][ i ].balance == 0 ) i = i + thBalances[msg.sender ][ i ].marker -1 ;
                
                SubToken subtoken = SubToken ( PEGC.getTokenAddress ( i ));
                uint256 share = subtoken.share();
                tokensperCents = share/_totalCentssupply;
                uint256 tokenholdershare = _balance *  tokensperCents;
                uint256 sendamount = thBalances[msg.sender ][ i ].balance;
               
                subtoken.transfer ( msg.sender, sendamount  );
                
            }
            Loop ( i );
            tokenHolderPaymentSync [ msg.sender ] = count  ;  
          
       
        
       
   }
  



}