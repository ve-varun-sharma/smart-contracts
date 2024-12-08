// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
// Psudeocode:1
// **State Variables:**
//    * `buyer`: Address of the buyer participating in the escrow.
//    * `seller`: Address of the seller participating in the escrow.
//    * `amount`: The agreed-upon amount of funds to be held in escrow.
//    * `isReleased`: A boolean flag indicating whether the funds have been released or not (initially false).
contract simpleEscrow {

    address public buyer;
    address public seller;
    uint256 public amount;
    bool public isReleased;

    constructor(address, _buyer, address, _seller, uint256 _amount) {
        buyer = _buyer;
        seller = _seller;
        amount = _amount;
        isReleased = false;

    }
    function releaseFunds() public {
        require(msg.sender == seller, "only the seller can release the funds.");
        require(!isReleased, "Funds have already been released.");
        payable(buyer).transfer(amount);
        isReleased = true;
    }

}