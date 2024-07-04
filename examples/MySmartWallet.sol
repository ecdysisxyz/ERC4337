// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC4337Base } from "ecdysisxyz/erc4337/src/main/functions/ERC4337Base.sol";
import { Schema as ERC4337Schema } from "ecdysisxyz/erc4337/src/main/storage/Schema.sol";
import { Storage as ERC4337Storage } from "ecdysisxyz/erc4337/src/main/storage/Storage.sol";

contract MySmartWallet is ERC4337Base {
    event Received(address sender, uint amount);

    constructor(address _owner) {
        ERC4337Schema.GlobalState storage s = ERC4337Storage.state();
        s.owner = _owner;
        s.sigValidityPeriod = 1 hours;
    }

    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
    external override returns (uint256 validationData) {
        if (_validateAndUpdateNonce(userOp)) {
            validationData = _validateSignature(userOp, userOpHash);
            if (missingAccountFunds > 0) {
                (bool success, ) = userOp.sender.call{value: missingAccountFunds}("");
                require(success, "Failed to transfer missingAccountFunds");
            }
        } else {
            validationData = SIG_VALIDATION_FAILED;
        }
    }

    function executeUserOp(UserOperation calldata userOp) external override {
        _executeUserOp(userOp);
    }

    // Custom function to update owner
    function updateOwner(address newOwner) external {
        ERC4337Schema.GlobalState storage s = ERC4337Storage.state();
        require(msg.sender == s.owner, "Only owner can update owner");
        s.owner = newOwner;
    }

    // Custom function to execute arbitrary transactions
    function execute(address target, uint256 value, bytes calldata data) external {
        ERC4337Schema.GlobalState storage s = ERC4337Storage.state();
        require(msg.sender == s.owner, "Only owner can execute transactions");
        (bool success, ) = target.call{value: value}(data);
        require(success, "Transaction execution failed");
    }

    // Function to get current owner
    function getOwner() external view returns (address) {
        return ERC4337Storage.state().owner;
    }

    // Function to get current nonce
    function getNonce() external view returns (uint256) {
        return ERC4337Storage.state().nonces[address(this)];
    }

    // Function to receive Ether
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
}
