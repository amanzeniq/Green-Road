// contracts/RewardToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RewardToken is ERC20 {
    constructor(string memory _tokenName, string memory _tokenSymbol, uint256 initialSupply) ERC20(_tokenName, _tokenSymbol) {
        _mint(msg.sender, initialSupply);
    }
}