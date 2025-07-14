// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {BidBeastsNFTMarket} from "../src/BidBeastsNFTMarketPlace.sol";
import {BidBeasts} from "../src/BidBeasts_NFT_ERC721.sol";
import {BidBeasts} from "../src/BidBeasts_NFT_ERC721.sol";
import {Test} from "forge-std/Test.sol";

contract BidBeastsMarketPlaceTest is Test {

    BidBeastsNFTMarket public market;
    BidBeasts public BBERC721; 

    address owner = makeAddr("owner");
    
    address NFT_user = makeAddr("user1");
    address BID_user = makeAddr("user2");

    function setUp() public {
        vm.startPrank(owner);
        BBERC721 = new BidBeasts();
        market = new BidBeastsNFTMarket(address(BBERC721));
        vm.stopPrank();
    }

    function testListNFT() public {

        vm.startPrank(owner);
        uint256 tokenId = BBERC721.mint(NFT_user);
        assertEq(BBERC721.ownerOf(tokenId), NFT_user);
        assertEq(BBERC721.balanceOf(NFT_user), 1);
        vm.stopPrank();

        vm.startPrank(NFT_user);
        BBERC721.approve(address(market), tokenId);
        market.listNFT(tokenId, 1 ether);
        vm.stopPrank();

        vm.startPrank(BID_user);
        vm.deal(BID_user, 2 ether);
        market.placeBid{value: 2 ether}(tokenId);
        vm.stopPrank();

        vm.warp(4 days);

        vm.startPrank(NFT_user);
        market.endAuction(tokenId);
        vm.stopPrank();

        assertEq(BBERC721.ownerOf(tokenId), BID_user);
        assertEq(BBERC721.balanceOf(BID_user), 1);  
    }

}

