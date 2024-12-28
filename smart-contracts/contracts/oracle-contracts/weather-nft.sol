// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

/**
 * @title MyContract is an example contract which requests data from
 * the Chainlink network
 * @dev This contract is designed to work on multiple networks, including
 * local test networks
 * https://blog.chain.link/how-to-build-dynamic-nfts-on-polygon/
 */
contract WeatherFeed is ChainlinkClient, Ownable {
  using Strings for string;
  using Chainlink for Chainlink.Request;

  string public weather;
  bytes32 public jobId;
  address public oracle;
  uint256 public fee;
  /**
   * @notice Deploy the contract with a specified address for the LINK
   * and Oracle contract addresses
   * @dev Sets the storage for the specified addresses
   * @param _link The address of the LINK token contract
   * @param _oracle The address of the Oracle contract
   * @param _jobId The job ID for the Chainlink request
   * @param _fee The fee for the Chainlink request
   */
  constructor(address initialOwner, address _link, address _oracle, bytes32 _jobId, uint256 _fee) Ownable() {
    _setChainlinkToken(_link);
    oracle = _oracle;
    jobId = _jobId;
    fee = _fee;
  }

  /**
   * @notice Request weather data from the Chainlink oracle
   */
  function requestWeatherData() public onlyOwner {
    Chainlink.Request memory request = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
    request.add('get', 'https://api.weatherapi.com/v1/current.json?key=APIKEY&q=Toronto');
    request.add('path', 'current.condition.text');
    _sendChainlinkRequestTo(oracle, request, fee);
  }

  /**
   * @notice Fulfill the Chainlink request
   * @param _requestId The ID of the request
   * @param _weather The weather data returned by the oracle
   */
  function fulfill(bytes32 _requestId, string memory _weather) public recordChainlinkFulfillment(_requestId) {
    weather = _weather;
  }
}
