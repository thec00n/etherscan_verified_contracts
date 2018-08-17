pragma solidity ^0.4.8;

library ArrayLib {
  // Inserts to keep array sorted (assumes input array is sorted)
	function insertInPlace(uint8[] storage self, uint8 n) {
		uint8 insertingIndex = 0;

		while (self.length &gt; 0 &amp;&amp; insertingIndex &lt; self.length &amp;&amp; self[insertingIndex] &lt; n) {
			insertingIndex += 1;
		}

		self.length += 1;
		for (uint8 i = uint8(self.length) - 1; i &gt; insertingIndex; i--) {
			self[i] = self[i - 1];
		}

		self[insertingIndex] = n;
	}
}