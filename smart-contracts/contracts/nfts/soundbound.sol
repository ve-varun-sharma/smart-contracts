// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

/**
 * @title SoulBoundToken
 * @dev Implementation of a non-transferrable NFT (SoulBound Token)
 * Once minted, these tokens cannot be transferred between addresses
 * They can only be minted by the contract owner and burned by the token owner
 */
contract SoulBoundToken is ERC721, Ownable {
  /// @dev Counter for token IDs, increments with each mint
  uint256 private _tokenIdCounter;

  /**
   * @dev Constructor initializes the contract with a name and symbol
   * Sets the contract deployer as the initial owner
   */
  constructor() ERC721('SoulBoundToken', 'SBT') Ownable(msg.sender) {}

  /**
   * @dev Mints a new token to the specified address
   * @param to The address that will own the minted token
   * @notice Only the contract owner can mint new tokens
   */
  function safeMint(address to) public onlyOwner {
    uint256 tokenId = _tokenIdCounter;
    _tokenIdCounter++;
    _safeMint(to, tokenId);
  }

  /**
   * @dev Burns a specific token
   * @param tokenId The ID of the token to burn
   * @notice Only the owner of the token can burn it
   */
  function burn(uint256 tokenId) external {
    require(ownerOf(tokenId) == msg.sender, 'Only the owner of the token can burn it.');
    _burn(tokenId);
  }

  /**
   * @dev Internal function to enforce non-transferability of tokens
   * @param from The current owner of the token
   * @param to The address to receive the token
   * @notice Allows only minting (from zero address) and burning (to zero address)
   */
  function _beforeTokenTransfer(address from, address to, uint256) internal pure {
    require(from == address(0) || to == address(0), 'This token cannot be transferred');
  }
}
