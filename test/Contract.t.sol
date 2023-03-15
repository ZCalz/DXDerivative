// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {DXDerivative} from "../src/DXDerivative.sol";
import {DXOptions} from "../src/DXOptions.sol";
import "../src/library/DXTypes.sol";
import "../src/mocks/Stablecoin.sol";

contract ContractTest is Test {
    DXDerivative public dxDerivative;
    DXOptions public optionsFactory;
    IERC20 mockDAI;
    IERC20 mockUSDC;

    address bob = address(0x1); // bob with address 0x00..0001
    address alice = address(0x2);

    function setUp() public {
        dxDerivative = new DXDerivative();
        mockDAI = new MockStableCoin("Mock DAI", "MDAI");
        mockUSDC = new MockStableCoin("Mock USDC", "MUSDC");
        vm.deal(bob, 100000);
        vm.deal(alice, 100000);
    }

    function testDeployedDXDerivative() public {
        optionsFactory = dxDerivative.optionFactory();
        console.logAddress(address(optionsFactory));
        string memory name = optionsFactory.name();
        string memory symbol = optionsFactory.symbol();
        assertEq(name, "DX Derivative");
        assertEq(symbol, "DXDV");
    }

    function testCreateBuyCallProposal() public {
        uint256 amountStablecoin = 10000;
        uint256 ethStrikePrice = 1500;
        uint256 setExpiration = block.timestamp + 30 days;

        vm.prank(alice);

        uint256 proposalId = dxDerivative.proposeBuyCall(
            mockDAI,
            amountStablecoin,
            ethStrikePrice,
            setExpiration
        );

        assertEq(dxDerivative.buyProposalIds(), 1);

        (
            libTypes.OptionType optionType,
            IERC20 assetAddr,
            uint256 amount,
            uint256 strikePrice,
            uint256 expiration,
            address proposer,
            bool isActive
        ) = dxDerivative.buyProposals(proposalId);

        assertEq(uint8(optionType), uint8(libTypes.OptionType.CALL));
        assertEq(address(assetAddr), address(mockDAI));
        assertEq(amount, amountStablecoin);
        assertEq(strikePrice, ethStrikePrice);
        assertEq(expiration, setExpiration);
        assertEq(proposer, address(alice));
        assertEq(isActive, true);
    }

    function testCreateBuyPutProposal() public {
        uint256 amountStablecoin = 10000;
        uint256 ethStrikePrice = 500;
        uint256 setExpiration = block.timestamp + 30 days;

        vm.prank(alice);

        uint256 proposalId = dxDerivative.proposeBuyPut(
            mockUSDC,
            amountStablecoin,
            ethStrikePrice,
            setExpiration
        );

        assertEq(dxDerivative.buyProposalIds(), 1);

        (
            libTypes.OptionType optionType,
            IERC20 assetAddr,
            uint256 amount,
            uint256 strikePrice,
            uint256 expiration,
            address proposer,
            bool isActive
        ) = dxDerivative.buyProposals(proposalId);

        assertEq(uint8(optionType), uint8(libTypes.OptionType.PUT));
        assertEq(address(assetAddr), address(mockUSDC));
        assertEq(amount, amountStablecoin);
        assertEq(strikePrice, ethStrikePrice);
        assertEq(expiration, setExpiration);
        assertEq(proposer, address(alice));
        assertEq(isActive, true);
    }

    function testFillProposal() public {
        uint256 amountStablecoin = 10000;
        uint256 ethStrikePrice = 1500;
        uint256 setExpiration = block.timestamp + 30 days;

        vm.prank(alice);

        uint256 proposalId = dxDerivative.proposeBuyPut(
            mockUSDC,
            amountStablecoin,
            ethStrikePrice,
            setExpiration
        );

        assertEq(dxDerivative.buyProposalIds(), 1);

        vm.prank(bob);

        uint256 optionsId = dxDerivative.fillBuyProposal{
            value: amountStablecoin
        }(proposalId);
        assertEq(optionsId, 0);

        // uint256 balanceOfBob = optionsFactory.balanceOf(bob);
        // assertEq(optionsFactory.balanceOf(address(bob)), 1);
        // assertEq(optionsFactory.ownerOf(optionsId), address(bob));
        // (
        //     libTypes.OptionType optionType,
        //     IERC20 assetAddr,
        //     uint256 amount,
        //     uint256 strikePrice,
        //     uint256 expiration,
        //     address assetHolder
        // ) = optionsFactory.optionDetails(optionsId);
        // optionsFactory.optionDetails(optionsId);
        // assertEq(uint8(optionType), uint8(libTypes.OptionType.PUT));
        // assertEq(address(assetAddr), address(mockUSDC));
        // assertEq(amount, amountStablecoin);
        // assertEq(strikePrice, ethStrikePrice);
        // assertEq(expiration, setExpiration);
        // assertEq(assetHolder, address(alice));
    }

    function testExample() public {
        vm.recordLogs();
        new DXDerivative();
        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        // assertEq(
        //     entries[0].topics[0],
        //     keccak256("LogCompleted(uint256,bytes)")
        // );
        // assertEq(entries[0].topics[1], bytes32(uint256(10)));
        // assertEq(abi.decode(entries[0].data, (string)), "operation completed");
        // console.logString(abi.decode(entries[0].data, (string)));
        assertTrue(true);
    }
}
