pragma solidity ^0.5.0;


import "./ProposalManager.sol";
import "./AccountManager.sol";
import "./ContractManager.sol";

//==============================================================
// SharedEco: main smart contract to support a shared economy DAO
// - User may join the DAO as provider or consumer
// - Generate proposal
// - Run vote process for available proposals
// - Approve a proposal
// - Generate contract and monitor its process QQasdf
//==============================================================

contract SharedEco {
    
    // create ProposalManager and AccountManager instances
    ProposalManager proposals = new ProposalManager();
    AccountManager accounts = new AccountManager();
    ContractManager contracts = new ContractManager();
    
    // list the relationship between item and account id
    mapping(string => uint) item_owner;
    mapping(string => uint) item_loaner;
    
    // a proposal record used to calculate hash in order to erify
    struct proposal_record {
        address recipient;
        uint    amount;
        uint    transactionData;
    }
    
    // list the relationship between proposal and id    
    mapping(uint => proposal_record)    proposal_table;
    
    // list the relationship between contract id and access code     
    mapping(uint => string)    accessCode_table;
    
    // list of currently available proposal ids
    uint[] available_prop;
    
    // total count of the owner and loaner
    uint owner_count = 0;
    uint loaner_count = 0;
    
    //========================================================================
    // Account Management 
    //========================================================================
    
    // user may use this function to setup their account
    function joinAsProvider(string memory name,
                            string memory item,
                            uint price) public payable {
                                
        // create an owner account 
        uint id = accounts.setOwner(name, item, price);
        item_owner[item] = id;
        owner_count++;
        
        // add sender to the whitelist
        proposals.add2whitelist(msg.sender);
    }
    
    // user may use this function to setup their account
    function joinAsBuyer(string memory name,
                         string memory item,
                         uint price) public {
        
        uint id = accounts.setLoaner(name, item, price, msg.sender);
        item_loaner[item] = id;
        loaner_count++;
    }
    
    function getOwnerCount() public view returns (uint) {
       return owner_count;
    }
 
 
    function getLoanerCount() public view returns (uint) {
       return loaner_count;
    }
    
    
    function getOwner(uint id) public view returns (uint,
                string memory,
                address,
                string memory,
                uint,
                bytes32) {
       return accounts.getOwner(id);
    }
    
    function getLoaner(uint id) public view returns (uint,
                string memory,
                address,
                string memory,
                uint,
                bytes32) {
       return accounts.getLoaner(id);
    }
    

    //========================================================================
    // Proposal Management 
    //========================================================================
    
    // generate random number
    function random() private view returns (uint8) {
       return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)))%251);
    }
   
    // generate a proposal based on item that user request
    function generateProposal(
        string memory _item,
        uint          _amount,
        string memory _description,
        uint          _beginDay,
        uint          _endDay
    ) payable public returns (uint) {
        
        // generate transactionData
        uint _transactionData = random();
        
        // collect information
        address _recipient = accounts.getOwnerAddr(item_owner[_item]);
        
        // generate a proposal
        uint id = proposals.newProposal( _recipient, 
                                         _amount,
                                         _description,
                                         _transactionData,
                                         1 weeks,
                                         _beginDay,
                                         _endDay);
        
        // store into the record
        proposal_table[id] = proposal_record(_recipient, _amount, _transactionData);
        
        // store into available proposals
        available_prop.push(id);
        available_prop.length++;
    } 
    
    // any miner may vote for the currently available proposals
    function VoteForProposal() public {
            
        if(available_prop.length <= 0) {
            return;
        }
        
        for(uint i=0; i< available_prop.length; i++) {
            // proposal id
            uint id = available_prop[i];
            
            proposals.vote(id,
                 proposal_table[id].recipient,
                 proposal_table[id].amount,
                 proposal_table[id].transactionData);
        }
    }
    
    //========================================================================
    // Contract Management 
    //========================================================================
    
    // execute the proposal when it meets the condition
    function ExecuteProposal(uint id) public returns (uint, string memory) {
        
        // generate a contract if proposal being approved
        if (proposals.verifyProposal(id)) {
            proposals.executeProposal(id);
        
        
            // create a new contract for it 
            uint cid = contracts.newContract(
                    proposals.getCreator(id),
                    proposals.getRecipient(id),
                    proposals.getAmount(id),
                    proposals.getBeginDay(id),
                    proposals.getEndDay(id));
            
            accessCode_table[cid] = contracts.generateAccessCode(cid); 
            return (cid, "contract has been created!");
        } 
        else {
            return (255, "Proposal has not yet met the conditions!");
        }
    }
    
    // retrieve access code for a contract 
    function getAccessCode(uint cid) public view returns (string memory) {
        return accessCode_table[cid];
    }
    
    // check if a contract is active or not
    function getContractStatus(uint cid) public view returns (bool) {
        return contracts.getStatus(cid);
    }
    
    // check if a contract is active or not
    function activateContract(uint cid) public {
        return contracts.activate(cid);
    }
    
    // check if a contract is active or not
    function deactivateContract(uint cid) public {
        return contracts.deactivate(cid);
    }
}
