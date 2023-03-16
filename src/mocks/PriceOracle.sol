// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MockPriceOracle {
    constructor() {}

    function priceFeedETH() public pure returns (uint256) {
        return uint256(2500);
    }

    function priceFeedBTC() public pure returns (uint256) {
        return uint256(34000);
    }
}
