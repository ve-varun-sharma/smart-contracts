// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

// Pseudocode for a Basic Voting Contract

// State Variables:

// voters: A mapping to store whether an address has voted
// proposals: A mapping to store the number of votes for each proposal
// numProposals: The total number of proposals

// Functions:

// vote(uint _proposal):
// Check if the sender has already voted
// If not, increment the vote count for the specified proposal
// Mark the sender as having voted
// winner():
// Find the proposal with the highest number of votes
// Return the index of the winning proposal

contract Voting {
    mapping(address => bool) public voters;
    mapping(uint => uint) public proposals;

    uint public numProposals;

    constructor(uint _numProposals) {
        numProposals = _numProposals;
    }

    function vote(uint _proposal) public {
        require(!voters[msg.sender], "Already voted.");
        require(_proposal < numProposals, "Invalid proposal.");

        voters[msg.sender] = true;
        proposals[_proposal]++;
    }

    function winner() public view returns (uint) {
        uint winningProposal = 0;
        uint winningVoteCount = 0;

        for (uint p = 0; p < numProposals; p++) {
            if (proposals[p] > winningVoteCount) {
                winningProposal = p;
                winningVoteCount = proposals[p];
            }
        }

        return winningProposal;
    }
}
