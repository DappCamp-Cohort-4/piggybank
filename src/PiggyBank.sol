// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PiggyBank {
    address child;
    address public owner;
    uint256 maxWithdrawAmount;

    constructor(address _child, uint256 _maxWithdrawAmount) {
        owner = msg.sender;
        child = _child;
        maxWithdrawAmount = _maxWithdrawAmount;
    }

    modifier isChild() {
        require(msg.sender == child, "Only the child can withdraw");
        _;
    }

    function deposit() public payable {}

    function withdraw(uint256 amount) public isChild {
        require(amount <= maxWithdrawAmount, "Withdraw amount greater than balance");
        require(amount <= address(this).balance, "Amount greater than balance");
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Failed to send Ether");
    }
}
