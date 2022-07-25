// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "./CommonTests.sol";

contract TestDeposits is CommonTest {

    // function setUp() public {
    //     vm.startPrank(mayc.ownerOf(_id));
    // }

    // +use tokens that have already been launched
    // +discreet functions: deposit NFT, deposit ERC20, execute w/ NFT, execute w/ ERC20, cancel NFT, cancel ERC20
    // deposit NFT from addr1, try executing with the wrong amount of ERC20, execute escrow with ERC20 from addr2
    // deposit ERC20 from addr1, execute escrow with NFT from addr2
    // deposit NFT from addr1, try canceling from addr2, cancel from addr1
    // deposit ERC20 from addr1, try cancelling from addr2, cancel from addr1

    event Owner(address o);

    function testNFTDeposits(uint erc20Amt) public {
        uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
        vm.assume(erc20Amt <= originalDaiHolderBalance);
        _setUpNFTDeposit(address(0), erc20Amt);     
        vm.stopPrank();
        
    }

    function testSecondNFTDepositShouldRevert(uint erc20Amt) public {
        uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
        vm.assume(erc20Amt <= originalDaiHolderBalance);
        _setUpNFTDeposit(address(0), erc20Amt);
        
        vm.expectRevert(bytes('ERC721: transfer of token that is not own'));
        escrow.escrowDeposit(true, _mayc, _id, _dai, erc20Amt, address(0));
        
        vm.stopPrank();
    }

    function testTokenDeposit(uint erc20Amt) public {
        uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
        vm.assume(erc20Amt <= originalDaiHolderBalance);
        _setUpTokenDeposit(address(0), erc20Amt);
        vm.stopPrank();
    }

    function testSecondTokenDepositShouldRevert(uint erc20Amt) public {
        uint originalDaiHolderBalance = dai.balanceOf(daiHolder);
        vm.assume(erc20Amt <= originalDaiHolderBalance);
        _setUpTokenDeposit(address(0), erc20Amt);

        vm.expectRevert(bytes('Escrow: deposit already made'));
        escrow.escrowDeposit(false, _mayc, _id, _dai, erc20Amt, address(0));
        
        vm.stopPrank();
    }

}
