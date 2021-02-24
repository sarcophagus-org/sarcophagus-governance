pragma solidity 0.4.24;

import "@aragon/templates-shared/contracts/BaseTemplate.sol";

contract SarcophagusDaoTemplate is BaseTemplate {
    string private constant ERROR_BAD_VOTE_SETTINGS =
        "SARCOPHAGUS_DAO_BAD_VOTE_SETTINGS";

    address private constant ANY_ENTITY = address(-1);
    uint64 private constant DEFAULT_FINANCE_PERIOD = uint64(30 days);

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
        require(
            _sarcoVotingRights != address(0),
            "Invalid SARCO Voting Rights"
        );

        _validateId(_id);
        _validateVotingSettings(_votingSettings);

        (Kernel dao, ACL acl) = _createDAO();
        (Voting voting, Agent agent, Finance finance) =
            _setupApps(
                dao,
                acl,
                _sarcoVotingRights,
                _votingSettings
            );
        _transferCreatePaymentManagerFromTemplate(acl, finance, voting);
        _transferRootPermissionsFromTemplateAndFinalizeDAO(
            dao,
            voting
        );
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

    function _setupApps(
        Kernel _dao,
        ACL _acl,
        MiniMeToken _sarcoVotingRights,
        uint64[3] memory _votingSettings
    )
        internal
        returns (
            Voting,
            Agent,
            Finance
        )
    {
        Agent agent = _installDefaultAgentApp(_dao);
        Finance finance =
            _installFinanceApp(_dao, agent, DEFAULT_FINANCE_PERIOD);
        Voting voting =
            _installVotingApp(_dao, _sarcoVotingRights, _votingSettings);

        _setupPermissions(_acl, agent, voting, finance);

        return (voting, agent, finance);
    }

    function _setupPermissions(
        ACL _acl,
        Agent _agent,
        Voting _voting,
        Finance _finance
    ) internal {
        _createAgentPermissions(_acl, _agent, _voting, _voting);
        _createVaultPermissions(_acl, Vault(_agent), _finance, _voting);
        _createFinancePermissions(_acl, _finance, _voting, _voting);
        _createFinanceCreatePaymentsPermission(
            _acl,
            _finance,
            _voting,
            address(this)
        );
        _createEvmScriptsRegistryPermissions(_acl, _voting, _voting);
        _createVotingPermissions(_acl, _voting, _voting, ANY_ENTITY, _voting);
    }

    function _validateVotingSettings(uint64[3] memory _votingSettings)
        private
        pure
    {
        require(_votingSettings.length == 3, ERROR_BAD_VOTE_SETTINGS);
    }
}
