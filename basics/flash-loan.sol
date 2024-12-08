// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@aave/protocol-v2/contracts/interfaces/IFlashLoanReceiver.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// Plan
// Define the contract and import necessary libraries.
// Implement the constructor to initialize the contract.
// Implement the flashLoan function to request a loan.
// Implement the executeOperation function to handle the loan logic.
// Implement the repayLoan function to repay the loan.




contract FlashLoanExample is IFlashLoanReceiver, Ownable {
    ILendingPoolAddressesProvider public addressesProvider;

    constructor(address _addressesProvider) {
        addressesProvider = ILendingPoolAddressesProvider(_addressesProvider);
    }

    function flashLoan(address asset, uint256 amount) external onlyOwner {
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        address receiverAddress = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        lendingPool.flashLoan(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Your custom logic here

        // Repay the loan
        uint256 totalDebt = amount + premium;
        IERC20(asset).approve(addressesProvider.getLendingPool(), totalDebt);

        return true;
    }

    function repayLoan(address asset, uint256 amount) external onlyOwner {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        IERC20(asset).approve(addressesProvider.getLendingPool(), amount);
    }
}