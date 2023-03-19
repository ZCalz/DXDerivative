// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import "@solmate/tokens/ERC721.sol";
import "@solmate/tokens/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./library/DXTypes.sol";
import "./library/Base64.sol";

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
        _updateTokenURI();
        return tokenId;
    }

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    function _updateTokenURI() private {
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory asset = "USDC";
        string memory amount = "1355";
        string memory expiration = "23/2/23";
        string memory optionType = "CALL";

        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg,
                optionType,
                asset,
                amount,
                expiration,
                "</text></svg>"
            )
        );
        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        // We'll be setting the tokenURI later!
        _setTokenURI(newItemId, "blah");

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
    }

    function tokenURI(uint256 id) public pure override returns (string memory) {
        id + id;
        return "URI";
    }

    function getOptionDetails(
        uint256 id
    ) public view returns (libTypes.Options memory) {
        return optionDetails[id];
    }

    function burnOption(uint256 id) public onlyOwner {
        _burn(id);
    }
}
