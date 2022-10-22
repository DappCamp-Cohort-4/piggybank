// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/PiggyBank.sol";

contract PiggyBankTest is Test {
    PiggyBank public piggyBank;
    address andrew = address(0xABCD);
    address betty = address(0xDEAD);
    address unauthorized = address(0xBEEF);
    uint256 maxWithDrawlAmount = 2 ether;

    function setUp() public {
        vm.prank(andrew);
        piggyBank = new PiggyBank(betty, maxWithDrawlAmount);
        piggyBank.deposit{value: 10 ether}();
        assertEq(address(piggyBank).balance, 10 ether);
    }

    function testDeployerIsSetToOwner() public {
        assertEq(piggyBank.owner(), address(andrew));
    }

    function testSuccessfulWithdraw() public {
        vm.prank(betty);
        piggyBank.withdraw(1 ether);
        assertEq(address(piggyBank).balance, 9 ether);
        assertEq(address(betty).balance, 1 ether);
    }

    function testCannotWithdrawIfNotBetty() public {
        vm.prank(unauthorized);
        vm.expectRevert("Only the child can withdraw");
        piggyBank.withdraw(1 ether);
    }

    function testCannotWithdrawOverLimit() public {
        vm.prank(betty);
        vm.expectRevert("Withdraw amount greater than balance");
        piggyBank.withdraw(3 ether);
    }

    function testCannotWithdrawMoreThanAvailableBalance() public {
        vm.prank(betty);
        vm.deal(address(piggyBank), 1 ether);
        vm.expectRevert("Amount greater than balance");
        piggyBank.withdraw(1.5 ether);
    }
}
