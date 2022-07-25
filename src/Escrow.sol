// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC721Receiver.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";

contract NFTEscrow is IERC721Receiver {
  mapping(bytes32 => bool) public Escrows;

  event EscrowInitiated(address indexed initiator, bool indexed isSeller, bytes32 indexed escrowId);
  event EscrowExecuted(address indexed initiator, bytes32 indexed escrowId);
  event EscrowCanceled(address indexed initiator, bytes32 indexed escrowId);

  function escrowDeposit(bool isSeller, address nftAddress, uint nftId, address erc20, uint erc20Amount, address reservedFor) public returns (bytes32 escrowId) {
    escrowId = keccak256(abi.encodePacked(isSeller, msg.sender, nftAddress, nftId, erc20, erc20Amount, reservedFor));

    

    if(isSeller) {
      IERC721(nftAddress).safeTransferFrom(msg.sender, address(this), nftId);
    } else {
      // IMPORTANT: if replacing an escrow deposit for the same NFT, be sure to cancel the old one using `escrowCancel`.
      require(Escrows[escrowId] == false, "Escrow: deposit already made");
      IERC20(erc20).transferFrom(msg.sender, address(this), erc20Amount);
    }

    Escrows[escrowId] = true;

    emit EscrowInitiated(msg.sender, isSeller, escrowId);
  }

  function escrowExecute(bool isSeller, bool isReserved, address counterparty, address nftAddress, uint nftId, address erc20, uint erc20Amount) public returns(bytes32 escrowId) {

    isReserved
      ? escrowId = keccak256(abi.encodePacked(!isSeller, counterparty, nftAddress, nftId, erc20, erc20Amount, msg.sender)) 
      : escrowId = keccak256(abi.encodePacked(!isSeller, counterparty, nftAddress, nftId, erc20, erc20Amount, address(0)));

    require(Escrows[escrowId], "Escrow: invalid escrow id");
      // prevent reentrancy by deleting here
    delete Escrows[escrowId];

    if(isSeller) {
      IERC721(nftAddress).safeTransferFrom(msg.sender, counterparty, nftId);
      IERC20(erc20).transfer(msg.sender, erc20Amount);
    } else {
      IERC20(erc20).transferFrom(msg.sender, counterparty, erc20Amount);
      IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, nftId);
    }
  

    emit EscrowExecuted(msg.sender, escrowId);
  }

  function escrowCancel(bool isSeller, address nftAddress, uint nftId, address erc20, uint erc20Amount, address reservedFor) public returns(bytes32 escrowId) {
    escrowId = keccak256(abi.encodePacked(isSeller, msg.sender, nftAddress, nftId, erc20, erc20Amount, reservedFor));
    if(Escrows[escrowId]) {
      // prevent reentrancy by deleting here
      delete Escrows[escrowId];

      if(isSeller) {
        IERC721(nftAddress).safeTransferFrom(address(this), msg.sender, nftId);
      } else {
        IERC20(erc20).transfer(msg.sender, erc20Amount);
      }
    }

    emit EscrowCanceled(msg.sender, escrowId);

  }

  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes calldata data
  ) public pure returns(bytes4) {
    return (IERC721Receiver.onERC721Received.selector);
  }
}