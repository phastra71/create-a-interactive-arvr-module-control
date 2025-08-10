pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";

contract InteractiveARVRModuleController {
    using Roles for address;

    // Define roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant DEVELOPER_ROLE = keccak256("DEVELOPER_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    // Module struct
    struct Module {
        uint256 id;
        string name;
        string description;
        address creator;
        string ARModelUrl;
        string VRModelUrl;
        uint256 creationTime;
    }

    // Mapping of modules
    mapping (uint256 => Module) public modules;
    uint256 public moduleIdCounter;

    // Events
    event ModuleCreated(uint256 moduleId, address creator);
    event ModuleUpdated(uint256 moduleId, address updater);
    event ModuleDeleted(uint256 moduleId, address deleter);

    // Only admin can create a new module
    function createModule(
        string memory _name,
        string memory _description,
        string memory _ARModelUrl,
        string memory _VRModelUrl
    ) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Only admin can create a new module");
        moduleIdCounter++;
        Module storage newModule = modules[moduleIdCounter];
        newModule.id = moduleIdCounter;
        newModule.name = _name;
        newModule.description = _description;
        newModule.creator = msg.sender;
        newModule.ARModelUrl = _ARModelUrl;
        newModule.VRModelUrl = _VRModelUrl;
        newModule.creationTime = block.timestamp;
        emit ModuleCreated(moduleIdCounter, msg.sender);
    }

    // Only developer can update a module
    function updateModule(
        uint256 _moduleId,
        string memory _name,
        string memory _description,
        string memory _ARModelUrl,
        string memory _VRModelUrl
    ) public {
        require(hasRole(DEVELOPER_ROLE, msg.sender), "Only developer can update a module");
        Module storage updatingModule = modules[_moduleId];
        require(updatingModule.creator == msg.sender, "Only the creator can update the module");
        updatingModule.name = _name;
        updatingModule.description = _description;
        updatingModule.ARModelUrl = _ARModelUrl;
        updatingModule.VRModelUrl = _VRModelUrl;
        emit ModuleUpdated(_moduleId, msg.sender);
    }

    // Only admin can delete a module
    function deleteModule(uint256 _moduleId) public {
        require(hasRole(ADMIN_ROLE, msg.sender), "Only admin can delete a module");
        Module storage deletingModule = modules[_moduleId];
        require(deletingModule.creator == msg.sender, "Only the creator can delete the module");
        delete modules[_moduleId];
        emit ModuleDeleted(_moduleId, msg.sender);
    }

    // Get a module by ID
    function getModule(uint256 _moduleId) public view returns (
        uint256,
        string memory,
        string memory,
        address,
        string memory,
        string memory,
        uint256
    ) {
        Module storage module = modules[_moduleId];
        return (
            module.id,
            module.name,
            module.description,
            module.creator,
            module.ARModelUrl,
            module.VRModelUrl,
            module.creationTime
        );
    }
}