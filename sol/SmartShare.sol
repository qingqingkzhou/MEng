pragma solidity ^0.5.0;

//==============================================================
// SharedEco: main smart contract to support a shared economy DAO
// - User may join the DAO as provider or consumer
// - Generate proposal
// - Run vote process for available proposals
// - Approve a proposal
// - Generate contract and monitor its process
//==============================================================

contract SmartShared {

    struct AccountInfo {
        string name;
        //string item;
        uint   price;
        address addr;
        bytes32 itemhash;
        bool ownerOrLoaner; // true: owner, false: loaner
    }
    
    mapping(uint => AccountInfo) m_users;
    
    uint user_index = 0;
    uint currentUser = 255;
    uint ownerUser = 255;
    uint loanerUser = 255;
    bool pendingProposal = false;
    
    // seed number used to generate hash code for item
    uint256 seed = 123;
    
    // A proposal
    struct Proposal {
        // date proposed 
        uint beginDay;
        uint endDay;

        // True if voting count limit has been reached, the votes have been counted,
        // and the majority said yes
        bool proposalPassed;
        bool active;
        
        // A hash to check validity of a proposal
        bytes32 proposalHash;
        // Deposit in wei the creator added when submitting their proposal. It
        // is taken from the msg.value of a newProposal call.
        uint proposalDeposit;
        
        string accessCode;
    }
    
    Proposal currentProposal;
    
    // used to generate hash code for item string
    function hashSeriesNumber(string memory item, uint256 number) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(number, item));
    }
    
    function setAccountStep1(string memory _name,
                      string memory _item,
                      uint _price)
                      public {

        m_users[user_index].name = _name;
        m_users[user_index].price = _price;
        m_users[user_index].itemhash = hashSeriesNumber(_item, seed);
    }
    
    function setAccountStep2(
                      bool ownerOruser)
                      public {

        m_users[user_index].addr  = msg.sender;
        m_users[user_index].ownerOrLoaner = ownerOruser;
        user_index++;
    }

    function login(string memory _user) public {
        
        currentUser = 255;
        
        for (uint i=0; i < user_index; i++) {
            
            if( keccak256(abi.encodePacked(m_users[i].name)) ==
                keccak256(abi.encodePacked(_user))) {
                // found user
                currentUser = i;
            }
        }
    }
    
    function getCurrentUser() public view returns (string memory) {
        if(currentUser == 255) {
            return "User not found";
        }
        else {
            return m_users[currentUser].name;    
        }
    }
    
    function doesItemExist(string memory _item) public {
        
        ownerUser = 255;
        
        for (uint i=0; i < user_index; i++) {
            
            if( m_users[i].ownerOrLoaner &&
                (hashSeriesNumber(_item, seed) == m_users[i].itemhash)) {
                // found item
                ownerUser = i;
            }
        }
    }
    
    function getItemOwner(uint _price) public view returns (string memory) {
        if(ownerUser == 255) {
            return "No matching item found";
        }
        else {
            if(_price < m_users[ownerUser].price) {
                return "Found matching item! But price is higher than expected!";
            }
            else {
                return m_users[ownerUser].name;    
            }
        }
    }
    
    function getUserCount() public view returns (uint) {
        return user_index;
    }
    
    function createProposal(uint _bday, uint _eday) public {
        
        if(ownerUser != 255 && currentUser !=255) {
            // generate Proposal
            
            // currentProposal.owner = m_users[ownerUser].addr;
            // currentProposal.loaner = m_users[currentUser].addr;
            // currentProposal.itemhash = m_users[ownerUser].itemhash;
            // currentProposal.amount = m_users[ownerUser].price;
            currentProposal.beginDay = _bday;
            currentProposal.endDay = _eday;
            currentProposal.proposalPassed = false;
            currentProposal.active = false;
            //currentProposal.proposalHash = hashSeriesNumber(m_users[ownerUser].name, m_users[ownerUser].price); // proposal hash
            //currentProposal.proposalDeposit = m_users[ownerUser].price;
        }
    }
    
    function setProposalStatus() public {
        
        if(ownerUser != 255 && currentUser !=255) {
            pendingProposal = true;
            loanerUser = currentUser;
        }
    }

    
    function getProposal() public view returns (string memory,
                        string memory, bytes32, uint, uint, uint, bool, bool) {
        
        if(ownerUser != 255 && currentUser !=255) {
            // generate Proposal
            
            return (m_users[ownerUser].name, 
                    m_users[loanerUser].name,
                    m_users[ownerUser].itemhash,
                    m_users[ownerUser].price,
                    currentProposal.beginDay,
                    currentProposal.endDay,
                    currentProposal.proposalPassed,
                    currentProposal.active);
        }
    }
    
    function hasPendingProposal() public view returns (bool) {
        
        if( pendingProposal &&
            (keccak256(abi.encodePacked(m_users[ownerUser].name)) ==
                keccak256(abi.encodePacked(m_users[currentUser].name)))) {
            return true;
        }
        else {
            return false;
        }
    }
    
    function ownerApproveProposal(bool _approveOrReject) public {
        
        if(ownerUser != 255 && currentUser !=255) {
            
            if(m_users[currentUser].ownerOrLoaner) {
                currentProposal.proposalPassed = _approveOrReject;
            }
        }
    }
    
    function activateProposal(bool _active) public {
        
        if(ownerUser != 255 && currentUser !=255 &&
            currentProposal.proposalPassed) {
                currentProposal.active = _active;
                pendingProposal = false;
        }
    }
    
    function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        
        return string(bstr);
    }
    
    // generate access code
    function generateAccessCode() public {
        if( currentProposal.active) {
            uint256 num = uint256(keccak256(abi.encodePacked(
                        block.timestamp, now,
                        currentProposal.beginDay)))%251;
                        
            currentProposal.accessCode = uint2str(num);
        }
        else {
            currentProposal.accessCode = "";
        }
    }
    
    // get access code
    function getAccessCode() public view returns (string memory) {
        
        if( currentProposal.active ||
            (
                (keccak256(abi.encodePacked(m_users[loanerUser].name)) ==
                 keccak256(abi.encodePacked(m_users[currentUser].name))) || 
                (keccak256(abi.encodePacked(m_users[ownerUser].name)) ==
                 keccak256(abi.encodePacked(m_users[currentUser].name)))
            )
           ) {
            return currentProposal.accessCode;
        }
        else {
            return "No Access Code Available";
        }
    }
}
