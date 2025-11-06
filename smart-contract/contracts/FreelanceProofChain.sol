// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract FreelanceProofChain {

    // --- State Variables ---
    uint256 private projectCounter;

    // --- Structs & Enums ---
    enum ProjectStatus { Created, Accepted, WorkSubmitted, Approved, Disputed }

    struct Project {
        uint256 id;
        string description;
        address payable client;
        address payable freelancer;
        uint256 amount;
        uint256 deadline;
        ProjectStatus status;
        string deliverableIPFSHash;
    }

    // --- Mappings ---
    mapping(uint256 => Project) public projects;

    // --- Events ---
    event ProjectCreated(uint256 indexed id, address indexed client, uint256 amount);
    event ProjectAccepted(uint256 indexed id, address indexed freelancer);
    event WorkSubmitted(uint256 indexed id, string ipfsHash);
    event WorkApproved(uint256 indexed id);
    event DisputeRaised(uint256 indexed id);

    // --- Functions ---

    /**
     * @notice Allows a client to create a new project and lock funds in escrow.
     */
    function createProject(string memory _description, uint256 _deadline) public payable {
        require(msg.value > 0, "Amount must be greater than zero.");
        projectCounter++;
        projects[projectCounter] = Project({
            id: projectCounter,
            description: _description,
            client: payable(msg.sender),
            freelancer: payable(address(0)),
            amount: msg.value,
            deadline: _deadline,
            status: ProjectStatus.Created,
            deliverableIPFSHash: ""
        });
        emit ProjectCreated(projectCounter, msg.sender, msg.value);
    }

    /**
     * @notice Allows a freelancer to accept an open project.
     */
    function acceptProject(uint256 _projectId) public {
        Project storage project = projects[_projectId];
        require(project.id != 0, "Project does not exist.");
        require(project.status == ProjectStatus.Created, "Project is not open for acceptance.");
        require(msg.sender != project.client, "Client cannot accept their own project.");

        project.freelancer = payable(msg.sender);
        project.status = ProjectStatus.Accepted;
        emit ProjectAccepted(_projectId, msg.sender);
    }

    /**
     * @notice Allows the assigned freelancer to submit their work.
     */
    function submitWork(uint256 _projectId, string memory _ipfsHash) public {
        Project storage project = projects[_projectId];
        require(project.status == ProjectStatus.Accepted, "Work cannot be submitted at this stage.");
        require(msg.sender == project.freelancer, "Only the assigned freelancer can submit work.");

        project.deliverableIPFSHash = _ipfsHash;
        project.status = ProjectStatus.WorkSubmitted;
        emit WorkSubmitted(_projectId, _ipfsHash);
    }

    /**
     * @notice Allows the client to approve submitted work and release funds.
     */
    function approveWork(uint256 _projectId) public {
        Project storage project = projects[_projectId];
        require(project.status == ProjectStatus.WorkSubmitted, "Work cannot be approved at this stage.");
        require(msg.sender == project.client, "Only the client can approve work.");

        project.status = ProjectStatus.Approved;
        (bool success, ) = project.freelancer.call{value: project.amount}("");
        require(success, "Failed to transfer funds.");

        emit WorkApproved(_projectId);
    }

    /**
     * @notice Allows either the client or freelancer to raise a dispute.
     */
    function raiseDispute(uint256 _projectId) public {
        Project storage project = projects[_projectId];
        require(project.id != 0, "Project does not exist.");
        require(msg.sender == project.client || msg.sender == project.freelancer, "Only client or freelancer can dispute.");
        require(project.status != ProjectStatus.Approved && project.status != ProjectStatus.Disputed, "Project cannot be disputed at this stage.");

        project.status = ProjectStatus.Disputed;
        emit DisputeRaised(_projectId);
    }
}