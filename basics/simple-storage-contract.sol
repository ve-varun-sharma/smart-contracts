// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// * **Simple Storage:** Create a contract that stores a single piece of data (like a string or number) and 
// allows it to be read and update

contract SimpleStorage {
    string public storedDataString;


    function storeData(string calldata _storedDataString) public {
        storedDataString = _storedDataString;
    }

    function getData() public view returns (string memory) {
        return storedDataString;
    }

}