# token-playground
Token playground to learn how create and interact with Soroban and Stellar Classic Assets using Soroban 


Addresses, keys, RPC_URL and asset code in settings.json

## Open soroban rpc & soroban preview docker containters
We'll use `standalone`, but you can also use `futurenet`
```
./quickstart.sh standalone
```

## Issue an Asset:
1. Set yout keys and asset code in `settings.json`

```
node src/issueAsset.js
```
TODO: make this script run in the soroban-preview docker container
`docker exec soroban-preview node src/issueAsset.js `. Check issue [#3](https://github.com/esteblock/token-playground/issues/3)

## Get info about the token
```
node src/getInfo.js

```