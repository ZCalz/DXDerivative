// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./libOptions.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {DXOptions} from "./DXOptions.sol";

contract DXDerivative {
    using Counters for Counters.Counter;

    event OpenedNewBuyProposal(uint256 proposalId, Proposal);
    event OpenedNewSellProposal(uint256 proposalId, Proposal);
    event FilledProposal(uint256 proposalId, uint256 optionsId);
    event ExpiredOptions(libTypes.Options); //after seller claims? may not actually need perhaps
    event ExecutedOptions(libTypes.Options);

    struct Proposal {
        libTypes.OptionType optionType;
        IERC20 assetAddr;
        uint256 amount;
        uint256 strikePrice;
        uint256 expiration;
        address proposer;
        bool isActive;
    }

    mapping(uint256 => Proposal) public buyProposals;
    mapping(uint256 => Proposal) sellProposals;
    mapping(uint256 => libTypes.Options) public filledOptions;
    mapping(uint256 => libTypes.Options) expiredOptions;
    mapping(uint256 => libTypes.Options) public executedOptions;
    mapping(address => uint256[]) userBuyProposals;
    mapping(address => uint256[]) userSellProposals;
    Counters.Counter public buyProposalIds;
    Counters.Counter sellProposalIds;

    DXOptions public optionFactory;

    constructor() {
        optionFactory = new DXOptions();
    }

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
        uint256 currentId = buyProposalIds.current();
        buyProposals[currentId] = proposed;
        userBuyProposals[msg.sender].push(currentId);
        emit OpenedNewBuyProposal(currentId, proposed);
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
        uint256 currentId = buyProposalIds.current();
        buyProposals[currentId] = proposed;
        userBuyProposals[msg.sender].push(currentId);
        emit OpenedNewBuyProposal(currentId, proposed);
        buyProposalIds.increment();
    }

    /// fill proposals
    function fillBuyOption(uint256 proposalId) public payable {
        Proposal memory info = buyProposals[proposalId];
        require(
            info.amount <= msg.value,
            "Expected asset amount requirements not met"
        );
        require(info.isActive == true, "This proposal is not active");
        buyProposals[proposalId].isActive = false;
        // mint Options
        uint256 optionsId = optionFactory.mint(
            info.proposer,
            info.optionType,
            info.amount,
            info.strikePrice,
            info.expiration,
            msg.sender
        );

        emit FilledProposal(proposalId, optionsId);
    }
    //execute options
    //claim expired options
}
