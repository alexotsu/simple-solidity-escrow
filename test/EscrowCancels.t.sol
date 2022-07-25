// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./CommonTests.sol";

contract TestCancels is CommonTest {
  event Owner(address o);

  function testCancelNFTDeposit() public {
    uint erc20Amt = dai.balanceOf(daiHolder); // this value can be anything because it never gets transferred in this test
    address originalMaycHolder = mayc.ownerOf(_id);
    _setUpNFTDeposit(address(0), erc20Amt);
    bytes32 escrowId = escrow.escrowCancel(true, address(mayc), _id, address(dai), erc20Amt, address(0));
    assertEq(mayc.ownerOf(_id), originalMaycHolder);
    assertTrue(!escrow.Escrows(escrowId));
  }

  function testCancelTokenDeposit(uint erc20Amt) public {
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    _setUpTokenDeposit(address(0), erc20Amt);
    bytes32 escrowId = escrow.escrowCancel(false, address(mayc), _id, address(dai), erc20Amt, address(0));
    assertEq(originalDaiHolderBalance, dai.balanceOf(daiHolder));
    assertTrue(!escrow.Escrows(escrowId));
  }
}