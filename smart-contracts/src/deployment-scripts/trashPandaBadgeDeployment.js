const hardhat = require('hardhat')

async function main() {
  // Log deployment start
  console.log('Deploying TrashPandaBadge...')

  const TrashPandaBadge = await hardhat.ethers.getContractFactory('TrashPandaBadge')

  // Prepare the deploy transaction
  const deployTxRequest = TrashPandaBadge.getDeployTransaction()

  // Estimate gas and cost
  // Instead of deployer.estimateGas(...), directly use hre.ethers.provider.estimateGas
  const estimatedGas = await hardhat.ethers.provider.estimateGas({
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
    // Deploy the contract

    const trashPandaBadge = await TrashPandaBadge.deploy()
    await trashPandaBadge.deployed()
    // Wait for few block confirmations to ensure deployment is confirmed
    await trashPandaBadge.deployTransaction.wait(6)

    // Verify the contract on Etherscan
    if (process.env.ETHERSCAN_API_KEY) {
      console.log('Verifying contract...')
      try {
        await hardhat.run('verify:verify', {
          address: trashPandaBadge.address,
          constructorArguments: [],
        })
      } catch (error) {
        console.error('Error verifying contract:', error)
      }
    }

    console.log('TransPandaBadge contract deployed to:', trashPandaBadge.address)
  } else {
    console.log('Deployment cancelled.')
  }
  terminalRl.close()
}

//   //   Optional: Mint initial token
//   const mintTx = await trashPandaBadge.safeMint(
//     'RECIPIENT_ADDRESS',
//     'https://storage.googleapis.com/web3-nfts/trash-panda-nft/1.json',
//   )
//   await mintTx.wait()
//   console.log('Initial token minted')

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
