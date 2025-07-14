// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BidBeasts is ERC721, Ownable(msg.sender) {

    event BidBeastsMinted(address indexed to, uint256 indexed tokenId);
    event BidBeastsBurn(address indexed from, uint256 indexed tokenId);

    uint256 CurrenTokenID; 
    constructor() ERC721("Goddie_NFT", "GDNFT") {}

    function mint(address to) public onlyOwner returns (uint256) {
        uint256 _tokenId = CurrenTokenID;
        _safeMint(to, _tokenId);
        emit BidBeastsMinted(to, _tokenId);
        CurrenTokenID++;
        return _tokenId;
    }

    function burn(uint256 _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner of this token");
        _burn(_tokenId);
        emit BidBeastsBurn(msg.sender, _tokenId);
    }
}