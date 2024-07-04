# ERC-4337 Smart Contract Wallet Library

This project provides a reusable library for implementing ERC-4337 compliant smart contract wallets. It is primarily designed to be used as a library within the metacontract (mc) framework, allowing developers to easily integrate account abstraction features into their projects.

## Overview

The library includes:

- Basic ERC-4337 implementation (`ERC4337Base.sol`)
- Storage schema for ERC-4337 wallets (`Schema.sol`)
- Storage access utilities (`Storage.sol`)
- An example implementation of a simple smart wallet (`MySmartWallet.sol`)

## Usage

To use this library in your metacontract project:

1. Install the library using Forge:
   ```
   forge install ecdysisxyz/erc4337
   ```
2. Import the necessary contracts in your Solidity files:
   ```solidity
   import { ERC4337Base } from "ecdysisxyz/erc4337/src/main/functions/ERC4337Base.sol";
   import { Schema as ERC4337Schema } from "ecdysisxyz/erc4337/src/main/storage/Schema.sol";
   import { Storage as ERC4337Storage } from "ecdysisxyz/erc4337/src/main/storage/Storage.sol";
   ```
3. Extend the `ERC4337Base` contract and implement your custom logic.

## Example

See `examples/MySmartWallet.sol` for a basic implementation of an ERC-4337 compliant smart wallet using this library.

## Features

- ERC-4337 compliant implementation
- Modular and extensible design
- Compatible with the metacontract (mc) framework
- Basic owner management and arbitrary transaction execution

## Development Status

Please note that this project is currently in beta and under active development. While we strive for high-quality code, the implementation has not yet undergone a formal audit. Use caution when integrating this library into production systems.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.

---

# Meta Contract Template
Welcome to the Meta Contract Template! This template is your fast track to smart contract development, offering a pre-configured setup with the [Meta Contract](https://github.com/metacontract/mc) framework and essential tools like the [ERC-7201 Storage Location Calculator](https://github.com/metacontract/erc7201). It's designed for developers looking to leverage advanced features and best practices right from the start.

## Quick Start
Ensure you have [Foundry](https://github.com/foundry-rs/foundry) installed, then initialize your project with:
```sh
$ forge init <Your Project Name> -t metacontract/template
```
This command sets up your environment with all the benefits of the meta contract framework, streamlining your development process.

## Features
- Pre-integrated with meta contract for optimal smart contract development with highly flexible upgradeability & maintainability.
- Includes ERC-7201 Storage Location Calculator for calculating storage locations based on ERC-7201 names for enhanced efficiency.
- Ready-to-use project structure for immediate development start.

For detailed documentation and further guidance, visit [Meta Contract Book](https://mc-book.ecdysis.xyz/).

Start building your decentralized applications with meta contract today and enjoy a seamless development experience!
