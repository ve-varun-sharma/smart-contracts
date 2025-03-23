// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    string public myString = "Hello World";

    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    bool public boolean1 = true;
    int public myInt = 1;

    string name = "Example 1";

    address public myAddress = 0x0000000000000000000000000000000000000000;

    function setName(string memory _name) public {
        name = _name;
    }

    function getName() public view returns (string memory) {
        return name;
    }

    function resetName() public {
        name = "Example 1";
    }

    uint public count;

    function increment1() public {
        count = count + 1;
    }
    function increment2() public {
        increment1();
    }
    function increment3() private {
        count = count + 1;
    }

    function increment4() public {
        increment3();
    }

    function increment5() external {
        count = count + 1;
    }

    function increment6() internal {
        count = count + 1;
    }

    function increment7() internal {
        increment6();
    }

    function add(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function pay() public payable {
        balance = msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
