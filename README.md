# BidBeasts NFT Marketplace

<p align="center">
<img width="300" height="300" alt="logo-removebg-preview" src="https://github.com/user-attachments/assets/02f9e14f-4deb-48a0-8029-e8200bd5d05f" />
</p>


## About the Project

This smart contract implements a basic auction-based NFT marketplace for the `BidBeasts` ERC721 token. It enables NFT owners to list their tokens for auction, accept bids from participants, and settle auctions with a platform fee mechanism.

The project was developed using Solidity, OpenZeppelin libraries, and is designed for deployment on Ethereum-compatible networks.

---

## The flow is simple:

1. **Listing**:  
   - NFT owners call `listNFT(tokenId, minPrice)` to list their token.
   - The NFT is transferred from the seller to the marketplace contract.

2. **Bidding**:  
   - Users call `placeBid(tokenId)` and send ETH to place a bid.
   - New bids must be higher than the previous bid.
   - Previous bidders are refunded automatically.

3. **Auction Completion**:  
   - After 3 days, anyone can call `endAuction(tokenId)` to finalize the auction.
   - If the highest bid meets or exceeds the minimum price:
     - NFT is transferred to the winning bidder.
     - Seller receives payment minus a 5% marketplace fee.
   - If no valid bids were made:
     - NFT is returned to the original seller.

4. **Fee Withdrawal**:  
   - Contract owner can withdraw accumulated fees using `withdrawFee()`.

---

## The contract also supports:

- **Minimum price enforcement** for listings.
- **Minimum bid enforcement** for bidders.
- **Auction deadline** of exactly 3 days.
- **Automatic refunding** of previous highest bidder.
- **Only owner access** for withdrawing platform fees.

---

## BidBeastsNFT Structure
```
├── lib/                    
├── src/                   
│   └── BidBeasts_NFT_ERC721.sol
|   └── BidBeastsNFTMarketPlace.sol
|        
├── script/                
│   └── BidBeastsNFTMarketPlaceDeploy.s.sol       
│
├── test/                  
│   └── BidBeastsMarketPlaceTest.t.sol   
│
├── foundry.toml       
└── README.md
```

---

## Compatibility

- **Chain**: Ethereum  
- **Token Standard**: ERC721  

---

## Set-up

```bash
git clone https://github.com/anikettyagi0x0/BidBeastsNFT_MarketPlace
cd BidBeastsNFT_MarketPlace

forge compile
forge test
