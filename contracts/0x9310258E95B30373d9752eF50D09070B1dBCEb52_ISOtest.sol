contract ISOtest {

    mapping (bytes32 =&gt; string) data;
    
    string ctype = &quot;ISO 9001:2015&quot;;
    string scope = &quot;Provision and control of quality of help desk, support, project procesing&quot;;
    string issuedTo = &quot;Digital Edge&quot;;
    string companyAddress = &quot;7 Teleport Drive, Staten Island, NY 10311&quot;;
    string issuedBy = &quot;Dekra&quot;;
    string signerBy = &quot;Cem O.Onus&quot;;
    string title = &quot;Managin Director&quot;;
    string certificateIssued = &quot;2/20/2018&quot;;
    string certificateSince = &quot;3/1/2018&quot;;
    string certificateExpires = &quot;2/29/2024&quot;;
    
    address owner;

    function ISOtest() public {
        owner = msg.sender;
    }
    

    function setData(string key, string value) public{
        require(msg.sender == owner);
        require(keccak256(data[keccak256(key)]) == keccak256(&quot;&quot;));
        data[keccak256(key)] = value;
    }
    
    function getData(string key) public constant returns(string) {
        return data[keccak256(key)];
    }
    
    function getName() public constant returns (string) {
        return data[keccak256(&#39;name&#39;)];
    }
    
    function getIssued() public constant returns (string) {
        return issuedTo;
    }
    
    function getScope() public constant returns (string) {
        return scope;
    }
    
    function getCompanyAddress() public constant returns (string) {
        return companyAddress;
    }
    
    function getIssuedBy() public constant returns (string) {
        return issuedBy;
    }
    
    function getSignerby() public constant returns (string) {
        return signerBy;
    }
    
    function getTitle() public constant returns (string) {
        return title;
    }
    
    function getCertificateIssued() public constant returns (string) {
        return certificateIssued;
    }
    
    function getCertificateSince() public constant returns (string) {
        return certificateSince;
    }
    
    function getCertificateExpires() public constant returns (string) {
        return certificateExpires;
    }
    
    function getType() public constant returns (string) {
        return ctype;
    }
    
}