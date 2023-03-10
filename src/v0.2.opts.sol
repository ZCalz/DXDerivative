// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@solmate/tokens/ERC721.sol";
import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

library libTypes {
    enum OptionType {
        CALL,
        PUT
    }

    struct Options {
        OptionType optionType;
        // IERC20 assetAddr;
        uint256 amount;
        uint256 strikePrice;
        uint256 expiration;
        address assetHolder;
        // address optionHolder;
    }
}

contract DXOptions is ERC721("DX Derivative", "DXDV"), Ownable {
    // enum OptionType {
    //     CALL,
    //     PUT
    // }
    // struct Options {
    //     OptionType optionType;
    //     // IERC20 assetAddr;
    //     uint256 amount;
    //     uint256 strikePrice;
    //     uint256 expiration;
    //     address assetHolder;
    // }

    mapping(uint256 => libTypes.Options) public optionDetails;

    // mapping(uint256 => address) internal _ownerOf;
    // mapping(address => uint256) internal _balanceOf;

    using Counters for Counters.Counter;
    Counters.Counter tokenIds;

    function mint(
        address _recipient,
        libTypes.OptionType _optionType,
        uint256 _amount,
        uint256 _strikePrice,
        uint256 _expiration,
        address _assetHolder
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = tokenIds.current();
        _safeMint(_recipient, tokenId);
        tokenIds.increment();
        optionDetails[tokenId] = libTypes.Options(
            _optionType,
            _amount,
            _strikePrice,
            _expiration,
            _assetHolder
        );
        return tokenId;
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        id + id;
        return "URI";
    }
}

contract DXDerivative {
    using Counters for Counters.Counter;

    event OpenedNewBuyProposal(uint256 proposalId, Proposal);
    event OpenedNewSellProposal(uint256 proposalId, Proposal);
    event FilledProposal(uint256 proposalId, uint256 optionsId);
    event ExpiredOptions(libTypes.Options); //after seller claims? may not actually need perhaps
    event ExecutedOptions(libTypes.Options);

    // enum OptionType {
    //     CALL,
    //     PUT
    // }

    // struct Options {
    //     OptionType optionType;
    //     IERC20 assetAddr;
    //     uint256 amount;
    //     uint256 strikePrice;
    //     uint256 expiration;
    //     address assetHolder;
    //     address optionHolder;
    // }

    struct Proposal {
        libTypes.OptionType optionType;
        IERC20 assetAddr;
        uint256 amount;
        uint256 strikePrice;
        uint256 expiration;
        address proposer;
        bool isActive;
    }

    mapping(uint256 => Proposal) buyProposals;
    mapping(uint256 => Proposal) sellProposals;
    mapping(uint256 => libTypes.Options) filledOptions;
    mapping(uint256 => libTypes.Options) expiredOptions;
    mapping(uint256 => libTypes.Options) executedOptions;
    Counters.Counter buyProposalIds;
    Counters.Counter sellProposalIds;

    DXOptions optionFactory = new DXOptions();

    function createOpenBuyCall(
        IERC20 asset,
        uint256 amount,
        uint256 strikePrice,
        uint256 expiration
    ) public {
        //calculate option price, require msg.value = price
        require(
            expiration > block.timestamp + 7 days,
            "Expiration must be at least a week from now"
        );
        Proposal memory proposed = Proposal(
            libTypes.OptionType.CALL,
            asset,
            amount,
            strikePrice,
            expiration,
            msg.sender,
            true
        );
        buyProposals[buyProposalIds.current()] = proposed;
        emit OpenedNewBuyProposal(buyProposalIds.current(), proposed);
        buyProposalIds.increment();
    }

    function createOpenBuyPut(
        IERC20 asset,
        uint256 amount,
        uint256 strikePrice,
        uint256 expiration
    ) public {
        //calculate option price, require msg.value = price
        require(
            expiration > block.timestamp + 7 days,
            "Expiration must be at least a week from now"
        );
        Proposal memory proposed = Proposal(
            libTypes.OptionType.PUT,
            asset,
            amount,
            strikePrice,
            expiration,
            msg.sender,
            true
        );
        buyProposals[buyProposalIds.current()] = proposed;
        emit OpenedNewBuyProposal(buyProposalIds.current(), proposed);
        buyProposalIds.increment();
    }

    /// fill proposals
    function fillBuyOption(uint256 proposalId) public payable {
        require(
            buyProposals[proposalId].amount == msg.value,
            "Expected asset amount requirements not met"
        );
        require(
            buyProposals[proposalId].isActive == true,
            "This proposal is not active"
        );

        (
            libTypes.OptionType optionType,
            ,
            uint256 amount,
            uint256 strikePrice,
            uint256 expiration,
            address proposer
        ) = buyProposals[proposalId];
        // mint Options
        uint256 optionsId = optionFactory.mint(
            proposer,
            optionType,
            amount,
            strikePrice,
            expiration,
            msg.sender
        );
        emit FilledProposal(proposalId, optionsId);
    }
    //execute options
    //claim expired options
}
