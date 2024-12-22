import { ethers } from 'hardhat'
import { expect } from 'chai'
import { Contract } from 'ethers'

describe('DynamicWeatherNFT', function () {
  let weatherNFT: Contract

  beforeEach(async function () {
    const WeatherNFT = await ethers.getContractFactory('DynamicWeatherNFT')
    weatherNFT = await WeatherNFT.deploy()
    await weatherNFT.deployed()
  })

  it('should deploy the contract', async function () {
    expect(weatherNFT.address).to.properAddress
  })

  it('should request weather data', async function () {
    const city = 'London'
    await weatherNFT.requestWeatherData(city)
    const storedCity = await weatherNFT.city()
    expect(storedCity).to.equal(city)
  })

  it('should fulfill weather data request', async function () {
    const city = 'London'
    await weatherNFT.requestWeatherData(city)

    // Simulate Chainlink node fulfilling the request
    const requestId = await weatherNFT.requestId()
    const temperature = 30 // Example temperature
    await weatherNFT.fulfill(requestId, temperature)

    const weatherDescription = await weatherNFT.weatherDescription()
    expect(weatherDescription).to.equal('Sunny')
  })
})
