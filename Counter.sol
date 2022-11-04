// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Counter{
    string public name;
    uint public count;


    constructor(string memory _name, uint _initialCount){
        name = _name;
        count = _initialCount;
    }

    /* function increment() public returns (uint newCount) {
        count ++; 
    }
 */
    /* function decrement() public returns (uint newCount) {
        count --; 
    } */

    function getCount() public view returns(uint) {
        return count;
    }

    function getName() public view returns(string memory CurrentName){
        return name;
    }

    function setName(string memory _newName) public returns(string memory newName){
        name = _newName;
        return name;
    }

}