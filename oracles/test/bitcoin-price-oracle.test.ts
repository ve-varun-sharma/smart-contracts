import { expect } from 'chai'
import { Contract } from 'ethers'
import hre from 'hardhat'

describe('BitcoinPrice', function () {
  let bitcoinPrice: Contract & { updatePrice: (price: string) => Promise<void>; latestPrice: () => Promise<string> }
  let owner: any
  let addr1: any

  beforeEach(async function () {
    ;[owner, addr1] = await hre.ethers.getSigners()
    const BitcoinPriceFactory = await hre.ethers.getContractFactory('BitcoinPrice')
    // const BitCoinOracleContract = await hre.ethers.deployContract('BitcoinPrice')

    bitcoinPrice = (await BitcoinPriceFactory.deploy()) as unknown as Contract & {
      updatePrice: (price: string) => Promise<void>
      latestPrice: () => Promise<string>
    }
    // await bitcoinPrice.deployed() //Not needed use getContractFactory then .deploy
    await bitcoinPrice.waitForDeployment()
    const deploymentReceipt = await bitcoinPrice.deploymentTransaction()?.wait() // Wait for the deployment transaction to be mined
    //@ts-expect-error There's no type for deployment receipt
    console.log('Deployment receipt contractAddress:', deploymentReceipt.contractAddress) // Log the deployment receipt
    // don't use .address, you must use .target
    console.log('Contract deployed at address:', bitcoinPrice.target) // Log the address
  })

  it('should deploy the contract', async function () {
    expect(bitcoinPrice.target).to.properAddress
    expect(bitcoinPrice.target).to.have.lengthOf(42) // Ethereum addresses are 42 characters long
  })

  it('should set the deployer as the oracle', async function () {
    const oracle = await bitcoinPrice.oracle()
    expect(oracle).to.equal(owner.address)
  })

  it('should update the price when called by the oracle', async function () {
    const newPrice = '{"bitcoin":"50000"}'
    await bitcoinPrice.updatePrice(newPrice)
    const latestPrice = await bitcoinPrice.latestPrice()
    expect(latestPrice).to.equal(newPrice)
  })

  it('should not update the price when called by a non-oracle', async function () {
    const newPrice = '{"bitcoin":"50000"}'
    // @ts-expect-error type not updated on Ether Contract type
    await expect(bitcoinPrice.connect(addr1).updatePrice(newPrice)).to.be.revertedWith('Only the Oracle can update')
  })
})
