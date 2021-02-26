module.exports = require("@aragon/os/truffle-config.js");

module.exports.networks.mainnet.gasPrice = 150e9;

module.exports.compilers = {
  solc: {
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
    }
  }
}