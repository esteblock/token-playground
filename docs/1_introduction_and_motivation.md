# Token Playground Chapter 1: Introduction & Motivation.

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

![Soroban Image](./img/soroban.png "Soroban Logo")

## Soroban

Soroban, the Stellar smart contract platform, is currently under development, and its official launch is expected to be sometime in 2023.

## Tokens in Soroban

**Tokens** are one of the most important applications on any smart contracts platform. In the case of Stellar, this is especially relevant because it already has a solution for tokens directly on the "Stellar Classic Blockchain" **(The Stellar Assets / Classic Tokens)**, even before Soroban.

Soroban provides a mechanism to **wrap a (classic) Stellar Asset in a smart contract** so that the token can be minted and transferred in Soroban. However, a lot of questions are arised...

- How can developers **issue tokens** in Soroban, or **wrap an existing classic Stellar Asset**?
- Are this two chains **sharing the token balance** for an specific address?
- Whan happens if the **issuer mints** tokens in Soroban after wrapping the asset?
- Whan happens if the **issuer mints** tokens in Stellar Classic after wrapping the asset?
- Can the Smart Contract prevent Stellar Classic transactions of the Stellar Asset?
- Can we enforce to some logic to be applied when they are transferred?
- Can we do the same if we create a token first in Soroban? Can we move it into Stellar Classic?

## The Token Playground's Motivation

Our motivation is to **explain through practice** to developers coming to Soroban **how Stellar Assets can coexist with smart contracts**, how they can take advantage of Soroban, and what limitations could be presented.

We have developed this  **Soroban's Token Playground** to explain how Stellar assets can be managed from a Soroban smart contract. For that, we have created a set of scripts that will show you in a practical way the main actions involved in token management:

- Issue an Stellar Asset
- Get info about an Stellar Asset (Asset Code, Issuer, Balance ) 
- Wrap a Stellar Asset from Stellar to Soroban (token)
- Mint wrapped token in Soroban 
- Get information from the wrapped token usins SAC contract 
- Get all contract id's from an asset issuer
- Use all user balance inside Soroban (Classic & Soroban)
- Call the token contract from another contract

## How to follow this Token Playground
All the code explained in this guide can be found in the token's playground repo: https://github.com/esteblock/token-playground/. We will try to explain every line of code. If you find a mistake, or you want to collaborate, just open an Issue in the repo!