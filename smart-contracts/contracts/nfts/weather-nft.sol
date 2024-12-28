// pragma solidity ^0.8.0;

// import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
// import '@chainlink/contracts/src/v0.8/interfaces/ChainlinkRequestInterface.sol';

// contract DynamicWeatherNFT is ERC721, ChainlinkRequestInterface {
//   bytes32 public requestId;
//   string public city;
//   string public weatherDescription;
//   string public imageHash;

//   constructor() ERC721('DynamicWeatherNFT', 'DWNFT') {}

//   function requestWeatherData(string memory _city) public {
//     city = _city;
//     Chainlink.Request memory req = buildChainlinkRequest(
//       'YOUR_JOB_ID', // Replace with your actual Job ID from Chainlink
//       address(this),
//       this.fulfill.selector
//     );
//     // Set the URL to access the weather data API
//     req.add('get', 'https://api.openweathermap.org/data/2.5/weather?q=');
//     req.add('get', _city);
//     req.add('get', '&appid=YOUR_API_KEY'); // Replace with your actual OpenWeatherMap API key
//     req.add('path', 'main.temp'); // Example: Fetch temperature data
//     requestId = sendChainlinkRequestTo(address(link), req, 100000); // Adjust timeout as needed
//   }

//   function fulfill(bytes32 _requestId, uint256 _temperature) public recordChainlinkFulfillment(_requestId) {
//     // Example: Update NFT metadata based on temperature
//     if (_temperature > 25) {
//       weatherDescription = 'Sunny';
//       imageHash = 'ipfs://hash_of_sunny_image';
//     } else {
//       weatherDescription = 'Rainy';
//       imageHash = 'ipfs://hash_of_rainy_image';
//     }
//     // Emit an event to signal the update
//     emit WeatherUpdated(city, weatherDescription, imageHash);
//   }

//   event WeatherUpdated(string city, string description, string imageHash);

//   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
//     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');

//     string memory jsonUri = baseURI();
//     string memory base64Encoded = Base64.encode(
//       bytes(
//         string(
//           abi.encodePacked(
//             '{"name": "Dynamic Weather NFT", "description": "',
//             weatherDescription,
//             '", "image": "',
//             imageHash,
//             '"}'
//           )
//         )
//       )
//     );
//     return string(abi.encodePacked(jsonUri, base64Encoded));
//   }

//   function baseURI() internal pure virtual override returns (string memory) {
//     return 'data:application/json;base64,';
//   }
// }

// //  This contract requires the following:
// // 1. Chainlink contract address (address(link))
// // 2. Chainlink Job ID
// // 3. OpenWeatherMap API key
// // 4. IPFS hashes for weather-specific images

// // **Explanation:**

// // 1. **Import necessary contracts:**
// //    - `ERC721` from OpenZeppelin for basic NFT functionality.
// //    - `ChainlinkRequestInterface` for interacting with Chainlink oracles.

// // 2. **State variables:**
// //    - `requestId`: Stores the ID of the Chainlink request.
// //    - `city`: Stores the city for which to fetch weather data.
// //    - `weatherDescription`: Stores a description of the weather (e.g., "Sunny", "Rainy").
// //    - `imageHash`: Stores the IPFS hash of the image representing the current weather.

// // 3. **`requestWeatherData()` function:**
// //    - Initiates a Chainlink request to the OpenWeatherMap API to fetch the current weather data for the specified city.
// //    - Stores the `requestId` for tracking the request.

// // 4. **`fulfill()` function:**
// //    - This function is called by the Chainlink oracle when the weather data is received.
// //    - Updates the `weatherDescription` and `imageHash` based on the received temperature data.
// //    - Emits a `WeatherUpdated` event.

// // 5. **`tokenURI()` function:**
// //    - Overrides the `tokenURI()` function from the ERC721 contract to generate a dynamic URI for each NFT.
// //    - The URI contains the `weatherDescription` and `imageHash`, making the NFT metadata dynamic.

// // 6. **`baseURI()` function:**
// //    - Defines the base URI for the NFT metadata.

// // **Note:**

// // * This is a simplified example. You'll need to adapt it to your specific requirements and integrate it with your chosen blockchain network.
// // * **Security:** Always thoroughly test and audit your smart contracts before deploying them on a mainnet.
// // * **Consider using a more advanced Chainlink VRF (Verifiable Random Function)** for more secure and unpredictable results.

// // This example demonstrates the core concept of creating a dynamic NFT that changes based on external data. You can further enhance it by adding more weather conditions, incorporating more complex image generation techniques, and exploring different ways to represent the weather data in the NFT.
// //
