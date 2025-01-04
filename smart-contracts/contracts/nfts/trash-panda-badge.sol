// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
// import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol';
// import '@openzeppelin/contracts/access/Ownable.sol';

// // https://www.quicknode.com/guides/ethereum-development/smart-contracts/how-to-create-a-soulbound-token
// contract TrashPandaBadge is Ownable, ERC721URIStorage {
//   uint256 private _tokenIdCounter;
//   string private _baseTokenURI;

//   constructor() ERC721('TrashPandaBadge', 'TRASH') Ownable(msg.sender) {
//     _baseTokenURI = 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/trash-panda-soulbound-token-metadata.json';
//   }

//   function safeMint(address to, string memory uri) public onlyOwner {
//     uint256 tokenId = _tokenIdCounter;
//     _tokenIdCounter++;
//     _safeMint(to, tokenId);
//     _setTokenURI(tokenId, uri);
//   }

//   function burn(uint256 tokenId) external {
//     require(ownerOf(tokenId) == msg.sender, 'Only the owner of the token can burn it.');
//     _burn(tokenId);
//   }

//   // -------------------------------------
//   // Overrides
//   //

//   // _beforeTokenTransfer is only virtual in ERC721, so override just from ERC721
//   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {
//     require(from == address(0) || to == address(0), 'This token cannot be transferred');
//   }

//   // _burn is not virtual in ERC721, but virtual in ERC721URIStorage, so override only from ERC721URIStorage
//   function _burn(uint256 tokenId) internal virtual override {
//     return super._burn(tokenId); // calls ERC721URIStorage._burn, which also calls ERC721._burn internally
//   }

//   // tokenURI is virtual in both ERC721 and ERC721URIStorage, so override both
//   function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage) returns (string memory) {
//     return super.tokenURI(tokenId);
//   }

//   // supportsInterface is also virtual in both, so override both
//   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721URIStorage) returns (bool) {
//     return super.supportsInterface(interfaceId);
//   }
// }
