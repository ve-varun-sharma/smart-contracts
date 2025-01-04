// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Ve3NFT is ERC721URIStorage {
  uint256 private _tokenIds;

  constructor(address initialOwner) ERC721('Ve3NFT', 'VE3') {}

  function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
    _tokenIds++;

    uint256 newItemId = _tokenIds;
    _mint(recipient, newItemId);
    _setTokenURI(newItemId, tokenURI);

    return newItemId;
  }
}
