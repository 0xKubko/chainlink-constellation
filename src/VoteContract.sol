// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract VoteContract {
    struct Vote {
        uint8 option;
        uint8 weight;
    }

    Vote[] public obtainedVotes;

    function obtainVotes(uint8[][] memory votes) public {
        for (uint256 i = 0; i < votes.length; i++) {
            obtainedVotes.push(Vote(votes[i][0], votes[i][1]));
        }
    }
}
