const { ethers } = require('ethers')
const hardhat = require('hardhat')

async function main() {
  const [deployer] = await hardhat.ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)

  const balance = await deployer.getBalance()
  console.log('Account balance:', balance.toString())

  const BitcoinPrice = await hardhat.ethers.getContractFactory('BitcoinPrice')
  const bitcoinPrice = await BitcoinPrice.deploy()

  console.log('BitcoinPrice contract deployed to:', bitcoinPrice.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
