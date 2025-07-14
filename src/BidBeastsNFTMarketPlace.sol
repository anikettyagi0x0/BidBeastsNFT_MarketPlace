// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {BidBeasts} from "./BidBeasts_NFT_ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract BidBeastsNFTMarket is Ownable(msg.sender) {
    
    BidBeasts public BBERC721;

    event BidBeastNftList(uint256 tokenId, uint256 minPrice);
    event BidBeastNftUnlist(uint256 tokenId, uint256 minPrice);
    event BidBeastNftBid(uint256 tokenId, uint256 amount);
    event BidBeastNftEndAuction(uint256 tokenId);
    event BidBeastnftWithdrawFee(uint256 amount);

    struct Listing {
        address seller;
        uint256 minPrice;
        uint256 deadline;
        bool listed;
    }

    struct Bid {
        address bidder;
        uint256 amount;
    }

    uint256 constant S_MAX_AUCTION_DURATION = 3 days;
    uint256 constant S_MIN_NFT_PRICE = 0.01 ether;
    uint256 constant S_MIN_NFT_BID_PRICE = 0.01 ether;
    uint256 constant S_FEE_PERCENTAGE = 5;

    uint256 public s_totalfee;
    mapping(uint256 => Listing) public listings;
    mapping(uint256 => Bid) public bids;

    constructor(address _BidBeastsNFT) {
        BBERC721 = BidBeasts(_BidBeastsNFT);
    }

    function listNFT(uint256 tokenId, uint256 _minPrice) external {

        require(BBERC721.ownerOf(tokenId) == msg.sender, "You are not the owner of this token");
        require(_minPrice >= S_MIN_NFT_PRICE, "NFT Min Price too low");

        BBERC721.transferFrom(msg.sender, address(this), tokenId);

        listings[tokenId] = Listing({
            seller: msg.sender,
            minPrice: _minPrice,
            deadline: block.timestamp + S_MAX_AUCTION_DURATION,
            listed: true

        });

        emit BidBeastNftList(tokenId, _minPrice);
    }

    function unlistNFT(uint256 tokenId) external {

        require(listings[tokenId].seller == msg.sender, "You are not the owner of this token");
        require(listings[tokenId].listed, "NFT is not listed");

        Listing storage listing = listings[tokenId];
        listing.listed = false;
        
        BBERC721.transferFrom(address(this), msg.sender, tokenId);

        emit BidBeastNftUnlist(tokenId, listing.minPrice);
    }

    function placeBid(uint256 tokenId) external payable {
        
        Listing storage listing = listings[tokenId];

        require(listing.listed, "Not listed");
        require(block.timestamp < listing.deadline, "Auction ended");
        require(msg.value > S_MIN_NFT_BID_PRICE, "Bid too low");

        Bid storage currentBid = bids[tokenId];
        require(msg.value > currentBid.amount, "New bid must be higher than current bid");

        // Refund previous bidder
        if (currentBid.bidder != address(0)) {
            (bool sent, ) = payable(currentBid.bidder).call{value: currentBid.amount}("");
            require(sent, "Refund failed");
        }
        
        // Store new highest bid
        bids[tokenId] = Bid(msg.sender, msg.value);

        emit BidBeastNftBid(tokenId, msg.value);
    }

    function endAuction(uint256 tokenId) external {
        Listing storage listing = listings[tokenId];
        Bid storage bid = bids[tokenId];
    
        require(listing.listed, "NFT not listed");
        require(listing.seller == msg.sender, "You are not the owner of this NFT");
        require(block.timestamp >= listing.deadline, "Auction not yet ended");

        listing.listed = false;

        if (bid.amount >= listing.minPrice) {

            BBERC721.transferFrom(address(this), bid.bidder, tokenId);

            uint256 fee = (bid.amount * S_FEE_PERCENTAGE) / 100;
            s_totalfee += fee;
            payable(listing.seller).transfer(bid.amount - fee);

        } else {

            BBERC721.transferFrom(address(this), listing.seller, tokenId);
        }

        emit BidBeastNftEndAuction(tokenId);
    }

    function withdrawFee() external onlyOwner {

        payable(owner()).transfer(s_totalfee);
        s_totalfee = 0;
        emit BidBeastnftWithdrawFee(s_totalfee);
    }

    // View Functions
    function getOwner() public view returns (address) {
        return owner();
    }

    function getListing(uint256 tokenId) public view returns (uint256, address, uint256, bool){
        return (listings[tokenId].minPrice, listings[tokenId].seller, listings[tokenId].deadline, listings[tokenId].listed);
    }
}
