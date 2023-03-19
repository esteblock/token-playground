# Token Playground Chapter 5:  Get info about a token in Classic.

Stellar horizon server povides an endpoint where you can request info about the token:   

https://horizon-testnet.stellar.org/assets?asset_code=ASSET_CODE&asset_issuer=ISSUER_ADDRESS

Next you have the command to get the same info that endpoint

```
docker exec soroban-preview-7 node src/getInfo.js
```

This script uses stellar sdk to request to horizon api about asset info 

```
console.log((await server.assets().forCode(asset_code).call()).records[0])

```


Below you'll find the response you get from endpoint or getInfo.js script 

```
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