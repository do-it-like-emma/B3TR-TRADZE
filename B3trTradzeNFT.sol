pragma solidity ^0.8.0;

contract B3trTradzeNFT {
    string public name = "B3tr Tradze";
    string public symbol = "B3TRZ";
    uint256 public totalSupply = 0;
    address public owner;

    mapping(uint256 => address) private _owners;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => uint256) private _balances;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function mint(address to, string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 tokenId = totalSupply;
        _owners[tokenId] = to;
        _tokenURIs[tokenId] = tokenURI;
        _balances[to]++;
        totalSupply++;
        emit Transfer(address(0), to, tokenId);
        return tokenId;
    }

    function batchMint(address to, string[] memory tokenURIs) public onlyOwner {
        for (uint256 i = 0; i < tokenURIs.length; i++) {
            mint(to, tokenURIs[i]);
        }
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0));
        return _tokenURIs[tokenId];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0));
        return tokenOwner;
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(msg.sender == from || msg.sender == owner);
        require(_owners[tokenId] == from);
        _owners[tokenId] = to;
        _balances[from]--;
        _balances[to]++;
        emit Transfer(from, to, tokenId);
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }
}