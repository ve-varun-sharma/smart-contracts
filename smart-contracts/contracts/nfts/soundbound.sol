// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract TrashPandaBadge is ERC721, ERC721URIStorage, Ownable {
  uint256 private _tokenIdCounter;
  string private _baseTokenURI;

  constructor() ERC721('TrashPandaBadge', 'TRASH') Ownable(msg.sender) {
    _baseTokenURI = 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/trash-panda-soulbound-token-metadata.json';
  }

  function safeMint(address to, string memory uri) public onlyOwner {
    uint256 tokenId = _tokenIdCounter;
    _tokenIdCounter++;
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, uri);
  }

  function burn(uint256 tokenId) external {
    require(ownerOf(tokenId) == msg.sender, 'Only the owner of the token can burn it.');
    _burn(tokenId);
  }

  function _beforeTokenTransfer(address from, address to, uint256) internal pure {
    require(from == address(0) || to == address(0), 'This token cannot be transferred');
  }

  function _burn(uint256 tokenId) internal override(ERC721) {
    super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(tokenId);
  }

  function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721URIStorage) returns (bool) {
    return super.supportsInterface(interfaceId);
  }
}
