pragma solidity ^0.4.17;

contract GetEbola {
    
    address private creator = msg.sender;
    
    function getInfo() constant returns (string, string)
    {
        string memory developer = &quot;Saluton, mia nomo estas Zach!&quot;; // Tio estas mia nomo :)
        string memory genomeInfo = &quot;Ebola virus - Zaire, cat.1976&quot;; // Ebola virus name and date genome was cataloged
        return (developer, genomeInfo);
    }
    
    function getEbola() constant returns (string)
    {
        // Returns bit.ly URL to swarm file bzz:/0191e5bf83b4b172ac36921a4ba1ceab49ba6178fcc35404047c04e6e5e95771
        string memory genomeURL = &quot;URL: http://bit.ly/0x4554482b45626f6c61&quot;;
        return (genomeURL);
    }
    
    function tipCreator() constant returns (string, address)
    {
        string memory tipMsg = &quot;If you like you can tip me at this address :)&quot;;
        address tipJar = creator; // Address of creator tip jar
        return (tipMsg, tipJar);
    }
    
    /**********
     Standard kill() function to terminate contract 
     **********/
    
    function kill() public returns (string)
    { 
        if (msg.sender == creator)
        {
            suicide(creator);  // kills the contract and sends balance to creator
        }
        else {
            string memory nope = &quot;Vi ne havas povon ĉi tie!&quot;;
            return (nope);
        }
    }
}