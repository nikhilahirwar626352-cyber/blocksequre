// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockSecureVotingSystem {

    // Struct for candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Struct for voters
    struct Voter {
        bool hasVoted;
        uint voteTo;
    }

    address public admin;
    bool public votingActive;

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
    uint public candidatesCount;

    constructor() {
        admin = msg.sender;
    }

    // ✅ Function 1: Add candidate (only admin)
    function addCandidate(string memory _name) public {
        require(msg.sender == admin, "Only admin can add candidates");
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
    }

    // ✅ Function 2: Start or stop voting (only admin)
    function toggleVotingStatus(bool _status) public {
        require(msg.sender == admin, "Only admin can change voting status");
        votingActive = _status;
    }

    // ✅ Function 3: Cast vote
    function vote(uint _candidateId) public {
        require(votingActive, "Voting is not active");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].voteTo = _candidateId;

        candidates[_candidateId].voteCount++;
    }

    // ✅ Function 4: Get candidate details
    function getCandidate(uint _candidateId) public view returns (string memory, uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate");
        Candidate memory c = candidates[_candidateId];
        return (c.name, c.voteCount);
    }
}

