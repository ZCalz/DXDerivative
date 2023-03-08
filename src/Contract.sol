// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// left to do:
// fetching pool price quotes and method for determining initial option prices. Price derived from mint time using existing params?
// possible option to use bidding or open position. Seller gets paid immediately upon purchase of their option with their funds locked for duration of option
contract Option is ERC721, ERC721Enumerable, ERC721Burnable, Ownable {
    using Counters for Counters.Counter;
    enum OptionType {
        CALL,
        PUT
    }
    uint256 private constant ONEWEEK = 604800;

    event RegisteredAnOption();
    event OptionUnregistered();
    event OptionMatched();
    event ExercisedOption();

    struct TrackOptionRegistrar {
        uint256 registerId;
        mapping(uint256 => RegisteredOptionToBuy) registeredOptions;
    }
    struct RegisteredOptionToBuy {
        bool matched;
        OptionType optType;
        uint256 strikePrice;
        uint256 expiration;
        uint256 amount;
    }

    struct OptionData {
        uint256 tokenId;
        OptionType optType;
        uint256 strikePrice;
        uint256 expiration;
        bool exersized;
        address seller;
    }

    mapping(address => TrackOptionRegistrar)
        private availableOptionsFromSellers;
    mapping(address => OptionData) private optionHolders;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Option", "OPT") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function sellOption() public {}

    function buyOption() public {}

    function getInitialOptionPrice() public pure {}

    function calculateExpiration(uint256 numOfWeeks)
        internal
        pure
        returns (uint256)
    {
        return numOfWeeks * ONEWEEK;
    }

    function getOptionType(bool _optType) internal pure returns (OptionType) {
        if (_optType == true) {
            return OptionType.CALL;
        } else {
            return OptionType.PUT;
        }
    }

    function withdrawlFunds() public {}

    //
    function unRegisterOption(uint256 registeredId) public {
        if (
            availableOptionsFromSellers[msg.sender]
                .registeredOptions[registeredId]
                .matched == false
        ) {
            delete availableOptionsFromSellers[msg.sender].registeredOptions[
                registeredId
            ];
        }
    }

    function registerSellerOptionContract(
        bool _optType,
        uint256 _strikePrice,
        uint256 numOfWeeks
    ) public payable {
        require(msg.value > 1 ether, "Amount must be greater than one ETH");
        RegisteredOptionToBuy memory newOption;
        newOption.matched = false;
        newOption.optType = getOptionType(_optType);
        newOption.strikePrice = _strikePrice;
        newOption.expiration =
            block.timestamp +
            calculateExpiration(numOfWeeks);
        newOption.amount = msg.value;

        uint256 registerId = availableOptionsFromSellers[msg.sender].registerId;
        availableOptionsFromSellers[msg.sender].registerId += 1;
        // require minum deposit to be one ETH
        //if deposited amount is in vault, register the option

        //if not ask to deposit
        availableOptionsFromSellers[msg.sender].registeredOptions[
            registerId
        ] = newOption;
    }

    function matchBuyerOptionContract(
        address to,
        bool _optType,
        uint256 _strikePrice,
        uint256 _expiration
    ) public onlyOwner {
        _createOption(to, _optType, _strikePrice, _expiration);
    }

    function createOptions(
        address to,
        bool _optType,
        uint256 _strikePrice,
        uint256 _expiration
    ) public onlyOwner {
        _createOption(to, _optType, _strikePrice, _expiration);
    }

    function _createOption(
        address to,
        bool _optType,
        uint256 _strikePrice,
        uint256 _expiration
    ) internal {
        require(to != address(0), "invalid address");
        require(isContract(to) != true, "invalid user address");
        require(
            _expiration >= block.timestamp,
            "expiration needs to be in the future"
        );

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        OptionData memory option;
        option.tokenId = tokenId;
        option.optType = getOptionType(_optType);
        option.strikePrice = _strikePrice;
        option.expiration = block.timestamp + _expiration;

        optionHolders[to] = option;
        _safeMint(to, tokenId);
    }

    function exersizeOption() public {}

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function isContract(address _a) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_a)
        }
        return size > 0;
    }
}
