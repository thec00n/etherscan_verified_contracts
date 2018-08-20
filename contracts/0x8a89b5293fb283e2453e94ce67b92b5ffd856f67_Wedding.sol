pragma solidity ^0.4.24;

contract Wedding {
    string bride = "Taja";
    string groom = "Matej";
    string date = "29th July 2017";
    
    function getWeddingData() returns (string) {
        return string(abi.encodePacked(bride, " & ", groom, ", happily married on ", date, ". :)"));
    }
    
    function myWishes() returns (string) {
        return "May today be the beginning of a long, happy life together!";
    }
}