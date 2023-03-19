# Token Playground Chapter 2 : Basic Concepts


## Stellar Assets

As mentioned  on the introduction chapter stellar provide a built in functionality to create and transfer any type of asset.  By built in we mean a core on-chain function that not uses any smart contract. 

Stellar asssets are identified by the combination of the asset code and the issuer (addres that creates the asset).  
Althought asset code can be reused, the combination with issuer indentify the asset uniquely. 

- `Asset code` , there are three type of asset codes: alphanumeric 4, alphanumeric 12 and liquidity pool shares
- `Issuer` , stellar address that issue the asset

Create a stellar asset is so easy as ithe ssuer address transfer the asset to a destination address. This transfer is performed by a transaction that includes a payment operation.  

Before to this tranfer destination address is required to  submit to the network a transaction including a change trust operation for which accept to receive the asset not created yet. This requirement will be a must for any addess pretend receive an amoun of the asset once is created. 

if the issuer send a new payment  to any stellar address and  the issuer is not locked, then amount sent will be minted , incrementins this way the total supply.


## Soroban 

Soroban is the stellar's  smart contract  platform, curently under development and in preview release.

Soroban smart contracts are small pieces of software written in the Rust language  and compiled to wasm code. Wasm smart contract code has to be  submitted to stellar blockchain in a transaction so that later it can be  invoked  and run in a short-live virtual machine ("VM") thanks to a new transaction. 

 
## Token 


Tokens in Sosoban can be issued as Stellar Assets or as custom Soroban Tokens (only soroban). Soroban contains a Token contract built in que througth a Token interface allows use Stellar Assets, interact with trustlines and use custom tokens. Stellar recommend issuing tokens as Stellar Assets to take advantge of the interoperatiblity with the existing ecosystem.

Next some resources about how uses tokens: 

[Token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface)

[Token example](https://soroban.stellar.org/docs/how-to-guides/tokens)

[SAC](https://soroban.stellar.org/docs/how-to-guides/stellar-asset-contract)


## SAC 


Stellar Asset contract (SAC) implements  the [token interface](https://soroban.stellar.org/docs/reference/interfaces/token-interface) 

Anyone can deploy the instances of Stellar Asset Contract. Note, that the initialization of the Stellar Asset Contracts happens automatically during the deployment. Asset Issuer will have the administrative permissions after the contract has been deployed.

In order to get  SAC  deployed we will use a function included in the [soroban tools](https://github.com/stellar/soroban-tools) command line to wrap a stellar asset in a contract 




