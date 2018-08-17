/*

Last contributor before the deadline gets all ether, stored in the contract!
Try your luck!

var raceAddress = &quot;0x02e01e9a73ed2cb24b32628c935256e455b0a078 &quot;;
var raceftwContract = web3.eth.contract([{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;getCurrentWinner&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;claimReward&quot;,&quot;outputs&quot;:[],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;getDisclaimer&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;string&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;constant&quot;:false,&quot;inputs&quot;:[],&quot;name&quot;:&quot;getRaceEndBlock&quot;,&quot;outputs&quot;:[{&quot;name&quot;:&quot;&quot;,&quot;type&quot;:&quot;uint256&quot;}],&quot;type&quot;:&quot;function&quot;},{&quot;inputs&quot;:[],&quot;type&quot;:&quot;constructor&quot;},{&quot;anonymous&quot;:false,&quot;inputs&quot;:[{&quot;indexed&quot;:false,&quot;name&quot;:&quot;newWinner&quot;,&quot;type&quot;:&quot;address&quot;}],&quot;name&quot;:&quot;LastContributorChanged&quot;,&quot;type&quot;:&quot;event&quot;}]);
var raceftw = raceftwContract.at(raceAddress);

console.log(&quot;current winner: &quot;, raceftw.getCurrentWinner.call());
console.log(&quot;race ends at block: &quot;, raceftw.getRaceEndBlock.call(), &quot; current block:&quot;, eth.blockNumber);
console.log(&quot;current balance: &quot;, web3.fromWei(eth.getBalance(raceAddress), &quot;ether&quot;));



//To participate in the race:
eth.sendTransaction({from:&lt;your address&gt;, to:&quot;0x02e01e9a73ed2cb24b32628c935256e455b0a078 &quot;, value:web3.toWei(10, &quot;finney&quot;), gas:50000});

//The winner can claim their reward by sending the following transaction:
raceftw.claimReward.sendTransaction({from:&lt;your address&gt;, gas:50000})

*/
contract RaceFTW {
    
    /* Disclaimer */
    string disclaimer = &quot;Copyright (c) 2016 \&quot;The owner of this contract\&quot; \nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \&quot;Software\&quot;), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \&quot;AS IS\&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.&quot;;
    
    function getDisclaimer() returns (string) {
        return disclaimer;
    }
    
    address lastContributor;
    uint fixedContribution = 10 finney;
    
    uint raceEnds = 0;
    
    // number of blocks. roughly 3 months at the contract creation blocks rate
    uint RACE_LENGTH = 555555;
    
    event LastContributorChanged(address newWinner);
    
    function RaceFTW () {
        raceEnds = block.number + RACE_LENGTH;
    }
    
    function getRaceEndBlock() returns (uint) {
        return raceEnds;
    }
    
    function getCurrentWinner() returns (address) {
        return lastContributor;
    }
    
    function () {
        //refund if the race ended
        if (block.number &gt; raceEnds) {
            throw;
        }
        //refund if sent amount not equal to 1 finney
        if (msg.value != fixedContribution) {
            throw;
        }
        //raise event if needed
        if (lastContributor != msg.sender) {
            LastContributorChanged(msg.sender);
        }
        
        //change the last contributor
        lastContributor = msg.sender;
    }
    
    
    function claimReward() {
        //only lastContributor can claim
        if (msg.sender != lastContributor) {
            throw;
        }
        //refund if race is not over yet
        if (block.number &lt; raceEnds) {
            throw;
        }
        if (this.balance &gt; 0) {
            lastContributor.send(this.balance);
        }
    }
}