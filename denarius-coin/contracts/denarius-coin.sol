// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;
import 'hardhat/console.sol';

contract Denarius {
  string public name = 'Denarius';
  string public symbol = 'DNRS';
  uint8 public decimals = 18;
  uint256 public totalSupply;

  // Mapping to store the balance of each address
  mapping(address => uint256) public balanceOf;
  // Mapping to store allowances
  mapping(address => mapping(address => uint256)) public allowance;

  // Events to log transfers and approvals
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  constructor(uint256 initialSupply) {
    totalSupply = initialSupply * 10 ** uint256(decimals);
    balanceOf[msg.sender] = totalSupply;
  }

  /**
   * @dev Transfers tokens from the caller's address to another address.
   * @param to The address to transfer to.
   * @param value The amount of tokens to transfer.
   * @return success A boolean indicating whether the operation succeeded.
   */
  function transfer(address to, uint256 value) public returns (bool success) {
    console.log('Sender balance before transfer:', balanceOf[msg.sender]);
    console.log('Attempting to transfer %s tokens to %s', value, to);

    require(balanceOf[msg.sender] >= value, 'Insufficient balance');
    balanceOf[msg.sender] -= value;
    balanceOf[to] += value;

    console.log('Sender balance after transfer:', balanceOf[msg.sender]);
    console.log('Recipient balance after transfer:', balanceOf[to]);

    emit Transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Approves an allowance for another address to spend tokens on behalf of the caller.
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   * @return success A boolean indicating whether the operation succeeded.
   */
  function approve(address spender, uint256 value) public returns (bool success) {
    allowance[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * @dev Transfers tokens from one address to another using an allowance.
   * @param from The address to transfer from.
   * @param to The address to transfer to.
   * @param value The amount of tokens to transfer.
   * @return success A boolean indicating whether the operation succeeded.
   */
  function transferFrom(address from, address to, uint256 value) public returns (bool success) {
    require(value <= balanceOf[from], 'Insufficient balance');
    require(value <= allowance[from][msg.sender], 'Allowance exceeded');
    balanceOf[from] -= value;
    balanceOf[to] += value;
    allowance[from][msg.sender] -= value;
    emit Transfer(from, to, value);
    return true;
  }

  /**
   * @dev Mints new tokens and assigns them to a specified address.
   * @param to The address to mint tokens to.
   * @param value The amount of tokens to mint.
   * @return success A boolean indicating whether the operation succeeded.
   */
  function mint(address to, uint256 value) public returns (bool success) {
    totalSupply += value;
    balanceOf[to] += value;
    emit Transfer(address(0), to, value);
    return true;
  }
}
