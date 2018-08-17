pragma solidity ^0.4.0;

contract EtherUnitConverter {
    /*
     * Ethereum Units Converter contract
     *
     * created by: D-Nice
     * contract address: 0x52070b253406fc4F2bf71dBaF910F66c45828DBA
     */

    mapping (string =&gt; uint) etherUnits;
    
    /* used web3.js unitMap for this data from: 
    https://github.com/ethereum/web3.js/blob/develop/lib/utils/utils.js#L41
    */
    function EtherUnitConverter () {
        etherUnits[&#39;noether&#39;]
        = 0;
        etherUnits[&#39;wei&#39;] 
        = 10**0;
        etherUnits[&#39;kwei&#39;] = etherUnits[&#39;babbage&#39;] = etherUnits[&#39;femtoether&#39;]
        = 10**3;
        etherUnits[&#39;mwei&#39;] = etherUnits[&#39;lovelace&#39;] = etherUnits[&#39;picoether&#39;] 
        = 10**6;
        etherUnits[&#39;gwei&#39;] = etherUnits[&#39;shannon&#39;] = etherUnits[&#39;nanoether&#39;] = etherUnits[&#39;nano&#39;] 
        = 10**9;
        etherUnits[&#39;szabo&#39;] = etherUnits[&#39;microether&#39;] = etherUnits[&#39;micro&#39;] 
        = 10**12;
        etherUnits[&#39;finney&#39;] = etherUnits[&#39;milliether&#39;] = etherUnits[&#39;milli&#39;] 
        = 10**15;
        etherUnits[&#39;ether&#39;] 
        = 10**18;
        etherUnits[&#39;kether&#39;] = etherUnits[&#39;grand&#39;]
        = 10**21;
        etherUnits[&#39;mether&#39;] = 10**24;
        etherUnits[&#39;gether&#39;] = 10**27;
        etherUnits[&#39;tether&#39;] = 10**30;
    }
    
    function convertToWei(uint amount, string unit) external constant returns (uint) {
        return amount * etherUnits[unit];
    }
    
    function convertTo(uint amount, string unit, string convertTo) external constant returns (uint) {
        uint input = etherUnits[unit];
        uint output = etherUnits[convertTo];
        if(input &gt; output)
            return amount * (input / output);
        else
            return amount / (output / input);
    } 
    
    string[11] unitsArray = [&#39;wei&#39;, &#39;kwei&#39;, &#39;mwei&#39;, &#39;gwei&#39;, &#39;szabo&#39;, &#39;finney&#39;, &#39;ether&#39;, &#39;kether&#39;, &#39;mether&#39;, &#39;gether&#39;, &#39;tether&#39;];

    function convertToEach(uint amount, string unit, uint unitIndex) external constant returns (uint convAmt, string convUnit) {

        uint input = etherUnits[unit];
        uint output = etherUnits[unitsArray[unitIndex]];
            
        if(input &gt; output)
            convAmt = (amount * (input / output));
        else
            convAmt = (amount / (output / input));
        convUnit = unitsArray[unitIndex];
    }
    
    function convertToAllTable(uint amount, string unit) 
    external constant returns 
    (uint weiAmt,
    uint kweiAmt,
    uint mweiAmt,
    uint gweiAmt,
    uint szaboAmt,
    uint finneyAmt,
    uint etherAmt) {
    
        uint input = etherUnits[unit];
        //kether and other higher units omitted due to stack depth limit
        (weiAmt, kweiAmt, mweiAmt, gweiAmt, szaboAmt, finneyAmt, etherAmt) = iterateTable(amount, input);
    }
    
    function iterateTable(uint _amt, uint _input) private constant returns 
    (uint, uint, uint, uint, uint, uint, uint) {
        uint[7] memory c;
        
        for(uint i = 0; i &lt; c.length; i++) {
            uint output = etherUnits[unitsArray[i]];
            
            if(_input &gt; output)
                c[i] = (_amt * (_input / output));
            else
                c[i] = (_amt / (output / _input));
        }
        return (c[0],c[1],c[2],c[3],c[4],c[5],c[6]);
    }
}