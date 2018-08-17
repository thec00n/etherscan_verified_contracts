/*

TokenSaleFactory interface:

[{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;tokenSalesByOwner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;tokenSalesAll&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_asset&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_price&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;createSale&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;tokenSalesByAsset&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;index&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;TokenSaleCreation&quot;,&quot;type&quot;:&quot;event&quot;}]


TokenSale interface:

[{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;asset&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;owner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;transfer_eth&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:true,&quot;inputs&quot;:[],&quot;name&quot;:&quot;price&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;_token&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_to&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_value&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;name&quot;:&quot;transfer_token&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[{&quot;name&quot;:&quot;newOwner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;transferOwnership&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[{&quot;name&quot;:&quot;_asset&quot;,&quot;type&quot;:&quot;address&quot;},{&quot;name&quot;:&quot;_price&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;constructor&quot;}]

Seller usage:

Follow the TokenSaleFactory contract using the TokenSaleFactory interface.
Use the createSale function to launch a sale given the subcurrency address 
and the price measured in wei for the smallest of that subcurrency 
for example 0.75 ETH per DGD would be 0.75 * 10^18 / 10^9

Find your tokensale by entering your address into the tokenSalesByOwner owner field
then entering the number you get into the tokensalesall field which is a list of all sales created

Deposit subcurrency to allow people to buy it at the pice you specified.

To withdraw funds use the function transfer_eth and give the amount in wei
To withdraw left over subcurrency use transfer_token given the address of the subcurrency you have deposited
or transfer_asset. Amounts are in the smallest unit of that subcurrency for example 1 DGD would be 10^9


Buyer usage:

Send ETH to a TokenSale address to automatically receive the token being sold.

To verify a TokenSale contract obtain the index and address. Folow the TokenSaleFactory and enter the index into the TokenSalesAll field to verify the address is the same.
Follow the TokenSale addresswith the TokenSale interface to verify the asset being sold is the right subcurrency and that the price is right.

*/

contract Token {
    event Transfer(address indexed from, address indexed to, uint256 value);
    function transfer(address _to, uint256 _value);
    function balanceOf(address) returns (uint256);
}

contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract TokenSale is owned {

	address public asset;
	uint256 public price;

	function TokenSale(address _asset, uint256 _price)
	{
	    asset = _asset; // addreress of subcurrency
	    price = _price; // number of wei per smallest unit of subcurrency. 
	                    // for example 0.75 ETH per DGD would be 0.75 * 10^18 / 10^9
	                    // 10^18 being the conversion to ETH and 10^9 being the conversion to DGD
	}


	function transfer_token(address _token, address _to, uint256 _value)
	onlyOwner()
	{
		Token(_token).transfer(_to,_value); // Oner can Transfer any subcurrency out of this contract
	}

	function transfer_asset(address _to, uint256 _value)
	onlyOwner()
	{
		Token(asset).transfer(_to,_value); // transfer the sale asset
	}

	function transfer_eth(address _to, uint256 _value)
	onlyOwner()
	{
            _to.send(_value); // owner can send ETH out. _value is in wei
	}

   	function () {

		uint order   = msg.value / price;
		
		if(order == 0) throw;
		
		uint256 balance = Token(asset).balanceOf(address(this));
		
		if(balance == 0) throw;
		
		if(order &gt; balance )
		{
		    order = balance;
		    uint256 change = msg.value - order * price;
		    msg.sender.send(change);
		}

		Token(asset).transfer(msg.sender,order);
    }
}


contract TokenSaleFactory {
    
    event TokenSaleCreation(uint256 index, address saleAddress);

    address[] public tokenSalesAll; // this public array stores all tokensales created

    mapping (address =&gt; uint256[]) public tokenSalesByOwner; // this mapping stores an index in tokenSalesAll of all tokensales created by a specific address
    mapping (address =&gt; uint256[]) public tokenSalesByAsset; // this mapping stores an index in tokenSalesAll of all tokensales for a particular subcurrency
    
    function createSale (address _asset, uint256 _price) returns (address) {
        address c = new TokenSale(_asset,_price);       // Create a tokensale
        TokenSale(c).transferOwnership(msg.sender);     // set the owner to whoever called the function
        uint256 index = tokenSalesAll.push(c) -1;
        tokenSalesByOwner[msg.sender].push(index);  
        tokenSalesByAsset[msg.sender].push(index);
        TokenSaleCreation(index,c);                       // alert interested client that a tokensale has been created
    }
    
    function () {
        throw;     // Prevents accidental sending of ether to the factory
                   // Do not send subcurrency to the factory either as it will become trapped
                   // you will send subcurrency to the TokenSale contracts this factory creates
    }
}