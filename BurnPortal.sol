pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./B3trTradzeNFT.sol";

contract BurnPortal is Ownable {
    IERC20 public ttToken;
    IERC20 public b3trToken;
    B3trTradzeNFT public nftContract;
    uint256 public constant TT_AMOUNT = 3 * 10**18;
    uint256 public constant B3TR_AMOUNT = 10 * 10**18;
    uint256 public constant MAX_NFTS = 333;
    uint256 public nftsDistributed = 0;
    uint256[] public availableNFTs;
    address public constant BURN_ADDRESS = address(0xdead);

    event NFTClaimed(address indexed user, uint256 tokenId);

    constructor(address _tt, address _b3tr, address _nft) Ownable(msg.sender) {
        ttToken = IERC20(_tt);
        b3trToken = IERC20(_b3tr);
        nftContract = B3trTradzeNFT(_nft);
        for (uint256 i = 0; i < MAX_NFTS; i++) {
            availableNFTs.push(i);
        }
    }

    function burnForNFT(uint256 randomIndex) external {
        require(nftsDistributed < MAX_NFTS, "All NFTs distributed");
        require(randomIndex < availableNFTs.length, "Invalid random index");
        require(ttToken.transferFrom(msg.sender, BURN_ADDRESS, TT_AMOUNT), "TT transfer failed");
        require(b3trToken.transferFrom(msg.sender, BURN_ADDRESS, B3TR_AMOUNT), "B3TR transfer failed");
        uint256 nftId = availableNFTs[randomIndex];
        availableNFTs[randomIndex] = availableNFTs[availableNFTs.length - 1];
        availableNFTs.pop();
        nftContract.transferFrom(address(this), msg.sender, nftId);
        nftsDistributed++;
        emit NFTClaimed(msg.sender, nftId);
    }

    function remainingNFTs() public view returns (uint256) {
        return MAX_NFTS - nftsDistributed;
    }

    function withdrawNFT(uint256 tokenId) external onlyOwner {
        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }
}