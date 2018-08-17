contract ERW {
    string public EdgarRichardWunsche;
    string public Parents;
    string public DateOfBirth;
    string public DateOfDeath;
    string public Location;
    
    function ERW() {
        EdgarRichardWunsche = &quot;Edgar Richard Wunsche (12.11.1930-22.04.2016). Rest in Peace Dad. Love Alan.&quot;;
        DateOfBirth = &quot;12.11.1930&quot;;
        DateOfDeath = &quot;22.04.2016&quot;;
        Parents = &quot;Beloved son of Anna Wunsche (Moser) and Antonin Wunsche.&quot;;
        Location = &quot;Toronto, Ontario, Canada&quot;;
    }

    function () {
        throw;     // Prevents accidental sending of ether
    }
}