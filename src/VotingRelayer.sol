// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract VotingRelayer {
    // emitted when 3 votes are placed
    event VotesPlaced(address indexed msgSender);

    uint256 public votesNum = 0;

    constructor() {}

    function emitVoteLog() public {
        emit VotesPlaced(msg.sender);
        votesNum = 0;
    }

    function vote() public {
        votesNum++;
        if (votesNum == 2) {
            emitVoteLog();
        }
    }
}
