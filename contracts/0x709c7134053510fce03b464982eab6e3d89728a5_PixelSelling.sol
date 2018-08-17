pragma solidity ^0.4.4;

contract PixelSelling {

    struct Location{
        address owner;
        string image;
        string message;
        bool sale;
        address saleTo;
        uint price;
    }

    struct Share{
        address owner;
        uint lastCashout;
        bool sale;
        address saleTo;
        uint price;
    }

    uint public latestprice;
    uint public noShares;
    uint public noSales;
    mapping (address=&gt;uint) public balances;

    uint emptyLocationProvision;
    uint privSaleProvision;
    uint priceRise;
    address creator;

    mapping (uint=&gt;Location) public locations;
    mapping (uint=&gt;Share) public shares;

    uint[] provisions;

    event Change(uint id, string eventType);

    modifier isValidLocId(uint id){
        if(!(id&gt;=0 &amp;&amp; id&lt;10000))
            throw;
        _;
    }

    function PixelSelling() {
        creator=msg.sender;
        latestprice=10000000000000000;
        priceRise  =20000000000000000;
        noShares=0;
        noSales=0;
        emptyLocationProvision=90;
        privSaleProvision=9;
    }

    function(){throw;}

    function buyEmptyLocation(uint id) isValidLocId(id) payable{
        Location l=locations[id];
        if(l.owner==0x0 &amp;&amp; msg.value==latestprice){
            l.owner=msg.sender;
            l.image=&#39;&#39;;
            l.message=&#39;&#39;;

            l.sale=false;
            l.saleTo=0x0;
            l.price=latestprice;

            shares[id] = Share(msg.sender,noSales,false,0x0,latestprice);

            if(noShares&gt;0){
                balances[creator]+=(latestprice/100)*(100-emptyLocationProvision);
                creditShareProvision(latestprice, emptyLocationProvision);
            }else{
                balances[creator]+=latestprice;
                provisions.push(0);
                noSales+=1;
            }

            noShares+=1;

            latestprice+=priceRise;

            Change(id,&#39;owner&#39;);
        }else{
            throw;
        }
    }

    function buyImagePriv(uint id) isValidLocId(id) payable{
        Location l=locations[id];
        if(
            l.owner!=0x0 &amp;&amp;
            l.sale==true &amp;&amp;
            (l.saleTo==msg.sender||l.saleTo==0x0) &amp;&amp;
            msg.value==l.price
        ){
            l.image=&#39;&#39;;
            l.message=&#39;&#39;;
            l.sale=false;
            l.saleTo=0x0;

            balances[creator]+=(msg.value/100);
            balances[l.owner]+=(msg.value/100)*(99-privSaleProvision);

            l.owner=msg.sender;

            creditShareProvision(msg.value, privSaleProvision);

            Change(id,&#39;img owner&#39;);
        }else{
            throw;
        }
    }

    function buySharePriv(uint id) isValidLocId(id) payable{
        Share s=shares[id];
		if(
			s.owner!=0x0 &amp;&amp;
			s.sale==true &amp;&amp;
			(s.saleTo==msg.sender||s.saleTo==0x0) &amp;&amp;
			msg.value==s.price
		){
            s.sale=false;
            s.saleTo=0x0;

            balances[creator]+=(msg.value/100);
            balances[shares[id].owner]+=(msg.value/100)*(99-privSaleProvision);

            shares[id].owner=msg.sender;

            creditShareProvision(msg.value, privSaleProvision);

            Change(id,&#39;share owner&#39;);
        }else{
            throw;
        }
    }

    function setImage(uint id, string img) isValidLocId(id) {
		Location l=locations[id];
        if(l.owner==msg.sender &amp;&amp; bytes(img).length&lt;5001){
            l.image=img;
            Change(id,&#39;image&#39;);
        }else{
            throw;
        }
    }

    function setMessage(uint id, string mssg) isValidLocId(id) {
		Location l=locations[id];
        if(l.owner==msg.sender &amp;&amp; bytes(mssg).length&lt;501){
            l.message=mssg;
            Change(id,&#39;message&#39;);
        }else{
			throw;
		}
    }

    function setSaleImg(uint id, bool setSale, address to, uint p) isValidLocId(id) {
        Location l=locations[id];
		if(l.owner==msg.sender){
            l.sale=setSale;
            l.price=p;
            l.saleTo=to;
            Change(id,&#39;img sale&#39;);
        }else{
			throw;
		}
    }

    function setSaleShare(uint id, bool setSale, address to, uint p) isValidLocId(id) {
        Share s=shares[id];
		if(s.owner==msg.sender){
            s.sale=setSale;
            s.price=p;
            s.saleTo=to;
            Change(id,&#39;share sale&#39;);
        }else{
			throw;
		}
    }

    function creditShareProvision(uint price, uint provision) private {
        provisions.push(provisions[noSales-1]+(((price/100)*provision)/noShares));
        noSales+=1;
    }

    function getProvisionBalance(uint id) isValidLocId(id) constant returns (uint balance) {
        Share s=shares[id];
        if(s.owner!=0x0){
            return provisions[noSales-1]-provisions[s.lastCashout];
        }else{
            return 0;
        }
    }

    function collectProvisions(uint id) isValidLocId(id) {
        Share s=shares[id];
        if(s.owner==msg.sender){
            balances[s.owner]+=provisions[noSales-1]-provisions[s.lastCashout];
            s.lastCashout=noSales-1;
        }else{
            throw;
        }
    }

    function withdrawBalance() {
        if(balances[msg.sender]&gt;0){
            uint amtToWithdraw=balances[msg.sender];
            balances[msg.sender]=0;
            if(!msg.sender.send(amtToWithdraw)) throw;
        }else{
            throw;
        }
    }
}