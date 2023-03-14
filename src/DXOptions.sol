// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "@solmate/tokens/ERC721.sol";
import "https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./libOptions.sol";

contract DXOptions is ERC721("DX Derivative", "DXDV"), Ownable {
    mapping(uint256 => libTypes.Options) public optionDetails;
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
