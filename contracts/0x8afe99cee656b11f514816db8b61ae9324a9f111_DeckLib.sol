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

// Cards are represented as an integer
// Suit = c / 13 (0 = clubs, 1 = diamonds, 2 = hearts, 3 = spades)
// Number = c % 13 [0...12] 0 being Ace and 12 being King

library DeckLib {
	using ArrayLib for uint8[];

	enum Suit { Spades, Hearts, Clubs, Diamonds }
	uint8 constant cardsPerSuit = 13;
	uint8 constant suits = 4;
	uint8 constant totalCards = cardsPerSuit * suits;

	struct Deck {
		uint8[] usedCards; // always has to be sorted
		address player;
		uint256 gameID;
	}

	function init(Deck storage self, uint256 gameID)  {
		self.usedCards = new uint8[](0);
		self.player = msg.sender;
		self.gameID = gameID;
	}

	function getCard(Deck storage self, uint256 blockNumber)  returns (uint8)  {
		uint cardIndex = self.usedCards.length;
		if (cardIndex &gt;= totalCards) throw;
		uint8 r = uint8(getRandomNumber(blockNumber, self.player, self.gameID, cardIndex, totalCards - cardIndex));

		for (uint8 i = 0; i &lt; cardIndex; i++) {
			if (self.usedCards[i] &lt;= r) r += 1;
		}

		self.usedCards.insertInPlace(r);

		return r;
	}

	function cardDescription(uint8 self) constant returns (Suit, uint8) {
		return (Suit(self / cardsPerSuit), cardFacevalue(self));
	}

	function cardEmojified(uint8 self) constant returns (uint8, string) {
		string memory emojiSuit;

		var (suit, number) = cardDescription(self);
		if (suit == Suit.Clubs) emojiSuit = &quot;♣️&quot;;
		else if (suit == Suit.Diamonds) emojiSuit = &quot;♦️&quot;;
		else if (suit == Suit.Hearts) emojiSuit = &quot;♥️&quot;;
		else if (suit == Suit.Spades) emojiSuit = &quot;♠️&quot;;

		return (number, emojiSuit);
	}

	function cardFacevalue(uint8 self) constant returns (uint8) {
		return 1 + self % cardsPerSuit;
	}

	function blackjackValue(uint8 self) constant returns (uint8) {
		uint8 cardValue = cardFacevalue(self);
		return cardValue &lt; 10 ? cardValue : 10;
	}

	function getRandomNumber(uint b, address player, uint256 gameID, uint n, uint m) constant returns (uint) {
		// Uses blockhash as randomness source.
		// Credits: https://github.com/Bunjin/Rouleth/blob/master/Provably_Fair_No_Cheating.md
		bytes32 blockHash = block.blockhash(b);
		if (blockHash == 0x0) throw;
		return uint(uint256(keccak256(blockHash, player, gameID, n)) % m);

	}
}