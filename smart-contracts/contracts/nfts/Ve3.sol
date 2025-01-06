// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

contract Ve3NFT is ERC721URIStorage, Ownable {
  using Strings for uint256;

  uint256 private _tokenIds;
  string private _baseTokenURI;

  // emit event for transparency of base uri changing
  event BaseURIChanged(string newBaseURI);

  constructor() ERC721('Ve3NFT', 'VE3') Ownable(msg.sender) {
    _baseTokenURI = 'https://storage.googleapis.com/web3-nfts/ve-nfts/ve3-nft-metadata.json';
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  function setBaseURI(string memory baseURI) public onlyOwner {
    // only the owner can set the base uri to prevent security issues
    _baseTokenURI = baseURI;
    emit BaseURIChanged(baseURI);
  }

  function mintNFT(address recipient, string memory tokenURI) public returns (uint256) {
    _tokenIds++;

    uint256 newItemId = _tokenIds;
    _mint(recipient, newItemId);
    _setTokenURI(newItemId, tokenURI);

    return newItemId;
  }
}
