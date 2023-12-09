// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "./Helper.sol";
import {BasicMessageReceiver} from "../src/BasicMessageReceiver.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.0/token/ERC20/IERC20.sol";

contract DeployBasicMessageReceiver is Script, Helper {
    function run(SupportedNetworks destination) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        (address router, , , ) = getConfigFromNetwork(destination);

        BasicMessageReceiver basicMessageReceiver = new BasicMessageReceiver(
            router
        );

        console.log(
            "Basic Message Receiver deployed on ",
            networks[destination],
            "with address: ",
            address(basicMessageReceiver)
        );

        vm.stopBroadcast();
    }
}

contract GetLatestMessageDetails is Script, Helper {
    function run(address basicMessageReceiver) external view {
        (
            bytes32 latestMessageId,
            uint64 latestSourceChainSelector,
            address latestSender,
            string memory latestMessage
        ) = BasicMessageReceiver(basicMessageReceiver).getLatestMessageDetails();

        console.log("Latest Message ID: ");
        console.logBytes32(latestMessageId);
        console.log("Latest Source Chain Selector: ");
        console.log(latestSourceChainSelector);
        console.log("Latest Sender: ");
        console.log(latestSender);
        console.log("Latest Message: ");
        console.log(latestMessage);
    }
}
