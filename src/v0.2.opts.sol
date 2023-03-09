// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import "@solmate/tokens/ERC721.sol";
import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DXOptions is ERC721("DX Derivative", "DXDV"), Ownable {
    using Counters for Counters.Counter;
    Counters.Counter tokenId;

    function mint(address recipient) public onlyOwner {
        _safeMint(recipient, tokenId.current());
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
    event FilledProposal(Options);
    event ExpiredOptions(Options); //after seller claims? may not actually need perhaps
    event ExecutedOptions(Options);

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
        address optionHolder;
    }

    struct Proposal {
        OptionType optionType;
        IERC20 assetAddr;
        uint256 amount;
        uint256 strikePrice;
        uint256 expiration;
        address proposer;
        bool isActive;
    }

    mapping(uint256 => Proposal) buyProposals;
    mapping(uint256 => Proposal) sellProposals;
    mapping(uint256 => Options) filledOptions;
    mapping(uint256 => Options) expiredOptions;
    mapping(uint256 => Options) executedOptions;
    Counters.Counter buyProposalIds;
    Counters.Counter sellProposalIds;

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
            OptionType.CALL,
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
            OptionType.PUT,
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
        // mint Options
    }
    //execute options
    //claim expired options
}
