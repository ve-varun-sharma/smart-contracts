async function main() {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)

  const Denarius = await ethers.getContractFactory('Denarius')
  const initialSupply = ethers.utils.parseUnits('1000000', 18) // 1,000,000 tokens
  const denarius = await Denarius.deploy(initialSupply)

  console.log('Denarius deployed to:', denarius.address)
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
