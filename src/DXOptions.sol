// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "@solmate/tokens/ERC721.sol";
import "@solmate/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./library/DXTypes.sol";

contract DXOptions is ERC721("DX Derivative", "DXDV"), Ownable {
    mapping(uint256 => libTypes.Options) public optionDetails;
    using Counters for Counters.Counter;

    Counters.Counter tokenIds;

    function mint(
        address _recipient,
        libTypes.OptionType _optionType,
        IERC20 _assetAddr,
        uint256 _amount,
        uint256 _strikePrice,
        uint256 _expiration,
        address _assetObligator
    ) public onlyOwner returns (uint256) {
        uint256 tokenId = tokenIds.current();
        _safeMint(_recipient, tokenId);
        tokenIds.increment();
        optionDetails[tokenId] = libTypes.Options(
            _optionType,
            _assetAddr,
            _amount,
            _strikePrice,
            _expiration,
            _assetObligator
        );
        return tokenId;
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        id + id;
        return "URI";
    }

    function getOptionDetails(
        uint256 id
    ) public returns (libTypes.Options memory) {
        return optionDetails[id];
    }
}
