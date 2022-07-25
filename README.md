# README

A simple escrow contract where a user can deposit either an NFT or a quantity of ERC-20 tokens and optionally reserve the escrowed asset(s) for a specific user by calling `escrowDeposit()`. The specified user (or any user, if none was specified) can transfer the requisite asset(s) to execute the escrow deal by calling `executeEscrow()`. Asset(s) that have not been transferred yet can be removed from escrow anytime by the original depositor by calling `escrowCancel()`.

Both parties must have approved the escrow contract to transfer their asset(s) before doing any operations.


# Test Data
Forking network state from block 15200618

Running 2 tests for test/EscrowCancels.t.sol:TestCancels
[PASS] testCancelNFTDeposit() (gas: 139372)
[PASS] testCancelTokenDeposit(uint256) (runs: 256, μ: 85202, ~: 91996)
Test result: ok. 2 passed; 0 failed; finished in 18.75s

Running 4 tests for test/EscrowDeposits.t.sol:TestDeposits
[PASS] testNFTDeposits(uint256) (runs: 256, μ: 130905, ~: 130905)
[PASS] testSecondNFTDepositShouldRevert(uint256) (runs: 256, μ: 136835, ~: 136835)
[PASS] testSecondTokenDepositShouldRevert(uint256) (runs: 256, μ: 87052, ~: 91575)
[PASS] testTokenDeposit(uint256) (runs: 256, μ: 83735, ~: 88435)
Test result: ok. 4 passed; 0 failed; finished in 21.57s

Running 6 tests for test/EscrowExecutes.t.sol:TestExecutes
[PASS] testExecuteBuyNFTNonReserved(uint256) (runs: 256, μ: 214277, ~: 221072)
[PASS] testExecuteBuyNFTReserved(uint256) (runs: 256, μ: 214065, ~: 221126)
[PASS] testExecuteBuyNFTReservedWrongAddressShouldRevert(uint256) (runs: 256, μ: 159815, ~: 163858)
[PASS] testExecuteSellNFTNonReserved(uint256) (runs: 256, μ: 184141, ~: 194302)
[PASS] testExecuteSellNFTReserved(uint256) (runs: 256, μ: 183902, ~: 194259)
[PASS] testExecuteSellNFTShouldRevert(uint256) (runs: 256, μ: 124287, ~: 128987)