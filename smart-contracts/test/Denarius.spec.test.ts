import { expect } from 'chai'
import { ethers } from 'hardhat'
import { Contract, ContractFactory } from 'ethers'
import { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers'

describe('Denarius', function () {
  //   let denarius: Contract
  let denarius: any

  let owner: HardhatEthersSigner
  let user1: HardhatEthersSigner
  let user2: HardhatEthersSigner
  // Change: Don't include decimals in parseUnits since contract handles it
  // const INITIAL_SUPPLY = ethers.parseUnits('1000000', 18) // Remove 18 decimals
  // parseUnits already applies 18 decimals, Contract then multiplies by 10^18 again, Results in double application of decimals
  // Set initial supply without decimals
  //   const INITIAL_SUPPLY = BigInt(1000000)
  const INITIAL_SUPPLY = BigInt(1000000)

  beforeEach(async function () {
    // Deploy contract
    ;[owner, user1, user2] = await ethers.getSigners()
    const DenariusFactory = await ethers.getContractFactory('Denarius')
    denarius = await DenariusFactory.deploy(INITIAL_SUPPLY)
    await denarius.waitForDeployment()
  })

  describe('Deployment', function () {
    it('Should set correct name and symbol', async function () {
      expect(await denarius.name()).to.equal('Denarius')
      expect(await denarius.symbol()).to.equal('DNRS')
      expect(await denarius.decimals()).to.equal(18)
    })

    it('Should mint initial supply amount', async function () {
      const expectedSupply = INITIAL_SUPPLY * BigInt(10 ** 18)
      expect(await denarius.totalSupply()).to.equal(expectedSupply)
    })

    it('Should mint initial supply to owner', async function () {
      const expectedSupply = INITIAL_SUPPLY * BigInt(10 ** 18)
      expect(await denarius.balanceOf(owner.address)).to.equal(expectedSupply)
    })
  })

  describe('Transfers', function () {
    it('Should transfer tokens between accounts', async function () {
      const amount = ethers.parseUnits('100', 18)
      await denarius.transfer(user1.address, amount)

      expect(await denarius.balanceOf(user1.address)).to.equal(amount)
    })

    it('Should emit Transfer event', async function () {
      const amount = ethers.parseUnits('100', 18)

      await expect(denarius.transfer(user1.address, amount))
        .to.emit(denarius, 'Transfer')
        .withArgs(owner.address, user1.address, amount)
    })

    it('Should fail if sender has insufficient balance', async function () {
      const amount = ethers.parseUnits('100', 18)
      await expect(denarius.connect(user1).transfer(user2.address, amount)).to.be.revertedWith('Insufficient balance')
    })
  })

  describe('Allowances', function () {
    const amount = ethers.parseUnits('100', 18)

    beforeEach(async function () {
      await denarius.approve(user1.address, amount)
    })

    it('Should update allowance', async function () {
      expect(await denarius.allowance(owner.address, user1.address)).to.equal(amount)
    })

    it('Should emit Approval event', async function () {
      await expect(denarius.approve(user1.address, amount))
        .to.emit(denarius, 'Approval')
        .withArgs(owner.address, user1.address, amount)
    })

    it('Should allow transferFrom within allowance', async function () {
      await denarius.connect(user1).transferFrom(owner.address, user2.address, amount)

      expect(await denarius.balanceOf(user2.address)).to.equal(amount)
      expect(await denarius.allowance(owner.address, user1.address)).to.equal(0)
    })

    it('Should fail if trying to transferFrom above allowance', async function () {
      const tooMuch = amount + ethers.parseUnits('1', 18)
      await expect(denarius.connect(user1).transferFrom(owner.address, user2.address, tooMuch)).to.be.revertedWith(
        'Allowance exceeded',
      )
    })
  })
})
