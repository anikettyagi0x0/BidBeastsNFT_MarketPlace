// SPDX-License-Identifier: MIT 
pragma solidity 0.8.20;

import {BidBeastsNFTMarket} from "../src/BidBeastsNFTMarketPlace.sol";
import {BidBeasts} from "../src/BidBeasts_NFT_ERC721.sol";
import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract BidBeastsScript is Script {

    BidBeastsNFTMarket public market;
    BidBeasts public BBERC721; 

    function setUp() public {}

    function run() public {

        vm.startBroadcast();
        BBERC721 = new BidBeasts();
        market = new BidBeastsNFTMarket(address(BBERC721));
        vm.stopBroadcast();

        console.log("BidBeastsNFTMarket deployed to:", address(market));
        console.log("BidBeasts deployed to:", address(BBERC721));
    }
}