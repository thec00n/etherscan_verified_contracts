pragma solidity ^0.4.18;

// File: contracts/UidCheckerInterface.sol

interface UidCheckerInterface {

  function isUid(
    string _uid
  )
  public
  pure returns (bool);

}

// File: contracts/UidCheckerForReddit.sol

/**
 * @title UidCheckerForReddit
 * @author Francesco Sullo &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="e38591828d808690808ca390968f8f8ccd808c">[email&#160;protected]</a>&gt;
 * @dev Checks if a uid is a Reddit uid
 */



contract UidCheckerForReddit
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
    if (uid.length &lt; 3 || uid.length &gt; 20) {
      return false;
    } else {
      for (uint i = 0; i &lt; uid.length; i++) {
        if (!(
        uid[i] == 45 || uid[i] == 95
        || (uid[i] &gt;= 48 &amp;&amp; uid[i] &lt;= 57)
        // it requires lowercases, to not risk conflicts
        // even if Reddit allows lower and upper cases
        || (uid[i] &gt;= 97 &amp;&amp; uid[i] &lt;= 122)
        )) {
          return false;
        }
      }
    }
    return true;
  }

}