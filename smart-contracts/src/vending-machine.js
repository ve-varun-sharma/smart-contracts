async function main() {
  const DigitalVendingMachine = await ethers.getContractFactory('DigitalVendingMachine')
  const vendingMachine = await DigitalVendingMachine.deploy()
  await vendingMachine.deployed()

  // Adding Items:
  // Only the owner can add items.
  await vendingMachine.addItem('Soda', ethers.utils.parseEther('0.01'), 100)
  await vendingMachine.addItem('Chips', ethers.utils.parseEther('0.005'), 200)
  // Purchasing Items:
  // Users can purchase items by specifying the item ID and quantity.
  await vendingMachine.purchaseItem(0, 2, { value: ethers.utils.parseEther('0.02') })
  // Withdrawing Funds:
  // The owner can withdraw all Ether accumulated from purchases.
  await vendingMachine.withdrawFunds()
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error)
    process.exit(1)
  })
