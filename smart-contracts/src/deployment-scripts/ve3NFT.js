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
  // Log deployment start
  console.log('Deploying Ve3NFT...')

  const [deployer] = await hardhat.ethers.getSigners()

  // Get network information
  const network = await hardhat.ethers.provider.getNetwork()
  console.log('Network:', {
    name: network.name,
    chainId: network.chainId.toString(),
    ensAddress: network.ensAddress || 'none',
  })

  console.log('Deploying contracts with the account:', deployer.address)

  // Grab the contract factory

  const Ve3NFT = await hardhat.ethers.getContractFactory('Ve3NFT')

  // Estimate gas using proper ethers v6 syntax
  const deployTx = await Ve3NFT.getDeployTransaction()
  const estimatedGas = await deployer.estimateGas(deployTx)

  // Check wallet balance
  const balance = await deployer.provider.getBalance(deployer.address)

  // Get current gas price using getFeeData
  const feeData = await hardhat.ethers.provider.getFeeData()
  const gasPrice = feeData.gasPrice

  // Calculate total cost (both values are already BigInt)
  const totalCost = estimatedGas * gasPrice

  // Format values for display
  const formattedGasPrice = hardhat.ethers.formatUnits(gasPrice, 'gwei')
  const formattedTotalCost = hardhat.ethers.formatEther(totalCost)
  const formattedBalance = hardhat.ethers.formatEther(balance)

  // Log values
  console.log(`Estimated gas units: ${estimatedGas.toString()}`)
  console.log(`Current gas price: ${formattedGasPrice} gwei`)
  console.log(`Total cost in ETH: ${Number(formattedTotalCost).toFixed(18)}`)
  console.log(`Account balance: ${Number(formattedBalance).toFixed(18)}`)

  // Validate sufficient funds
  if (balance < totalCost) {
    throw new Error(`Insufficient funds. Need ${formattedTotalCost} ETH but have ${formattedBalance} ETH`)
  }
  console.log('Sufficient funds available, proceeding with deployment...')

  // Prompt the user to proceed or reject
  const terminalRl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  })

  // Ask user for confirmation
  const answer = await askUser('Do you want to proceed with the deployment? (yes/no): ')
  if (answer.toLowerCase() === 'yes') {
    // Deploy the contract

    console.log('ABOUT TO DEPLOY')
    // Deploy contract
    const baseURI = 'https://storage.googleapis.com/web3-nfts/ve-nfts/ve3-nft-metadata.json'
    const ve3NFT = await Ve3NFT.deploy()
    await ve3NFT.waitForDeployment()

    console.log('Ve3NFT deployed to:', await ve3NFT.getAddress())
    // Set base URI
    await ve3NFT.setBaseURI(baseURI)
    console.log('Base URI set to:', baseURI)

    // Wait for few block confirmations to ensure deployment is confirmed
    await ve3NFT.deployTransaction.wait(6)

    // Verify the contract on Etherscan
    // if (process.env.ETHERSCAN_API_KEY) {
    //   console.log('Verifying contract...')
    //   try {
    //     await hardhat.run('verify:verify', {
    //       address: ve3NFT.address,
    //       constructorArguments: [],
    //     })
    //   } catch (error) {
    //     console.error('Error verifying contract:', error)
    //   }
    // }

    console.log('Ve3NFT contract deployed to:', ve3NFT.address)
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
