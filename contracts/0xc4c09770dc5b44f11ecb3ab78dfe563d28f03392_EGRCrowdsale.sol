pragma solidity 0.4.18;


contract EngravedToken {
    uint256 public totalSupply;
    function issue(address, uint256) public returns (bool) {}
    function balanceOf(address) public constant returns (uint256) {}
    function unlock() public returns (bool) {}
    function startIncentiveDistribution() public returns (bool) {}
    function transferOwnership(address) public {}
    function owner() public returns (address) {}
}


contract EGRCrowdsale {
    // Crowdsale details
    address public beneficiary;
    address public confirmedBy; // Address that confirmed beneficiary

    // Maximum tokens supply
    uint256 public maxSupply = 1000000000; // 1 billion

    // Minum amount of ether to be exchanged for EGR
    uint256 public minAcceptedAmount = 10 finney; // 0.01 ETH

    //Amount of free tokens per user in airdrop period
    uint256 public rateAirDrop = 1000;

    // Number of airdrop participants
    uint256 public airdropParticipants;

    //Maximum number of airdrop participants
    uint256 public maxAirdropParticipants = 500;

    // Check if this is the first participation in the airdrop
    mapping (address =&gt; bool) public participatedInAirdrop;

    // ETH to EGR rate
    uint256 public rateAngelsDay = 100000;
    uint256 public rateFirstWeek = 80000;
    uint256 public rateSecondWeek = 70000;
    uint256 public rateThirdWeek = 60000;
    uint256 public rateLastWeek = 50000;

    uint256 public airdropEnd = 3 days;
    uint256 public airdropCooldownEnd = 7 days;
    uint256 public rateAngelsDayEnd = 8 days;
    uint256 public angelsDayCooldownEnd = 14 days;
    uint256 public rateFirstWeekEnd = 21 days;
    uint256 public rateSecondWeekEnd = 28 days;
    uint256 public rateThirdWeekEnd = 35 days;
    uint256 public rateLastWeekEnd = 42 days;

    enum Stages {
        Airdrop,
        InProgress,
        Ended,
        Withdrawn,
        Proposed,
        Accepted
    }

    Stages public stage = Stages.Airdrop;

    // Crowdsale state
    uint256 public start;
    uint256 public end;
    uint256 public raised;

    // EGR EngravedToken
    EngravedToken public engravedToken;

    // Invested balances
    mapping (address =&gt; uint256) internal balances;

    struct Proposal {
        address engravedAddress;
        uint256 deadline;
        uint256 approvedWeight;
        uint256 disapprovedWeight;
        mapping (address =&gt; uint256) voted;
    }

    // Ownership transfer proposal
    Proposal public transferProposal;

    // Time to vote
    uint256 public transferProposalEnd = 7 days;

    // Time between proposals
    uint256 public transferProposalCooldown = 1 days;

    /**
     * Throw if at stage other than current stage
     *
     * @param _stage expected stage to test for
     */
    modifier atStage(Stages _stage) {
        require(stage == _stage);
        _;
    }

    /**
     * Throw if at stage other than current stage
     *
     * @param _stage1 expected stage to test for
     * @param _stage2 expected stage to test for
     */
    modifier atStages(Stages _stage1, Stages _stage2) {
        require(stage == _stage1 || stage == _stage2);
        _;
    }

    /**
     * Throw if sender is not beneficiary
     */
    modifier onlyBeneficiary() {
        require(beneficiary == msg.sender);
        _;
    }

    /**
     * Throw if sender has a EGR balance of zero
     */
    modifier onlyTokenholders() {
        require(engravedToken.balanceOf(msg.sender) &gt; 0);
        _;
    }

    /**
     * Throw if the current transfer proposal&#39;s deadline
     * is in the past
     */
    modifier beforeDeadline() {
        require(now &lt; transferProposal.deadline);
        _;
    }

    /**
     * Throw if the current transfer proposal&#39;s deadline
     * is in the future
     */
    modifier afterDeadline() {
        require(now &gt; transferProposal.deadline);
        _;
    }

    /**
     * Most params are hardcoded for clarity
     *
     * @param _engravedTokenAddress The address of the EGR EngravedToken contact
     * @param _beneficiary Company address
     * @param _start airdrop start date
     */
    function EGRCrowdsale(address _engravedTokenAddress, address _beneficiary, uint256 _start) public {
        engravedToken = EngravedToken(_engravedTokenAddress);
        beneficiary = _beneficiary;
        start = _start;
        end = start + 42 days;
    }

    /**
     * Receives ETH and issue EGR EngravedTokens to the sender
     */
    function() public payable atStage(Stages.InProgress) {
        // Crowdsale not started and not ended yet
        // Enforce min amount
        require(now &gt; start &amp;&amp; now &lt; end &amp;&amp; msg.value &gt;= minAcceptedAmount);

        uint256 valueInEGR = toEGR(msg.value);

        require((engravedToken.totalSupply() + valueInEGR) &lt;= (maxSupply * 10**3));
        require(engravedToken.issue(msg.sender, valueInEGR));

        uint256 received = msg.value;
        balances[msg.sender] += received;
        raised += received;
    }

    /**
     * Get balance of `_investor`
     *
     * @param _investor The address from which the balance will be retrieved
     * @return The balance
     */
    function balanceOf(address _investor) public view returns (uint256 balance) {
        return balances[_investor];
    }

    /**
     * For testing purposes
     *
     * @return The beneficiary address
     */
    function confirmBeneficiary() public onlyBeneficiary {
        confirmedBy = msg.sender;
    }

    /**
     * Convert `_wei` to an amount in EGR using
     * the current rate
     *
     * @param _wei amount of wei to convert
     * @return The amount in EGR
     */
    function toEGR(uint256 _wei) public view returns (uint256 amount) {
        uint256 rate = 0;
        if (stage != Stages.Ended &amp;&amp; now &gt;= start &amp;&amp; now &lt;= end) {
            // Check for cool down after airdrop
            if (now &lt;= start + airdropCooldownEnd) {
                rate = 0;
            // Check for AngelsDay
            } else if (now &lt;= start + rateAngelsDayEnd) {
                rate = rateAngelsDay;
            // Check for cool down after the angels day
            } else if (now &lt;= start + angelsDayCooldownEnd) {
                rate = 0;
            // Check first week
            } else if (now &lt;= start + rateFirstWeekEnd) {
                rate = rateFirstWeek;
            // Check second week
            } else if (now &lt;= start + rateSecondWeekEnd) {
                rate = rateSecondWeek;
            // Check third week
            } else if (now &lt;= start + rateThirdWeekEnd) {
                rate = rateThirdWeek;
            // Check last week
            } else if (now &lt;= start + rateLastWeekEnd) {
                rate = rateLastWeek;
            }
        }
        require(rate != 0); // Check for cool down periods
        return _wei * rate * 10**3 / 1 ether; // 10**3 for 3 decimals
    }

    /**
    * Function to participate in the airdrop
    */
    function claim() public atStage(Stages.Airdrop) {
        // Crowdsal not started yet nor Airdrop expired
        // Only once per address
        require(airdropParticipants &lt; maxAirdropParticipants
            &amp;&amp; now &gt; start &amp;&amp; now &lt; start + airdropEnd
            &amp;&amp; participatedInAirdrop[msg.sender] == false);

        require(engravedToken.issue(msg.sender, rateAirDrop * 10**3));

        participatedInAirdrop[msg.sender] = true;
        airdropParticipants += 1;
    }

    /**
     * Function to end the airdrop and start crowdsale
     */
    function endAirdrop() public atStage(Stages.Airdrop) {
        require(now &gt; start + airdropEnd);
        stage = Stages.InProgress;
    }

    /**
     * Function to end the crowdsale by setting
     * the stage to Ended
     */
    function endCrowdsale() public atStage(Stages.InProgress) {
        // Crowdsale not ended yet
        require(now &gt; end);
        stage = Stages.Ended;
    }

    /**
     * Transfer raised amount to the company address
     */
    function withdraw() public onlyBeneficiary atStage(Stages.Ended) {
        require(beneficiary.send(raised));
        stage = Stages.Withdrawn;
    }

    /**
     * Transfer custom amount to a custom address
     */
    function withdrawCustom(uint256 amount, address addressee) public onlyBeneficiary atStage(Stages.Ended) {
        require(addressee.send(amount));
        raised = raised - amount;
        if (raised == 0) {
            stage = Stages.Withdrawn;
        }
    }

    /**
     * Emergency stage change to Withdrawn
     */
    function moveStageWithdrawn() public onlyBeneficiary atStage(Stages.Ended) {
        stage = Stages.Withdrawn;
    }

    /**
     * Propose the transfer of the EngravedToken contract ownership
     * to `_engravedAddress`
     *
     * @param _engravedAddress the address of the proposed EngravedToken owner
     */
    function proposeTransfer(address _engravedAddress) public onlyBeneficiary
    atStages(Stages.Withdrawn, Stages.Proposed) {
        // Check for a pending proposal
        require(stage != Stages.Proposed || now &gt; transferProposal.deadline + transferProposalCooldown);

        transferProposal = Proposal({
            engravedAddress: _engravedAddress,
            deadline: now + transferProposalEnd,
            approvedWeight: 0,
            disapprovedWeight: 0
        });

        stage = Stages.Proposed;
    }

    /**
     * Allows EGR holders to vote on the poposed transfer of
     * ownership. Weight is calculated directly, this is no problem
     * because EngravedTokens cannot be transferred yet
     *
     * @param _approve indicates if the sender supports the proposal
     */
    function vote(bool _approve) public onlyTokenholders beforeDeadline atStage(Stages.Proposed) {
        // One vote per proposal
        require(transferProposal.voted[msg.sender] &lt; transferProposal.deadline - transferProposalEnd);

        transferProposal.voted[msg.sender] = now;
        uint256 weight = engravedToken.balanceOf(msg.sender);

        if (_approve) {
            transferProposal.approvedWeight += weight;
        } else {
            transferProposal.disapprovedWeight += weight;
        }
    }

    /**
     * Calculates the votes and if the majority weigt approved
     * the proposal the transfer of ownership is executed.

     * The Crowdsale contact transferres the ownership of the
     * EngravedToken contract to Engraved
     */
    function executeTransfer() public afterDeadline atStage(Stages.Proposed) {
        // Check approved
        require(transferProposal.approvedWeight &gt; transferProposal.disapprovedWeight);
        require(engravedToken.unlock());
        require(engravedToken.startIncentiveDistribution());

        engravedToken.transferOwnership(transferProposal.engravedAddress);

        require(engravedToken.owner() == transferProposal.engravedAddress);

        stage = Stages.Accepted;
    }

}