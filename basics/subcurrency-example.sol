// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.26;
//https://docs.soliditylang.org/en/v0.8.28/introduction-to-smart-contracts.html#subcurrency-example

// This will only compiled via IR
contract Coin {
    // The keyword "public" makes variables accessible from other contracts

    address public minter;
    mapping(address => uint) public balances;

    // Events allow clients to react to specific contract changes you declare

    event Sent(address from, address to, uint amount);

    // Contructor code is only run when the contract is created

    constructor() {
        minter = msg.sender;

    }

    // Sends an amount of newly created coints to an address
    // Can only be called by the contract creator

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Errors allow you to provide information amount why an operation failed
    // They are retuned to the caller of the function
    
    error InsufficientBalance(uint requested, uint available);

    // Sends an amount of existing coins
    // From the any caller to an address

    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], InsufficientBalance(amount, balances[msg.sender]));
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
