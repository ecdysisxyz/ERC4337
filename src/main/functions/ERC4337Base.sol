// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../storage/Schema.sol";
import "../storage/Storage.sol";

abstract contract ERC4337Base {
    event UserOperationEvent(bytes32 indexed userOpHash, address indexed sender, address indexed paymaster, uint256 nonce, bool success, uint256 actualGasCost, uint256 actualGasUsed);

    struct UserOperation {
        address sender;
        uint256 nonce;
        bytes initCode;
        bytes callData;
        uint256 callGasLimit;
        uint256 verificationGasLimit;
        uint256 preVerificationGas;
        uint256 maxFeePerGas;
        uint256 maxPriorityFeePerGas;
        bytes paymasterAndData;
        bytes signature;
    }

    function validateUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
    external virtual returns (uint256 validationData);

    function executeUserOp(UserOperation calldata userOp) external virtual;

    function getNonce(address sender) public view returns (uint256) {
        return Storage.state().nonces[sender];
    }

    function _validateSignature(UserOperation calldata userOp, bytes32 userOpHash)
    internal view returns (uint256 validationData) {
        Schema.GlobalState storage s = Storage.state();
        bytes32 hash = keccak256(abi.encodePacked(userOpHash, s.sigValidityPeriod, block.chainid));
        if (s.owner != ecrecover(hash, uint8(userOp.signature[0]), bytes32(userOp.signature[1:33]), bytes32(userOp.signature[33:65]))) {
            return 1;
        }
        return 0;
    }

    function _validateAndUpdateNonce(UserOperation calldata userOp) internal virtual returns (bool) {
        Schema.GlobalState storage s = Storage.state();
        require(userOp.nonce == s.nonces[userOp.sender], "ERC4337: invalid nonce");
        s.nonces[userOp.sender]++;
        return true;
    }

    function _validatePaymasterUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 maxCost)
    internal virtual returns (bytes memory context, uint256 validationData) {
        // Paymaster validation logic here
        return ("", 0);
    }

    function _executeUserOp(UserOperation calldata userOp) internal virtual {
        Schema.GlobalState storage s = Storage.state();
        require(!s.executedUserOps[keccak256(abi.encode(userOp))], "ERC4337: UserOperation already executed");
        s.executedUserOps[keccak256(abi.encode(userOp))] = true;

        (bool success, ) = userOp.sender.call{gas: userOp.callGasLimit}(userOp.callData);

        emit UserOperationEvent(
            keccak256(abi.encode(userOp)),
            userOp.sender,
            address(0), // paymaster address (if applicable)
            userOp.nonce,
            success,
            0, // actual gas cost (to be calculated)
            0  // actual gas used (to be calculated)
        );
    }
}
