# This is the Soroban's Token Playground

Soroban provides a mechanism to **wrap a (classic) Stellar asset in a smart contract** so that the token can be minted and transferred in Soroban. However, a lot of questions are arised...

- How can developers **issue tokens** in Soroban, or **wrap an existing Stellar Classic Asset**?
- Are this two chains **sharing the token balance** for an specific address?
- Whan happens if the **issuer mints** tokens in Soroban after wrapping the asset?
- Can the Smart Contract prevent Stellar Classic transactions of the Stellar Asset?
- Can we enforce to some logic to be applied when they are transferred?

We have developed a **token playground** to explain how Stellar assets can be managed from a Soroban smart contract. Please check our Playground's Chapters:


* [Chapter 1: Introduction & Motivation.](1_introduction-and-motivation.md)    

* [Chapter 2 : Basic Concepts](Basic-concepts.md) 

* [Chapter 3 : Environment preparation](Environment-preparation.md)

* [Chapter 4 :  Issue and Mint Asset in Stellar.](Issue-and-mint-asset-in-stellar.md)

* [Chapter 5:  Get info about a token in Classic.](Get-info-about-token-in-stellar.md)

* [Chapter 6 : Wrap a token from Stellar Classic to Soroban.](6_wrap_a_token_from_classic_to_soroban.md)

* [Chapter 7 : Mint from a wrapped token in Soroban.](7_mint-from-a-wrapped-token-in-soroban.md)

* [Chapter 8 : Get information from the wrapped token using the SAC contract.](8_get_info_from_wrapped_using_SAC.md)

* [Chapter 9: Get all contract id's from an asset issuer](9_get_all_contract_ids_from_an_issuer.md)

* [Chapter 10: Use all user balance inside Soroban (balance from Classic & Soroban)](10_use_all_user_balance_inside_soroban.md)

* [Chapter 11: Call the token contract from another contract](11_call_the_token_contract_from_another_contract.md)