async function main() {
  const [deployer] = await ethers.getSigners()

  // Grab the contract factory
  const Ve3NFT = await ethers.getContractFactory('Ve3NFT')

  // Start deployment, returning a promise that resolves to a contract object
  const ve3NFT = await Ve3NFT.deploy(deployer.address) // Pass the deployer's address as the initial owner

  await ve3NFT.deployed()

  console.log('Contract deployed to address:', ve3NFT.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
