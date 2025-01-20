// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Documentation: RewardsManager Smart Contract

// 1. Introduction

// The RewardsManager smart contract is designed to manage a multi-faceted rewards system, incorporating role-based permissions and a proposal-based execution mechanism. This contract facilitates the administration of achievement-based and payout-based rewards, as well as the management of associated configurations and velocity controls.

// The core principle is that actions are initiated by specific roles (e.g., Achievement Managers and Reward Managers) through "proposals". These proposals must be approved by a set number of team members before being executed on-chain. This approach ensures that the reward system is managed securely and collaboratively.

// 2. Key Features

// Role-Based Access Control: Implements roles such as Administrator, Achievement Manager, and Reward Manager, each with distinct permissions.

// Proposal System: Uses a proposal mechanism to suggest, review, and execute changes to the rewards infrastructure.

// Approval Thresholds: Allows configurable approval thresholds per role, requiring a certain number of approvals for a proposal to pass.

// Achievement Management: Enables the administration of achievement IDs, including stopping minting on certain IDs.

// Reward Management: Facilitates the setup, adjustment, and NFT assignment to rewards, and also the management of velocity controls.

// Event-Driven: Emits detailed events for key actions like role changes, proposal creation, approvals, rejections and executions.

contract RewardsManager {
  // --- Role Management ---

  //   3. Roles and Permissions

  // Administrator (ADMIN):

  // Can grant or revoke any role (grantRole, revokeRole).

  // Can set proposal approval thresholds for different roles (setRoleApprovalThreshold).

  // Can reject any proposal without requiring a threshold.(rejectProposal)

  // Has access to all other functions.

  // Achievement Manager (ACHIEVEMENT_MANAGER):

  // Can propose the addition of new achievement IDs (proposeNewAchievements).

  // Can propose to stop minting for existing achievement IDs (proposeMintingStopped).

  // Reward Manager (REWARD_MANAGER):

  // Can propose reward configurations for quests, including reward tokens, totals, and per-token amounts (proposeRewards).

  // Can propose adjustments to existing reward configurations (proposeRewardAdjustment).

  // Can propose assignments of NFTs to rewards (proposeNfts).

  // Can propose new velocity controls or updates to existing ones (proposeVelocityControl).

  enum Role {
    ADMIN,
    ACHIEVEMENT_MANAGER,
    REWARD_MANAGER
  }

  mapping(address => Role) public roles;
  mapping(Role => uint256) public roleApprovalThresholds;

  event RoleGranted(address indexed user, Role role);
  event RoleRevoked(address indexed user, Role role);

  constructor() {
    // Set default approval thresholds (e.g., 2 approvals required for all roles)
    roleApprovalThresholds[Role.ADMIN] = 2;
    roleApprovalThresholds[Role.ACHIEVEMENT_MANAGER] = 2;
    roleApprovalThresholds[Role.REWARD_MANAGER] = 2;
    // Grant deployer the admin role
    _grantRole(msg.sender, Role.ADMIN);
  }

  modifier onlyRole(Role role) {
    require(roles[msg.sender] == role, 'Caller does not have the required role');
    _;
  }

  function grantRole(address _user, Role _role) public onlyRole(Role.ADMIN) {
    _grantRole(_user, _role);
  }
  function _grantRole(address _user, Role _role) private {
    roles[_user] = _role;
    emit RoleGranted(_user, _role);
  }

  function revokeRole(address _user, Role _role) public onlyRole(Role.ADMIN) {
    require(roles[_user] == _role, "User doesn't have the specified role");
    delete roles[_user];
    emit RoleRevoked(_user, _role);
  }

  function setRoleApprovalThreshold(Role _role, uint256 _threshold) public onlyRole(Role.ADMIN) {
    roleApprovalThresholds[_role] = _threshold;
  }

  // --- Proposal Struct and Storage ---

  //   State Variables:

  // roles: Mapping from address to Role to track the role assigned to an address.

  // roleApprovalThresholds: Mapping from Role to uint256 representing the required approval count for a proposal from that role.

  // proposals: Mapping from uint256 (proposal ID) to Proposal struct.

  // proposalsByType: Mapping of ProposalType to a list of proposalId

  // proposalCount: Tracks the number of proposals created.
  struct Proposal {
    address proposer;
    ProposalType proposalType;
    bytes data;
    mapping(address => bool) approvals;
    uint256 approvalCount;
    bool executed;
  }

  enum ProposalType {
    NEW_ACHIEVEMENTS,
    STOP_MINTING,
    REWARDS_PROPOSAL,
    REWARD_ADJUSTMENT,
    NFT_PROPOSAL,
    VELOCITY_CONTROL
  }

  uint256 public proposalCount;
  mapping(uint256 => Proposal) public proposals;
  mapping(ProposalType => uint256[]) public proposalsByType;

  // Events:
  // RoleGranted, RoleRevoked: Emitted when roles are granted or revoked.

  // ProposalCreated: Emitted when a new proposal is created.

  // ProposalApproved: Emitted when a proposal is approved by a team member.

  // ProposalExecuted: Emitted when a proposal meets its approval threshold and is executed.

  // ProposalRejected: Emitted when a proposal is rejected by an admin.
  event ProposalCreated(uint256 indexed proposalId, ProposalType proposalType, address indexed proposer);
  event ProposalApproved(uint256 indexed proposalId, address indexed approver);
  event ProposalExecuted(uint256 indexed proposalId);
  event ProposalRejected(uint256 indexed proposalId);

  function _createProposal(ProposalType _proposalType, bytes memory _data) internal returns (uint256) {
    uint256 proposalId = proposalCount++;
    proposals[proposalId] = Proposal({
      proposer: msg.sender,
      proposalType: _proposalType,
      data: _data,
      approvalCount: 0,
      executed: false
    });
    proposalsByType[_proposalType].push(proposalId);
    emit ProposalCreated(proposalId, _proposalType, msg.sender);
    return proposalId;
  }

  function _getProposal(uint256 _proposalId) internal view returns (Proposal storage) {
    require(_proposalId < proposalCount, 'Invalid Proposal ID');
    return proposals[_proposalId];
  }

  // --- Proposal Submission Functions ---

  function proposeNewAchievements(uint256[] memory ids) public onlyRole(Role.ACHIEVEMENT_MANAGER) {
    bytes memory data = abi.encode(ids);
    _createProposal(ProposalType.NEW_ACHIEVEMENTS, data);
  }

  function proposeMintingStopped(uint256[] memory ids) public onlyRole(Role.ACHIEVEMENT_MANAGER) {
    bytes memory data = abi.encode(ids);
    _createProposal(ProposalType.STOP_MINTING, data);
  }

  function proposeRewards(
    uint256[] memory ids,
    uint256[] memory rewardTypes,
    address[] memory rewardTokens,
    uint256[] memory totalRewards,
    uint256[] memory rewardsPerTokens,
    uint256[][] memory nftIds
  ) public onlyRole(Role.REWARD_MANAGER) {
    bytes memory data = abi.encode(ids, rewardTypes, rewardTokens, totalRewards, rewardsPerTokens, nftIds);
    _createProposal(ProposalType.REWARDS_PROPOSAL, data);
  }

  function proposeRewardAdjustment(
    uint256[] memory ids,
    uint256[] memory rewards_indexes,
    address[] memory rewardTokens,
    uint256[] memory totalRewards,
    uint256[] memory rewardsPerTokens,
    bool[] memory enableds
  ) public onlyRole(Role.REWARD_MANAGER) {
    bytes memory data = abi.encode(ids, rewards_indexes, rewardTokens, totalRewards, rewardsPerTokens, enableds);
    _createProposal(ProposalType.REWARD_ADJUSTMENT, data);
  }

  function proposeNfts(
    uint256[] memory ids,
    uint256[] memory reward_indexes,
    uint256[][] memory nftIds
  ) public onlyRole(Role.REWARD_MANAGER) {
    bytes memory data = abi.encode(ids, reward_indexes, nftIds);
    _createProposal(ProposalType.NFT_PROPOSAL, data);
  }

  function proposeVelocityControl(
    uint256 id,
    uint256 maxPerClaim,
    uint256 maxTotalClaimed,
    bool enabled,
    uint256 expiry,
    uint256 intervalLimit,
    uint256 interval,
    uint256 intervalStart
  ) public onlyRole(Role.REWARD_MANAGER) {
    bytes memory data = abi.encode(
      id,
      maxPerClaim,
      maxTotalClaimed,
      enabled,
      expiry,
      intervalLimit,
      interval,
      intervalStart
    );
    _createProposal(ProposalType.VELOCITY_CONTROL, data);
  }

  // --- Proposal Approval & Execution ---

  function approveProposal(uint256 _proposalId) public {
    Proposal storage proposal = _getProposal(_proposalId);
    require(!proposal.executed, 'Proposal has already been executed.');
    require(!proposal.approvals[msg.sender], 'This user has already approved this proposal.');
    proposal.approvals[msg.sender] = true;
    proposal.approvalCount++;
    emit ProposalApproved(_proposalId, msg.sender);
    _checkAndExecuteProposal(_proposalId);
  }

  function rejectProposal(uint256 _proposalId) public onlyRole(Role.ADMIN) {
    Proposal storage proposal = _getProposal(_proposalId);
    require(!proposal.executed, 'Proposal has already been executed.');
    proposal.executed = true;
    emit ProposalRejected(_proposalId);
  }

  function _checkAndExecuteProposal(uint256 _proposalId) private {
    Proposal storage proposal = _getProposal(_proposalId);
    uint256 approvalThreshold = roleApprovalThresholds[roles[proposal.proposer]];

    if (proposal.approvalCount >= approvalThreshold) {
      proposal.executed = true;
      _executeProposal(_proposalId, proposal);
      emit ProposalExecuted(_proposalId);
    }
  }

  function _executeProposal(uint256 _proposalId, Proposal storage proposal) private {
    //We should create a struct of handlers
    if (proposal.proposalType == ProposalType.NEW_ACHIEVEMENTS) {
      uint256[] memory ids = abi.decode(proposal.data, (uint256[]));
      _handleNewAchievements(ids);
    } else if (proposal.proposalType == ProposalType.STOP_MINTING) {
      uint256[] memory ids = abi.decode(proposal.data, (uint256[]));
      _handleMintingStopped(ids);
    } else if (proposal.proposalType == ProposalType.REWARDS_PROPOSAL) {
      (
        uint256[] memory ids,
        uint256[] memory rewardTypes,
        address[] memory rewardTokens,
        uint256[] memory totalRewards,
        uint256[] memory rewardsPerTokens,
        uint256[][] memory nftIds
      ) = abi.decode(proposal.data, (uint256[], uint256[], address[], uint256[], uint256[], uint256[][]));
      _handleRewardsProposal(ids, rewardTypes, rewardTokens, totalRewards, rewardsPerTokens, nftIds);
    } else if (proposal.proposalType == ProposalType.REWARD_ADJUSTMENT) {
      (
        uint256[] memory ids,
        uint256[] memory rewards_indexes,
        address[] memory rewardTokens,
        uint256[] memory totalRewards,
        uint256[] memory rewardsPerTokens,
        bool[] memory enableds
      ) = abi.decode(proposal.data, (uint256[], uint256[], address[], uint256[], uint256[], bool[]));
      _handleRewardAdjustment(ids, rewards_indexes, rewardTokens, totalRewards, rewardsPerTokens, enableds);
    } else if (proposal.proposalType == ProposalType.NFT_PROPOSAL) {
      (uint256[] memory ids, uint256[] memory reward_indexes, uint256[][] memory nftIds) = abi.decode(
        proposal.data,
        (uint256[], uint256[], uint256[][])
      );
      _handleNftProposal(ids, reward_indexes, nftIds);
    } else if (proposal.proposalType == ProposalType.VELOCITY_CONTROL) {
      (
        uint256 id,
        uint256 maxPerClaim,
        uint256 maxTotalClaimed,
        bool enabled,
        uint256 expiry,
        uint256 intervalLimit,
        uint256 interval,
        uint256 intervalStart
      ) = abi.decode(proposal.data, (uint256, uint256, uint256, bool, uint256, uint256, uint256, uint256));
      _handleVelocityControl(id, maxPerClaim, maxTotalClaimed, enabled, expiry, intervalLimit, interval, intervalStart);
    }
  }

  // --- Handler Functions (Example Implementations) ---

  function _handleNewAchievements(uint256[] memory ids) private {
    // Implementation: Logic to handle new achievement IDs
    // For example: You could create mappings to track which IDs are valid for minting.
    // Emit relevant event
  }

  function _handleMintingStopped(uint256[] memory ids) private {
    // Implementation: Logic to handle stopping minting on certain achievement IDs
    // Example: Could set a boolean for each ID to control if its mintable
    // Emit relevant event
  }

  function _handleRewardsProposal(
    uint256[] memory ids,
    uint256[] memory rewardTypes,
    address[] memory rewardTokens,
    uint256[] memory totalRewards,
    uint256[] memory rewardsPerTokens,
    uint256[][] memory nftIds
  ) private {
    // Implementation: Logic to setup rewards for given quest Ids
    // Create a mapping for each quest and a reward mapping on that
    // Emit relevant event
  }

  function _handleRewardAdjustment(
    uint256[] memory ids,
    uint256[] memory rewards_indexes,
    address[] memory rewardTokens,
    uint256[] memory totalRewards,
    uint256[] memory rewardsPerTokens,
    bool[] memory enableds
  ) private {
    // Implementation: logic to adjust rewards
    // Look up the quest id, and the reward index, then adjust the reward object
    // Emit relevant event
  }

  function _handleNftProposal(
    uint256[] memory ids,
    uint256[] memory reward_indexes,
    uint256[][] memory nftIds
  ) private {
    // Implementation: Logic for assigning nfts
    // Look up the quest and reward index and assign nfts
    // Emit relevant event
  }

  function _handleVelocityControl(
    uint256 id,
    uint256 maxPerClaim,
    uint256 maxTotalClaimed,
    bool enabled,
    uint256 expiry,
    uint256 intervalLimit,
    uint256 interval,
    uint256 intervalStart
  ) private {
    // Implementation: Logic to handle velocity control setup
    // Create / Update an existing record of velocity control
    // Emit relevant event
  }
}
