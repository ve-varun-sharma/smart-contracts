// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract V3 is ERC721URIStorage, Ownable {
  uint256 private _tokenIdCounter;
  string private _baseTokenURI;

  constructor(string memory baseURI) ERC721URIStorage('Ve3', 'Ve3') {
    _baseTokenURI = baseURI;
  }

  function mintVeNFT(address to) public onlyOwner {
    uint256 tokenId = _tokenIdCounter;
    _tokenIdCounter++;
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, tokenURI(tokenId));
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return _baseTokenURI;
  }

  // TODO: Get the _exist() function fixed.
  function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage) returns (string memory) {
    require(_exists(tokenId), 'Token ID does not exist');
    return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), '.json'));
  }
  function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage) {
    super._burn(tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
