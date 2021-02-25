pragma solidity 0.4.24;

import "@aragon/templates-shared/contracts/BaseTemplate.sol";

contract SarcophagusDaoTemplate is BaseTemplate {
    event SarcophagusDaoDeployed(
        address dao,
        address acl,
        address sarcophagusVotingRights,
        address voting,
        address agent,
        address finance
    );

    constructor(
        DAOFactory _daoFactory,
        ENS _ens,
        MiniMeTokenFactory _minimeTokenFactory,
        IFIFSResolvingRegistrar _aragonID
    ) public BaseTemplate(_daoFactory, _ens, _minimeTokenFactory, _aragonID) {
        _ensureAragonIdIsValid(_aragonID);
    }

    /**
     * @dev Deploy a Company DAO using a SarcoVotingRights token
     * @param _id String with the name for org, will assign `[id].aragonid.eth`
     * @param _sarcoVotingRights Address of the SARCO Voting Rights contract
     * @param _votingSettings Array of [supportRequired, minAcceptanceQuorum, voteDuration] to set up the voting app of the organization
     */
    function newInstance(
        string memory _id,
        MiniMeToken _sarcoVotingRights,
        uint64[3] memory _votingSettings
    ) public {
        require(_sarcoVotingRights != address(0), "Invalid SARCO Voting Rights");
        require(_votingSettings.length == 3, "Invalid voting settings");

        _validateId(_id);

        (Kernel dao, ACL acl) = _createDAO();
        Agent agent = _installDefaultAgentApp(dao);
        Finance finance = _installFinanceApp(dao, agent, uint64(30 days));
        Voting voting = _installVotingApp(dao, _sarcoVotingRights, _votingSettings);

        _createAgentPermissions(acl, agent, voting, voting);
        _createVaultPermissions(acl, Vault(agent), finance, voting);
        _createFinancePermissions(acl, finance, voting, voting);
        _createFinanceCreatePaymentsPermission(acl, finance, voting, address(this));
        _createEvmScriptsRegistryPermissions(acl, voting, voting);
        _createVotingPermissions(acl, voting, voting, address(-1), voting);

        _transferCreatePaymentManagerFromTemplate(acl, finance, voting);
        _transferRootPermissionsFromTemplateAndFinalizeDAO(dao, voting);
        _registerID(_id, dao);

        emit SarcophagusDaoDeployed(
            address(dao),
            address(acl),
            address(_sarcoVotingRights),
            address(voting),
            address(agent),
            address(finance)
        );
    }
}
