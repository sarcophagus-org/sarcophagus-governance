# Sarcophagus DAO
> In partnership with Decent Labs, with lots of help from dOrg

The Sarcophagus DAO gives SARCO stakers the ability to vote and manage the SARCO ecosystem.

## 🚨 Not Audited

## Permissions
| App | Permission | Description | Grantee | Manager |  
|-----|------------|-------------|---------|---------|  
| Kernel | APP_MANAGER_ROLE | Manage apps | $ADMIN | $ADMIN |  
| ACL | CREATE_PERMISSIONS_ROLE | Create permissions | $ADMIN | $ADMIN |  
| EVMScriptRegistry | REGISTRY_ADD_EXECUTOR_ROLE | Add executors | $ADMIN | $ADMIN |  
| EVMScriptRegistry | REGISTRY_MANAGER_ROLE | Enable and disable executors | $ADMIN | $ADMIN |  
| Voting | CREATE_VOTES_ROLE | Create new votes | ANY_ENTITY | $ADMIN |  
| Voting | MODIFY_SUPPORT_ROLE | Modify support | Voting | $ADMIN |  
| Voting | MODIFY_QUORUM_ROLE | Modify quorum | Voting | $ADMIN |  
| Agent | TRANSFER_ROLE | Transfer Agent's tokens | Voting | $ADMIN |  
| Agent | EXECUTE_ROLE | Execute actions | Voting | $ADMIN |  
| Agent | RUN_SCRIPT_ROLE | Run EVM Script | Voting | $ADMIN | 

## Getting Started
1. Use the right npm version:  
`nvm install && nvm use`  

2. Install dependencies:  
`npm i`  

3. Build everything:  
`npm run compile`  

## Local Development
1. Run tests:  
`nvm run test`  

## Rinkeby Testing
1. Build contracts:  
`npm run compile`  

2. Configure testnet accounts within `~/.aragon/rinkeby_key.json`:  
```
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

3. Configure DAO within `./configs/rinkeby-dao-config.json`:  
```
{
  "name": "...", // Optional, if not present random name will be used
  "supportRequiredPct": 50,
  "minAcceptQuorumPct": 5,
  "voteTimeDays": 7,
  "sarcoVotingRights": "..."
}
```

4. Deploy SarcophagusDaoTemplate.sol to Aragon's PM (if changes were made):  
`npm run deploy:rinkeby`  

5. Create new DAO instance:  
`npm run create:rinkeby`  

## Mainnet Deployment

Same as Rinkeby steps above, with the following name changes...
2. `~/.aragon/mainnet_key.json`  
3. `./configs/mainnet-dao-config.json`  
4. `npm run deploy:mainnet`  
5. `npm run create:mainnet`  

## Aragon Architecture Walk-through
* [Presentation Video](https://youtu.be/A7DHfRJUuIk)  
* [References Document](https://docs.google.com/document/d/1_YB-8TXDRg98Fzn8NZrtcUf7DGfSVDdzqiqkwLtBxF4/edit?usp=sharing)  
