pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract B3trTradzeNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 public totalSupply = 0;

    constructor() ERC721("B3tr Tradze", "B3TRZ") Ownable(msg.sender) {}

    function mint(address to, string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 tokenId = totalSupply;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        totalSupply++;
        return tokenId;
    }

    function batchMint(address to, string[] memory tokenURIs) public onlyOwner {
        for (uint256 i = 0; i < tokenURIs.length; i++) {
            mint(to, tokenURIs[i]);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}