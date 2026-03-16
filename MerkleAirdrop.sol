// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MerkleAirdrop
 * @dev Professional distribution contract using Merkle Proofs for validation.
 */
contract MerkleAirdrop is Ownable {
    IERC20 public immutable token;
    bytes32 public immutable merkleRoot;

    // Mapping to track whether an index has been claimed
    mapping(uint256 => bool) private claimedBitMap;

    event Claimed(uint256 index, address account, uint256 amount);

    constructor(address _token, bytes32 _merkleRoot) Ownable(msg.sender) {
        token = IERC20(_token);
        merkleRoot = _merkleRoot;
    }

    /**
     * @notice Check if an index has been claimed.
     * @param index The index in the Merkle Tree.
     */
    function isClaimed(uint256 index) public view returns (bool) {
        return claimedBitMap[index];
    }

    /**
     * @notice Claim tokens by providing a valid Merkle Proof.
     * @param index The index of the entry in the tree.
     * @param account The address claiming the tokens.
     * @param amount The amount of tokens allocated to this address.
     * @param merkleProof The cryptographic proof.
     */
    function claim(
        uint256 index,
        address account,
        uint256 amount,
        bytes32[] calldata merkleProof
    ) external {
        require(!isClaimed(index), "Airdrop already claimed.");

        // Verify the merkle proof
        bytes32 node = keccak256(abi.encodePacked(index, account, amount));
        require(MerkleProof.verify(merkleProof, merkleRoot, node), "Invalid proof.");

        // Mark it claimed and send tokens
        claimedBitMap[index] = true;
        require(token.transfer(account, amount), "Transfer failed.");

        emit Claimed(index, account, amount);
    }

    /**
     * @notice Allows owner to reclaim tokens if the airdrop expires.
     */
    function emergencyWithdraw() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
    }
}
