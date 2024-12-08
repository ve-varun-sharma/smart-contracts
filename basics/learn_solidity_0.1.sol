// SPDX-License-Identifiers: Unlicense

pragma solidity ^0.8.0;

contract MyContract {
    string public myString = "my String";
    bool public boolean1 = true;
    uint public myUint = 1;
    int public myInt = 1;
    address public myAddress = 0x742d35Cc6634C0532925a3b844Bc454e4438f44e;

    string name1 = "Name 1";
    string private name2 = "name 2";
    string internal name3 = "name 3";
    string public name4 = "name 4";

    string name = "example 1";
    function setName(string memory _name) public {
        name = _name;
    }
    function getName() public view returns(string memory) {
        return name;
    }

    function resetName() internal {
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
        count+=1;
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
 }