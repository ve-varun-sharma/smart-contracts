import { HardhatUserConfig } from 'hardhat/config'
import '@nomicfoundation/hardhat-toolbox'
require('dotenv').config()

const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY
if (!WALLET_PRIVATE_KEY) {
  console.log('Missing env var: WALLET_PRIVATE_KEY')
}
if (WALLET_PRIVATE_KEY) {
  console.log('Sanity Check - We have Private Wallet key.')
}

const config: HardhatUserConfig = {
  solidity: '0.8.28',
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  networks: {
    // for mainnet
    'base-mainnet': {
      url: 'https://mainnet.base.org',
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    // for testnet
    'base-sepolia': {
      url: 'https://sepolia.base.org',
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    // for local dev environment
    'base-local': {
      url: 'http://localhost:8545',
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    zkEvmTestnet: {
      url: `https://rpc.cardona.zkevm-rpc.com`,
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    polygon: {
      url: `https://polygon-rpc.com`,
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    polygonzkEVM: {
      url: `https://zkevm-rpc.com`,
      accounts: [WALLET_PRIVATE_KEY as string],
      gasPrice: 1000000000,
    },
    hardhat: {
      chainId: 1337,
    },
  },

  defaultNetwork: 'hardhat',
}

export default config
