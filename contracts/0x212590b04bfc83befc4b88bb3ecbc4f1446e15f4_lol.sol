contract lol{
        address private admin;
        function lol() {
            admin = msg.sender;
        }
        modifier onlyowner {if (msg.sender == admin) _  }
function recycle() onlyowner
{
        //Destroy the contract
        selfdestruct(admin);
    
}
}