// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Ve3NFT is ERC721URIStorage, Ownable {
  uint256 private _tokenIds;
  string private _metadataURL;

  event MetadataURLChanged(string newMetadataURL);

  constructor() ERC721('Ve3NFT', 'VE3') Ownable(msg.sender) {
    _metadataURL = 'https://storage.googleapis.com/web3-nfts/ve-nfts/ve3-nft-metadata.json';
  }

  function setMetadataURL(string memory metadataURL) public onlyOwner {
    _metadataURL = metadataURL;
    emit MetadataURLChanged(metadataURL);
  }

  function mintNFT(address recipient) public returns (uint256) {
    _tokenIds++;
    uint256 newItemId = _tokenIds;
    _mint(recipient, newItemId);
    _setTokenURI(newItemId, _metadataURL);
    return newItemId;
  }

  function getMetadataURL() public view returns (string memory) {
    return _metadataURL;
  }
}
