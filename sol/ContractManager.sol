pragma solidity ^0.5.0;

//==============================================================
// Manage all the contracts:
// - Create contract once a proposal being approved
// - Setup aggreed amount and expiration day and any condition
// - Monitors the term of the contract
// - Activate and terminate a contract
//==============================================================

contract ContractManager {

    // A proposal
    struct shared_contract {
        // parties that involved in this contract 
        address owner;
        address loaner;
        
        // The amount agreed
        uint amount;
        
        // A unix timestamp, denoting the end of the contract 
        uint beginDay;
        
        // A unix timestamp, denoting the end of the contract 
        uint endDay;
        
        // True if the contract is active
        bool active;
        
        // Access code attached to this contract 
        string code;
    }
    
    mapping(uint => shared_contract) contract_table;
    
    uint index = 0;
    
    
    // create a new contract
    // return the access code
    // make the contract active when the begin time reached
    function newContract(
        address _owner_id,
        address _loaner_id,
        uint _amount,
        uint _beginDay,
        uint _endDay
    ) public returns (uint) {

        if (msg.sender == address(this)) {
            //to prevent a 51% attacker to convert the ether into deposit
            return 255;
        }
        
        // create contract contents
        contract_table[index].owner = _owner_id;
        contract_table[index].loaner = _loaner_id;
        contract_table[index].amount = _amount;
        contract_table[index].beginDay = _beginDay;
        contract_table[index].endDay = _endDay;
        contract_table[index].code = string(generateAccessCode(index));
        
        if (now >= _beginDay) {
            contract_table[index].active = true;    
        }
        else {
            contract_table[index].active = false;
        }
        
        ++index;
        
        return index-1;
    }
    
    // activate a contract
    function activate(uint id) public {

        contract_table[id].active = true;
    }
    
    // de-activate a contract
    function deactivate(uint id) public {

        contract_table[id].active = false;
    }
    
    // true: active        false: inactive
    function getStatus(uint id) public view returns(bool) {

        return contract_table[id].active;
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
    function generateAccessCode(uint id) public view returns (string memory) {
        
        uint256 num = uint256(keccak256(abi.encodePacked(
                        id,
                        block.timestamp, now,
                        contract_table[id].amount)))%251;
                        
        return uint2str(num);
    }
}
