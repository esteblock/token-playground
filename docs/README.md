# This is the Soroban's Token Playground

Soroban provides a mechanism to **wrap a (classic) Stellar asset in a smart contract** so that the token can be minted and transferred in Soroban. However, a lot of questions are arised...

Soroban offers a mechanism to **wrap a (classic) Stellar asset within a smart contract** enabling the token to be minted and exchanged within the Soroban framework. However, numerous questions have arisen...


- How can developers **issue tokens** within Soroban or **wrap an existing Stellar Classic Asset?**
- Do these two chains **share the token balance** for a specific address?
- What occurs if the **issuer mints** tokens in Soroban subsequent to wrapping the asset?
- Can the Smart Contract prevent Stellar Classic transactions involving the Stellar Asset?
- Is it possible to impose specific logic during asset transfers?
- How do we handle the native Stellar Lumens (XLM) token within Soroban?


We have developed a **token playground** to explain how Stellar assets can be managed from a Soroban smart contract. Please check our Playground's Chapters:


* [Chapter 1: Introduction & Motivation.](1_introduction_and_motivation.md)    

* [Chapter 2 : Basic Concepts](2_basic_concepts.md) 

* [Chapter 3 : Environment preparation](3_environment_preparation.md)

* [Chapter 4 :  Issue and Mint Asset in Stellar.](4_issue_and_mint_asset_in_stellar.md)

* [Chapter 5:  Get info about a token in Classic.](5_get_info_about_token_in_stellar.md)

* [Chapter 6 : Wrap a token from Stellar Classic to Soroban.](6_wrap-a-token-from-classic-to-soroban.md)

* [Chapter 7 : Mint from a wrapped token in Soroban.](7_mint_from_a_wrapped_token_in_soroban.md)
<!-- 
* [Chapter 8 : Get information from the wrapped token using the SAC contract.](8_get_info_from_wrapped_using_SAC.md)

* [Chapter 9: Get all contract id's from an asset issuer](9_get_all_contract_ids_from_an_issuer.md)

* [Chapter 10: Use all user balance inside Soroban (balance from Classic & Soroban)](10_use_all_user_balance_inside_soroban.md)

* [Chapter 11: Call the token contract from another contract](11_call_the_token_contract_from_another_contract.md) -->

* [Chapter 8 : Use the native Stellar Lumens (XLM) the classic way.](8_use_xlm_native_inside_classic.md)

* [Chapter 9 : Read the native token (XLM) using soroban-cli.](9_read_native_soroban_cli.md)

* [Chapter 10 : Write the native token (XLM) using soroban-cli.](10_native_XLM_transfer_transfer_from_soroban_cli.md)

* [Chapter 11 : Use the native token (XLM) inside a smart contract.](11_use_XLM_inside_contract.md)


* [Chapter 12 : Identify a Stellar Classic Asset using stellar-sdk.](12_identify_classic_using_stellar_sdk.md)

* [Chapter 13 : Wrap an asset using stellar-sdk.](13_wrap_classic_using_stellar_sdk.md)
