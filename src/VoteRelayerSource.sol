// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {Withdraw} from "./utils/Withdraw.sol";

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract VoteRelayerSource is Withdraw {
    address immutable i_router;
    address immutable i_link;
    uint8[][] public unprocessedVotes;
    uint256 public votesThreshold;
    address public receiver;
    uint64 public destinationChainSelector;

    event MessageSent(bytes32 messageId);
    event VotePlaced(uint8 option, uint8 weight);
    event VotesThresholdSet(uint256 votesThreshold);
    event ReceiverSet(address receiver);
    event DestinationChainSelectorSet(uint64 destinationChainSelector);

    constructor(address _router, address _link, uint256 _votesThreshold, address _receiver, uint64 _destinationChainSelector) {
        i_router = _router;
        i_link = _link;
        votesThreshold = _votesThreshold;
        receiver = _receiver;
        destinationChainSelector = _destinationChainSelector;
    }

    function vote(uint8 _option, uint8 _weight) public {
        // this could include logic checking double-voting, eligibility, etc.
        unprocessedVotes.push([_option, _weight]);

        emit VotePlaced(_option, _weight);

        // relay with CCIP when threshold is met
        if (unprocessedVotes.length == votesThreshold) {
            Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
                receiver: abi.encode(receiver),
                data: abi.encodeWithSignature("obtainVotes(uint8[][])", unprocessedVotes),
                tokenAmounts: new Client.EVMTokenAmount[](0),
                extraArgs: "",
                feeToken: i_link
            });

            bytes32 messageId;

            uint256 fee = IRouterClient(i_router).getFee(
                destinationChainSelector,
                message
            );

            LinkTokenInterface(i_link).approve(i_router, fee);
            messageId = IRouterClient(i_router).ccipSend(
                destinationChainSelector,
                message
            );

            emit MessageSent(messageId);

            delete unprocessedVotes;
        }
    }

    function setVotesThreshold(uint256 _votesThreshold) public {
        votesThreshold = _votesThreshold;
        emit VotesThresholdSet(_votesThreshold);
    }

    function setReceiver(address _receiver) public {
        receiver = _receiver;
        emit ReceiverSet(_receiver);
    }

    function setDestinationChainSelector(uint64 _destinationChainSelector) public {
        destinationChainSelector = _destinationChainSelector;
        emit DestinationChainSelectorSet(_destinationChainSelector);
    }

    receive() external payable {}
}
