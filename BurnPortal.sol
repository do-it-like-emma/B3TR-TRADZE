pragma solidity ^0.8.0;

interface IVIP180 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract BurnPortal {
    IVIP180 public ttToken;
    IVIP180 public b3trToken;
    B3trTradzeNFT public nftContract;
    uint256 public constant TT_AMOUNT = 3 * 10**18;
    uint256 public constant B3TR_AMOUNT = 10 * 10**18;
    uint256 public constant MAX_NFTS = 333;
    uint256 public nftsDistributed = 0;
    uint256[] public availableNFTs;
    address public owner;

    event NFTClaimed(address indexed user, uint256 tokenId);

    constructor(address _tt, address _b3tr, address _nft) {
        ttToken = IVIP180(_tt);
        b3trToken = IVIP180(_b3tr);
        nftContract = B3trTradzeNFT(_nft);
        owner = msg.sender;
        for (uint256 i = 0; i < MAX_NFTS; i++) {
            availableNFTs.push(i);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function burnForNFT() external {
        require(nftsDistributed < MAX_NFTS);

        require(ttToken.transferFrom(msg.sender, address(0xdead), TT_AMOUNT));
        require(b3trToken.transferFrom(msg.sender, address(0xdead), B3TR_AMOUNT));

        uint256 randomIndex = random() % availableNFTs.length;
        uint256 nftId = availableNFTs[randomIndex];
        availableNFTs[randomIndex] = availableNFTs[availableNFTs.length - 1];
        availableNFTs.pop();

        nftContract.transferFrom(address(this), msg.sender, nftId);
        nftsDistributed++;
        emit NFTClaimed(msg.sender, nftId);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nftsDistributed)));
    }

    function remainingNFTs() public view returns (uint256) {
        return MAX_NFTS - nftsDistributed;
    }

    function withdrawNFT(uint256 tokenId) external onlyOwner {
        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }
}