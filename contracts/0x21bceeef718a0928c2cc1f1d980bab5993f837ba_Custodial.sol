/*
 * Custodial Smart Contract.  Copyright &#169; 2017 by ABDK Consulting.
 * Author: Mikhail Vladimirov &lt;<span class="__cf_email__" data-cfemail="b8d5d1d3d0d9d1d496ced4d9dcd1d5d1cad7cef8dfd5d9d1d496dbd7d5">[email&#160;protected]</span>&gt;
 */
pragma solidity ^0.4.10;

/**
 * Custodial Smart Contract that that charges fee for keeping ether.
 */
contract Custodial {
  uint256 constant TWO_128 = 0x100000000000000000000000000000000; // 2^128
  uint256 constant TWO_127 = 0x80000000000000000000000000000000; // 2^127

  /**
   * Address of the client, i.e. owner of the ether kept by the contract.
   */
  address client;

  /**
   * Address of the advisor, i.e. the one who receives fee charged by the
   * contract for keeping client&#39;s ether.
   */
  address advisor;

  /**
   * Capital, i.e. amount of client&#39;s ether (in Wei) kept by the contract.
   */
  uint256 capital;

  /**
   * Time when capital was last updated (in seconds since epoch).
   */
  uint256 capitalTimestamp;

  /**
   * Fee factor, the capital is multiplied by each second multiplied by 2^128.
   * I.e. capital(t+1) = capital (t) * feeFactor / 2^128.
   */
  uint256 feeFactor;

  /**
   * Create new Custodial contract with given client address, advisor address
   * and fee factor.
   *
   * @param _client client address
   * @param _advisor advisor address
   * @param _feeFactor fee factor
   */
  function Custodial (address _client, address _advisor, uint256 _feeFactor) {
    if (_feeFactor &gt; TWO_128)
      throw; // Fee factor must be less then or equal to 2^128

    client = _client;
    advisor = _advisor;
    feeFactor = _feeFactor;
  }

  /**
   * Get client&#39;s capital (in Wei).
   *
   * @param _currentTime current time in seconds since epoch
   * @return client&#39;s capital
   */
  function getCapital (uint256 _currentTime)
  constant returns (uint256 _result) {
    _result = capital;
    if (capital &gt; 0 &amp;&amp; capitalTimestamp &lt; _currentTime &amp;&amp; feeFactor &lt; TWO_128) {
      _result = mul (_result, pow (feeFactor, _currentTime - capitalTimestamp));
    }
  }

  /**
   * Deposit ether on the client&#39;s account.
   */
  function deposit () payable {
    if (msg.value &gt; 0) {
      updateCapital ();
      if (msg.value &gt;= TWO_128 - capital)
        throw; // Capital should never exceed 2^128 Wei
      capital += msg.value;
      Deposit (msg.sender, msg.value);
    }
  }

  /**
   * Withdraw ether from client&#39;s account and sent it to the client&#39;s address.
   * May only be called by client.
   *
   * @param _value value to withdraw (in Wei)
   * @return true if ether was successfully withdrawn, false otherwise
   */
  function withdraw (uint256 _value)
  returns (bool _success) {
    if (msg.sender != client) throw;

    if (_value &gt; 0) {
      updateCapital ();
      if (_value &lt;= capital) {
        if (client.send (_value)) {
          Withdrawal (_value);
          capital -= _value;
          return true;
        } else return false;
      } else return false;
    } else return true;
  }

  /**
   * Withdraw all ether from client&#39;s account and sent it to the client&#39;s
   * address.  May only be called by client.
   *
   * @return true if ether was successfully withdrawn, false otherwise
   */
  function withdrawAll ()
  returns (bool _success) {
    if (msg.sender != client) throw;

    updateCapital ();
    if (capital &gt; 0) {
      if (client.send (capital)) {
        Withdrawal (capital);
        capital = 0;
        return true;
      } else return false;
    } else return true;
  }

  /**
   * Withdraw fee charged by the contract as well as all unaccounted ether on
   * contract&#39;s balance and send it to the advisor&#39;s address.  May only be
   * called by advisor.
   *
   * @return true if fee and unaccounted ether was successfully withdrawn,
   *          false otherwise
   */
  function withdrawFee ()
  returns (bool _success) {
    if (msg.sender != advisor) throw;

    uint256 _value = this.balance - getCapital (now);
    if (_value &gt; 0) {
      return advisor.send (_value);
    } else return true;
  }

  /**
   * Terminate account and send all its balance to advisor.  May only be called
   * by advisor when capital is zero.
   */
  function terminate () {
    if (msg.sender != advisor) throw;

    if (capital &gt; 0) throw;
    if (this.balance &gt; 0) {
      if (!advisor.send (this.balance)) {
        // Ignore error
      }
    }
    suicide (advisor);
  }

  /**
   * Update capital, i.e. charge fee from it.
   */
  function updateCapital ()
  internal {
    if (capital &gt; 0 &amp;&amp; capitalTimestamp &lt; now &amp;&amp; feeFactor &lt; TWO_128) {
      capital = mul (capital, pow (feeFactor, now - capitalTimestamp));
    }
    capitalTimestamp = now;
  }

  /**
   * Multiply _a by _b / 2^128.  Parameter _a should be less than or equal to
   * 2^128 and parameter _b should be less than 2^128.
   *
   * @param _a left argument
   * @param _b right argument
   * @return _a * _b / 2^128
   */
  function mul (uint256 _a, uint256 _b)
  internal constant returns (uint256 _result) {
    if (_a &gt; TWO_128) throw;
    if (_b &gt;= TWO_128) throw;
    return (_a * _b + TWO_127) &gt;&gt; 128;
  }

  /**
   * Calculate (_a / 2^128)^_b * 2^128.  Parameter _a should be less than 2^128.
   *
   * @param _a left argument
   * @param _b right argument
   * @return (_a / 2^128)^_b * 2^128
   */
  function pow (uint256 _a, uint256 _b)
  internal constant returns (uint256 _result) {
    if (_a &gt;= TWO_128) throw;

    _result = TWO_128;
    while (_b &gt; 0) {
      if (_b &amp; 1 == 0) {
        _a = mul (_a, _a);
        _b &gt;&gt;= 1;
      } else {
        _result = mul (_result, _a);
        _b -= 1;
      }
    }
  }

  /**
   * Logged when ether was deposited on client&#39;s account.
   *
   * @param from address ether came from
   * @param value amount of ether deposited (in Wei)
   */
  event Deposit (address indexed from, uint256 value);

  /**
   * Logged when ether was withdrawn from client&#39;s account.
   *
   * @param value amount of ether withdrawn (in Wei)
   */
  event Withdrawal (uint256 value);
}