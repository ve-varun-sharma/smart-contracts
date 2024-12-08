// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import 'hardhat/console.sol';
import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';

// TODO WORK IN PROGRESS DUE TO _ownerOf/_exists issue via inheritance from openzeppelin
/// @title Tempestas Militum (Storm of the Soldiers).
/// @author Ve
/// @dev This smart contract/NFT changes based on the current weather and provides the appropiate Roman Solider art based on the climate.

contract TempestasMilitumNFT is ERC721, Ownable {
  /// @notice Base URI for the NFT metadata
  string public baseURI;

  /// @notice Current temperature value
  int256 public currentTemperature;

  /// @notice Mapping from token ID to token URI
  mapping(uint256 => string) private _tokenURIs;

  /// @notice Constructor to initialize the contract
  /// @param _name Name of the NFT collection
  /// @param _symbol Symbol of the NFT collection
  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

  /// @notice Internal function to return the base URI
  /// @return Base URI string
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  /// @notice Function to set the base URI for the NFT metadata
  /// @param _baseURI New base URI string
  function setBaseURI(string memory _baseURI) public onlyOwner {
    baseURI = _baseURI;
  }

  /// @notice Function to mint a new NFT
  /// @param to Address to receive the NFT
  /// @param tokenId ID of the NFT to be minted
  function mint(address to, uint256 tokenId) public onlyOwner {
    _safeMint(to, tokenId);
    _setTokenURI(tokenId, baseURI);
  }

  /// @notice Internal function to set the token URI for a given token ID
  /// @param tokenId ID of the token
  /// @param _tokenURI URI to be assigned to the token
  function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
    require(_ownerOf(tokenId), 'ERC721Metadata: URI set of nonexistent token');
    _tokenURIs[tokenId] = _tokenURI;
  }

  /// @notice Function to get the token URI for a given token ID
  /// @param tokenId ID of the token
  /// @return URI string of the token
  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

    string memory weatherCondition = getWeatherCondition(currentTemperature);

    return string(abi.encodePacked(baseURI, weatherCondition, '.json'));
  }

  /// @notice Internal function to determine the weather condition based on temperature
  /// @param temperature Temperature value
  /// @return Weather condition string
  function getWeatherCondition(int256 temperature) internal pure returns (string memory) {
    if (temperature < 0) {
      return 'cold';
    } else if (temperature < 15) {
      return 'cool';
    } else if (temperature < 30) {
      return 'warm';
    } else {
      return 'hot';
    }
  }

  /// @notice Function to update the current temperature
  /// @param temperature New temperature value
  function updateTemperature(int256 temperature) public onlyOwner {
    currentTemperature = temperature;
  }
}
