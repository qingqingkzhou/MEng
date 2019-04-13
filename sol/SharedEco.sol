pragma solidity ^0.5.0;

contract SharedEco {
    
   struct AccountInfo {
    string name;
    string item;
    uint   price;
   }
   
   AccountInfo m_owner;
   AccountInfo m_loaner;

   function setOwner(string memory name, string memory item, uint price) public {
       m_owner.name = name;
       m_owner.item = item;
       m_owner.price = price;
   }
   
   function getOwner() public view returns (string memory, string memory, uint) {
       return (m_owner.name, m_owner.item, m_owner.price);
   }
   
   function setLoaner(string memory name, string memory item, uint price) public {
       m_loaner.name = name;
       m_loaner.item = item;
       m_loaner.price = price;
   }
   
   function getLoaner() public view returns (string memory, string memory, uint) {
       return (m_loaner.name, m_loaner.item, m_loaner.price);
   }
   
   function approveDeal(address payable owner_addr) public {
       owner_addr.transfer(1);
   }
    
}