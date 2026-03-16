# ZK-Merkle Airdrop

A high-performance, professional implementation of a Merkle Airdrop. This repository provides the logic required to distribute ERC20 tokens to thousands of users while only storing a single 32-byte hash (the Merkle Root) on the blockchain.

### Features
* **Massive Scalability**: Support for millions of recipients without increasing deployment costs.
* **Gas Efficiency**: Users pay for their own claim transaction, offloading the cost from the distributor.
* **Security**: Prevents double-claiming using a bitmask/mapping and ensures cryptographic integrity via Merkle Proofs.
* **Ownership Control**: Allows the owner to sweep unclaimed tokens after the airdrop period ends.

### How to Use
1. Generate a Merkle Tree off-chain using the addresses and amounts of eligible users.
2. Deploy `MerkleAirdrop.sol` with the Merkle Root and the Token address.
3. Users provide their specific `index`, `amount`, and `proof` to the `claim` function.
4. The contract verifies the proof against the root and transfers the tokens.
