// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// // Don't use this import
// //In the latest version of @chainlink/contracts (i.e, v1.2.0 at this point in time),
// // the AggregatorV3Interface.sol file has been moved to the shared/interfaces folder
// // Reference: https://ethereum.stackexchange.com/questions/164934/source-chainlink-contracts-src-v0-8-interfaces-aggregatorv3interface-sol-not
// // import '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';
// import '@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';
// import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
// import '@openzeppelin/contracts/access/Ownable.sol';
// import '@openzeppelin/contracts/utils/Strings.sol';

// // 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/to_panda_rain.png', // Rainy image
// // 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/to_panda_summer.png', // Sunny image
// // 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/to_panda_summer.png' // Snowy image
// // 'https://storage.googleapis.com/web3-nfts/trash-panda-nft/to_panda_normal.png'// Normal image

// contract TorontoRaccoonNFT is ERC721, Ownable {
//   using Strings for uint256;
//   uint256 private _tokenIdCounter;

//   string private _baseTokenURI;
//   AggregatorV3Interface internal weatherOracle;

//   mapping(uint256 => string) private _tokenURIs;

//   uint256 public constant MAX_SUPPLY = 5;

//   constructor(string memory baseTokenURI, address oracleAddress) ERC721('TorontoRaccoonNFT', 'TRASH') {
//     _baseTokenURI = baseTokenURI;
//     weatherOracle = AggregatorV3Interface(oracleAddress);
//   }

//   function _baseURI() internal view override returns (string memory) {
//     return _baseTokenURI;
//   }

//   function mint(address to) public onlyOwner {
//     uint256 tokenId = _tokenIdCounter;
//     require(_tokenIdCounter < MAX_SUPPLY, 'Max supply reached');
//     _tokenIdCounter += 1;
//     _safeMint(to, tokenId);
//     _updateTokenURI(tokenId);
//   }

//   function tokenURI(uint256 tokenId) public view override returns (string memory) {
//     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
//     return _tokenURIs[tokenId];
//   }

//   function setBaseURI(string memory baseTokenURI) public onlyOwner {
//     _baseTokenURI = baseTokenURI;
//   }

//   function _updateTokenURI(uint256 tokenId) internal {
//     (, int256 weatherData, , , ) = weatherOracle.latestRoundData();
//     string memory weatherCondition = _getWeatherCondition(weatherData);
//     _tokenURIs[tokenId] = string(abi.encodePacked(_baseURI(), weatherCondition, '/', tokenId.toString(), '.json'));
//   }

//   function _getWeatherCondition(int256 weatherData) internal pure returns (string memory) {
//     if (weatherData < 0) {
//       return 'cold';
//     } else if (weatherData < 20) {
//       return 'cool';
//     } else if (weatherData < 30) {
//       return 'warm';
//     } else {
//       return 'hot';
//     }
//   }

//   function updateAllTokenURIs() public onlyOwner {
//     for (uint256 i = 0; i < (_tokenIdCounter += 1); i++) {
//       _updateTokenURI(i);
//     }
//   }

//   function totalSupply() public view returns (uint256) {
//     return _tokenIdCounter;
//   }
// }
