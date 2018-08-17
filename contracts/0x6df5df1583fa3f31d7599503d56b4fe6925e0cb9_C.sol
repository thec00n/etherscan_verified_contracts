pragma solidity ^0.4.4;

contract C
{
    mapping (bytes2 =&gt; string) languageCodeToComment;
    function C() public
    {
        languageCodeToComment[&quot;ZH&quot;] = &quot;漢字&quot;;
    }
    function m() public view returns (string)
    {
        return languageCodeToComment[&quot;ZH&quot;];
    }
}