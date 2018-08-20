pragma solidity ^0.4.4;

contract C
{
    mapping (bytes2 => string) languageCodeToComment;
    function C() public
    {
        languageCodeToComment["ZH"] = "漢字";
    }
    function m() public view returns (string)
    {
        return languageCodeToComment["ZH"];
    }
}