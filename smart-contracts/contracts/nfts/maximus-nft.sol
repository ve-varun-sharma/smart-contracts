// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

/// @title MaximusNFT
/// @dev A MaximusNFT contract that allows people to mint a limited number of Maximus NFTs for a certain price.
contract MaximusNFT is ERC721, Ownable {
  uint256 public maxSupply;
  uint256 public totalMinted;
  uint256 public mintPrice;
  string public baseTokenURI;

  /// @notice Constructor to initialize the contract
  /// @param _name Name of the NFT collection
  /// @param _symbol Symbol of the NFT collection
  /// @param _maxSupply Maximum number of NFTs that can be minted
  /// @param _mintPrice Price to mint each NFT
  /// @param _baseTokenURI Base URI for the NFT metadata
  constructor(
    address initialOwner,
    string memory _name,
    string memory _symbol,
    uint256 _maxSupply,
    uint256 _mintPrice,
    string memory _baseTokenURI
  ) ERC721(_name, _symbol) Ownable(initialOwner) {
    maxSupply = _maxSupply;
    mintPrice = _mintPrice;
    baseTokenURI = _baseTokenURI;
  }

  /// @notice Function to mint a new NFT
  /// @param to Address to receive the NFT
  function mint(address to) public payable {
    require(totalMinted < maxSupply, 'Max supply reached');
    require(msg.value >= mintPrice, 'Insufficient payment');
    uint256 tokenId = totalMinted + 1;
    _safeMint(to, tokenId);
    totalMinted++;
  }

  /// @notice Internal function to return the base URI
  /// @return Base URI string
  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  /// @notice Function to withdraw the contract balance to the owner's address
  function withdraw() public onlyOwner {
    payable(owner()).transfer(address(this).balance);
  }
}
