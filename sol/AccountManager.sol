pragma solidity ^0.5.0;

//==============================================================
// Manage all the accounts:
// - Create accounts for owners
// - Create accounts for loaners
// - Generate hash code for items 
// - Link account with corresponding address
// - Provide interfaces to read information of accounts
//==============================================================

contract AccountManager {

    struct AccountInfo {
        string name;
        string item;
        uint   price;
        address addr;
        bytes32 itemhash;
    }
    
    mapping(uint => AccountInfo) m_owner;
    mapping(uint => AccountInfo) m_loaner;
    
    uint index_owner;
    uint index_loaner;
    
    // seed number used to generate hash code for item
    uint256 seed = 123;
    
    constructor() public {
        index_owner = 0;
        index_loaner = 0;
    }
    
    // used to generate hash code for item string
    function hashSeriesNumber(string memory item, uint256 number) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(number, item));
    }

    function setOwner(string memory _name,
                      string memory _item,
                      uint _price,
                      address _addr)
                      public returns (uint) {

        m_owner[index_owner].name  = _name;
        m_owner[index_owner].item  = _item;
        m_owner[index_owner].price = _price;
        m_owner[index_owner].addr  = _addr;
        m_owner[index_owner].itemhash = hashSeriesNumber(_item, seed);
        
        index_owner++;
        
        return index_owner-1;
    }
   
    function getOwnerCount() public view returns (uint) {
        return index_owner;
    }
    
    function getLoanerCount() public view returns (uint) {
        return index_loaner;
    }
    
    function removeOwner(uint id) public {
       delete m_owner[id];
    }
   
    function getOwner(uint id) public view returns (
                uint,
                string memory,
                address,
                string memory,
                uint,
                bytes32) {
       return (id,
               m_owner[id].name,
               m_owner[id].addr,
               m_owner[id].item,
               m_owner[id].price,
               m_owner[id].itemhash);
    }
   
   
    function setLoaner(string memory name,
                       string memory item,
                       uint price,
                       address payable addr)
                       public returns (uint) {
        
        m_loaner[index_loaner] = AccountInfo(name,
                                      item,
                                      price,
                                      addr,
                                      hashSeriesNumber(item, seed));
                                      
        index_loaner++;
        
        return index_loaner-1;
    }
   
    function removeLoaner(uint id) public {
       delete m_loaner[id];
    }
   
   
    function getLoaner(uint id) public view returns (
                uint,
                string memory,
                address,
                string memory,
                uint,
                bytes32) {
       return (id,
               m_loaner[id].name,
               m_loaner[id].addr,
               m_loaner[id].item,
               m_loaner[id].price,
               m_loaner[id].itemhash);
    }
    
    function getLoanerAddr(uint id) public view returns (address) {
       return m_loaner[id].addr;
    }
    
    function getOwnerAddr(uint id) public view returns (address) {
       return m_owner[id].addr;
    }
    
}
