import { expect } from 'chai'
import { ethers } from 'hardhat'
import { Contract } from 'ethers'
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers'
import hre from 'hardhat'

describe('MaximusNFT', function () {
  let MaximusNFT: Contract
  let maximusNFT: Contract
  let owner: SignerWithAddress
  let addr1: SignerWithAddress
  let addr2: SignerWithAddress

  beforeEach(async function () {
    ;[owner, addr1, addr2] = await hre.ethers.getSigners()

    const MaximusNFTFactory = await hre.ethers.getContractFactory('MaximusNFT')
    maximusNFT = await MaximusNFTFactory.deploy(
      'MaximusNFT',
      'MAX',
      100,
      ethers.utils.parseEther('0.05'),
      'https://example.com/metadata/',
    )
    await maximusNFT.deployed()
  })

  it('Should set the correct owner', async function () {
    expect(await maximusNFT.owner()).to.equal(owner.address)
  })

  it('Should mint an NFT and set the correct URI', async function () {
    await maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.05') })
    expect(await maximusNFT.totalMinted()).to.equal(1)
    expect(await maximusNFT.ownerOf(1)).to.equal(addr1.address)
    expect(await maximusNFT.tokenURI(1)).to.equal('https://example.com/metadata/1')
  })

  it('Should not mint more than the max supply', async function () {
    for (let i = 0; i < 100; i++) {
      await maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.05') })
    }
    await expect(
      maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.05') }),
    ).to.be.revertedWith('Max supply reached')
  })

  it('Should fail if insufficient payment is sent', async function () {
    await expect(
      maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.01') }),
    ).to.be.revertedWith('Insufficient payment')
  })

  it('Should allow the owner to withdraw funds', async function () {
    await maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.05') })
    const initialOwnerBalance = await ethers.provider.getBalance(owner.address)
    await maximusNFT.withdraw()
    const finalOwnerBalance = await ethers.provider.getBalance(owner.address)
    expect(finalOwnerBalance).to.be.gt(initialOwnerBalance)
  })

  it('Should not allow non-owner to withdraw funds', async function () {
    await maximusNFT.connect(addr1).mint(addr1.address, { value: ethers.utils.parseEther('0.05') })
    await expect(maximusNFT.connect(addr1).withdraw()).to.be.revertedWith('Ownable: caller is not the owner')
  })
})
