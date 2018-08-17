contract RipplePayExample {

mapping(address =&gt; mapping(address =&gt; uint)) TrustSettings; // store trustLines for a given address

function updateTrustSettings(address _peer, uint newTrustLimit) {
TrustSettings[msg.sender][_peer] = newTrustLimit;
}

function getTrustSetting(address _peer) returns(uint) {
return TrustSettings[msg.sender][_peer];
}
}