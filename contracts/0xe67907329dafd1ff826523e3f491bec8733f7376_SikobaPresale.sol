pragma solidity ^0.4.8;

/**
 * SIKOBA PRESALE CONTRACTS
 *
 * Version 0.1
 *
 * Author Roland Kofler, Alex Kampa, Bok &#39;BokkyPooBah&#39; Khoo
 *
 * MIT LICENSE Copyright 2016 Sikoba LTD
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the &quot;Software&quot;), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED &quot;AS IS&quot;, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **/

contract Owned {
    address public owner;

    function Owned() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }
}

/// ----------------------------------------------------------------------------------------
/// @title Sikoba Presale Contract
/// @author Roland Kofler, Alex Kampa, Bok &#39;Bokky Poo Bah&#39; Khoo
/// @dev Changes to this contract will invalidate any security audits done before.
/// It is MANDATORY to protocol audits in the &quot;Security reviews done&quot; section
///  # Security checklists to use in each review:
///  - Consensys checklist https://github.com/ConsenSys/smart-contract-best-practices
///  - Roland Kofler&#39;s checklist https://github.com/rolandkofler/ether-security
///  - Read all of the code and use creative and lateral thinking to discover bugs
///  # Security reviews done:
///  Date         Auditors       Short summary of the review executed
///  Mar 03 2017 - Roland Kofler  - NO SECURITY REVIEW DONE
///  Mar 07 2017 - Roland Kofler, - Informal Security Review; added overflow protections;
///                Alex Kampa       fixed wrong inequality operators; added maximum amount
///                                 per transactions
///  Mar 07 2017 - Alex Kampa     - Some code clean up; removed restriction of
///                                 MINIMUM_PARTICIPATION_AMOUNT for preallocations
///  Mar 08 2017 - Bok Khoo       - Complete security review and modifications
///  Mar 09 2017 - Roland Kofler  - Check the diffs between MAR 8 and MAR 7 versions
///  Mar 12 2017 - Bok Khoo       - Renamed TOTAL_PREALLOCATION_IN_WEI
///                                 to TOTAL_PREALLOCATION.
///                                 Removed isPreAllocation from addBalance(...)
///  Mar 13 2017 - Bok Khoo       - Made dates in comments consistent
/// ----------------------------------------------------------------------------------------
contract SikobaPresale is Owned {
    // -------------------------------------------------------------------------------------
    // TODO Before deployment of contract to Mainnet
    // 1. Confirm MINIMUM_PARTICIPATION_AMOUNT and MAXIMUM_PARTICIPATION_AMOUNT below
    // 2. Adjust PRESALE_MINIMUM_FUNDING and PRESALE_MAXIMUM_FUNDING to desired EUR
    //    equivalents
    // 3. Adjust PRESALE_START_DATE and confirm the presale period
    // 4. Update TOTAL_PREALLOCATION to the total preallocations received
    // 5. Add each preallocation address and funding amount from the Sikoba bookmaker
    //    to the constructor function
    // 6. Test the deployment to a dev blockchain or Testnet to confirm the constructor
    //    will not run out of gas as this will vary with the number of preallocation
    //    account entries
    // 7. A stable version of Solidity has been used. Check for any major bugs in the
    //    Solidity release announcements after this version.
    // 8. Remember to send the preallocated funds when deploying the contract!
    // -------------------------------------------------------------------------------------

    // Keep track of the total funding amount
    uint256 public totalFunding;

    // Minimum and maximum amounts per transaction for public participants
    uint256 public constant MINIMUM_PARTICIPATION_AMOUNT =   0 ether;
    uint256 public constant MAXIMUM_PARTICIPATION_AMOUNT = 250 ether;

    // Minimum and maximum goals of the presale
    uint256 public constant PRESALE_MINIMUM_FUNDING =  1 ether;
    uint256 public constant PRESALE_MAXIMUM_FUNDING = 2 ether;

    // Total preallocation in wei
    uint256 public constant TOTAL_PREALLOCATION = 0 ether;

    // Public presale period
    // Starts Apr 05 2017 @ 12:00pm (UTC) 2017-04-05T12:00:00+00:00 in ISO 8601
    // Ends 2 weeks after the start
    uint256 public constant PRESALE_START_DATE = now;
    uint256 public constant PRESALE_END_DATE = PRESALE_START_DATE + 15 minutes;

    // Owner can clawback after a date in the future, so no ethers remain
    // trapped in the contract. This will only be relevant if the
    // minimum funding level is not reached
    // Jan 01 2018 @ 12:00pm (UTC) 2018-01-01T12:00:00+00:00 in ISO 8601
    uint256 public constant OWNER_CLAWBACK_DATE = PRESALE_START_DATE + 20 minutes;

    /// @notice Keep track of all participants contributions, including both the
    ///         preallocation and public phases
    /// @dev Name complies with ERC20 token standard, etherscan for example will recognize
    ///      this and show the balances of the address
    mapping (address =&gt; uint256) public balanceOf;

    /// @notice Log an event for each funding contributed during the public phase
    /// @notice Events are not logged when the constructor is being executed during
    ///         deployment, so the preallocations will not be logged
    event LogParticipation(address indexed sender, uint256 value, uint256 timestamp);

    function SikobaPresale () payable {
        assertEquals(TOTAL_PREALLOCATION, msg.value);
        // Pre-allocations
        // addBalance(0xdeadbeef, 10 wei);
        // addBalance(0xcafebabe, 5 wei);
        assertEquals(TOTAL_PREALLOCATION, totalFunding);
    }

    /// @notice A participant sends a contribution to the contract&#39;s address
    ///         between the PRESALE_STATE_DATE and the PRESALE_END_DATE
    /// @notice Only contributions between the MINIMUM_PARTICIPATION_AMOUNT and
    ///         MAXIMUM_PARTICIPATION_AMOUNT are accepted. Otherwise the transaction
    ///         is rejected and contributed amount is returned to the participant&#39;s
    ///         account
    /// @notice A participant&#39;s contribution will be rejected if the presale
    ///         has been funded to the maximum amount
    function () payable {
        // A participant cannot send funds before the presale start date
        if (now &lt; PRESALE_START_DATE) throw;
        // A participant cannot send funds after the presale end date
        if (now &gt; PRESALE_END_DATE) throw;
        // A participant cannot send less than the minimum amount
        if (msg.value &lt; MINIMUM_PARTICIPATION_AMOUNT) throw;
        // A participant cannot send more than the maximum amount
        if (msg.value &gt; MAXIMUM_PARTICIPATION_AMOUNT) throw;
        // A participant cannot send funds if the presale has been reached the maximum
        // funding amount
        if (safeIncrement(totalFunding, msg.value) &gt; PRESALE_MAXIMUM_FUNDING) throw;
        // Register the participant&#39;s contribution
        addBalance(msg.sender, msg.value);
    }

    /// @notice The owner can withdraw ethers after the presale has completed,
    ///         only if the minimum funding level has been reached
    function ownerWithdraw(uint256 value) external onlyOwner {
        // The owner cannot withdraw before the presale ends
        if (now &lt;= PRESALE_END_DATE) throw;
        // The owner cannot withdraw if the presale did not reach the minimum funding amount
        if (totalFunding &lt; PRESALE_MINIMUM_FUNDING) throw;
        // Withdraw the amount requested
        if (!owner.send(value)) throw;
    }

    /// @notice The participant will need to withdraw their funds from this contract if
    ///         the presale has not achieved the minimum funding level
    function participantWithdrawIfMinimumFundingNotReached(uint256 value) external {
        // Participant cannot withdraw before the presale ends
        if (now &lt;= PRESALE_END_DATE) throw;
        // Participant cannot withdraw if the minimum funding amount has been reached
        if (totalFunding &gt;= PRESALE_MINIMUM_FUNDING) throw;
        // Participant can only withdraw an amount up to their contributed balance
        if (balanceOf[msg.sender] &lt; value) throw;
        // Participant&#39;s balance is reduced by the claimed amount.
        balanceOf[msg.sender] = safeDecrement(balanceOf[msg.sender], value);
        // Send ethers back to the participant&#39;s account
        if (!msg.sender.send(value)) throw;
    }

    /// @notice The owner can clawback any ethers after a date in the future, so no
    ///         ethers remain trapped in this contract. This will only be relevant
    ///         if the minimum funding level is not reached
    function ownerClawback() external onlyOwner {
        // The owner cannot withdraw before the clawback date
        if (now &lt; OWNER_CLAWBACK_DATE) throw;
        // Send remaining funds back to the owner
        if (!owner.send(this.balance)) throw;
    }

    /// @dev Keep track of participants contributions and the total funding amount
    function addBalance(address participant, uint256 value) private {
        // Participant&#39;s balance is increased by the sent amount
        balanceOf[participant] = safeIncrement(balanceOf[participant], value);
        // Keep track of the total funding amount
        totalFunding = safeIncrement(totalFunding, value);
        // Log an event of the participant&#39;s contribution
        LogParticipation(participant, value, now);
    }

    /// @dev Throw an exception if the amounts are not equal
    function assertEquals(uint256 expectedValue, uint256 actualValue) private constant {
        if (expectedValue != actualValue) throw;
    }

    /// @dev Add a number to a base value. Detect overflows by checking the result is larger
    ///      than the original base value.
    function safeIncrement(uint256 base, uint256 increment) private constant returns (uint256) {
        uint256 result = base + increment;
        if (result &lt; base) throw;
        return result;
    }

    /// @dev Subtract a number from a base value. Detect underflows by checking that the result
    ///      is smaller than the original base value
    function safeDecrement(uint256 base, uint256 increment) private constant returns (uint256) {
        uint256 result = base - increment;
        if (result &gt; base) throw;
        return result;
    }
}