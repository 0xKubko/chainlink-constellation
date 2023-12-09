// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract VotingRelayer {

    event VotesPlaced(bytes unprocessedVotes);
    event VotesThresholdSet(uint256 votesThreshold);

    struct Vote {
        uint8 option;
        uint8 weight;
    }

    Vote[] public unprocessedVotes;
    uint256 public votesThreshold = 3;
    bytes public encodedVotes;

    constructor(uint256 _votesThreshold) {
        votesThreshold = _votesThreshold;
    }

    function emitVoteLog() internal {
        emit VotesPlaced(encodedVotes);
        delete unprocessedVotes;
        delete encodedVotes;
    }

    function vote(uint8 _option, uint8 _weight) public {
        // this could include logic checking double-voting, eligibility, etc.
        unprocessedVotes.push(Vote(_option, _weight));

        encodedVotes = abi.encodePacked(encodedVotes, _option, _weight);

        // if 3 votes are placed, emit the log & reset the votes
        if (unprocessedVotes.length == votesThreshold) {
            emitVoteLog();
        }
    }

    function setVotesThreshold(uint256 _votesThreshold) public {
        votesThreshold = _votesThreshold;
        emit VotesThresholdSet(_votesThreshold);
    }
}
