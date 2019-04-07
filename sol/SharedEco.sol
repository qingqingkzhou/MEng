pragma solidity ^0.4.6;

contract SharedEco {
    
   string m_name;
   string m_item;
   uint   m_price;
   
   function setOwner(string name, string item, uint price) public {
       m_name = name;
       m_item = item;
       m_price = price;
   }
   
   function getOwner() public constant returns (string, string, uint) {
       return (m_name, m_item, m_price);
   }
    
}