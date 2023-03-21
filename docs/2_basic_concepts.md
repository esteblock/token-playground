# Token Playground Chapter 2 : Basic Concepts

- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

## 1. Stellar Assets

As mentioned on the [introduction chapter](1_introduction_and_motivation.md), the Stellar Blockchain provides a built in functionality to create and transfer any type of asset.  By **built-in** we mean a core on-chain function that does not uses any smart contract. 

### 1.1 Identification of Stellar Assets
Stellar Asssets are identified by the combination of the **asset code** and the **issuer public key** (the addres that creates the asset). Althought asset codes can be reused, the combination with issuer indentify the asset unique. 

- `asset code`: there are three type of asset codes: alphanumeric 4, alphanumeric 12 and liquidity pool shares
- `issuer`: Stellar address that issue the asset

An Stellar Asset identification can be as follows:
```
ASSET_CODE:ISSUER_PUBLIC_KEY
```
Here is an example:
```
 AstroDollar:GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI
```

### 1.2 Creation of Stellar Assets
The creation of an Stellar Asset is very easy: The issuer needs to transfer the asset to a destination address. This transfer is performed by a transaction that includes a payment operation. However, let's don't forget, that before receiving the asset, the destination address is required to submit a **change trust operation** in order to accept to an specific asset not created yet. 

Read more about trustlines in the [Stellar's Trustlines section](https://developers.stellar.org/docs/fundamentals-and-concepts/stellar-data-structures/accounts#trustlines)

Following this steps, the asset will be **minted / created**, incrementins this way the total supply. If the issuer do not wants to mint any more, it needs to **lock the issuing account**. Learn more about asset supply in the [Stellar's "Limiting the Supply of an Asset" section](https://developers.stellar.org/docs/issuing-assets/control-asset-access#limiting-the-supply-of-an-asset)


## 2. Soroban 

Soroban is the Stellar's smart contract platform, curently under development and in preview releases.

Soroban smart contracts are small pieces of software written in the Rust language  and compiled to wasm code. Wasm smart contract code has to be submitted to stellar blockchain in a transaction so that later it can be  invoked and run in a short-live virtual machine ("VM") thanks to a new transaction. 
 
## 3. Tokens

Tokens in Soroban can be issued as Stellar Assets or as custom Soroban Tokens (only soroban). Custom Soroban tokens can follow any type of logic, (as a non ERC-20 token). But the most interesting tokens are those that implement the [token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface) which is similar to the widely used EVM's ERC-20 token standard.

### 3.1 The Stellar Asset Contract (SAC)
Soroban contains the so called **"Stellar Asset Contract" (SAC)**, which is a **token contract** that implements the [token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface) ,  Using a SAC contract allows users to use their (classic) Stellar account and trustline balances in Soroban.

Stellar recommend issuing tokens as Stellar Assets, and then wraping into a SAC token to take advantge of the interoperatiblity with the existing ecosystem.

Next some resources about how uses tokens: 

[Token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface)

[Token example](https://soroban.stellar.org/docs/how-to-guides/tokens)

[Stellar Asset Contract (SAC)](https://soroban.stellar.org/docs/how-to-guides/stellar-asset-contract)


## 3.2 Issuing a SAC

Anyone can deploy an instances of a Stellar Asset Contract. However, even that the initialization of the Stellar Asset Contracts happens automatically during the deployment, Asset Issuer will have the administrative permissions after the contract has been deployed.

In order to get  SAC  deployed we will use a function included in the [soroban tools](https://github.com/stellar/soroban-tools) command line to wrap a stellar asset in a contract 

## Next
In the next two chapters we will prepare our enviroment in order to isse (classic) Stellar Assets and mint them as Stellar Asset Contracts in Soroban. Remain alert!


