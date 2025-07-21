// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract UserProfile {
    struct User {
        string name;
        uint256 age;
        string email;
        uint256 registeredAt;
        bool active;
    }

    mapping(address => User) private profiles;
    address[] public users;
    uint256 public count;

    event Registered(address indexed user, string name, uint256 time);
    event Updated(address indexed user, string name, uint256 time);

    modifier onlyActive() {
        require(profiles[msg.sender].active, "Not registered");
        _;
    }

    modifier valid(string memory _name, uint256 _age, string memory _email) {
        require(bytes(_name).length > 0, "Name empty");
        require(_age > 0 && _age <= 120, "Invalid age");
        require(bytes(_email).length > 0, "Email empty");
        _;
    }

    function register(string memory _name, uint256 _age, string memory _email) external valid(_name, _age, _email) {
        require(!profiles[msg.sender].active, "Already registered");
        profiles[msg.sender] = User(_name, _age, _email, block.timestamp, true);
        users.push(msg.sender);
        count++;
        emit Registered(msg.sender, _name, block.timestamp);
    }

    function updateProfile(string memory _name, uint256 _age, string memory _email) external onlyActive valid(_name, _age, _email) {
        User storage u = profiles[msg.sender];
        u.name = _name;
        u.age = _age;
        u.email = _email;
        emit Updated(msg.sender, _name, block.timestamp);
    }

    function getProfile() external view onlyActive returns (string memory, uint256, string memory, uint256) {
        User storage u = profiles[msg.sender];
        return (u.name, u.age, u.email, u.registeredAt);
    }

    function getProfileOf(address _addr) external view returns (string memory, uint256, string memory, uint256, bool) {
        User storage u = profiles[_addr];
        return (u.name, u.age, u.email, u.registeredAt, u.active);
    }

    function isRegistered(address _addr) external view returns (bool) {
        return profiles[_addr].active;
    }
}
