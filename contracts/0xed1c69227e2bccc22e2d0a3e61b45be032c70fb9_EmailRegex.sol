pragma solidity ^0.4.11;

contract EmailRegex {
  struct State {
    bool accepts;
    function (byte) constant internal returns (uint) func;
  }

  string public constant regex = &quot;[a-zA-Z0-9._%+-]<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="557e15">[email&#160;protected]</a>[a-zA-Z0-9.-_]+\.[a-zA-Z]{2,}&quot;;

  function state(uint id) constant internal returns (State) {
    if (id == 1) {
      return State(false, s1);
    }
    if (id == 2) {
      return State(false, s2);
    }
    if (id == 3) {
      return State(false, s3);
    }
    if (id == 4) {
      return State(false, s4);
    }
    if (id == 5) {
      return State(false, s5);
    }
    if (id == 6) {
      return State(false, s6);
    }
    if (id == 7) {
      return State(false, s7);
    }
    if (id == 8) {
      return State(false, s8);
    }
    if (id == 9) {
      return State(true, s9);
    }
    if (id == 10) {
      return State(true, s10);
    }
  }

  function matches(string input) constant returns (bool) {
    uint cur = 1;

    for (var i = 0; i &lt; bytes(input).length; i++) {
      var c = bytes(input)[i];

      cur = state(cur).func(c);
      if (cur == 0) {
        return false;
      }
    }

    return state(cur).accepts;
  }

  function s1(byte c) constant internal returns (uint) {
    if (c &gt;= 37 &amp;&amp; c &lt;= 37 || c &gt;= 43 &amp;&amp; c &lt;= 43 || c &gt;= 45 &amp;&amp; c &lt;= 45 || c &gt;= 46 &amp;&amp; c &lt;= 46 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 95 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 2;
    }

    return 0;
  }

  function s2(byte c) constant internal returns (uint) {
    if (c &gt;= 37 &amp;&amp; c &lt;= 37 || c &gt;= 43 &amp;&amp; c &lt;= 43 || c &gt;= 45 &amp;&amp; c &lt;= 45 || c &gt;= 46 &amp;&amp; c &lt;= 46 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 95 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 3;
    }
    if (c &gt;= 64 &amp;&amp; c &lt;= 64) {
      return 4;
    }

    return 0;
  }

  function s3(byte c) constant internal returns (uint) {
    if (c &gt;= 37 &amp;&amp; c &lt;= 37 || c &gt;= 43 &amp;&amp; c &lt;= 43 || c &gt;= 45 &amp;&amp; c &lt;= 45 || c &gt;= 46 &amp;&amp; c &lt;= 46 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 95 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 3;
    }
    if (c &gt;= 64 &amp;&amp; c &lt;= 64) {
      return 4;
    }

    return 0;
  }

  function s4(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 91 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 5;
    }

    return 0;
  }

  function s5(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 91 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 7;
    }

    return 0;
  }

  function s6(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 91 &amp;&amp; c &lt;= 95) {
      return 7;
    }
    if (c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 8;
    }

    return 0;
  }

  function s7(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 91 &amp;&amp; c &lt;= 95 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 7;
    }

    return 0;
  }

  function s8(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 91 &amp;&amp; c &lt;= 95) {
      return 7;
    }
    if (c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 9;
    }

    return 0;
  }

  function s9(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 91 &amp;&amp; c &lt;= 95) {
      return 7;
    }
    if (c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 10;
    }

    return 0;
  }

  function s10(byte c) constant internal returns (uint) {
    if (c &gt;= 46 &amp;&amp; c &lt;= 46) {
      return 6;
    }
    if (c &gt;= 47 &amp;&amp; c &lt;= 47 || c &gt;= 48 &amp;&amp; c &lt;= 57 || c &gt;= 58 &amp;&amp; c &lt;= 64 || c &gt;= 91 &amp;&amp; c &lt;= 95) {
      return 7;
    }
    if (c &gt;= 65 &amp;&amp; c &lt;= 90 || c &gt;= 97 &amp;&amp; c &lt;= 122) {
      return 10;
    }

    return 0;
  }
}