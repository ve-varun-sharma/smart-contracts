// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
  address[] public owners;
  uint256 public requiredConfirmations;

  struct Transaction {
    address payable destination;
    uint256 value;
    bytes data;
    bool executed;
    uint256 numConfirmations;
    mapping(address => bool) confirmations;
  }

  mapping(uint256 => Transaction) public transactions;
  uint256 public transactionCount;

  event Deposit(address indexed sender, uint256 value);
  event SubmitTransaction(
    uint256 indexed transactionId,
    address indexed owner,
    address indexed destination,
    uint256 value,
    bytes data
  );
  event ConfirmTransaction(uint256 indexed transactionId, address indexed owner);
  event ExecuteTransaction(uint256 indexed transactionId);
  event RevokeConfirmation(uint256 indexed transactionId, address indexed owner);

  modifier onlyWallet() {
    require(isOwner(msg.sender), 'Not an owner');
    _;
  }

  modifier notExecuted(uint256 transactionId) {
    require(!transactions[transactionId].executed, 'Transaction already executed');
    _;
  }

  modifier validRequirement(uint256 numOwners, uint256 _required) {
    require(_required > 0 && _required <= numOwners, 'Invalid required confirmations');
    _;
  }

  constructor(
    address[] memory _owners,
    uint256 _requiredConfirmations
  ) validRequirement(_owners.length, _requiredConfirmations) {
    owners = _owners;
    requiredConfirmations = _requiredConfirmations;
  }

  receive() external payable {
    emit Deposit(msg.sender, msg.value);
  }

  function submitTransaction(address payable _destination, uint256 _value, bytes memory _data) public onlyWallet {
    transactionCount++;
    transactions[transactionCount] = Transaction({
      destination: _destination,
      value: _value,
      data: _data,
      executed: false,
      numConfirmations: 0,
      confirmations: mapping(address => bool)()
    });
    emit SubmitTransaction(transactionCount, msg.sender, _destination, _value, _data);
  }

  function confirmTransaction(uint256 _transactionId) public onlyWallet notExecuted(_transactionId) {
    Transaction storage transaction = transactions[_transactionId];
    require(!transaction.confirmations[msg.sender], 'Transaction already confirmed');
    transaction.confirmations[msg.sender] = true;
    transaction.numConfirmations++;
    emit ConfirmTransaction(_transactionId, msg.sender);
  }

  function executeTransaction(uint256 _transactionId) public onlyWallet notExecuted(_transactionId) {
    Transaction storage transaction = transactions[_transactionId];
    require(transaction.numConfirmations >= requiredConfirmations, 'Not enough confirmations');
    transaction.executed = true;
    (bool success, ) = transaction.destination.call{ value: transaction.value }(transaction.data);
    require(success, 'Transaction execution failed.');
    emit ExecuteTransaction(_transactionId);
  }

  function revokeConfirmation(uint256 _transactionId) public onlyWallet notExecuted(_transactionId) {
    Transaction storage transaction = transactions[_transactionId];
    require(transaction.confirmations[msg.sender], 'Transaction not yet confirmed');
    transaction.confirmations[msg.sender] = false;
    transaction.numConfirmations--;
    emit RevokeConfirmation(_transactionId, msg.sender);
  }

  function isOwner(address _addr) public view returns (bool) {
    for (uint256 i = 0; i < owners.length; i++) {
      if (owners[i] == _addr) {
        return true;
      }
    }
    return false;
  }

  function getOwners() public view returns (address[] memory) {
    return owners;
  }

  function getTransactionCount() public view returns (uint256) {
    return transactionCount;
  }
}
