pragma solidity ^0.4.18;

// File: contracts/UidCheckerInterface.sol

interface UidCheckerInterface {

  function isUid(
    string _uid
  )
  public
  pure returns (bool);

}

// File: contracts/UidCheckerForTwitter.sol

/**
 * @title UidCheckerForTwitter
 * @author Francesco Sullo &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c5a3b7a4aba6a0b6a6aa85b6b0a9a9aaeba6aa">[email&#160;protected]</a>&gt;
 * @dev Checks if a uid is a Twitter uid
 */

contract UidCheckerForTwitter
is UidCheckerInterface
{

  string public fromVersion = &quot;1.0.0&quot;;

  function isUid(
    string _uid
  )
  public
  pure
  returns (bool)
  {
    bytes memory uid = bytes(_uid);
    if (uid.length == 0 || uid.length &gt; 20) {
      return false;
    } else {
      for (uint i = 0; i &lt; uid.length; i++) {
        if (uid[i] &lt; 48 || uid[i] &gt; 57) {
          return false;
        }
      }
    }
    return true;
  }

}