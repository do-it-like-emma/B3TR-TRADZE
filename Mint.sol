// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Mint is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
        
    mapping(uint => bool) public mintedNFTs;

    uint256 public constant MAX_NFTS = 333;
    uint256 public MINTED_NFTS = 0;

    address public burnContract;

    constructor(address initialOwner)
        ERC721("B3tr Tradze", "B3TRZ")
        Ownable(initialOwner)
    {
        burnContract= payable(address(0x3b29d124d384431136511B9Ce421E38E93f620c6));
    }

    modifier onlyApproved() {
        require(msg.sender == burnContract || msg.sender == owner(), "Caller is not approved to mint NFTs");
        _;
    }

    function setBurnContract(address _burnContract) external onlyOwner {
        burnContract = _burnContract;
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyApproved
    {
        require( MINTED_NFTS < MAX_NFTS, "All NFTs distributed");
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        mintedNFTs[tokenId] = true;
        MINTED_NFTS++;

    }

    function batchMint(address to, string[] memory tokenURIs, uint256[] memory tokenIds) public onlyApproved {
        for (uint256 i = 0; i < tokenURIs.length; i++) {
            safeMint(to, tokenIds[i], tokenURIs[i]);
        }
    }

    // The following functions are overrides required by Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
