// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GreenRoad is Ownable {
    IERC20 public token20;
    IERC721 public token721;

    uint256 rewardPercentage;

    event CarbonEmissionSaved(address indexed user, uint256 amount);
    event TokensTransferred(address indexed user, address indexed receiver, uint256 amount);
    event NFTTransferred(address indexed user, address indexed receiver, uint256 tokenId);

    constructor(address _token20, address _token721, uint256 _rewardPercentage) Ownable() {
        token20 = IERC20(_token20);
        token721 = IERC721(_token721);
        rewardPercentage = _rewardPercentage;
    }

    function rewardCarbonEmission(address user, uint256 amount, address receiver) external onlyOwner {
        uint256 rewardAmount = (amount * rewardPercentage) / 100;
        token20.transfer(receiver, rewardAmount);

        emit TokensTransferred(user, receiver, rewardAmount);
    }

    function rewardERC20(address user, uint256 amount, address receiver) external onlyOwner {
        token20.transferFrom(user, receiver, amount);

        emit TokensTransferred(user, receiver, amount);
    }

    function rewardERC721(address user, uint256 tokenId, address receiver) external onlyOwner {
        token721.safeTransferFrom(user, receiver, tokenId);

        emit NFTTransferred(user, receiver, tokenId);
    }

    function setERC20Token(address _token20) external onlyOwner {
        token20 = IERC20(_token20);
    }

    function setERC721Token(address _token721) external onlyOwner {
        token721 = IERC721(_token721);
    }
}
