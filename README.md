## Governance for All
NOT FOR PRODUCTION USE BY ANY MEANS: modified Chainlink CCIP Starter Kit

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Getting Started

1. Install packages

```
forge install
```

and

```
npm install
```

2. Compile contracts

```
forge build
```
3. Set up environment variables
Create a new file named `.env` in the root directory of the project and add the following variables: (can be modified .env.example)
```shell
PRIVATE_KEY=""
ETHEREUM_SEPOLIA_RPC_URL=""
OPTIMISM_GOERLI_RPC_URL=""
AVALANCHE_FUJI_RPC_URL=""
ARBITRUM_TESTNET_RPC_URL=""
POLYGON_MUMBAI_RPC_URL=""
```
(In our case, we will need only Avalanche Fuji and Polygon Mumbai RPC URLs)\
\
Once that is done, to load the variables in the `.env` file, run the following command:

```shell
source .env
```


## Usage

### 1. Deploy VoteRelayerDestination.sol and VoteContract.sol on Avalanche Fuji
``forge script ./script/VoteRelayer.s.sol:DeployDestination -vvv --broadcast --rpc-url avalancheFuji --sig "run(uint8)" -- 2``

As a part of the return message, you will get the address of the deployed VoteRelayerDestination.sol and VoteContract.sol contracts.

``voteContract deployed on  Avalanche Fuji with address:  <ADDRESS>``\
``voteRelayerDestination deployed on  Avalanche Fuji with address:  <ADDRESS>``

### 2. Deploy VoteRelayerSource.sol on Polygon Mumbai
``forge script ./script/VoteRelayer.s.sol:DeploySource -vvv --broadcast --rpc-url polygonMumbai --sig "run(uint8, uint256, address, uint64)" -- 4 <VOTE_THRESHOLD> <DESTINATION_MINTER_ADDRESS> 14767482510784806043``

where ``<VOTE_THRESHOLD>`` is the number of votes required to trigger the vote relaying to the destination blockchain \
and ``<DESTINATION_MINTER_ADDRESS>`` is the address of the deployed DestinationMinter.sol contract on Avalanche Fuji (previous step).

The return message will contain the address of the deployed VoteRelayerSource.sol contract.\
``voteRelayerSource deployed on  Polygon Mumbai with address:  <ADDRESS>``

### 3. Fund the VoteRelayerSource.sol contract on Polygon Mumbai with testnet LINK tokens. 
You can get some from the [Chainlink Faucet](https://faucets.chain.link/mumbai). 
Recommended amount for testing is 3 LINK tokens.

### 4. Vote through the VoteRelayerSource.sol contract on Polygon Mumbai
``forge script ./script/VoteRelayer.s.sol:Vote -vvv --broadcast --rpc-url polygonMumbai --sig "run(address, uint8, uint8)" -- <VOTE_RELAYER_SOURCE_ADDRESS> <OPTION> <WEIGHT>``

where ``<VOTE_RELAYER_SOURCE_ADDRESS>`` is the address of the deployed VoteRelayerSource.sol contract on Polygon Mumbai (previous step)\
``<OPTION>`` is the option you want to vote for and ``<WEIGHT>`` is the weight of your vote.

Once the ``VOTE_THRESHOLD`` is reached, the vote will be relayed to the Avalanche Fuji blockchain having to pay only one transaction fee.
