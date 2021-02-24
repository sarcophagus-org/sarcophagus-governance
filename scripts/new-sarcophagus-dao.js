const { getEventArgument } = require('@aragon/test-helpers/events')

const time = require('./helpers/time')(web3)

const SarcophagusDaoTemplate = artifacts.require("SarcophagusDaoTemplate")

const NETWORK_ARG = "--network"
const DAO_CONFIG_ARG = "--daoConfig"

const argValue = (arg, defaultValue) =>
  process.argv.includes(arg) ?
  process.argv[process.argv.indexOf(arg) + 1] :
  (typeof defaultValue === "function" ? defaultValue() : defaultValue)

const network = () => argValue(NETWORK_ARG, "rinkeby")
const daoConfig = () => argValue(DAO_CONFIG_ARG, () => `../configs/${network()}-dao-config.json`)

const sarcophagusDaoTemplateAddress = () => {
  if (network() === "rinkeby") {
    const Arapp = require("../arapp")
    return Arapp.environments.rinkeby.address
  } else if (network() === "mainnet") {
    const Arapp = require("../arapp")
    return Arapp.environments.mainnet.address
  } else if (network() === "xdai") {
    const Arapp = require("../arapp")
    return Arapp.environments.xdai.address
  } else {
    const Arapp = require("../arapp_local")
    return Arapp.environments.devnet.address
  }
}

module.exports = async (callback) => {
  try {
    const config = require(daoConfig());
    let sarcoVotingRightsAddr;

    if (config.sarcoVotingRights) {
      console.log("SarcoVotingRights already deployed at:")
      console.log(config.sarcoVotingRights)
      sarcoVotingRightsAddr = config.sarcoVotingRights;
    } else {
      console.log("No SarcoVotingRights address found, please deploy one!")
      console.exit(1)
    }

    const sarcophagusDaoTemplate = await SarcophagusDaoTemplate.at(sarcophagusDaoTemplateAddress())

    const sarcophagusDaoName = config.name ? config.name : "sarcophagus-dao-" + Math.floor(10000 * Math.random())

    const receipt = await sarcophagusDaoTemplate.newInstance(
      sarcophagusDaoName,
      sarcoVotingRightsAddr,
      [
        config.supportRequiredPct * 1e16,
        config.minAcceptQuorumPct * 1e16,
        time.duration.days(config.voteTimeDays).toNumber()
      ]
    )

    const dao = getEventArgument(receipt, 'DeployDao', 'dao')
    console.log("successfully deployed the Sarcophagus DAO:")
    console.log(`address: ${dao}`)
    console.log(`name: ${sarcophagusDaoName}`)
    console.log(`url: https://${network()}.client.aragon.org/#/${sarcophagusDaoName}/`)
    callback()
  } catch (error) {
    console.log(error)
    callback(error)
  }
}
