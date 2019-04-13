pragma solidity ^0.5.0;


//==============================================================
// Manage all the proposals:
// - Create Proposal
// - Vote for a Proposal: based on the hash code integrity
// - Generate hash code 
// - Verify a proposal: check vote 
// - Execute a proposal: transfer the money
//==============================================================

contract ProposalManager {

    // The minimum debate period that a generic proposal can have
    uint constant minProposalDebatePeriod = 1 weeks;
    // The whitelist: List of addresses the DAO is allowed to send ether to
    mapping (address => bool) public allowedRecipients;
    // The minimum deposit (in wei) required to submit any proposal
    uint public proposalDeposit = 2;
    // The minimum votes a proposal has to hold
    uint public minVoteCount = 10;
    // The minimum votes a proposal has to hold
    uint public maxVoteNoCount = minVoteCount/10;
    
    
    // A proposal
    struct Proposal {
        // Address of the proposal creator
        address creator;
        // The address where the `amount` will go to if the proposal is accepted
        address recipient;
        // A plain text description of the proposal
        string description;
        // The amount to transfer to `recipient` if the proposal is accepted.
        uint amount;
        
        // date proposed 
        uint beginDay;
        uint endDay;
        
        // A unix timestamp, denoting the end of the voting period
        uint votingDeadline;
        // True if the proposal's votes have yet to be counted, otherwise False
        bool open;
        // True if voting count limit has been reached, the votes have been counted,
        // and the majority said yes
        bool proposalPassed;
        // A hash to check validity of a proposal
        bytes32 proposalHash;
        // Deposit in wei the creator added when submitting their proposal. It
        // is taken from the msg.value of a newProposal call.
        uint proposalDeposit;
        // Number of Tokens in favor of the proposal
        uint yes_count;
        // Number of Tokens opposed to the proposal
        uint no_count;
        // Simple mapping to check if a shareholder has voted for it
        mapping (address => bool) votedYes;
        // Simple mapping to check if a shareholder has voted against it
        mapping (address => bool) votedNo;
    }
   
    mapping (uint => Proposal) proposals;
    uint index = 0;
    
    
    // create a new Proposal
    // the contract itself cannot create the proposal
    // only user can create proposal
    // recipient has to be listed in the whitelist to be able to create proposal
    function newProposal(
        address _recipient,
        uint    _amount,
        string memory _description,
        uint _transactionData,
        uint64 _debatingPeriod,
        uint _beginDay,
        uint _endDay
    ) payable public returns (uint) {

        if (!allowedRecipients[_recipient]
            //|| _debatingPeriod < minProposalDebatePeriod
            || _debatingPeriod > 8 weeks
            || msg.value < proposalDeposit
            || msg.sender == address(this) //to prevent a 51% attacker to convert the ether into deposit
            )
                return 255;
        
        // create proposal contents
        proposals[index].creator = msg.sender;
        proposals[index].recipient = _recipient;
        proposals[index].description = _description;
        proposals[index].amount = _amount;
        proposals[index].votingDeadline = now + _debatingPeriod;
        proposals[index].beginDay = _beginDay;
        proposals[index].endDay = _endDay;
        proposals[index].open = true;
        proposals[index].proposalPassed = false;
        
        // create hash for the proposal
        proposals[index].proposalHash = keccak256(abi.encodePacked(_recipient, _amount, _transactionData)); // proposal hash
        proposals[index].proposalDeposit = msg.value; //proposalDeposit
        proposals[index].yes_count = 0;
        proposals[index].no_count = 0;
        
        ++index;
        
        return index-1;
    }

    
    // add accepted recipient to the whitelist
    function add2whitelist(address _recipient) public {
        allowedRecipients[_recipient] = true;
    }
    
    // vote for a proposal
    function vote(
        uint id,
        address _recipient,
        uint _amount,
        uint _transactionData) public {
        
        if (proposals[id].votedYes[msg.sender]
            || proposals[id].votedNo[msg.sender]
            || (!proposals[id].open)) {
            // same voter cannot vote multiple timestamp
            return;
        }
        
        // verify hash
        if (proposals[id].proposalHash ==
            keccak256(abi.encodePacked(_recipient, _amount, _transactionData))) {
            proposals[id].yes_count++;
            proposals[id].votedYes[msg.sender] = true;
        }
        else {
            proposals[id].no_count++;
            proposals[id].votedNo[msg.sender] = true;
        }
    }
    
    
    // verify a proposal
    function verifyProposal(uint id) public returns (bool) {
        
        // check if total vote count is enough
        if ((proposals[id].yes_count + proposals[id].no_count) < minVoteCount) {
            return false;
        }
        
        // close the vote window
        proposals[id].open = false;
        
        // check the yes count and no count
        if (proposals[id].yes_count >= (minVoteCount - maxVoteNoCount)) {
            proposals[id].proposalPassed = true;
        }
        else {
            proposals[id].proposalPassed = false;   
        }
        
        return proposals[id].proposalPassed;
    }
    
    // add accepted recipient to the whitelist
    function executeProposal(uint id) public {
        
        // transfer the money
        msg.sender.transfer(proposals[id].proposalDeposit);
    }
                                  
    // get proposal content for creating contract 
    function getCreator(uint id) public view returns(address) {
        return proposals[id].creator;
    }
    
    // get proposal content for creating contract 
    function getRecipient(uint id) public view returns(address) {
        return proposals[id].recipient;
    }
    
    function getAmount(uint id) public view returns (uint) {
        return proposals[id].amount;        
    }
    
    function getBeginDay(uint id) public view returns (uint) {
        return proposals[id].beginDay;        
    }
    
    function getEndDay(uint id) public view returns (uint) {
        return proposals[id].endDay;        
    }
    
    function gethash(uint id) public view returns (bytes32) {
        return proposals[id].proposalHash;        
    }
}
