const hardhat = require('hardhat')
const readline = require('readline')

function askUser(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  })
  return new Promise(resolve => {
    rl.question(question, answer => {
      rl.close()
      resolve(answer)
    })
  })
}
async function main() {
  const [deployer] = await hardhat.ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)
  const BitcoinPriceOracle = await hardhat.ethers.getContractFactory('BitcoinPrice')

  // const balance = await deployer.getBalance();
  // console.log('Account balance:', hre.ethers.utils.formatEther(balance), 'ETH');

  // Prepare the deploy transaction
  const deployTxRequest = BitcoinPriceOracle.getDeployTransaction()

  // Estimate gas and cost
  // Instead of deployer.estimateGas(...), directly use hre.ethers.provider.estimateGas
  const estimatedGas = await hre.ethers.provider.estimateGas({
    ...deployTxRequest,
    from: deployer.address,
  })

  // Both estimatedGas and gasPrice should be BigNumbers
  console.log(`Estimated gas cost: = ${estimatedGas.toString()}`)

  // Prompt the user to proceed or reject
  const terminalRl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  })

  // Ask user for confirmation
  const answer = await askUser('Do you want to proceed with the deployment? (yes/no): ')
  if (answer.toLowerCase() === 'yes') {
    const bitcoinPrice = await BitcoinPriceOracle.deploy()
    await bitcoinPrice.deployed() // Wait for the deployment to be mined

    console.log('BitcoinPrice contract deployed to:', bitcoinPrice.address)
  } else {
    console.log('Deployment cancelled.')
  }
  terminalRl.close()
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
