// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./CommonTests.sol";

contract TestExecutes is CommonTest {

  function testExecuteBuyNFTNonReserved(uint erc20Amt) public {
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    address originalMaycHolder = mayc.ownerOf(_id);
    uint maycHolderDai = dai.balanceOf(originalMaycHolder);
    _setUpNFTDeposit(address(0), erc20Amt);
    vm.stopPrank();
    vm.startPrank(daiHolder);
    dai.approve(address(escrow), erc20Amt);
    escrow.escrowExecute(false, false, originalMaycHolder, address(mayc), _id, address(dai), erc20Amt);
    assertEq(maycHolderDai + erc20Amt, dai.balanceOf(originalMaycHolder));
    assertEq(mayc.ownerOf(_id), daiHolder);
    vm.stopPrank();
  }

  function testExecuteBuyNFTReserved(uint erc20Amt) public {
    address originalMaycHolder = mayc.ownerOf(_id);
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    uint maycHolderDai = dai.balanceOf(originalMaycHolder);
    _setUpNFTDeposit(address(daiHolder), erc20Amt);
    vm.stopPrank();
    vm.startPrank(daiHolder);
    dai.approve(address(escrow), erc20Amt);
    escrow.escrowExecute(false, true, originalMaycHolder, address(mayc), _id, address(dai), erc20Amt);
    assertEq(maycHolderDai + erc20Amt, dai.balanceOf(originalMaycHolder));
    assertEq(mayc.ownerOf(_id), daiHolder);
    vm.stopPrank();
  }

  function testExecuteBuyNFTReservedWrongAddressShouldRevert(uint erc20Amt) public {
    address originalMaycHolder = mayc.ownerOf(_id);
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    // reserve purchase for any arbitrary address
    _setUpNFTDeposit(address(this), erc20Amt);
    vm.stopPrank();
    vm.startPrank(daiHolder);
    dai.approve(address(escrow), erc20Amt);
    vm.expectRevert(bytes('Escrow: invalid escrow id'));
    escrow.escrowExecute(false, false, originalMaycHolder, address(mayc), _id, address(dai), erc20Amt);
    vm.stopPrank();
  }

  function testExecuteSellNFTNonReserved(uint erc20Amt) public {
    address originalMaycHolder = mayc.ownerOf(_id);
    uint maycHolderDai = dai.balanceOf(originalMaycHolder);

    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    _setUpTokenDeposit(address(0), erc20Amt);
    vm.stopPrank();
    vm.startPrank(originalMaycHolder);
    mayc.approve(address(escrow), _id);
    escrow.escrowExecute(true, false, daiHolder, address(mayc), _id, address(dai), erc20Amt);
    assertEq(maycHolderDai + erc20Amt, dai.balanceOf(originalMaycHolder));
    assertEq(mayc.ownerOf(_id), daiHolder);
    vm.stopPrank();
  }

  function testExecuteSellNFTReserved(uint erc20Amt) public {
    address originalMaycHolder = mayc.ownerOf(_id);
    uint maycHolderDai = dai.balanceOf(originalMaycHolder);
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    _setUpTokenDeposit(originalMaycHolder, erc20Amt);
    vm.stopPrank();
    vm.startPrank(originalMaycHolder);
    mayc.approve(address(escrow), _id);
    escrow.escrowExecute(true, true, daiHolder, address(mayc), _id, address(dai), erc20Amt);
    assertEq(maycHolderDai + erc20Amt, dai.balanceOf(originalMaycHolder));
    assertEq(mayc.ownerOf(_id), daiHolder);
    vm.stopPrank();
  }

  function testExecuteSellNFTShouldRevert(uint erc20Amt) public {
    address originalMaycHolder = mayc.ownerOf(_id);
    uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
    vm.assume(erc20Amt <= originalDaiHolderBalance);
    _setUpTokenDeposit(address(this), erc20Amt);
    vm.stopPrank();
    vm.startPrank(originalMaycHolder);
    mayc.approve(address(escrow), _id);
    vm.expectRevert(bytes('Escrow: invalid escrow id'));
    escrow.escrowExecute(true, true, originalMaycHolder, address(mayc), _id, address(dai), erc20Amt);
    vm.stopPrank();
  }
}

