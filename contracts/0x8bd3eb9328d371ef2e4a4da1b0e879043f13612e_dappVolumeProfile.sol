pragma solidity ^0.4.19;

contract dappVolumeProfile {

	mapping (address =&gt; string) public ownerAddressToName;
	mapping (address =&gt; string) public ownerAddressToUrl;

	function setAccountNickname(string _nickname) public {
		require(msg.sender != address(0));
		require(bytes(_nickname).length &gt; 0);
		ownerAddressToName[msg.sender] = _nickname;
	}

	function setAccountUrl(string _url) public {
		require(msg.sender != address(0));
		require(bytes(_url).length &gt; 0);
		ownerAddressToUrl[msg.sender] = _url;
	}

}