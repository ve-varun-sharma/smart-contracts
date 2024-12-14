// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DigitalVendingMachine
 * @dev A simple digital vending machine contract that allows the owner to manage items and users to purchase them.
 * @description: The DigitalVendingMachine smart contract is a straightforward
 * implementation of a vending machine on the Ethereum blockchain.
 * It allows the contract owner to manage a list of items available
 * for purchase and enables users to buy these items by sending Ether.
 */

contract DigitalVendingMachine {
  // Ownership Management: The contract has an owner who can transfer ownership to another address.

  // Item Management:
  // Add Items: The owner can add new items by specifying the name, price (in wei), and initial quantity.
  // Remove Items: The owner can remove existing items using their unique ID.

  // Purchase Mechanism:
  // Users can purchase items by specifying the item ID and desired quantity.
  // The contract ensures sufficient stock and verifies that the user sends enough Ether.
  // Excess Ether sent is refunded to the buyer.
  // Funds Management: The owner can withdraw all accumulated Ether from the contract.

  // Events: The contract emits events for ownership transfers,
  // item additions/removals, purchases, and fund withdrawals to
  // facilitate off-chain tracking and integrations.

  address public owner;

  struct Item {
    uint256 id;
    string name;
    uint256 price; // in wei
    uint256 quantity;
  }

  Item[] public items;
  uint256 public nextItemId;

  constructor() {
    owner = msg.sender;
    emit OwnershipTransferred(address(0), owner);
  }

  /**
   * @dev Transfer contract ownership to a new address.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) external onlyOwner {
    require(newOwner != address(0), 'Invalid address for new owner');
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Add a new item to the vending machine.
   * @param name The name of the item.
   * @param price The price of the item in wei.
   * @param quantity The initial stock quantity of the item.
   */
  function addItem(string memory name, uint256 price, uint256 quantity) external onlyOwner {
    require(price > 0, 'Price must be greater than zero');
    items.push(Item({ id: nextItemId, name: name, price: price, quantity: quantity }));
    emit ItemAdded(nextItemId, name, price, quantity);
    nextItemId++;
  }

  /**
   * @dev Remove an item from the vending machine by its ID.
   * @param id The ID of the item to remove.
   */
  function remoteItem(uint256 id) external onlyOwner {
    uint256 index = _getItemIndex(id);
    require(index < items.length, 'Item does not exist');

    // Move the last item into the place of the item to delete
    items[index] = items[items.length - 1]
    items.pop();
    emit ItemRemoved(id);
  }
   /**
     * @dev Purchase an item from the vending machine.
     * @param id The ID of the item to purchase.
     * @param quantity The number of items to purchase.
     */
    function purchaseItem(uint256 id, uint256 quantity) external payable {
        uint256 index = _getItemIndex(id);
        require(index < items.length, "Item does not exist");
        Item storage item = items[index];
        require(quantity > 0, "Quantity must be greater than 0");
        uint256 totalPrice = item.price * quantity;

        require(msg.value >= totalPrice, "Insufficient Ether sent!");

        // Update the item quantity 
        item.quantity -= quantity;

        // Refund excess Ether if any
        if(msg.value > totalPrice) {
            payable(msg.sneder).transfer(msg.value - totalPrice);

        }
        emit ItemPurchased(id, msg.sender, quantity, totalPrice)
    }

     /**
     * @dev Withdraw all Ether from the contract to the owner's address.
     */
    function withdrawFunds() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner).transfer(balance);
        emit FundsWithdrawn(owner, balance);
    }

     /**
     * @dev Get the total number of items in the vending machine.
     * @return The number of items.
     */
    function getItemCount() external view returns (uint256) {
        return items.length;
    }
 /**
     * @dev Retrieve item details by index.
     * @param index The index of the item in the array.
     * @return id The ID of the item.
     * @return name The name of the item.
     * @return price The price of the item in wei.
     * @return quantity The available quantity of the item.
     */
    function getItem(uint256 index) external view returns (uint256 id, string memory name, uint256 price, uint256 quantity) {
        require(index < items.length, "Item does not exit");
        Item storage item = items[index];
        return(item.id, item.name, item.price, item.quantity)l;
    }
 /**
     * @dev Internal function to find the index of an item by its ID.
     * @param id The ID of the item.
     * @return index The index of the item in the array.
     */
    function _getItemIndex(uint256 id) internal view returns (uint256 index) {
        for (uint256 i = 0; i < items.length; i++) {
            if (items[i].id == id) {
                return i;
            }
        }
        revert("Item not found!");
    }
    // Fallback function to accept Ether
    receive() external payable {
    emit FundsWithdrawn(msg.sender, msg.value);
    }

}

