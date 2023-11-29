// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";

import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public mt;
    DeployMyToken public deployMyToken;
    address bob  = makeAddr("bob");
    address alice  = makeAddr("alice");

    uint public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployMyToken = new DeployMyToken();
        mt = deployMyToken.run();

        vm.prank(msg.sender);
        mt.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(mt.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowanceWorks() public {
        uint initAllowance = 1000;
        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        mt.approve(alice, initAllowance);

        uint transferAmount = 500;
        vm.prank(alice);
        mt.transferFrom(bob, alice, transferAmount);
        assertEq(mt.balanceOf(alice),transferAmount);
        assertEq(mt.balanceOf(bob),STARTING_BALANCE - transferAmount);
    }

    function testTransferBeyondBalance() public {
        uint transferAmount = STARTING_BALANCE + 1 ether;

        vm.prank(bob);
        vm.expectRevert();
        mt.transfer(alice, transferAmount);
    }

    function testTransferFromBeyondAllowance() public {
        uint initAllowance = 1000;
        uint transferAmount = initAllowance + 1 ether;

        vm.prank(bob);
        mt.approve(alice, initAllowance);

        vm.prank(alice);
        vm.expectRevert();
        mt.transferFrom(bob, alice, transferAmount);
    }
}