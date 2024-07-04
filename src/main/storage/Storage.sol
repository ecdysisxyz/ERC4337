// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./Schema.sol";

library Storage {
    bytes32 constant STATE_POSITION = keccak256(abi.encode(uint256(keccak256("ecdysisxyz.erc4337.globalstate")) - 1)) & ~bytes32(uint256(0xff));

    function state() internal pure returns (Schema.GlobalState storage s) {
        bytes32 position = STATE_POSITION;
        assembly {
            s.slot := position
        }
    }
}
