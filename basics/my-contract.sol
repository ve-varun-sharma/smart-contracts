// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyValueContract {
    string value;

    constructor() {
        value = "myValue";
    }

    function get() public view returns (string memory) {
        return value;
    }

    function set(string memory _value) public {
        value = _value;
    }
}

contract StateContract {
    string value;

    bool public myBook = true;
    int public myInt = -1;
    uint public myUint = 1;

    uint8 public myNum = 8;

    uint256 public myInty = 1234;

    enum State {
        Waiting,
        Ready,
        Active
    }
    State public state;

    constructor() {
        state = State.Waiting;
    }

    function get() public view returns (string memory) {
        return value;
    }

    function activate() public {
        state = State.Active;
    }

    function isActive() public view returns (bool) {
        return state == State.Active;
    }
}

contract PersonContract {
    uint256 public peopleCount;

    // Person[] public people;
    mapping(uint => Person) public people;

    struct Person {
        uint _id;
        string _firstName;
        string _lastName;
    }

    function AddPerson(
        string memory _firstName,
        string memory _lastName
    ) public {
        // people.push(Person(_firstName, _lastName));
        people[peopleCount] = Person(peopleCount, _firstName, _lastName);
        peopleCount += 1;
    }
}

contract VeTokenContract {
    mapping(address => uint256) public balances;

    address payable wallet;

    constructor(address payable _wallet) {
        wallet = _wallet;
    }

    function buyToken() public payable {
        // buy a token
        balances[msg.sender] += 1;
        wallet.transfer(msg.value);
        // send ether to te wallet
    }
}
