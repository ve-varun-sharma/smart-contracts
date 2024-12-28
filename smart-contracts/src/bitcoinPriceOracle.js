require('dotenv').config()
const axios = require('axios')
const hardhat = require('hardhat')

// Turtorial: https://jamesbachini.com/creating-your-own-oracle-solidity-nodejs/
const API_ENDPOINT = 'https://api.coindesk.com/v1/bpi/currentprice.json'
const RPC_URL = 'https://rpc.sepolia.org'
const CONTRACT_ADDRESS = '0xf83845D8cFA12b2De8D6301536519C290aCd04C5'

const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY
if (!WALLET_PRIVATE_KEY) {
  console.log('Missing env var: WALLET_PRIVATE_KEY')
}

const CONTRACT_ABI = [
  {
    inputs: [
      {
        internalType: 'string',
        name: '_newPrice',
        type: 'string',
      },
    ],
    name: 'updatePrice',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
]

async function fetchBitcoinPrice() {
  const response = await axios.get(API_ENDPOINT)
  return response.data.bpi.USD.rate_float
}

async function updateOracle() {
  try {
    const bitcoinPrice = await fetchBitcoinPrice()
    // You probably wouldn't want to format this in json
    const json = `{"bitcoin":"${bitcoinPrice}"}`

    const provider = new hardhat.ethers.JsonRpcProvider(RPC_URL)
    const signer = new hardhat.ethers.Wallet(WALLET_PRIVATE_KEY, provider)
    const contract = new hardhat.ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer)

    const tx = await contract.updatePrice(json)
    await tx.wait()

    console.log('The oracle has spoken:', json)
  } catch (error) {
    console.error('The spirits are angry:', error)
  }
}

setInterval(updateOracle, 60 * 1000) // every 60 seconds
updateOracle()
