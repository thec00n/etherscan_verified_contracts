pragma solidity ^0.4.21;


contract AuctusWhitelist {
	address public owner;
	uint256 public timeThatFinishGuaranteedPeriod = 1522245600; //2018-03-28 2 PM UTC
	uint256 public maximumValueAfterGuaranteedPeriod = 15000 ether; //too high value
	uint256 public maximumValueDuringGuaranteedPeriod;
	uint256 public maximumValueWithoutProofOfAddress;

	mapping(address =&gt; WhitelistInfo) public whitelist;
	mapping(address =&gt; bool) public canListAddress;

	struct WhitelistInfo {
		bool _whitelisted;
		bool _unlimited;
		bool _doubleValue;
		bool _shouldWaitGuaranteedPeriod;
	}

	function AuctusWhitelist(uint256 maximumValueToGuaranteedPeriod, uint256 maximumValueForProofOfAddress) public {
		owner = msg.sender;
		canListAddress[msg.sender] = true;
		maximumValueDuringGuaranteedPeriod = maximumValueToGuaranteedPeriod;
		maximumValueWithoutProofOfAddress = maximumValueForProofOfAddress;
	}

	modifier onlyOwner() {
		require(owner == msg.sender);
		_;
	}

	function transferOwnership(address newOwner) onlyOwner public {
		require(newOwner != address(0));
		owner = newOwner;
	}

	function changeMaximumValueDuringGuaranteedPeriod(uint256 maximumValue) onlyOwner public {
		require(maximumValue &gt; 0);
		maximumValueDuringGuaranteedPeriod = maximumValue;
	}

	function changeMaximumValueWithoutProofOfAddress(uint256 maximumValue) onlyOwner public {
		require(maximumValue &gt; 0);
		maximumValueWithoutProofOfAddress = maximumValue;
	}

	function setAddressesThatCanList(bool canList, address[] _addresses) onlyOwner public {
		for (uint256 i = 0; i &lt; _addresses.length; i++) {
			canListAddress[_addresses[i]] = canList;
		}
	}

	function listAddresses(bool whitelisted, bool unlimited, bool doubleValue, bool shouldWait, address[] _addresses) public {
		require(canListAddress[msg.sender]);
		for (uint256 i = 0; i &lt; _addresses.length; i++) {
			whitelist[_addresses[i]] = WhitelistInfo(whitelisted, unlimited, doubleValue, shouldWait);
		}
	}

	function getAllowedAmountToContribute(address addr) view public returns(uint256) {
		if (!whitelist[addr]._whitelisted) {
			return 0;
		} else if (now &lt;= timeThatFinishGuaranteedPeriod) {
			if (whitelist[addr]._shouldWaitGuaranteedPeriod) {
				return 0;
			} else {
				if (whitelist[addr]._doubleValue) {
					uint256 amount = maximumValueDuringGuaranteedPeriod * 2;
					if (whitelist[addr]._unlimited || amount &lt; maximumValueWithoutProofOfAddress) {
						return amount;
					} else {
						return maximumValueWithoutProofOfAddress;
					}
				} else {
					return maximumValueDuringGuaranteedPeriod;
				}
			}
		} else {
			if (whitelist[addr]._unlimited) {
				return maximumValueAfterGuaranteedPeriod;
			} else {
				return maximumValueWithoutProofOfAddress;
			}
		}
	}
}