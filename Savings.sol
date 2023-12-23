//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Savings {
    address ethAddress;
    address public owner;

    mapping (address => uint256) savings;
    
    event DepositSuccessful(address user, uint256 amount);
    event WithdrawalSuccessful (address user, uint256 amount);

    constructor(address _ethAddress) {
        ethAddress = _ethAddress;
        owner = msg.sender;
    }

    function deposit (uint256 _amount) external {
        require (IERC20(ethAddress).balanceOf(msg.sender) >= _amount, "insufficient balance");
        require (_amount > 0, "cannot accept zero value");

        IERC20(ethAddress).transferFrom(msg.sender, address(this), _amount);

        savings [msg.sender] += _amount;

        emit DepositSuccessful (msg.sender, _amount);
    }

    function withdraw (uint256 _amount) external {
        require(_amount > 0, "cannot withdraw zero value");
        require(savings[msg.sender] !=0 , "Insufficient funds");

        IERC20(ethAddress).transfer(msg.sender, _amount);

        savings[msg.sender]= savings[msg.sender] -=_amount;

        emit WithdrawalSuccessful (msg.sender, _amount);
    }

    function getUserSavings () external view returns (uint256) {
        return savings[msg.sender];
    }
}