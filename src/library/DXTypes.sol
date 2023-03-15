// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

library libTypes {
    enum OptionType {
        CALL,
        PUT
    }

    struct Options {
        OptionType optionType;
        IERC20 assetAddr;
        uint256 amount;
        uint256 strikePrice;
        uint256 expiration;
        address assetHolder;
        // address optionHolder;
    }
}
