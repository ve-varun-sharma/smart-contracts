// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// TODO: Overall a work in progress:
// Imports and Inheritance: The contract imports IERC20 from OpenZeppelin for
// interacting with the YGG token and Ownable for access control.
// TODO add Ownable
contract EmploymentTokenVestingContractForVe {
    IERC20 public yggToken;
    address public employee;
    uint256 public cliffDuration = 365 days;
    uint256 public vestingDuration = 2 * 365 days;
    uint256 public start;
    uint256 public totalTokens = 166666.67 * 10 ** 18; // $50,000 / $0.30 per token
    uint256 public tokensPerMonth = totalTokens / 24;
    uint256 public releasedTokens;

    event TokensReleased(uint256 amount);

    constructor(address _yggToken, address _employee, uint256 _start) {
        yggToken = IERC20(_yggToken);
        employee = _employee;
        start = _start;
    }

    function release() public {
        require(
            block.timestamp >= start + cliffDuration,
            "Cliff period not reached"
        );
        uint256 elapsedTime = block.timestamp - start;
        uint256 totalVestedTokens = 0;

        if (elapsedTime >= cliffDuration + vestingDuration) {
            totalVestedTokens = totalTokens;
        } else {
            uint256 monthsElapsed = (elapsedTime - cliffDuration) / 30 days;
            totalVestedTokens = monthsElapsed * tokensPerMonth;
        }

        uint256 releasableTokens = totalVestedTokens - releasedTokens;
        require(releasableTokens > 0, "No tokens to release");

        releasedTokens += releasableTokens;
        yggToken.transfer(employee, releasableTokens);

        emit TokensReleased(releasableTokens);
    }

    function getReleasableTokens() public view returns (uint256) {
        if (block.timestamp < start + cliffDuration) {
            return 0;
        }

        uint256 elapsedTime = block.timestamp - start;
        uint256 totalVestedTokens = 0;

        if (elapsedTime >= cliffDuration + vestingDuration) {
            totalVestedTokens = totalTokens;
        } else {
            uint256 monthsElapsed = (elapsedTime - cliffDuration) / 30 days;
            totalVestedTokens = monthsElapsed * tokensPerMonth;
        }

        return totalVestedTokens - releasedTokens;
    }
}
