// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PiggyBank.sol";

contract PiggyBankTest is Test {
    PiggyBank public piggyBank;
    address childAddress = address(0xDEAD);
    address unauthorizedAddress = address(0xBEEF);
    uint256 maxWithDrawlAmount = 2 ether;

    function setUp() public {
       piggyBank = new PiggyBank(childAddress, maxWithDrawlAmount);     
       piggyBank.deposit {value: 10 ether}();
       assertEq(address(piggyBank).balance, 10 ether);  
    }

    function testSuccessfulWithdraw() public {
      vm.prank(childAddress);
      piggyBank.withdraw(1 ether);
      assertEq(address(piggyBank).balance, 9 ether);
      assertEq(address(childAddress).balance, 1 ether);   
    }

    function testCannotWithdrawIfNotChild() public {
        vm.prank(unauthorizedAddress);
        vm.expectRevert("Only the child can withdraw");
        piggyBank.withdraw(1 ether);
    }

    function testCannotWithdrawOverLimit() public {
        vm.prank(childAddress);
        vm.expectRevert("Withdraw amount greater than balance");
        piggyBank.withdraw(3 ether);        
    }

    function testCannotWithdrawMoreThanAvailableBalance() public {
        vm.prank(childAddress);
        vm.deal(address(piggyBank), 1 ether);
        vm.expectRevert("Amount greater than balance");
        piggyBank.withdraw(1.5 ether);
    }

    
}
