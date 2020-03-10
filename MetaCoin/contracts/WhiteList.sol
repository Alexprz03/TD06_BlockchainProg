  pragma solidity ^0.6.1;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";

contract Whitelist is Ownable {
   mapping (address => bool) members;

   constructor() public Ownable() {
   }

   function addMember(address _member) public onlyOwner{
       members[_member] = true;
   }
}