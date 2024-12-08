// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// simple **"Counter"** contract. It allows you to increment a value 
// each time it's called, demonstrating basic contract functionality:
contract counterContract {

// public variable to hold the count
uint256 public count; 


// Function to increment the counter
function increment() public {
    count++;
}

// function to get the counter value

function getCount() public view returns (uint256) {
    // Using view is cheaper for gas efficiency rather than regular functions.
    // We don't need to modify the state, so view is the way to go.
    return count;
}
}