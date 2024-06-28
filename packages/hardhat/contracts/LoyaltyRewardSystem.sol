// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoyaltyRewardSystem {
    address public owner;
    uint256 public rewardRate; // reward rate for each task
    mapping(address => uint256) public balances;

    struct Task {
        uint256 id;
        string description;
        uint256 reward;
        bool completed;
    }

    Task[] public tasks;
    uint256 public taskCounter;

    event RewardEarned(address indexed user, uint256 amount);
    event GiftCardPurchased(address indexed user, uint256 amount, string giftCardCode);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier validTaskId(uint256 _taskId) {
        require(_taskId < taskCounter, "Invalid task ID");
        _;
    }

    constructor(uint256 _rewardRate) {
        owner = msg.sender;
        rewardRate = _rewardRate;
    }

    function addTask(string memory _description, uint256 _reward) public onlyOwner {
        tasks.push(Task({id: taskCounter, description: _description, reward: _reward, completed: false}));
        taskCounter++;
    }

    function completeTask(uint256 _taskId) public validTaskId(_taskId) {
        require(!tasks[_taskId].completed, "Task already completed");
        tasks[_taskId].completed = true;
        balances[msg.sender] += tasks[_taskId].reward;
        emit RewardEarned(msg.sender, tasks[_taskId].reward);
    }

    function purchaseGiftCard(uint256 _amount, string memory _giftCardCode) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        emit GiftCardPurchased(msg.sender, _amount, _giftCardCode);
    }

    function getBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTask(uint256 _taskId) public view validTaskId(_taskId) returns (Task memory) {
        return tasks[_taskId];
    }

    function setRewardRate(uint256 _newRate) public onlyOwner {
        rewardRate = _newRate;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
