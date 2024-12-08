// Declare the contract instance
const artifacts = require("../artifacts"); // Assuming your contract name is "Counter"
const CounterContract = artifacts.require("CounterContract"); // Assuming your contract name is "Counter"

contract("CounterContract", (accounts) => {
  let counterInstance;

  beforeEach(async () => {
    counterInstance = await CounterContract.new(); // Deploy a new instance of the contract before each test
  });

  it("increments the counter", async () => {
    await counterInstance.increment(); // Call the increment function on the deployed contract
    const count = await counterInstance.getCount();
    assert.equal(count, 1); // Assert that the count is now 1
  });

  it("starts at zero", async () => {
    const count = await counterInstance.getCount();
    assert.equal(count, 0); // Assert that the initial count is 0
  });
});
