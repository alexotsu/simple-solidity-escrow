// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "forge-std/Test.sol";
import "src/Escrow.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract CommonTest is Test {
  address _mayc = 0x60E4d786628Fea6478F785A6d7e704777c86a7c6;
  uint _id = 22046;
  address _dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
  address daiHolder = 0x236F233dBf78341d25fB0F1bD14cb2bA4b8a777c; // whale w/ ~1m DAI
  address _uni = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;

  NFTEscrow escrow = new NFTEscrow();

  IERC721 mayc = IERC721(_mayc);
  IERC20 dai = IERC20(_dai);
  IERC20 uni = IERC20(_uni);
  
  function _setUpNFTDeposit(address addr, uint erc20Amt) public {
    vm.startPrank(mayc.ownerOf(_id));
    mayc.approve(address(escrow), _id);
    bytes32 escrowId = escrow.escrowDeposit(true, _mayc, _id, _dai, erc20Amt, addr);
    assertTrue(escrow.Escrows(escrowId));
    assertEq(mayc.ownerOf(_id), address(escrow));
  }

  function _setUpTokenDeposit(address addr, uint erc20Amt) public {
    vm.startPrank(daiHolder);
    dai.approve(address(escrow), erc20Amt);
    bytes32 escrowId = escrow.escrowDeposit(false, _mayc, _id, _dai, erc20Amt, addr);
    assertTrue(escrow.Escrows(escrowId));
    assertEq(erc20Amt, dai.balanceOf(address(escrow)));
  }
}