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

  // Get current nonce
  const nonce = await deployer.getNonce()
  console.log('Current nonce:', nonce)

  // Get network information
  const network = await hardhat.ethers.provider.getNetwork()

  // Get network currency symbol
  const currencySymbol = network.name === 'polygon' ? 'MATIC' : 'ETH'
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

  const rawBalance = balance.toString()

  // Format values with full precision
  const formattedGasPrice = hardhat.ethers.formatUnits(gasPrice, 'gwei')
  const formattedTotalCost = hardhat.ethers.formatUnits(totalCost, 18)
  const formattedBalance = hardhat.ethers.formatUnits(balance, 18)

  // Debug logs with raw values
  console.log('Raw balance:', rawBalance)
  console.log(`Estimated gas units: ${estimatedGas.toString()}`)
  console.log(`Current gas price: ${formattedGasPrice} gwei`)
  console.log(`Total cost in ${currencySymbol}: ${formattedTotalCost}`)
  console.log(`Account balance in ${currencySymbol}: ${formattedBalance}`)

  // Validate sufficient funds
  if (balance < totalCost) {
    throw new Error(
      `Insufficient funds. Need ${formattedTotalCost} ${currencySymbol} but have ${formattedBalance} ${currencySymbol}`,
    )
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

    // Deploy with explicit nonce and higher gas price
    const deploymentOptions = {
      nonce: nonce,
      gasLimit: estimatedGas * BigInt(2), // Double gas limit for safety
      gasPrice: ((await hardhat.ethers.provider.getFeeData()).gasPrice * BigInt(12)) / BigInt(10), // 20% higher
    }

    console.log('Deployment options:', {
      nonce: deploymentOptions.nonce,
      gasLimit: deploymentOptions.gasLimit.toString(),
      gasPrice: hardhat.ethers.formatUnits(deploymentOptions.gasPrice, 'gwei') + ' gwei',
    })

    const ve3NFT = await Ve3NFT.deploy(deploymentOptions)

    // const ve3NFT = await Ve3NFT.deploy()
    // await ve3NFT.waitForDeployment()

    console.log('Ve3NFT deployed to:', await ve3NFT.getAddress())
    // Set base URI
    await ve3NFT.setBaseURI(baseURI)
    console.log('Base URI set to:', baseURI)

    // Wait for few block confirmations to ensure deployment is confirmed
    // await ve3NFT.deployTransaction.wait(6)

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

    console.log('Ve3NFT contract deployed to:', ve3NFT.getAddress())
  } else {
    console.log('Deployment cancelled.')
  }
  terminalRl.close()
}

main()
  .then(() => process.exit(0))
  .catch(async error => {
    if (error.message.includes('ALREADY_EXISTS')) {
      console.log('Transaction already pending. Please wait or increase gas price.')
    } else {
      console.error(error)
    }
    process.exit(1)
  })
// Ve3NFT deployed to: 0x24E8ffdB8c50ecB25bE1dC26F0561A387d763d50
