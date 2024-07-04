// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library Schema {
    /// @custom:storage-location erc7201:ecdysisxyz.erc4337.globalstate
    struct GlobalState {
        mapping(address => uint256) nonces;
        mapping(bytes32 => bool) executedUserOps;
        address owner;
        uint256 sigValidityPeriod;
    }
}
