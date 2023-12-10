// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "./Helper.sol";
import {VoteContract} from "../src/VoteContract.sol";
import {VoteRelayerDestination} from "../src/VoteRelayerDestination.sol";
import {VoteRelayerSource} from "../src/VoteRelayerSource.sol";

contract DeployDestination is Script, Helper {
    function run(SupportedNetworks destination) external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        (address router, , , ) = getConfigFromNetwork(destination);

        VoteContract voteContract = new VoteContract();

        console.log(
            "voteContract deployed on ",
            networks[destination],
            "with address: ",
            address(voteContract)
        );

        VoteRelayerDestination voteRelayerDestination = new VoteRelayerDestination(
            router,
            address(voteContract)
        );

        console.log(
            "voteRelayerDestination deployed on ",
            networks[destination],
            "with address: ",
            address(voteRelayerDestination)
        );

        vm.stopBroadcast();
    }
}

contract DeploySource is Script, Helper {
    function run(SupportedNetworks source, uint256 _votesThreshold, address _receiver, uint64 _destinationChainSelector) external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        (address router, address link, , ) = getConfigFromNetwork(source);

        VoteRelayerSource sourceMinter = new VoteRelayerSource(router, link, _votesThreshold, _receiver, _destinationChainSelector);

        console.log(
            "VoteRelayerSource deployed on ",
            networks[source],
            "with address: ",
            address(sourceMinter)
        );

        vm.stopBroadcast();
    }
}

contract Vote is Script, Helper {
    function run(
        address payable sourceMinterAddress,
        uint8 _option,
        uint8 _weight
    ) external {
        uint256 senderPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(senderPrivateKey);

        VoteRelayerSource(sourceMinterAddress).vote(
            _option,
            _weight
        );

        vm.stopBroadcast();
    }
}
