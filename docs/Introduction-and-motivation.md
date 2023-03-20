# Token Playground Chapter 1: Introduction & Motivation.

![Soroban Image](./img/soroban.png "Soroban Logo")

Soroban, stellar's smart contract platform, is currently under development and  its officeal launchment is expected some time in 2023. One of the most important applications on any smart contracts platform is how manage tokens  (creation, mint, transfer, burn,  etc.. ). In the case of stellar this is specially  relevant due to the fact that it is one of the oldest blockchains and has a solution for manage tokens (stellar assets) beyond smart contract  builtin directly on chain. 

Stellar allow manage tokens previous to soroban and custom soroban tokens. Here we will focus on Stellar Assets (clasic tokens).

Our main motiviation in the current developement is to explain to developers coming to soroban how stellar assets can coexist with smart contracts, how they can  take advantage of soroban and what limitations could present.

A well known smart contract platform is the Ethereum VM. Ethereum ecossystem has developed different standard to create, mint, burn and transfer tokens like  ERC20 for fungible tokens and ERC721 for NFT. An evm  smart contract is fully responsible  over the creation, mint,burn, total supply  and transfer of the token that manages, assuring as well the ownership of the holders(address) over their balances.  This control over token operations and supply allow evm tokens's smart contract  offer some nice features as: 

- Link transfer operations  to smart contract logic as pay royalties to nft authors or apply fees
- Create  collaterized tokens to  lending redeemption and  assure 1:1 with tokens they represent 

Soroban provide a mechanism to wrap a stellar asset in a smart contract so that it can be minted, transfered and manage address balances but can't avoid that tokens not deposited in it to be  transfered using stellar transaction neither assure it could  apply logic over the token when they are transfered.

We have developed a token playground to explain how stellar asset can be managed from a soroban smart contract. For that we have created a set of scripts that will show you in a practical way the main actions involved in token managment:

- Issue the token, create the token outside of soroban throw an issuer address, a regular stellar address the crate the token for the first time by transfer to a destination addres.  Stellar allow lock issuer addres to establish a total supply. We leave issuer address unlocke to allow soroban to mint new tokens.  
- Get info about the token (Asset Code, Issuer, Balance ) 
- Wrap the token from Stellar to Soroban 
- Mint wrapped token in Soroban 
- Get information from the wrapped token usins SAC contract 
- Get all contract id's from an asset issuer
- Use all user balance inside Soroban (Classic & Soroban)
- Call the token contract from another contract










```
```