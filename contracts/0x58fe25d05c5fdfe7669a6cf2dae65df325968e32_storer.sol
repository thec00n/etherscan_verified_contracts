pragma solidity ^0.4.2;
contract storer {
	address public owner;
	string public log;

	function storer() {
		owner = msg.sender ;
		}

	modifier onlyOwner {
		if (msg.sender != owner)
            		throw;
        		_;
		}

	function store(string _log) onlyOwner() {
	log = _log;
		}

	function kill() onlyOwner() {
	selfdestruct(owner); }
	
/*

{
	&quot;maker&quot;: {
		&quot;address&quot;: &quot;0x0a6d88d0ac14bb76b58bf6341b65a10353b8aee8&quot;,
		&quot;token&quot;: {
			&quot;name&quot;: &quot;Augur Reputation Token&quot;,
			&quot;symbol&quot;: &quot;REP&quot;,
			&quot;decimals&quot;: 18,
			&quot;address&quot;: &quot;0xe94327d07fc17907b4db788e5adf2ed424addff6&quot;
		},
		&quot;amount&quot;: &quot;860000000000000000&quot;,
		&quot;feeAmount&quot;: &quot;0&quot;
	},
	&quot;taker&quot;: {
		&quot;address&quot;: &quot;0x6CF821A13455cABed0adc2789C6803FA2e938cA9&quot;,
		&quot;token&quot;: {
			&quot;name&quot;: &quot;pcp cab dac sec 5&quot;,
			&quot;symbol&quot;: &quot;CCA&quot;,
			&quot;decimals&quot;: 8,
			&quot;address&quot;: &quot;0xaf34de25a4962c05287025a386869fa0e12ce95d&quot;
		},
		&quot;amount&quot;: &quot;1700000000&quot;,
		&quot;feeAmount&quot;: &quot;0&quot;
	},
	&quot;expiration&quot;: &quot;1509303780&quot;,
	&quot;feeRecipient&quot;: &quot;0x0000000000000000000000000000000000000000&quot;,
	&quot;salt&quot;: &quot;99080185595902305128011107182726626379042477463436851204612997193034843428216&quot;,
	&quot;signature&quot;: {
		&quot;v&quot;: 28,
		&quot;r&quot;: &quot;0xa5a3b9dee57e814e2cc733c2b362cee5c037baade9dbdd47bcfa47de10c38a10&quot;,
		&quot;s&quot;: &quot;0x75225fddc9b382a218b4d64e8992ab17e6d030fde885c4c618a97da0311e1e5f&quot;,
		&quot;hash&quot;: &quot;0x4e427f1a75e0f55745689b0f6e36d4f44a8fcb1b525620c69e491a36daf9a3ee&quot;
	},
	&quot;exchangeContract&quot;: &quot;0x12459c951127e0c374ff9105dda097662a027093&quot;,
	&quot;networkId&quot;: 1
}

	&#39;0x protocol implementation
	&#39;carnet d&#39;ordres
	&#39;offre d&#39;achat
	&#39;acheteur, compte num&#233;ro :	0x0a6d88d0ac14bb76b58bf6341b65a10353b8aee8
	&#39;compte d&#39;actif, actif :	CCA (clevestAB equity)
	&#39;volume :			17.00000000
	&#39;au prix de
	&#39;compte en devises, devise :	REP
	&#39;montant :			0.860
	&#39;consolidation
	&#39;compte en devises, devise :	ETH
	&#39;montant :			0.01
	&#39;compte en devise, devise :	CHF
	&#39;montant :			17.00
	&#39;contr&#244;le source :		

*/	
}