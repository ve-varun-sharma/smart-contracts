// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// creating a basic ERC-20 compatible token transfer contract in Solidity.

contract VeToken { 
    // Total supply of tokens
    uint256 public totalSupply = 1000; // initial supply set here
    // Mapping of addresses to their balances

    mapping(address => uint256) public balanceOf;

    // Event emitted when a transfer occurs
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor() {
        balanceOf[msg.sender] = totalSupply; // Give the deployer all tokens initially
    }

    function transfer(address to, uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;    
        emit Transfer(msg.sender, to, amount);
    }
}