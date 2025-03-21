// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Mint.sol";

contract Burn is Ownable {

    Mint public mintContract;

    ERC721 public ttContract;
    IERC20 public b3trToken;
    address B3TR_receiver;
    address tt_receiver;
    uint256 public constant B3TR_AMOUNT = 10 * 10 ** 18;
    uint256 public constant MAX_NFTS = 333;
    uint256 public constant MINTED_NFTS = 0;

    event MessageEvent(string message);

    constructor(address tt_contract, address b3tr_receiver, address burn_address, address nft_contract) Ownable(msg.sender) {
        mintContract = Mint(nft_contract);
        ttContract = ERC721(tt_contract);
        b3trToken = IERC20(0xbf64cf86894Ee0877C4e7d03936e35Ee8D8b864F);
        B3TR_receiver = b3tr_receiver;
        tt_receiver = burn_address;
    }

    function burn(uint256[] memory tt_nfts, address user, string memory tokenURI, uint256 tokenId) public returns (uint256) {

        emit MessageEvent("Burn function called");
        require(!mintContract.mintedNFTs(tokenId), "NFT already minted");
        emit MessageEvent("NFT not minted");

        require(tt_nfts.length == 3, "3 TT NFts required");

        emit MessageEvent("TT NFTs length is 3");


        for (uint256 i = 0; i < 1; i++) {
            require(ttContract.ownerOf(tt_nfts[i]) == msg.sender, "Not token owner");
            ttContract.safeTransferFrom(msg.sender, tt_receiver, tt_nfts[i]);
        }

        emit MessageEvent("TT NFTs transferred");


        require(b3trToken.transferFrom(msg.sender, B3TR_receiver, B3TR_AMOUNT), "B3TR transfer failed");

        emit MessageEvent("B3TR transferred");
        
        mintContract.safeMint(user, tokenId, tokenURI);

        emit MessageEvent("NFT minted");

        return tokenId;
    }


}