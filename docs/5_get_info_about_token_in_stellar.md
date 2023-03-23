# Token Playground Chapter 5:  Get info about a token in Classic.


- Check this guide in [https://token-playground.gitbook.io/](https://token-playground.gitbook.io/)
- Edit this guide in it's repo: [https://github.com/esteblock/token-playground/](https://github.com/esteblock/token-playground/)
- Contribute to this guide in the [./docs folder](https://github.com/esteblock/token-playground/tree/main/docs) of the repo

# Introduction:


In this chapter we will  show you how to get info about the asset that we have created and minted in the [previous chapter](4_issue_and_mint_asset_in_stellar.md). 

The Horizon sever provides an HTTP API to request data in the stellar network, providing  several endpoints.  One of them allow us to request assets info. Our code uses the Stellar SDK sends request to these endpoints.

Remember to **follow the code** in the [Token Playground's Repo](https://github.com/esteblock/token-playground/). Also, you can clone the code by doing

```bash
git clone https://github.com/esteblock/token-playground/
```

# 1. Get info about a token from stellar  

Asset information are stored in stellar ledgers. In order to facitilate the access to the data, stellar provides the Horizon API with several endpoints. Here we show you the endpoint URL with the query string to request an asset info. 

```
https://horizon-testnet.stellar.org/assets?asset_code=ASSET_CODE&asset_issuer=ISSUER_ADDRESS
```

The query string includes two parameters, one is the `asset_code` and one is the `asset_issuer`. This request will return the info of a single asset as reponse. 

An answer looks like this:

```json
Futurenet Classic Info: 
{
  _links: { toml: { href: '' } },
  asset_type: 'credit_alphanum12',
  asset_code: 'MYASSETCODE',
  asset_issuer: 'GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI',
  paging_token: 'MYASSETCODE_GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI_credit_alphanum12',
  num_accounts: 1,
  num_claimable_balances: 0,
  num_liquidity_pools: 0,
  amount: '5.0000000',
  accounts: {
    authorized: 1,
    authorized_to_maintain_liabilities: 0,
    unauthorized: 0
  },
  claimable_balances_amount: '0.0000000',
  liquidity_pools_amount: '0.0000000',
  balances: {
    authorized: '5.0000000',
    authorized_to_maintain_liabilities: '0.0000000',
    unauthorized: '0.0000000'
  },
  flags: {
    auth_required: false,
    auth_revocable: false,
    auth_immutable: false,
    auth_clawback_enabled: false
  },
  toml: [Function (anonymous)]
}

```

In the response you'll find relevant info  about the asset as:

-`asset code`    MYASSETCODE

-`asset issuer`  GAM5XOXRUWPMKENBGOEAKMLRQ4ENHLHDSU2L2J7TVJ34ZI7S6PHMYIGI

-`amount issued` 5.0000000



# 2. Use our code


If you want to use our [Token Playground's Repo](https://github.com/esteblock/token-playground/) **code**, we prepared the [src/getInfo.js](https://github.com/esteblock/token-playground/blob/main/src/getInfo.js) script that can be called by the `soroban-preview-7` docker container:

You can run it by:

```
docker exec soroban-preview-7 node src/getInfo.js
```

Also you can run it with a different asset code than the one in settings.json by passing it as argument:

```bash
 docker exec soroban-preview-7 node src/getInfo.js ASSET_CODE
```

This script uses the stellar sdk to request to horizon api about asset info. [Stellar sdk](https://github.com/stellar/js-stellar-sdk) is a javascript library from stellar that offers a layer API for Horizon endpoints and facilities building, signing and submiting transactions. 

Here, you'll find a fragmet of the code that exemplifies how stellar sdk access to horizon asset endpoint. 

```javascript

import StellarSdk from "stellar-sdk";

....

var server = new StellarSdk.Server(settings.horizonUrl, {allowHttp: true});

console.log("Futurenet Classic Info: ")
console.log((await server.assets().forCode(asset_code).call()).records[0])

```

# 3. Next

In the [next chapter](6_wrap_a_token_from_classic_to_soroban.md) we will wrap this asset from the classic Stellar blockchain into a Soroban smart contract. Are you ready?! 

___

This Playground has been developed by [@esteblock](https://github.com/esteblock/) in collaboration with [@marcos74](https://github.com/marcos74) from [@Dogstarcoin](https://github.com/Dogstarcoin)
