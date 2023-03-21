// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {MockPriceOracle} from "./mocks/PriceOracle.sol";
import "./DXDerivative.sol";
import "./DXOptions.sol";

contract Market {
    using Counters for Counters.Counter;
    Counters.Counter private marketIds;
    Counters.Counter private auctionIds;

    DXDerivative derivativeContract;
    DXOptions dxOptionsContract;

    event AuctionItemListed(uint256 auctionId, uint256 tokenId);
    event AuctionItemSold(uint256 auctionId, uint256 tokenId, address soldTo);

    event MarketItemListed(uint256 marketId, uint256 tokenId);
    event MarketItemSold(uint256 marketId, uint256 tokenId, address soldTo);

    struct Fee {
        uint256 numerator;
        uint256 denominator;
    }
    struct MarketListing {
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool isActive;
        bool sold;
    }

    struct AuctionListing {
        uint256 tokenId;
        uint256 expiration;
        address payable seller;
        uint256 minBid;
        uint256 currentHighestBid;
        bool isActive;
        bool sold;
    }
    /**
    can only be listed once by the owner in each type of listing
    refreshes when sold and starts new for each new seller
    */
    struct ActivelyListed {
        bool auction;
        bool market;
    }
    //marketId
    mapping(uint256 => MarketListing) public assetOnMarket;
    //auctionId
    mapping(uint256 => AuctionListing) public assetOnAuction;
    //tokenId
    mapping(uint256 => ActivelyListed) public tokenIsListed;

    Fee public fee;

    modifier onlyAssetOwner(address seller, uint256 tokenId) {
        require(
            dxOptionsContract.ownerOf(tokenId) == seller,
            "You are not the owner of this asset"
        );
        _;
    }

    modifier allowableMarket(address seller, uint256 tokenId) {
        require(
            tokenIsListed[tokenId].market == true,
            "This token is not an active market listing"
        );
        _;
    }

    modifier allowableAuction(address seller, uint256 tokenId) {
        require(
            tokenIsListed[tokenId].auction == true,
            "This token is not an active auction listing"
        );
        require(
            assetOnAuction[tokenId].currentHighestBid == 0,
            "Cannot modify or remove auction when there are existing bids"
        );
        _;
    }

    constructor(
        DXDerivative _derivativeContract,
        DXOptions _dxOptionsContract
    ) {
        derivativeContract = _derivativeContract;
        dxOptionsContract = _dxOptionsContract;
        fee = Fee({numerator: 3, denominator: 100});
    }

    function updateFee(uint256 numerator, uint256 denominator) public {
        //make only admin
        fee = Fee(numerator, denominator);
    }

    //LISTINGS
    function createListing(
        //free listings?
        uint256 _tokenId,
        uint256 _price
    ) public onlyAssetOwner(msg.sender, _tokenId) {
        //require listing not currently active
        require(
            tokenIsListed[tokenId].market == false,
            "Item already listed in market listing"
        );
        _dxOptionsContract.transferFrom(msg.sender, address(this), tokenId);
        tokenIsListed[_tokenId].market = true;

        assetOnSale[marketIds.current()] = new MarketListing({
            tokenId: _tokenId,
            price: _price,
            seller: msg.sender,
            isActive: true,
            sold: false
        });
        emit ItemListed(marketId, tokenId);
        marketIds.increment();
    }

    function modifyListing(
        uint256 _marketId,
        uint256 _newPrice
    )
        public
        onlyAssetOwner(msg.sender, assetOnSale[_marketId].seller)
        allowableMarket(assetOnSale[_marketId].tokenId)
    {
        //require listing currently active
        assetOnSale[_marketId].price = _newPrice;
        //emit price change?
    }

    function removeListing(
        uint256 _marketId
    )
        public
        // onlyAssetOwner(msg.sender, tokenId)
        allowableMarket(assetOnSale[_marketId].tokenId)
        nonReentrant //?
    {
        //require listing currently active
        _dxOptionsContract.transferFrom(
            address(this),
            assetOnSale[_marketId].seller,
            tokenId
        );
        tokenIsListed[_tokenId].market = false;
        assetOnSale[_marketId].isActive = false;
        //send option contract back to user?
    }

    function buyAsset(uint256 _marketId) public payable nonReentrant {
        require(
            msg.sender != assetOnSale[_marketId].seller,
            "You cannot buy your own listing"
        );
        uint256 memory price = assetOnSale[_marketId].price;
        require(msg.value >= price, "Did not sent enough to pay for listing");

        //payment spliter?
        (bool sent, ) = (assetOnSale[_marketId].seller).call{
            value: (price - ((price * numerator) / (price * denominator)))
        }("");
        require(sent, "Failed to send Ether");

        emit MarketItemSold(_marketId, tokenId, msg.sender);
        tokenIsListed[_tokenId].sold = true;
        tokenIsListed[_tokenId].market = false;
    }

    //AUCTIONS
    function createAuction(
        uint256 _tokenId,
        uint256 _expiration,
        uint256 _minBid
    ) public onlyAssetOwner(msg.sender, tokenId) {
        require(
            tokenIsListed[tokenId].auction == false,
            "Item already listed in market listing"
        );
        _dxOptionsContract.transferFrom(msg.sender, address(this), tokenId);
        tokenIsListed[_tokenId].auction = true;
        AuctionListing memory auction = new AuctionListing({
            tokenId: _tokenId,
            expiration: _expiration,
            seller: msg.sender,
            minBid: _minBid,
            currentHighestBid: 0,
            isActive: true,
            sold: false
        });
        assetOnAuction[auctionIds.current()] = auction;
        emit AuctionItemListed(auctionIds.current(), _tokenId);
        auctionIds.increment();
    }

    function claimWinningBid() public {}

    function modifyAuctionInfo() public allowableAuction(tokenId) {}

    function removeAuction() public allowableAuction(tokenId) {}

    function bidOnAsset() public payable nonReentrant {} //

    //for items not listed or to make new offer from existing offers with price acceptable to buyer
    function createOffer() public payable nonReentrant {}

    function getListedAssets() public {}

    function getAssetsOnAuction() public {}

    function registerDerivativeOnMarketPlace() public {
        //supports derivative type required
    }
}
