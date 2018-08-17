pragma solidity ^0.4.18;

contract EtherealNotes {
    
    string public constant CONTRACT_NAME = &quot;EtherealNotes&quot;;
    string public constant CONTRACT_VERSION = &quot;A&quot;;
    string public constant QUOTE = &quot;&#39;When you stare into the abyss the abyss stares back at you.&#39; -Friedrich Nietzsche&quot;;
    
    event Note(address sender,string indexed note);
    function SubmitNote(string note) public{
        Note(msg.sender, note);
    }
}