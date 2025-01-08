const hre = require('hardhat')
require('dotenv').config()

async function main() {
  // Replace with your contract's ABI and address
  const contractABI = [
    {
      inputs: [
        {
          internalType: 'address',
          name: 'recipient',
          type: 'address',
        },
        {
          internalType: 'string',
          name: 'tokenURI',
          type: 'string',
        },
      ],
      name: 'mintNFT',
      outputs: [
        {
          internalType: 'uint256',
          name: '',
          type: 'uint256',
        },
      ],
      stateMutability: 'nonpayable',
      type: 'function',
    },
  ]
  const contractAddress = '0x24E8ffdB8c50ecB25bE1dC26F0561A387d763d50'

  // Replace with your wallet's private key
  const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY
  if (!WALLET_PRIVATE_KEY) {
    console.log('Missing env var: WALLET_PRIVATE_KEY')
    process.exit(1)
  }

  const provider = new hre.ethers.providers.JsonRpcProvider('https://rpc.zkevm.polygon.network')
  const wallet = new hre.ethers.Wallet(WALLET_PRIVATE_KEY, provider)
  const contract = new hre.ethers.Contract(contractAddress, contractABI, wallet)

  // Check if the mintNFT function exists
  if (typeof contract.mintNFT !== 'function') {
    console.error('mintNFT function not found in the contract ABI')
    return
  }

  // Replace with the recipient address and token URI
  const toAddress = '0xf83845D8cFA12b2De8D6301536519C290aCd04C5'
  const tokenURI = 'https://storage.googleapis.com/web3-nfts/ve-nfts/ve3-nft-metadata.json'

  try {
    const tx = await contract.mintNFT(toAddress, tokenURI)
    console.log('Transaction hash:', tx.hash)

    const receipt = await tx.wait()
    console.log('Transaction confirmed in block:', receipt.blockNumber)
  } catch (error) {
    console.error('Error minting NFT:', error)
  }
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
