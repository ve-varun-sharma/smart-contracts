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

  // Get current gas price
  const gasPrice = await hardhat.ethers.provider.getFeeData()

  // Calculate total cost in wei
  const totalCostWei = estimatedGas * gasPrice.gasPrice
  const totalCostEth = hardhat.ethers.formatEther(totalCostWei)

  // Both estimatedGas and gasPrice should be BigNumbers
  console.log(`Estimated gas cost = ${estimatedGas.toString()}`)
  console.log(`Current gas price: ${hre.ethers.formatUnits(gasPrice.gasPrice, 'gwei')} gwei`)
  console.log(`Total cost in ETH: ${totalCostEth}`)

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
