// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {MockPriceOracle} from "./mocks/PriceOracle.sol";
import "./DXDerivative.sol";

contract Market {
    DXDerivative derivativeContract;
    event AuctionStarted();
    event AuctionEnded();
    event ItemListed();
    event ItemSold();
    struct MarketListing {
        address asset;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        bool sold;
    }

    struct AuctionListing {
        address asset;
        uint256 tokenId;
        uint256 expiration;
        address payable seller;
        address payable owner;
        bool sold;
    }

    constructor(DXDerivative _derivativeContract) {
        derivativeContract = _derivativeContract;
    }

    function createListing() public {}

    function createAuction() public {}

    function bidOnAsset() public {} //

    function getListedAssets() public {}

    function getAssetsOnAuction() {}

    function registerDerivativeOnMarketPlace() {
        //supports derivative type required
    }
}
