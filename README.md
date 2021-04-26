# Sarcophagus Governance

[![Discord](https://img.shields.io/discord/753398645507883099?color=768AD4&label=discord)](https://discord.com/channels/753398645507883099/)
[![Twitter](https://img.shields.io/twitter/follow/sarcophagusio?style=social)](https://twitter.com/sarcophagusio)

Sarcophagus is a decentralized dead man's switch built on Ethereum and Arweave.

## Overview

This repository contains the smart contracts (and corresponding deployment scripts) that power the Sarcophagus governance system (DAO).

## 🚨 WARNING: THESE CONTRACTS HAVE NOT BEEN AUDITED

## Permissions
| App | Permission | Description | Grantee | Manager |  
|-----|------------|-------------|---------|---------|  
| Kernel | APP_MANAGER_ROLE | Manage apps | Voting | Voting |  
| ACL | CREATE_PERMISSIONS_ROLE | Create permissions | Voting | Voting |  
| EVMScriptRegistry | REGISTRY_ADD_EXECUTOR_ROLE | Add executors | Voting | Voting |  
| EVMScriptRegistry | REGISTRY_MANAGER_ROLE | Enable and disable executors | Voting | Voting |  
| Voting | CREATE_VOTES_ROLE | Create new votes | ANY_ENTITY | Voting |  
| Voting | MODIFY_SUPPORT_ROLE | Modify support | Voting | Voting |  
| Voting | MODIFY_QUORUM_ROLE | Modify quorum | Voting | Voting |  
| Finance | CREATE_PAYMENTS_ROLE | Create new payments | Voting | Voting |
| Finance | EXECUTE_PAYMENTS_ROLE | Execute payments | Voting | Voting |
| Finance | MANAGE_PAYMENTS_ROLE | Manage payments | Voting | Voting |
| Agent | TRANSFER_ROLE | Transfer Agent's tokens | Voting | Voting |  
| Agent | EXECUTE_ROLE | Execute actions | Voting | Voting |  
| Agent | RUN_SCRIPT_ROLE | Run EVM Script | Voting | Voting | 

## Getting Started

First, ensure you're using the right npm version:

```sh
$ nvm install && nvm use
```

Then, install the necessary dependencies:

```sh
$ npm i
```

Finally, build everything!

```sh
$ npm run compile
```

## Local Development

To run tests:

```sh
$ nvm run test
```

## Rinkeby Testing

First, build the contracts:

```
$ npm run compile
```

Then, configure your testnet accounts within `~/.aragon/rinkeby_key.json`:

```json
{
  "rpc": "https://rinkeby.infura.io/v3/${API_KEY}",
  "keys": [
    "d79...", // ADMIN
    "c7a...", // STAKER_1
    "653...", // STAKER_2
    "9ac...", // STAKER_3
    "7a0...", // NON_STAKER
    "4f6..."  // NON_STAKER
  ]
}
```

Next, configure the DAO within `./configs/rinkeby-dao-config.json`:

```json
{
  "name": "...", // Optional, if not present random name will be used
  "supportRequiredPct": 50,
  "minAcceptQuorumPct": 5,
  "voteTimeDays": 7,
  "sarcoVotingRights": "..."
}
```

If you've made any changes, deploy `SarcophagusDaoTemplate.sol` to aragonPM:

```sh
$ npm run deploy:rinkeby
```

Finally, create a new DAO instance:

```sh
$ npm run create:rinkeby
```

## Mainnet Deployment

- First, build the contracts.
- Configure your testnet accounts within `~/.aragon/mainnet_key.json`
- Next, configure the DAO within `./configs/mainnet-dao-config.json`
- Deploy to aragonPM via `npm run deploy:mainnet`
- Finally, `npm run create:mainnet` to create a new instance of the DAO.

## Aragon Architecture Walk-through

* [Presentation Video](https://youtu.be/A7DHfRJUuIk)  
* [References Document](https://docs.google.com/document/d/1_YB-8TXDRg98Fzn8NZrtcUf7DGfSVDdzqiqkwLtBxF4/edit?usp=sharing)  

## Community
[![Discord](https://img.shields.io/discord/753398645507883099?color=768AD4&label=discord)](https://discord.com/channels/753398645507883099/)
[![Twitter](https://img.shields.io/twitter/follow/sarcophagusio?style=social)](https://twitter.com/sarcophagusio)

We can also be found on [Telegram](https://t.me/sarcophagusio).

Made with :skull: and proudly decentralized.
