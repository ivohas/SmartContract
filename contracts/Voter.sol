// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "./Election.sol";

contract Voter is Election {
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(uint256 => mapping(address => uint256)) public voterRegistry;

    modifier notVoted(uint256 electionId) {
        require(!hasVoted[electionId][msg.sender], "You have already voted");
        _;
    }

    function vote(uint256 electionId, uint256 partyId) public electionOngoing(electionId) notVoted(electionId) {
        ElectionDetails storage election = elections[electionId];
        require(block.timestamp >= election.startTime, "Election has not started yet");
        require(block.timestamp <= election.endTime, "Election has ended");
        require(partyId <= election.partyCount, "Invalid party ID");

        hasVoted[electionId][msg.sender] = true;
        voterRegistry[electionId][msg.sender] = partyId;

        election.parties[partyId].voteCount++;
    }
}
    