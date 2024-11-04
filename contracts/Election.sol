// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./Admin.sol";

contract Election is Admin {
    struct Party {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    struct ElectionDetails {
        uint256 id;
        string name;
        uint256 startTime;
        uint256 endTime;
        mapping(uint256 => Party) parties;
        uint256 partyCount;
    }

    mapping(uint256 => ElectionDetails) public elections;
    uint256 public electionCount;

    // Modifier to ensure the election is ongoing (based on start and end times)
    modifier electionOngoing(uint256 electionId) {
        require(
            block.timestamp >= elections[electionId].startTime && 
            block.timestamp <= elections[electionId].endTime,
            "Election is closed"
        );
        _;
    }

    // Create an election
    function createElection(string memory _name, uint256 _startTime, uint256 _endTime) public onlyAdmin {
        require(_endTime > _startTime, "End time must be after start time");
        
        electionCount++;
        ElectionDetails storage newElection = elections[electionCount];
        newElection.id = electionCount;
        newElection.name = _name;
        newElection.startTime = _startTime;
        newElection.endTime = _endTime;
    }

    // Add a party to an election
    function addParty(uint256 electionId, string memory _partyName) public onlyAdmin {
        ElectionDetails storage election = elections[electionId];
        require(block.timestamp < election.startTime, "Cannot add parties to a started election");
        
        election.partyCount++;
        election.parties[election.partyCount] = Party(election.partyCount, _partyName, 0);
    }

    // Get election results (only available after election ends)
    function getResults(uint256 electionId) public view returns (Party[] memory) {
        ElectionDetails storage election = elections[electionId];
        require(block.timestamp > election.endTime, "Election is still ongoing");

        Party[] memory results = new Party[](election.partyCount);
        for (uint256 i = 1; i <= election.partyCount; i++) {
            results[i - 1] = election.parties[i];
        }

        return results;
    }
}
